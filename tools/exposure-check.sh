#!/bin/sh
# exposure-check.sh -- every top-level directory of this site is DECLARED web-served or BLOCKED,
# and the blocks are still there.
#
# WHY THIS EXISTS, and it is not hypothetical. THIS DIRECTORY WAS LIVE ON THE PUBLIC WEB until
# 2026-09-18. Measured before tools/.htaccess existed:
#
#     https://librewaternet.org/tools/                   200, a full directory index
#     https://librewaternet.org/tools/build-chrome.php   200, EXECUTED
#     https://librewaternet.org/tools/build-features.php 500, EXECUTED and fatal
#     https://librewaternet.org/tools/build_claims.py    200, source downloadable
#
# That is REMOTE EXECUTION of this site's own build scripts over HTTP. It was found by Tom noticing
# an untracked `tools/error_log` in `git status` -- the log the fatal wrote -- and NOT by check.sh,
# which had been green the whole time. Two days earlier the same shape had been found on the sibling
# suite from outside: https://hawsedc.com/engcalcs/.claude/settings.json answered 200, serving the
# agent definitions and the permission allow-list, and that produced
# engcalcs/dev/scripts/docroot_exposure_check.php, which this script is modelled on.
#
# BOTH TIMES A PERSON LOOKING FROM OUTSIDE FOUND IT WHILE EVERY CHECK INSIDE THE REPOSITORY PASSED.
# That is the gap this closes: the repository could not say which directories are MEANT to be
# reachable, so it could not notice one that was reachable by accident.
#
# THE DOCUMENT ROOT IS THIS REPOSITORY. Deployment is `git pull` into ~/addon_html/<site>/, so every
# tracked directory is under the document root whether or not a visitor has any business in it, and
# a new one is reachable the moment it is pushed. Exposed-by-default is the state this ends.
#
# `Require all denied`, NOT `Options -Indexes`. An `Options` directive where `AllowOverride Options`
# is not granted returns 500 for EVERY request under that path, with no partial symptom -- the root
# .htaccess here records that reasoning in its own words, and the EngCalcs working guide records it
# as able to take a whole suite down on a host change. `Require all denied` is mod_authz_core and is
# proven on this account: it is how engcalcs/dev/ blocks its own tooling, and it is what closed
# tools/ on the day this was written.
#
# IT READS DECLARATIONS, NEVER THE LIVE SITE. Proving that Apache obeys them needs a request: the
# answer differs per host, a cold checkout has no network, and a check that depends on one is a
# check somebody deletes. What proves the other half is the account's own daily page check on the
# host, which fetches every URL and reads the body as well as the status.
#
# Usage:  sh tools/exposure-check.sh [--root=DIR]
#         --root lets tools/exposure-selftest.sh point it at a tree it built. 0 pass, 1 fail.

root=$(pwd)
for a in "$@"; do
	case "$a" in
		--root=*) root=${a#--root=} ;;
	esac
done
root=${root%/}

decl="$root/tools/docroot-declarations.txt"
fail=0
say() { printf '%s\n' "$*"; }
bad() { fail=1; printf '\nFAIL  %s\n' "$*"; }

[ -f "$decl" ] || { printf 'FAIL  no declaration file at %s\n' "$decl"; exit 1; }

# ---------------------------------------------------------------------------
# The tracked directory list. `git ls-files` rather than a directory walk, so an untracked scratch
# directory in somebody's working copy is not a finding: it is not deployed, because deployment is
# `git pull`. Untracked directories are COUNTED and printed rather than passed over in silence.
# ---------------------------------------------------------------------------
tracked=$(git -C "$root" ls-files 2>/dev/null) || tracked=''
[ -n "$tracked" ] || { printf 'FAIL  `git ls-files` gave nothing in %s -- not a checkout?\n' "$root"; exit 1; }

dirs=$(printf '%s\n' "$tracked" | grep '/' | cut -d/ -f1 | sort -u)
topfiles=$(printf '%s\n' "$tracked" | grep -cv '/')

ondisk=$(cd "$root" && ls -A1 2>/dev/null | while read -r e; do [ -d "$root/$e" ] && printf '%s\n' "$e"; done)
untracked=0
for e in $ondisk; do
	printf '%s\n' "$dirs" | grep -qx "$e" || untracked=$((untracked + 1))
done

# A line is `web <dir> <reason>` or `deny <dir> <reason>`. Anything else in that file is a mistake
# and is reported rather than ignored, because a malformed line silently declares nothing.
state_of() {
	awk -v d="$1" '$1 !~ /^#/ && $2 == d { print $1; exit }' "$decl"
}

denies() {
	[ -f "$1" ] || return 1
	grep -Eq '^[[:space:]]*(Require[[:space:]]+all[[:space:]]+denied|Deny[[:space:]]+from[[:space:]]+all|Order[[:space:]]+deny)' "$1"
}

nweb=0; ndeny=0
for d in $dirs; do
	s=$(state_of "$d")
	case "$s" in
		web)
			nweb=$((nweb + 1))
			;;
		deny)
			ndeny=$((ndeny + 1))
			if ! denies "$root/$d/.htaccess"; then
				bad "$d/ is DECLARED blocked in tools/docroot-declarations.txt and no longer denies."
				say "      Its tracked files are being served. This is the ratchet leg: a deliberate"
				say "      block must not be removable by deleting one line."
				say "      FIX: printf 'Require all denied\\n' > $d/.htaccess"
				say "      (Require all denied, NOT Options -Indexes -- see the head of this script.)"
			fi
			;;
		*)
			bad "$d/ is DECLARED NEITHER web-served NOR blocked."
			say "      The document root is this repository, so this directory is reachable over HTTP"
			say "      by default and nobody has said whether that is intended. A .php file in it is"
			say "      EXECUTED by the server; that is what happened to tools/ until 2026-09-18."
			say "      FIX: add a line to tools/docroot-declarations.txt --"
			say "        web  $d  <the reason a visitor reaches it>"
			say "      or"
			say "        deny $d  <the reason nobody should>   plus  $d/.htaccess saying Require all denied"
			;;
	esac
done

# A declaration matching nothing is stale, and a stale declaration reads as coverage it no longer
# has. An exception nobody can trip is a ratchet gone slack.
while read -r s d rest; do
	case "$s" in ''|\#*) continue ;; esac
	case "$s" in
		web|deny) ;;
		*) bad "tools/docroot-declarations.txt: '$s' is not 'web' or 'deny' (line naming '$d')."; continue ;;
	esac
	[ -n "$rest" ] || bad "tools/docroot-declarations.txt: '$d' is declared with no reason given."
	printf '%s\n' "$dirs" | grep -qx "$d" \
		|| bad "tools/docroot-declarations.txt declares '$d/', which holds no tracked files. FIX: delete the row."
done < "$decl"

# ---------------------------------------------------------------------------
# The blanket dot-path rule in the root .htaccess.
#
# HELD AT THIS LEVEL DELIBERATELY, as the sibling check does. `.git` is not a tracked directory, so
# the walk above can never see it, and the 403 it returns today comes from a host-wide rule this
# repository does not own -- a host change can silence that without touching anything here. The rule
# below is mod_alias in a file we ship. And `<FilesMatch "^\.">` does NOT cover the case: it matches
# FILENAMES, so `.git/config` is served as an ordinary file. That exact mistake is what put
# .claude/settings.json on the open web.
# ---------------------------------------------------------------------------
blanket=0
if [ -f "$root/.htaccess" ]; then
	grep -Eq '^[[:space:]]*(RedirectMatch|RewriteRule)[[:space:]].*\\\.' "$root/.htaccess" \
		&& grep -Eq '^[[:space:]]*(RedirectMatch|RewriteRule)[[:space:]].*(\[\^/\]|\.\+|\.\*)' "$root/.htaccess" \
		&& blanket=1
fi
if [ "$blanket" = 0 ]; then
	bad "the root .htaccess carries no blanket DOT-PATH rule."
	say "      Without it, blocking .git depends on a host-wide setting this repository does not own."
	say "      FIX: add a line of the shape"
	say '        RedirectMatch 404 "/\.(?!well-known/)[^/]+/"'
fi

# ---------------------------------------------------------------------------
# Report. The counts print on a pass too: a scan that has gone blind finds nothing and reads as
# progress, which is the shape that has already cost this account two exposures.
# ---------------------------------------------------------------------------
say ""
say "Docroot exposure -- $(printf '%s\n' "$dirs" | grep -c .) tracked top-level directories"
say "  $nweb declared web-served, $ndeny declared blocked and still denying"
say "  blanket dot-path rule in the root .htaccess: $([ "$blanket" = 1 ] && echo present || echo MISSING)"
say "  turned away: $topfiles tracked top-level FILES, $untracked untracked directories"
say "    Files are out of scope: both repositories are public on GitHub, so readable source is not"
say "    itself the harm -- the harm is a directory that INDEXES or EXECUTES. Untracked directories"
say "    are not deployed, because deployment is git pull."
say "  This reads DECLARATIONS, never the live site. What proves Apache obeys them is the account's"
say "  own daily page check on the host."

[ "$fail" = 0 ] && say "" && say "Nothing exposed by default."
exit "$fail"
