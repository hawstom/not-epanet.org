#!/bin/sh
# Everything this repository checks. Run it before every commit:  sh check.sh
#
# Written 2026-09-06, after an editorial review of the live site. Each check below holds a sentence
# this site PRINTS, which is the only kind of rule worth a script here: the page tells the reader it
# makes no outside request and that every claim on it is checkable, and until now nothing but
# somebody's memory stopped either from quietly becoming false.

fail=0
say() { printf '%s\n' "$*"; }
bad() { fail=1; printf 'FAIL  %s\n' "$*"; }

# VISITOR TEXT, which is what several checks below are actually about. A page's own comments, its
# <style> and <script> blocks, and its <code> spans are NOT visitor prose, and a check that cannot
# tell the difference reads its own subject matter as a violation: claims row 9.5 SAYS the words
# "@import" and "url()" in order to promise the site contains neither, and the first draft of check
# 2 failed on that sentence.
#
# **BOTH REMOVALS ARE NON-GREEDY, AND THAT IS THE WHOLE DIFFICULTY.** Written with sed the natural
# way -- a `/<script>/,/<\/script>/d` range, or `s/<!--.*-->//g` over a joined file -- each one
# silently eats the rest of the document when the closing tag is on the same line as the opening
# one, or when a page has two comments. A check that deletes its own haystack passes. This was
# caught by mutation: a planted em dash and a planted third-party <script> both went unreported.
prose() {
	awk '{ buf = buf $0 "\n" }
	     END { gsub(/<!--([^-]|-[^-]|--[^>])*-->/, "", buf)
	           gsub(/<style[^>]*>([^<]|<[^\/]|<\/[^s])*<\/style>/, "", buf)
	           gsub(/<script[^>]*>([^<]|<[^\/]|<\/[^s])*<\/script>/, "", buf)
	           gsub(/<code>[^<]*<\/code>/, "", buf)
	           print buf }' "$1"
}

# The same, MINUS the script and style removal: what a page FETCHES lives in exactly those tags, so
# stripping them is how you blind check 2. A mention of a tag in prose is escaped (`&lt;script&gt;`)
# and cannot match here, which is what makes this safe to run over the ledger page.
markup() {
	awk '{ buf = buf $0 "\n" }
	     END { gsub(/<!--([^-]|-[^-]|--[^>])*-->/, "", buf)
	           gsub(/<code>[^<]*<\/code>/, "", buf)
	           print buf }' "$1"
}

# ---------------------------------------------------------------------------
# 1. EVERY PAGE IS A DOCUMENT, AND DECLARES ITS ENCODING EARLY
#
# The sibling site's host sends `Content-Type: text/html` with no charset, so a page that does not
# declare its own is decoded as Windows-1252 and every non-ASCII character breaks. **Within the
# first 1024 bytes**, which is all a browser reads before deciding, and above the <title>, or the
# title itself is decoded wrongly first.
for f in *.html; do
	[ -e "$f" ] || continue
	head -c 1024 "$f" | grep -qi 'charset[ ]*=[ ]*.\?utf-8' || bad "$f declares no UTF-8 charset in its first 1024 bytes"
	head -c 200 "$f" | grep -qi '<!doctype html>' || bad "$f does not open with <!doctype html> (quirks mode)"
	grep -qi '<html lang="[a-z-]*"' "$f" || bad "$f has no <html lang>"
	grep -qi '<meta name="viewport"' "$f" || bad "$f has no viewport meta"
	grep -qi '<meta name="description"' "$f" || bad "$f has no meta description"
done

# ---------------------------------------------------------------------------
# 2. THE PAGE MAKES NO REQUEST TO ANYBODY
#
# Every page's own footer says: "This page makes no request to any other server: no fonts, no
# scripts, no images from elsewhere, no analytics, no cookies, and no storage on your device."
# That is the claim a sceptical reader tests first and the easiest one to break by habit -- the
# sibling site broke it with three Google Fonts families and did not notice for weeks.
#
# An outbound LINK is the point of the site and is fine. This looks only at what a page FETCHES.
for f in *.html; do
	[ -e "$f" ] || continue
	src=$(markup "$f")
	printf '%s' "$src" | grep -qE '<(link|script|img|iframe|source|video|audio)[^>]*(src|href)="(https?:)?//' \
		&& bad "$f fetches something from another origin"
	printf '%s' "$src" | grep -q '@import' && bad "$f uses @import"
	printf '%s' "$src" | grep -qE 'url\(["'"'"']?https?:' && bad "$f fetches a CSS asset from another origin"
	printf '%s' "$src" | grep -qE 'localStorage|sessionStorage|document\.cookie|indexedDB|fetch\(|XMLHttpRequest' \
		&& bad "$f stores or fetches something; the footer says it does neither"
done
for f in *.css; do
	[ -e "$f" ] || continue
	grep -q '@import' "$f" && bad "$f uses @import"
	grep -qE 'url\(["'"'"']?https?:' "$f" && bad "$f fetches from another origin"
done

# ---------------------------------------------------------------------------
# 3. NO EM DASH IN VISITOR TEXT
#
# The suite's ratchet, at zero here and meant to stay there. Not a claim about good English: the
# dash is fine, the reader is not, and a page about honesty that reads as machine-written has lost
# the argument before its first fact. Comments are out of scope, so they are stripped first.
for f in *.html; do
	[ -e "$f" ] || continue
	n=$(prose "$f" | grep -o -e '—' -e '&mdash;' | wc -l)
	[ "$n" = 0 ] || bad "$f has $n em dash(es) in visitor text; the ratchet is at zero"
done

# ---------------------------------------------------------------------------
# 4. NO LOCAL LINK OR ASSET IS MISSING
for f in *.html; do
	[ -e "$f" ] || continue
	# Collected first, looped in THIS shell: a pipeline's last stage runs in a subshell, so a `bad`
	# called down a pipe would set fail=1 in a copy that then exits, and the check could not fail.
	for u in $(grep -o -e 'href="[^"]*"' -e 'src="[^"]*"' "$f" | sed 's/^[a-z]*="//;s/"$//'); do
		case "$u" in http*|\#*|mailto:*|data:*|//*|./) continue ;; esac
		[ -f "${u%%#*}" ] || bad "$f references a missing file: $u"
	done
done

# ---------------------------------------------------------------------------
# 5. THE PUBLISHED LEDGER MATCHES THE WORKING ONE
#
# claims.html is generated from CLAIMS.md. If they can drift, the page that exists so a reader can
# check us is the one thing on the site nobody is checking.
if command -v python3 >/dev/null 2>&1; then
	python3 build_claims.py --check >/dev/null 2>&1 || bad "claims.html is out of date; run: python3 build_claims.py"
else
	say 'NOTE  python3 not found; claims.html freshness not checked'
fi

# ---------------------------------------------------------------------------
# 6. THE NAME OF A PRIVATE PERSON IS NOT PUBLISHED HERE
#
# Tom's ruling, 2026-09-06 ("Anonymize."), after a board member's name, credential and country
# reached the LIVE ledger page by way of a source note. The site takes a position on naming nobody
# but Tom, EPA's author, and the authors of the software it credits by licence. This holds the
# specific slip that happened; it cannot hold the general rule, which is a person's judgement.
for f in *.html *.md; do
	[ -e "$f" ] || continue
	grep -qE '\b[A-Z][a-z]+ [A-Z][a-z]+, P\.E\.' "$f" && bad "$f names a private individual with a credential; see check 6"
done

if [ "$fail" = 0 ]; then say 'All checks pass.'; else say ''; say 'BLOCKING FAILURES above.'; fi
exit "$fail"
