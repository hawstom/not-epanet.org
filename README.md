# not-epanet.org

A three-page static gateway site. Its job is to send a visitor to
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
| `claims.html` | The ledger as a page. **Generated. Do not edit by hand** |
| `CLAIMS.md` | Every factual assertion on the site, one per row, with its source. The source of truth for `claims.html` |
| `build_claims.py` | Renders `CLAIMS.md` to `claims.html`. `--check` fails if the page is stale |
| `check.sh` | Every check this repository runs. Six of them, seconds. Run before every commit |

## Why three pages and not four

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
- **The claims ledger is published** (added 2026-09-06). The front page tells the reader that
  every claim on it is checkable, and before this page existed there was nowhere to check:
  `CLAIMS.md` was written but unpublished, and neither page linked a repository. A promise of
  verifiability with nothing behind it is the one kind of dishonesty this site cannot afford.
  It is generated from `CLAIMS.md`, so the published ledger cannot drift from the working one.

## What the site claims

Everything is in `CLAIMS.md`, row by row, with a source for each. In summary:

- It is **not** EPANET, **not** a version of EPANET, **not** an official successor, and **not**
  affiliated with, endorsed by, reviewed by, or sponsored by the US EPA or the US government.
  It is in the first block of substance on every page, before the doors and before both sections;
  only the wordmark, the heading and the one-line lede come before it. **Corrected 2026-09-06**:
  this used to say "above everything else", which was false, and the same false claim had been
  written into the page itself. **Reordered 2026-09-07** on Tom's instruction: inside that block
  the three reasons for using EPANET's name now come first and the denial follows them.
  `epanet.html` still opens with the denial.
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
- **No canonical host, and no absolute link to this site's own pages.** Every internal link is
  relative, so the site works from any name it is served under, and from `file://`.
  **`not-epanet.org` is the canonical one**, decided by Tom on 2026-09-06 after seeing the
  unhyphenated form: *"When I saw that notepanet.org had the word 'note' in it prominently, I felt
  that I had made a mistake, and so I registered not-epanet.org as a correction."* He is right, and
  the general advice against hyphenated domains does not reach this case: that advice is about
  domains whose unhyphenated form reads correctly, and `notepanet` does not read as "not EPANET" to
  anybody. Setting the word boundary with a hyphen is the standard remedy for exactly this, and
  camel case (`NotEPANET.org`) cannot help because host names are case-insensitive and are shown
  lowercased. The other five are held defensively and should redirect here.
- **No external request of any kind.** No web fonts (the sibling site uses Google Fonts; this one
  cannot, and uses system stacks instead), no CDN, no scripts, no images, no analytics, no
  cookies, no `localStorage`. A page about honesty that phoned home would be the first thing a
  sceptical reader found.
- **No donation route, no sign-up, no contact form.** Contact goes through LibreWaterNet.org,
  which already has one.
- **No claim about phones**, and no claim about what the software will do next.

## Before every commit: `sh check.sh`

Six checks, and each one holds a sentence this site PRINTS, which is the only kind of rule worth a
script here. Every page is a document (doctype, `lang`, viewport, description, charset in the first
1024 bytes); **no page fetches anything from anywhere**, which is the promise in every footer; no em
dash in visitor text; no local link or asset missing; the published ledger matches the working one;
and no private individual is named with a credential.

Two of them were written after the review below and are not decoration. The fetch check exists
because the sibling site made the same promise while loading three font families from Google. The
name check exists because a board member's name, credential and country reached the **live ledger
page**, which is the last page on this site that should carry something nobody meant to publish.

The text extraction the checks share is deliberately non-greedy, and that is the whole difficulty:
written the natural way in sed, a `/<script>/,/<\/script>/` range eats the rest of the document when
the closing tag shares a line with the opening one, and a check that deletes its own haystack
passes. Mutation testing caught it; keep testing them that way.

## Conventions

- **Oxford style, serial comma included** (Tom, 2026-09-06).
- **No em dash in visitor-facing text.** House ratchet from the suite's `CLAUDE.md`.
- `<meta charset="utf-8">` in the first 1024 bytes of every page, before the `<title>`. The
  sibling site's host sends `Content-Type: text/html` with no charset, so a page that does not
  declare its own is decoded as Windows-1252.
- Light and dark are both painted explicitly; `prefers-color-scheme` and a `data-theme`
  override both work, matching the sibling site.

## State

**Live at https://not-epanet.org**, with `notepanet.org` redirecting to it, and pushed to
`github.com/hawstom/not-epanet.org`. Everything here is published the moment it is deployed, so a
wrong sentence is a wrong sentence on the public web. Run `sh check.sh` and
`python3 build_claims.py --check` before every commit.

## Corrections from Tom's first reading, 2026-09-06

He read the draft and found four claims that were too flattering or simply false. Recorded because
the site's own subject makes getting these wrong worse than getting them wrong anywhere else.

- **The colour claim was FALSE.** The draft said EPANET 2.2's five map colours are our default
  scheme. The shipped default is Viridis. Tom caught it (*"Isn't this patently false? What about
  Cynthia Brewer?"*), and the source of the error was a comment in the suite's own
  `js/looped-network.js` that said the same false thing; that comment is corrected too. EPANET's
  ramp is in the palette, unsoftened, and is the fallback for an unknown key. It is not the default.
- **The file-format claim was FALSE.** *"There is no format of our own for anyone to be locked into,
  because we never invented one"* is not true: a project saves as JSON and holds scenarios, saved
  profile paths, a background image, map tiles and the stored view, multi-line and link-anchored
  Text, and geographic coordinates. Now stated, with the list.
- **The interface claim was humble to the point of misleading.** *"Follows EPANET's"* is now
  *"inspired by and informed by"*, in Tom's own words, and the bullet says where the editor is not
  downstream at all.
  - **And the second half of that bullet was then wrong the other way, corrected 2026-09-06.** It
    claimed a profile tool and a search as places we are not simply downstream. Tom: *"EPANET has
    not only a profile tool, but graphs of time series, contours, frequency, and system flow."* He
    supplied the replacement list himself — scenarios, a world map, find and replace, flexible
    multi-labels, and a menu system we say we HOPE is less confusing. **The lesson is that "where
    we are ahead" is the hardest claim on a site like this to get right**, because it is the one
    claim whose evidence is a program none of us runs daily.
- **"No board" is gone.** Tom has a board member. The person is not named here: this
  repository is public, and naming a living person in it is their decision to make and not
  ours. The site itself never claimed either way.

And two additions rather than corrections:

- **The SEO motive is disclosed.** The draft said we use EPANET's name *"for one reason only"*.
  Tom: *"Honesty requires that we disclose all three reasons... I don't want to hide the SEO motive
  or pretend it isn't important."* His three, used as he wrote them: to connect with EPANET users,
  to give credit, and to tell you plainly what we are not.
  - **This took two passes and the first one failed in an instructive way.** It listed "to connect
    with EPANET users" and "to be found" as two separate reasons, which is the same reason twice,
    and pushed his third out of the list into a trailing sentence. Tom: *"You essentially repeated
    the first twice and lost the third."* The SEO motive is not a fourth reason competing with his
    three; it is the MECHANISM of the first, and it is now stated inside it in as many words.
- **Extended period simulation is called that.** Not "a run over time", not "simulation over time".
  Tom, having conceded the alternative reads better: *"But for an engineering software, let's do
  what you said: Use the EPANET language."* The suite now has a build check enforcing it.

## The editorial review, 2026-09-06

A second reading, this time by an editor briefed to find what would embarrass the masthead, and to
sniff for AI slop. The findings and Tom's ruling on each are in the suite's
`dev/editorial-review.md`, keyed `EDR-nn`. What changed here:

- **The boasting went.** Tom, on the lede: *"Methinkest thou boastest too much."* The page had been
  announcing its own honesty (**Deep honesty**, *said without decoration*, *None of them is
  flattering, and that is the point*, *we are not going to dress it up*) while making a case that
  needs no framing. Every clause that praised the page's own conduct is gone; every fact is still
  there. **Do not write another one.** An honest page is honest in its declarative sentences.
- **Honesty item 3 says something.** It was a heading and a posture. It now carries the two dates
  Tom supplied: development started 28 July 2026, one real-world design report as of 1 September
  2026. Ledger row 3.7a.
- **The ledger cites a public repository**, not `~/webdev/...` on one laptop. A page that says "this
  is where you check them" and then names a folder nobody can open is asking to be taken on trust,
  which is the one thing it exists not to do.
- **The ramp arithmetic was wrong.** Row 2.11b said "41 Brewer ramps"; 41 is the whole palette and
  35 of them are Brewer's. It contradicted librewaternet.org, on the page whose only job is being
  checkable.
- **§7 no longer publishes a commercial reason on a gratitude page** (Tom's ruling, EDR-18). The
  credit to the browser build of the engine stands as written.
- **The 2.2 date is an estimate rather than a refusal**: around early 2020, marked as approximate.
- **Nobody private is named**, here or on the live ledger, and `check.sh` holds it.
