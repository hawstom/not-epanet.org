#!/bin/sh
# exposure-selftest.sh -- a LIVE MUTATION test of tools/exposure-check.sh.
#
# WHY. That check passes by finding nothing, and a check that has gone blind also finds nothing. The
# two exposures it exists to prevent were both found from OUTSIDE the repository while everything
# inside it was green, so "green" is exactly the state that must be worth something here.
#
# It builds a throwaway git repository in a temporary directory, breaks ONE thing at a time, and
# requires the REAL script -- run through its own --root, not a copy of its logic -- to refuse and to
# NAME what is wrong. A mutation the check survives is a leg that is not doing anything.
#
# Usage:  sh tools/exposure-selftest.sh          Exit 0 pass, 1 fail.

here=$(cd "$(dirname "$0")" && pwd)
check="$here/exposure-check.sh"
fail=0
bad() { fail=1; printf 'FAIL  selftest: %s\n' "$*"; }

# A minimal site that PASSES: one web directory, one blocked directory that denies, a root .htaccess
# with the blanket dot-path rule, and the declaration file the real script reads.
build() {
	t=$(mktemp -d)
	mkdir -p "$t/tools" "$t/img" "$t/docs"
	printf 'x\n' > "$t/img/logo.svg"
	printf 'x\n' > "$t/docs/notes.md"
	printf 'Require all denied\n' > "$t/docs/.htaccess"
	printf 'RewriteEngine On\nRedirectMatch 404 "/\\.(?!well-known/)[^/]+/"\n' > "$t/.htaccess"
	printf 'Require all denied\n' > "$t/tools/.htaccess"
	cat > "$t/tools/docroot-declarations.txt" <<'DECL'
web   img   pictures the pages show
deny  docs  working notes
deny  tools this tooling, including the check itself
DECL
	printf 'x\n' > "$t/index.html"
	git -C "$t" init -q
	git -C "$t" add -A >/dev/null 2>&1
	git -C "$t" -c user.email=t@example.com -c user.name=t commit -qm x >/dev/null 2>&1
	printf '%s' "$t"
}

# run <root> -> prints output, sets rc
run() { out=$(sh "$check" --root="$1" 2>&1); rc=$?; }

# ---- case 1: an untouched tree passes. Without this, every case below could pass for the wrong
# reason -- a script that always exits 1 would kill every mutation and be useless.
t=$(build); run "$t"
[ "$rc" = 0 ] || { bad "a correct tree was refused (exit $rc)"; printf '%s\n' "$out"; }
rm -rf "$t"

# ---- case 2: THE LEG THAT MATTERS. A new top-level directory declared NEITHER way must FAIL and
# must be named. Not because such a directory is wrong, but because exposed-by-default is the state
# this ends -- and a .php inside it would be EXECUTED over HTTP.
t=$(build)
mkdir "$t/secret"; printf 'x\n' > "$t/secret/build.php"
git -C "$t" add -A >/dev/null 2>&1
git -C "$t" -c user.email=t@example.com -c user.name=t commit -qm y >/dev/null 2>&1
run "$t"
[ "$rc" = 1 ] || bad "an UNDECLARED directory was not refused (exit $rc)"
printf '%s' "$out" | grep -q 'secret/' || bad "the undeclared directory was not named in the output"
rm -rf "$t"

# ---- case 3: the ratchet. A declared block that has stopped denying must FAIL.
t=$(build); printf '# nothing\n' > "$t/docs/.htaccess"; run "$t"
[ "$rc" = 1 ] || bad "a blocked directory that stopped denying was not refused (exit $rc)"
printf '%s' "$out" | grep -q 'docs/' || bad "the unblocked directory was not named in the output"
rm -rf "$t"

# ---- case 3b: the same directory with NO .htaccess at all.
t=$(build); rm -f "$t/docs/.htaccess"; run "$t"
[ "$rc" = 1 ] || bad "a blocked directory with no .htaccess was not refused (exit $rc)"
rm -rf "$t"

# ---- case 3c: `Options -Indexes` MUST NOT SATISFY THE BLOCK. It is the wrong directive twice over:
# it hides a listing while still serving and EXECUTING every file by name, and where AllowOverride
# Options is not granted it returns 500 for every request under the path.
t=$(build); printf 'Options -Indexes\n' > "$t/docs/.htaccess"; run "$t"
[ "$rc" = 1 ] || bad "Options -Indexes was accepted as a block (exit $rc)"
rm -rf "$t"

# ---- case 4: a declaration matching nothing must FAIL. An exception nobody can trip is a ratchet
# gone slack, and a stale row reads as coverage it no longer has.
t=$(build); printf 'deny  gone  a directory that was deleted\n' >> "$t/tools/docroot-declarations.txt"; run "$t"
[ "$rc" = 1 ] || bad "a stale declaration was not refused (exit $rc)"
printf '%s' "$out" | grep -q 'gone' || bad "the stale declaration was not named in the output"
rm -rf "$t"

# ---- case 5: the blanket dot-path rule is gone from the root .htaccess.
t=$(build); printf 'RewriteEngine On\n' > "$t/.htaccess"; run "$t"
[ "$rc" = 1 ] || bad "a missing blanket dot-path rule was not refused (exit $rc)"
rm -rf "$t"

# ---- case 5b: `<FilesMatch "^\.">` MUST NOT satisfy it. It matches FILENAMES, so .git/config is
# served as an ordinary file -- the precise mistake that put .claude/settings.json on the open web.
t=$(build)
printf 'RewriteEngine On\n<FilesMatch "^\\.">\nRequire all denied\n</FilesMatch>\n' > "$t/.htaccess"
run "$t"
[ "$rc" = 1 ] || bad "a FilesMatch dotfile rule was accepted as a dot-PATH rule (exit $rc)"
rm -rf "$t"

# ---- case 6: a declaration with no reason must FAIL. A bare name records a decision nobody can
# re-derive, which is how a block becomes folklore.
t=$(build); printf 'web   extra\n' >> "$t/tools/docroot-declarations.txt"
mkdir "$t/extra"; printf 'x\n' > "$t/extra/a.txt"
git -C "$t" add -A >/dev/null 2>&1
git -C "$t" -c user.email=t@example.com -c user.name=t commit -qm z >/dev/null 2>&1
run "$t"
[ "$rc" = 1 ] || bad "a declaration with no reason was accepted (exit $rc)"
rm -rf "$t"

if [ "$fail" = 0 ]; then
	printf 'Exposure selftest: 9 mutations, all refused by the real check.\n'
else
	printf '\nThe exposure check has gone blind in at least one leg. Do not trust its green.\n'
fi
exit "$fail"
