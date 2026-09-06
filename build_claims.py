#!/usr/bin/env python3
"""Generate claims.html from CLAIMS.md.

CLAIMS.md is the source of truth and stays a working document; this script renders
it as the site's third page. Run it after any edit to CLAIMS.md:

    python3 build_claims.py            # write claims.html
    python3 build_claims.py --check    # exit 1 if claims.html is out of date

CLAIMS.md is written for the people maintaining the site, so a few sentences address
them directly. Those are rewritten for a reader, and every such rewrite is listed in
PUBLIC_REWRITES below rather than being applied invisibly. Nothing else changes: no
row is dropped, softened, or reordered.
"""

import html
import io
import os
import re
import sys

SRC = "CLAIMS.md"
OUT = "claims.html"

# Patterns, not literals, because CLAIMS.md wraps its prose and a phrase may straddle
# a newline. Each is required to match exactly once, so a reworded source fails loudly
# here rather than silently publishing an instruction meant for the maintainers.
PUBLIC_REWRITES = [
    # (The row 1.3 rewrite that stood here is gone: Tom confirmed the EPA had not been
    # contacted on 2026-09-06, so CLAIMS.md now records the confirmation and there is
    # no instruction left to hide.)
    # Second person, addressed to the maintainer, in a document a stranger is reading.
    (r"\*\*This is a real cost to\s+a gratitude page and Tom should rule on it:\*\*",
     "**This is a real cost to a gratitude page:**"),
]


def inline(t):
    """Markdown inline to HTML. Escape first, then re-introduce the few tags we allow."""
    t = html.escape(t, quote=False)
    t = re.sub(r"`([^`]+)`", r"<code>\1</code>", t)
    t = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", r'<a href="\2">\1</a>', t)
    t = re.sub(r"\*\*([^*]+)\*\*", r"<b>\1</b>", t)
    t = re.sub(r"(?<!\*)\*([^*]+)\*(?!\*)", r"<i>\1</i>", t)
    return t


def render(md):
    for pat, new in PUBLIC_REWRITES:
        md, n = re.subn(pat, new.replace("\\", "\\\\"), md)
        assert n == 1, "PUBLIC_REWRITES matched %d times, expected 1: %r" % (n, pat[:60])

    out, lines, i = [], md.split("\n"), 0
    while i < len(lines):
        ln = lines[i]

        if ln.startswith("## "):
            out.append("</div>\n<div class=\"item\">\n<h3>%s</h3>" % inline(ln[3:].strip()))
            i += 1; continue
        if ln.startswith("# "):
            i += 1; continue           # the h1 is supplied by the page shell
        if ln.strip() == "---":
            i += 1; continue

        # table
        if ln.startswith("|") and i + 1 < len(lines) and re.match(r"^\|[\s:|-]+\|$", lines[i + 1]):
            head = [c.strip() for c in ln.strip().strip("|").split("|")]
            i += 2
            rows = []
            while i < len(lines) and lines[i].startswith("|"):
                rows.append([c.strip() for c in lines[i].strip().strip("|").split("|")])
                i += 1
            out.append('<div class="table-scroll"><table>')
            out.append("<thead><tr>%s</tr></thead>" %
                       "".join("<th>%s</th>" % inline(c) for c in head))
            out.append("<tbody>")
            for r in rows:
                cells = "".join('<td>%s</td>' % inline(c) for c in r)
                out.append("<tr>%s</tr>" % cells)
            out.append("</tbody></table></div>")
            continue

        # bullet list, allowing wrapped continuation lines
        if ln.startswith("- "):
            items = []
            while i < len(lines) and (lines[i].startswith("- ") or
                                      (lines[i].startswith("  ") and lines[i].strip() and items)):
                if lines[i].startswith("- "):
                    items.append(lines[i][2:].strip())
                else:
                    items[-1] += " " + lines[i].strip()
                i += 1
            out.append('<ul class="facts">%s</ul>' %
                       "".join("<li>%s</li>" % inline(x) for x in items))
            continue

        if ln.strip() == "":
            i += 1; continue

        para = [ln.strip()]
        i += 1
        while i < len(lines) and lines[i].strip() and not lines[i].startswith(("|", "- ", "#")):
            para.append(lines[i].strip()); i += 1
        out.append("<p>%s</p>" % inline(" ".join(para)))

    body = "\n".join(out)
    if body.startswith("</div>\n"):
        body = body[len("</div>\n"):]
    return body + "\n</div>"


SHELL = """<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Every claim, with its source</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="Every factual assertion on not-epanet.org, one per row, with the source it rests on. Generated from the site's own claims ledger.">
<link rel="stylesheet" href="style.css">
</head>
<body>
<div class="sheet-bg" aria-hidden="true"></div>

<div class="sheet">

<header class="topbar">
\t<div class="marks">
\t\t<a class="wordmark" href="./"><span class="not">Not</span> EPANET</a>
\t\t<a class="wordmark sister" href="https://librewaternet.org"><span class="libre">Libre</span>WaterNet</a>
\t</div>
\t<nav>
\t\t<a href="index.html#honesty">Honesty</a>
\t\t<a href="index.html#gratitude">Gratitude</a>
\t\t<a href="epanet.html">About EPANET</a>
\t</nav>
</header>

<main>

<div class="hero">
\t<span class="label">The whole ledger</span>
\t<h1>Every claim, with its source<span class="rule-under"></span></h1>
\t<p class="lede">The front page says every claim on it is one you can check. This is where you
\tcheck them. One row per assertion, so each stands or falls on its own.</p>

\t<div class="disclaimer">
\t\t<span class="label">How to read this</span>
\t\t<p><code>EC</code> means the EngCalcs repository, which holds the software this site points
\t\tto. A row citing a file in it is citing the code itself. Where a claim rests on an outside
\t\tsource, the source is linked and you can go and disagree with us.</p>
\t\t<p>This page is generated from the site's own working ledger, so it cannot drift from the
\t\tdocument the people maintaining the site actually use. Sections 6, 7 and 8 are the
\t\tuncomfortable ones: what we could not verify, what we gave up, and what we refuse to claim.</p>
\t</div>
</div>

<section>
<div class="item">
%s
</section>

</main>

<footer>
\t<p><b>Not EPANET.</b> This site is not affiliated with, endorsed by, or sponsored by the
\tUnited States Environmental Protection Agency. EPANET is a public-domain program of the
\tUS EPA.</p>
\t<p>This page makes no request to any other server: no fonts, no scripts, no images from
\telsewhere, no analytics, no cookies, and no storage on your device. The only outbound
\tlinks are the ones you can see, and they only go anywhere when you click them.</p>
\t<p><a href="index.html">Back to the front page</a> &middot;
\t<a href="epanet.html">About EPANET</a> &middot;
\t<a href="https://librewaternet.org">LibreWaterNet.org</a></p>
</footer>

</div>
</body>
</html>
"""


def build():
    md = io.open(SRC, encoding="utf-8").read()
    return SHELL % render(md)


if __name__ == "__main__":
    page = build()
    if "--check" in sys.argv:
        cur = io.open(OUT, encoding="utf-8").read() if os.path.exists(OUT) else ""
        if cur != page:
            print("STALE: %s does not match %s. Run: python3 %s" % (OUT, SRC, sys.argv[0]))
            sys.exit(1)
        print("FRESH: %s matches %s" % (OUT, SRC))
    else:
        io.open(OUT, "w", encoding="utf-8").write(page)
        print("wrote %s (%d bytes)" % (OUT, len(page)))
