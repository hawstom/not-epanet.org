# Every factual claim on this site, with its source

One row per assertion, so each can be checked on its own. `EC` means the EngCalcs repository,
which is public at [github.com/hawstom/engcalcs](https://github.com/hawstom/engcalcs); a row citing
a path inside it is citing a file you can open. Anything we could not verify is in the last section,
and is either absent from the site or flagged on the site itself.

Checked 2026-09-06.

---

## 1. The disclaimer (index.html, epanet.html)

| # | Claim | Source |
|---|---|---|
| 1.1 | EPANET is a program of the US Environmental Protection Agency | [epa.gov/water-research/epanet](https://www.epa.gov/water-research/epanet); [Wikipedia: EPANET](https://en.wikipedia.org/wiki/EPANET) |
| 1.2 | This site is not EPA's, and the software is not EPANET, not a version of it, and not an official successor | True by construction. Nothing here is EPA's, and the software is a separate GPL v3 program that embeds EPANET's engine |
| 1.3 | EPA has not reviewed, endorsed, approved, sponsored, or been asked | `EC/dev/positioning.md` §6 records a courtesy note to Open Water Analytics as *not yet sent*; no EPA contact is recorded anywhere in the repository. Confirmed by Tom Haws on 2026-09-06, the day the site went live. |
| 1.4 | EPANET is obtained from EPA at epa.gov/water-research/epanet | The agency's own page |

## 2. Honesty item 1, what we owe EPANET (index.html)

| # | Claim | Source |
|---|---|---|
| 2.2 | OWA-EPANET 2.3.5 is the bundled engine, still offered and still the default setting; released 2025-02-20 | [OpenWaterAnalytics/EPANET releases](https://github.com/OpenWaterAnalytics/EPANET/releases), v2.3.5 dated February 20, 2025. Agrees with `EC/js/vendor/README.md` |
| 2.3 | Extended period simulation, water age, source trace, chemical decay, pump energy, rule-based controls, and PRV/PSV/FCV first ran through the EPANET engine; our own solver now runs them too, and EPANET stays the default | `EC/CLAUDE.md` `lpn_` section: EPANET runs them as it always has, and EPANET is the default; the built-in solver gained each one in phases, each matched against EPANET 2.3.5 on every shipped example before it merged (`EC/dev/native-eps-plan.md`, `EC/dev/roadmap-closed-ids.md` Task 733, closed 2026-11-03) |
| 2.4 | Our own solver now runs them too, built one piece at a time and checked against EPANET's answers at every step | `EC/dev/native-eps-plan.md`; harnesses `EC/dev/lpn-spike/native-*-harness.js`; Task 733 closed 2026-11-03 |
| 2.5 | We read and write EPANET's own `.inp`, `[TITLE]` to `[END]` | `EC/js/lpn-inp.js` names 26 section headings including `[TITLE]` and `[END]`. Export shipped 2026-08-18 (`EC/CLAUDE.md`) |
| 2.6 | 2,425 head comparisons across 25 reporting steps, agreeing to 0.005 ft, against EPA's own Net3 report | `EC/CLAUDE.md`: "checked against all 25 steps of EPA's own `Net3.rpt` to 0.005 ft over 2,425 head comparisons (`EC/dev/lpn-spike/eps-net3-harness.js`)" |
| 2.10 | Element vocabulary, curve types, rule grammar, and unit-switch behaviour follow EPANET | `EC/CLAUDE.md`: element types list; "EPANET HAS EXACTLY FOUR KINDS"; `EC/js/lpn-rules.js` is "EPANET's own grammar"; "EPANET behaves the same way we do" on unit switching |

## 3. Honesty items 2 to 5 (index.html)

| # | Claim | Source |
|---|---|---|
| 3.1 | The licence paragraph, quoted | Tom Haws, verbatim, 2026-09-06, supplied in the brief for this site |
| 3.2 | The software is GNU GPL v3 or later | `EC/CLAUDE.md` licence line; `EC/dev/positioning.md` §2 |
| 3.3 | EPANET carries no licence because a US government work has no copyright to license | 17 U.S.C. § 105; see 4.2 |
| 3.4 | "We are what we are ... we have no idea what we are not and what we don't know" | Tom Haws, 2026-08-22, quoted in `EC/dev/positioning.md` §2, which records it as written *for* the LibreWaterNet splash page and therefore sanctioned for public use |
| 3.5 | We do not publish a completeness claim against EPANET | `EC/dev/positioning.md` §2: "never write a completeness claim against EPANET"; the LibreWaterNet.org repository restates it |
| 3.6 | The AI paragraph, quoted | Tom Haws, verbatim, 2026-09-06, supplied in the brief for this site |
| 3.7 | No foundation, no governance document, no funding | `EC/dev/positioning.md` §1 and §8. **"No board" was removed 2026-09-06**: there is a board member, not named here. Naming a living person on a public page is their decision, not ours, so the site claims neither a board nor the absence of one. |
| 3.7a | Development started on 28 July 2026, and as of 1 September 2026 the software has carried one real-world design report | Tom Haws, 2026-09-06. **Added 2026-09-06**, when honesty item 3 stopped saying "we are not going to dress it up" and started saying how new, which is a fact and needs a row like any other |
| 3.8 | 27 languages | `EC/lib/lang.ec.*.php` is 27 files. Stated as 27 on librewaternet.org |

## 4. Gratitude (index.html)

| # | Claim | Source |
|---|---|---|
| 4.1 | EPANET was paid for by American taxpayers and given away | Follows from 4.2 and from EPANET being EPA work. Stated as a characterisation, not a budget figure |
| 4.2 | 17 U.S.C. § 105: copyright is not available for any work of the United States government; a "work of the United States Government" is one prepared by an officer or employee as part of official duties (§ 101) | [uscode.house.gov, title 17 § 105](https://uscode.house.gov/view.xhtml?req=%28title%3A17+section%3A105+edition%3Aprelim%29); [Copyright status of works by the federal government](https://en.wikipedia.org/wiki/Copyright_status_of_works_by_the_federal_government_of_the_United_States) |
| 4.3 | EPANET was created by Lewis A. Rossman for EPA and first appeared in 1993 | [Wikipedia: EPANET](https://en.wikipedia.org/wiki/EPANET); [EPA Science Matters, EPANET 2.2.0](https://www.epa.gov/sciencematters/epanet-220-epa-and-water-community-collaboration) |
| 4.4 | A formal report on the EPANET water quality model was published in 1993 | [OSTI record, EPANET water quality model](https://www.osti.gov/biblio/5795398); [EPA Science Inventory](https://cfpub.epa.gov/si/si_public_record_Report.cfm?Lab=NRMRL&dirEntryID=44860) |
| 4.5 | 2.2 was the last release made by EPA itself | [USEPA/EPANET2.2 on GitHub](https://github.com/USEPA/EPANET2.2); `EC/js/vendor/README.md`: "EPANET development moved to Open Water Analytics ... after EPA's 2.2.0". Only an approximate date is stated on the site, see section 6 |
| 4.6 | EPANET is used by utilities, consultants, regulators, and academics worldwide, and its engine is embedded in many other packages | [Wikipedia: EPANET](https://en.wikipedia.org/wiki/EPANET); [EPA Science Matters](https://www.epa.gov/sciencematters/epanet-220-epa-and-water-community-collaboration) |
| 4.7 | Open Water Analytics is a community effort in collaboration with EPA; 2.3 released 2024-07-17, 2.3.5 on 2025-02-20 | [OpenWaterAnalytics/EPANET releases](https://github.com/OpenWaterAnalytics/EPANET/releases); `EC/js/vendor/README.md` |
| 4.8 | The browser build of the engine is MIT, © Luke Butler, wrapping MIT OWA-EPANET, compiled to WebAssembly | `EC/js/vendor/README.md`; `EC/js/vendor/epanet-js.LICENSE`. **The name is printed as of 2026-09-06**, in this credit and nowhere else, see section 7 |
| 4.8a | People have wrapped, ported, rebuilt and taught EPANET for thirty years: graphical front ends free and commercial, the hydraulic solver, university courses | A characterisation, not an enumeration, and the paragraph says so in as many words: it mentions them together because the list is longer than we know. **It names nobody, on Tom's instruction, 2026-09-06**: *"I preferred not to name any names in this paragraph"*. The one name we do print is the licence credit at 4.8, where a credit belongs. EPANET first appeared in 1993 (4.3), which is where "thirty years" comes from |
| 4.8b | That work was done before the age of AI, and it is what made it possible for one semi-retired engineer with an AI to build this in a summer | Tom Haws, 2026-09-06, whose tribute this is and who asked for it in these terms. The dates are 3.7a: development started 28 July 2026. Written as a measure of what they left behind, not as a claim about us |
| 4.9 | Bootstrap 5.3.2, MIT, © 2011-2023 The Bootstrap Authors | `EC/js/vendor/README.md`; the licence header inside the vendored files |
| 4.10 | Colour schemes, Apache-2.0, © 2002 Cynthia Brewer, Mark Harrower, and The Pennsylvania State University | `EC/js/lpn-ramps.js` licence block; [colorbrewer2.org/export/LICENSE.txt](https://colorbrewer2.org/export/LICENSE.txt) |
| 4.11 | viridis, magma, inferno, plasma released CC0 by Nathaniel J. Smith, Stefan van der Walt, and (viridis) Eric Firing | `EC/js/lpn-ramps.js`; [github.com/BIDS/colormap](https://github.com/BIDS/colormap) |
| 4.12 | OpenStreetMap supplies the street basemap and Nominatim answers place-name search; Mapbox supplies satellite imagery and terrain elevation | `EC/CLAUDE.md`: the four third-party requests; the street map shows on the first, empty project, the other three are opt-in |
| 4.12a | Public domain under § 105 is a statement about United States law; the site says so in those words | 17 U.S.C. § 105 denies copyright to a US government work; the position outside the United States is not governed by it. **Corrected 2026-09-06** after an editorial review pointed out that "in the public domain by operation of law" stood next to "a working engineer anywhere on earth" |
| 4.13 | The third-party **code** is vendored; a copy travels with the software rather than being fetched while you work. The two **services** in 4.12 are not code and are fetched over the network; the street map shows on the first, empty project and can be detached, and everything else waits behind its own consent gate | `EC/js/vendor/README.md`: "Everything this site loads comes from this site. There is no CDN, no hosted font, and no third-party code of any kind." Map tiles are the stated data exception, and the site says the tiles come from those services  **Corrected 2026-09-06**: the page previously said "all of them are vendored" over a list that included OpenStreetMap, Nominatim, and Mapbox, which was false. The list is now split, and the services carry their own paragraph saying they are off until turned on. |
| 4.14 | ColorBrewer published 2002 by Brewer, Harrower, and Penn State, funded by the NSF Digital Government program through the GeoVISTA Center | [Wikipedia: ColorBrewer](https://en.wikipedia.org/wiki/ColorBrewer); [ColorBrewer: Learn More, Penn State](https://www.personal.psu.edu/cab38/ColorBrewer/ColorBrewer_learnMore.html) |
| 4.15 | The schemes are designed per class count and tested for photocopying, projection, and colour-blind readers | `EC/js/lpn-ramps.js`: "Brewer PUBLISHES a separate, individually designed set for each class count"; [ColorBrewer: Learn More](https://www.personal.psu.edu/cab38/ColorBrewer/ColorBrewer_learnMore.html) on display environments and colourblind-safe options |
| 4.16 | Cynthia Brewer received the ICA Carl Mannerfelt Gold Medal in 2023 | [Wikipedia: Cynthia Brewer](https://en.wikipedia.org/wiki/Cynthia_Brewer); [Penn State Geography directory](https://www.geog.psu.edu/directory/cynthia-brewer) |
| 4.17 | The acknowledgement sentence is fixed by Apache-2.0 clause 2, and clauses 4 and 5 forbid using the name to endorse or promote | `EC/js/lpn-ramps.js` licence block, which quotes clause 2 verbatim; [the licence text](https://colorbrewer2.org/export/LICENSE.txt) |
| 4.18 | The FSF released GPL version 3 on 2007-06-29 | [fsf.org/news/gplv3_launched](https://www.fsf.org/news/gplv3_launched); the licence's own header, "Version 3, 29 June 2007" |
| 4.19 | Net1, Net2, and Net3 are the example networks an EPANET-compatible program is checked against | `EC/CLAUDE.md`: `.inp` export "returns 1,280 numeric tokens across Net1/2/3 character-for-character"; EPA ships them with EPANET |

## 5. epanet.html

| # | Claim | Source |
|---|---|---|
| 5.1 | EPANET performs extended-period simulation of hydraulic and water-quality behaviour in pressurised pipe networks | [Wikipedia: EPANET](https://en.wikipedia.org/wiki/EPANET), quoting the program's own description |
| 5.2 | The four consequences of public domain (no licence, no owner, anyone may take it private, cannot be withdrawn) | Follows from 4.2. The "anyone may take it private" point is standard public-domain doctrine and is also what makes EPANET's engine embeddable in commercial products (4.6) |
| 5.3 | A run report from our page prints a version higher than the one on EPA's download page | `EC/js/vendor/README.md`: "The run report prints it as `2.3.05` ... beside EPA's own download page, which still offers 2.2.0" |
| 5.4 | Open development continues at github.com/OpenWaterAnalytics/EPANET | The repository itself |

## 6. Stated on the site as unverified

- **The exact release date of EPANET 2.2.** [Wikipedia](https://en.wikipedia.org/wiki/EPANET)
  gives July 23, 2020. `EC/js/vendor/README.md` records "EPA's 2.2.0 of December 2019". We did not
  resolve which is right, so the site says **around early 2020** and says in as many words that it
  is an approximation. Tom's ruling, 2026-09-06: an estimate a reader can use beats a refusal,
  as long as it is marked as one.
- **The exact administrative name of the EPA division.** Sources give "Water Supply and Water
  Resources Division" (Wikipedia) and "Drinking Water Research Division" (the 1993 report
  abstract). The site says only "EPA's water research programme" and states that it did not
  verify the division name.

## 7. Constraints observed, and what they cost

- **Cynthia Brewer.** The Apache-2.0 licence on her schemes (see 4.17) fixes the wording of the
  acknowledgement and forbids using the project name to endorse or promote. The site therefore
  reproduces the required sentence verbatim, in English, untranslated, in its own box, and puts
  the name in no heading and in no product or control name. The one prose mention names the
  source of the colours, which is attribution and not promotion.
- **No live commercial trademark, and one deliberate exception.** `EC/dev/positioning.md` §1 and
  ROADMAP task 296 ban naming competing products. **Tom lifted it for this one name on 2026-09-06**:
  epanet-js is a library we depend on, not a product we compete with, and the honest way to credit a
  library is to say what it is called. It is printed once, as a licence credit; the tribute to
  everybody who has extended EPANET over thirty years sits above it and deliberately names nobody
  (*"I preferred not to name any names in this paragraph"*). The ban stands everywhere else, and no
  competing application is named anywhere on this site.
- **No claim about phones, no comparison, no feature table, no completeness claim.** All from
  `EC/dev/positioning.md` and the LibreWaterNet.org repository.

## 8. Claims deliberately not made

- Any number for how many people use the software.
- Any statement about what EPA thinks of this, or would think of it.
- Any date, roadmap, or promise about future features.
- Any statement that the software is as capable as EPANET, in any respect other than the
  specific measured agreements in rows 2.6 to 2.8.

## 9. The doors, the footers, and the claims page

Added 2026-09-06, after a review found these assertions on the page with no row of their own.

| # | Claim | Source |
|---|---|---|
| 9.1 | The network editor draws a looped network on a map, solves it, and saves or exports an EPANET file | `EC/js/looped-network.js` File menu: New, Open, Save, Import `.inp`, Import geo, `lpn_file_export_inp`. **Corrected 2026-09-06**: the page said "publish the drawing", and there is no publish, share, or image export |
| 9.2 | Free, no sign-up, runs in your browser, in 27 languages | `EC/CLAUDE.md`: no database, no authentication, all computation client-side; `EC/lib/lang.ec.*.php` is 27 files |
| 9.3 | The project is looking for advisors, bug reports, power users with wish lists, and non-profit directors, not for money | `EC/dev/positioning.md` §1, Tom's own four phrases, used in his order |
| 9.4 | It is a web page rather than a Windows program | EPA distributes EPANET as a Windows program from its own page; this suite runs in a browser (`EC/CLAUDE.md`). Not a claim that EPANET is Windows-only, and the site does not make one |
| 9.5 | No page makes any request to another server: no fonts, no scripts, no images, no analytics, no cookies, no storage | `check.sh`, check 2, which fails the build on a cross-origin `src`, `href`, `@import` or `url()`, and on any storage call. **Held by a script since 2026-09-06**, having been held by somebody remembering until then: the sibling site made the same promise and was fetching three font families from Google the whole time. It is the claim a sceptical reader tests first |
| 9.6 | EPANET runs an instant or a week | Follows from 5.1: extended-period simulation with a user-set duration |
| 9.7 | This page exists because the site says every claim is checkable | The site said so before this page existed, which was the defect that produced it |
