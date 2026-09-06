# notepanet.org

A two-page static gateway site. Its job is to send a visitor to
[LibreWaterNet.org](https://librewaternet.org) and to the looped network editor at
`hawsedc.com/engcalcs/Looped-Network.php`, and, on the way, to say plainly what the software
is not.

Drafted 2026-09-06 for Tom Haws, from his brief: *"My vision is for it to be a
model/example/demonstration/leadership of deep honesty and deep gratitude."*

## What is here

| File | What it is |
|---|---|
| `index.html` | The disclaimer, the two doors, the honesty section, and the gratitude section |
| `epanet.html` | What EPANET is, who made it, what public domain means, and where to get it |
| `style.css` | The whole stylesheet. No other assets exist |
| `CLAIMS.md` | Every factual assertion on the site, one per row, with its source |

## Why two pages and not four

The obvious split was `index` + `gratitude` + `honesty` + `epanet`. It was rejected for the
honesty half and taken for the EPANET half, for one reason each.

- **Honesty and gratitude stay on the front page.** This is a gateway site: most visitors will
  read one page and leave through a link. Putting the honest statement behind a click means the
  ordinary visit is the one that misses it, which would make the site a claim about honesty
  rather than an instance of it. Both sections are therefore below the disclaimer on `index.html`,
  in the path of somebody heading for the buttons.
- **EPANET gets its own page.** It is reference material *about somebody else's software*, it is
  the one part a reader might reasonably want to send to a colleague on its own, and keeping it
  separate stops the front page turning into a page mostly about EPA. The disclaimer is repeated
  at the top of it, because a page reached directly from a search must carry its own denial.

## What the site claims

Everything is in `CLAIMS.md`, row by row, with a source for each. In summary:

- It is **not** EPANET, **not** a version of EPANET, **not** an official successor, and **not**
  affiliated with, endorsed by, reviewed by, or sponsored by the US EPA or the US government.
  This is the first block on both pages, above everything else.
- The project it points to is **deeply dependent on EPANET**, in seven specific and checkable
  ways: the vendored engine, the analyses that only run through it, the file format, the
  verification anchors, the Hazen-Williams constants, the element vocabulary, and the interface.
- The project is **GPL v3 or later**, which is a restriction EPA did not impose; the site says so
  in Tom's own words and keeps his invitation to argue with him about it.
- The project is **new**, and does not publish a completeness claim against EPANET.
- The work is **AI-assisted**, carried with Tom's own statement of why, unedited.
- The gratitude list names the US government, 17 U.S.C. § 105, EPA and Lewis A. Rossman, Open
  Water Analytics, the vendored libraries, Cynthia Brewer, EPANET's own interface, and the Free
  Software Foundation.

## What is deliberately absent

- **No live commercial trademark of any competing product.** EPANET is the only piece of software
  named as a peer, and it is named in order to disclaim it. This follows the ban in the suite's
  own `dev/positioning.md`.
- **No comparison, no feature table, no completeness claim, and no grievance.** The site never
  says the software does everything EPANET does, and never criticises EPANET's interface.
- **No date for EPANET 2.2.** Two public sources disagree; `epanet.html` says so out loud rather
  than picking one.
- **No canonical host, and no absolute link to this site's own pages.** Tom has registered
  `note-epanet.org`, `notepanet.org`, `NotEPANET.org`, and `Not-EPANET.org`, and has named
  different pairs of those on different days. Every internal link is relative, so the site works
  from any of them, and from `file://`.
- **No external request of any kind.** No web fonts (the sibling site uses Google Fonts; this one
  cannot, and uses system stacks instead), no CDN, no scripts, no images, no analytics, no
  cookies, no `localStorage`. A page about honesty that phoned home would be the first thing a
  sceptical reader found.
- **No donation route, no sign-up, no contact form.** Contact goes through LibreWaterNet.org,
  which already has one.
- **No claim about phones**, and no claim about what the software will do next.

## Conventions

- **Oxford style, serial comma included** (Tom, 2026-09-06).
- **No em dash in visitor-facing text.** House ratchet from the suite's `CLAUDE.md`.
- `<meta charset="utf-8">` in the first 1024 bytes of every page, before the `<title>`. The
  sibling site's host sends `Content-Type: text/html` with no charset, so a page that does not
  declare its own is decoded as Windows-1252.
- Light and dark are both painted explicitly; `prefers-color-scheme` and a `data-theme`
  override both work, matching the sibling site.

## Not done

Not registered, not deployed, not pushed anywhere. One local git repository, no remote.
