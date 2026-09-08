# Tasks — dojo-skills

intent: TASKS is the open-wave surface only. Per ADR 0004, `.dojo/progress.md` is the single
per-wave log — closed waves live there (with their verification prose and commit hashes),
not here. Each line below is a tombstone: what the wave was and how it resolved. There are
no pending waves; new work starts a new plan section.

## Tombstone ledger

- **Trim waves 3–10 (17 skills → 12)** — done 2026-08-29: hajime Gate 0 + review gates;
  refactor/stuck, algorithm-classification, contribution-review absorbed into kata-green /
  kata-red / dojo-conduct; bugfix merged into hajime's "feature or bugfix?" fork; kokai
  stubbed; tanren slimmed; randori gained the glossary pin-the-exclusion rule. Outcome and
  per-wave hashes: .dojo/progress.md; commits fa5fcee…b4a9fac.
- **Wave 11 — dojo router** — invalidated 2026-08-31: index not wanted; governance-load
  dedup landed inline (one banner in hajime, assumes-loaded notes elsewhere). Commit 9f33b18.
- **Wave 12 — `_enforce_`/`_proof_` sigils** — invalidated 2026-08-29: contradicts the
  glossary's own definition of a leading word (recruits priors the model already holds —
  sigils have none). Natural phrases stay canonical.
- **Wave 13 — kan description perf claim** — done 2026-08-31: pure claim-cut; the
  description dropped the promise, no body branch added (kan doesn't do performance work).
  Commit ebfe42b.
- **Wave 14 — dojo-* cross-ref sentence removal** — invalidated 2026-08-31: premise stale;
  cross-refs live only in descriptions where they route correctly. Commit ebfe42b.
- **Wave 15 — per-H2 rationale footers** — invalidated 2026-08-29: fails the deletion test
  (~14 always-loaded lines whose only consumer is the human who owns the manual).
- **Wave 16 — dojo-diagnose** — invalidated 2026-08-29: a new skill right after cutting
  five; a checklist reached for ~never. Fails "would I remember to invoke this?".
- **Wave 17 — dojo-write-skill bridge** — invalidated 2026-08-29: permanent dependency-
  bridge to external `writing-great-skills` — the external-source-chasing deliberately
  ended this session.
- **Wave — artifact consolidation + sharing boundary (ADR 0005)** — done 2026-09-03:
  one-folder footprint (durable record at `.dojo/` root; `adr/`, `session/`, `proof/`
  function folders; `graphify-out/` tool-homed exception); the sharing boundary explicit in
  dojo-conduct; tracking-posture question + location menu + migration offer in hajime; lint
  R17 (artifact map, stale-path ban, denylist agreement, posture verification); R16 rescued
  from after the lint exit (was dead code); R4 ADR-slug fix; evals posture-aware. Commit:
  this wave's closing commit.

## Open waves

None. New work starts here as a new plan section with the same per-wave shape:
self-contained waves, lint green at every step, no dangling pointers, byte-negative
preferred.

## Improvement Backlog

Items the author wants to revisit at some point. Not a plan; not a commitment;
not a `.dojo/TASKS.md` wave. Promote into a wave via `/kaizen` when the moment is right.

- **Landing page source-of-truth** — **resolved 2026-09-03:** the Codeberg-era premise
  ("generated from an external pages repo") is stale. The site moved to GitHub Pages and
  lives in this repo (`docs/index.html`), hand-maintained, published on every push. The
  source of truth for the site is now this repo — the 2026-09-03 HANDOFF-card edit is
  canonical, no re-pull exists to resurrect anything. Item closed.
- Eval coverage — three scenarios exist (greenfield supervised, brownfield,
  autonomous-ceiling). Coverage is honest (artifact assertions only); expand
  only when a real protocol gap appears, not for its own sake.
- Promote section in `dojo-principles` — **seeded 2026-09-03:** first entries promoted by
  explicit human approval (deploy-edge content parity; no rule-counts in prose). Earned by
  working sessions, not invented.
- Refactor assessment — when a wave ends, the assessment is *brief + one
  decision*. Avoid overproducing ceremony.
- `scripts/dojo-lint.sh` R4 false-positives on ADR filenames — **resolved 2026-09-03:**
  R4 now strips `adr/NNNN-…` slugs from the scan before matching, so ADRs may be
  referenced by full filename again.
- Wave 3 design note (from external review, 2026-07-10) — **resolved 2026-08-31, without
  the router:** the router wave was invalidated; the banner dedup kept the inline
  imperative (one banner in hajime) rather than a pointer chain — the note's warning
  about pointer chains is what the assumes-loaded notes implement.
- Wave 4 counter-proposal (from external review, 2026-07-10) — **resolved 2026-08-29:**
  the sigil tokens were invalidated post-trim; natural phrases stay canonical.
- **"failing check" vs "failing test"** — **resolved 2026-09-03:** census showed the
  normative surfaces (README philosophy, DOJO-MANUAL, kata-red/kata-green) already used
  "failing check"; the five outliers (dojo-conduct ×2, hajime, kan ×2) normalized. Canonical:
  "failing check" — broader than "test" (the RED artifact need not be a test-suite test) and
  it recruits the dojo-check gate concept. Literal test-fixture prose keeps "test".
- HANDOFF surface (2026-09-02) — **resolved in the same wave it was raised:** deleted;
  the backlog moved here. A cold reader orients from README + .dojo/CONTEXT.md + .dojo/TASKS.md +
  .dojo/progress.md + git log (ADR 0004 addendum).
- Same-machine parallel sessions via git worktrees — **deferred 2026-09-08**
  (branching-convention grill): attractive as a default for concurrent autonomous sessions, but
  "evolve slowly" won; revisit via /kaizen when the need is real.

## Plan 2026-09-03 — install fidelity (repo → runtime)

intent: Close the repo→runtime fidelity gap — install drift detectable, EOL mutation harmless —
and correct the three currency findings — so the philosophy the agent runs is provably the
philosophy in the repo. (Findings provenance: .dojo/findings.md, session-start discoveries.)

### Wave 1 — install drift is detectable by one command

status: done
`scripts/install-parity.sh <dir>` reports content parity (EOL-insensitive by design — the
install path normalizes line endings) between this repo's skill directories and an installed
skills dir: per-skill OK, per-file DRIFT/MISSING/EXTRA lines, exit nonzero on any drift,
exit 2 on usage error. Reports only — never mutates the target. Documented in README
("Updating Dojo").
Proven by: a mechanics-eval section — passes on a fresh fixture install (LF and CRLF
variants alike), fails with per-file output on a seeded stale one.

### Wave 2 — no shell script ships inside a skill dir; currency fixes land

status: done
Lint R18: any `*.sh` under a skill directory fails lint (the install path normalizes EOLs;
a CRLF shebang is fatal off-Windows — R13's class, relocated to the deploy edge; structural
ban beats per-machine checking). Plus the content-review fixes: .dojo/CONTEXT.md glossary
drops the stale "R1–R14" enumeration (no count baked into a name — it goes stale at R18);
the manual pointer in the governance trio names its home repo (dangles in user projects);
dojo-project gains the content-repo carve-out this repo itself relies on (ADR 0004 addendum).
Proven by: lint green with R18 enforced; a seeded skill-dir .sh fails R18.

## Plan — the site says what the system does: modes, scope, names, freshness, polish (2026-09-07)

intent: the landing page currently explains the two run modes in one parenthetical, leaves the
pre-edit checks unscoped (a consumer could read them as theirs), shows no kanji/translation on
the skill cards, omits tanren from its names grid (README's technique list omits it too), and
opens with nothing current. Each wave fixes one layer; impeccable owns the final UI polish.

- **Wave 1 — modes explained, checks scoped** — status: done (6590136)
  goal: #cycle gains a supervised/autonomous modes block — a per-session choice at /hajime;
  supervised stops at gates (density full/standard/light, engagement notes), autonomous runs to
  completion (halts on divergence, pauses at the wave ceiling with resume.md) — facts mirrored
  from README's modes sentence; #install's "Two checks" block states it applies to editing
  Dojo's own skills (scripts/ + evals/ live in this repo, not in installs); README's technique
  list gains tanren. Proven by: grep assertions + R16 green (catalogue/cycle/install tokens
  untouched) + dojo-check green.
- **Wave 2 — kanji identity on the cards, latest wave in the hero** — status: done (13a0216)
  goal: every named skill card carries its kanji + translation sourced from the corpus — hajime
  始め begin · randori 乱取り freeform sparring · kan 看 perception · kaizen 改善 continuous
  improvement · tanren 鍛錬 forging · kokai 公開 making public · kata-red/green/commit 型 the
  wave form; the governing trio gets none (no kanji exists in the corpus — none invented);
  #names grid gains tanren 鍛錬; hero gains a hand-curated latest-wave line derived from
  .dojo/progress.md. Proven by: per-card grep, names grid = 8 terms, hero line matches
  .dojo/progress.md's last entry, R16 green.
- **Wave 3 — impeccable polish pass** — status: done
  goal: run the impeccable skill's refinement flow on docs/index.html (context.mjs setup; a
  narrow refinement on the incumbent implementation — refinement preserves, no redesign; its
  bounded-pass ceiling governs verification). The incumbent world (ink/stone palette, kanji
  accents) is preserved; polish fixes defects, not identity. Proven by: the polish reference's
  checklist in bounded passes; HTML valid; R16 tokens intact; dojo-check green.

## Plan 2026-09-08 — the branching convention: plan branches

intent: git flow works the same way in every Dojo project — one plan branch per plan, wave
commits on it, merge at plan-complete session close, push human-only — so main always holds
complete, proof-gated work, plans park or die at branch cost, and the human stays the only
publisher.

- **Wave 1 — the convention is recorded and sanctioned** — status: done (36dcf25)
  goal: ADR 0006 records the why (plan-branch granularity over wave-branches, merge autonomy
  at session close, abandonment = human decision + harvest + delete, worktrees deferred);
  dojo-conduct carries the plan-branch lifecycle (create/resume at hajime, wave commits via
  kata-commit, merge at plan-complete close, push human-only, harvest rule, and the clause that
  AI revision never replaces human presence at PR review and merge); dojo-principles carries
  the integration invariant (main only ever receives work that completed a plan branch, every
  wave proof-gated); .dojo/CONTEXT.md pins "plan branch" in the glossary (with git-flow and
  skill-branch exclusions), the non-goals, and the Decisions entry. Proven by: grep assertions
  per surface + lint green + dojo-check green.
- **Wave 2 — the flow is wired into the session skills** — status: done (0be4703)
  goal: hajime creates or resumes the plan branch at session init and merges at
  plan-complete close (supervised: propose; autonomous: self); kata-commit gains the
  main-guard (a wave commit while on main means the branch was never created → halt).
  Proven by: grep assertions on the new steps; mechanics eval green; lint green.
- **Wave 3 — consistency: lint, manual, public docs** — status: done (cf401af)
  goal: a new lint R asserts cross-surface agreement of the convention tokens (R16 style;
  a seeded violation fails); DOJO-MANUAL gains the rationale entries; README +
  docs/index.html carry a short consumer-level workflow mention (no publish/site coupling in
  the convention text — consumers vary per project). Proven by: lint green with the new R
  enforced + seeded-violation check; R16 tokens intact; dojo-check green.
