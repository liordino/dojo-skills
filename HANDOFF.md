# Project Handoff — dojo-skills

> Living resume surface. Append-only on **Wave History**; everything else is updated
> in place when reality changes. See `CONTEXT.md` for Glossary/Non-Goals/Decisions.

## Project Overview

Dojo is a disciplined development system for AI coding agents, packaged as a set of
installable skills plus supporting docs and dev-time tooling. It enforces TDD in
approval-gated waves, builds a shared domain language, maintains living project
documentation, keeps long sessions sharp through a context-compaction cycle, and
carries a project from idea to shipped, installable release. This repository **is**
that system: the skills, the manual, the README, the changelog, the landing page,
and the dev-time lint + eval tooling.

The audience is anyone who pairs with an AI coding agent and wants the pair to
behave like a disciplined collaborator rather than an overconfident autocomplete.
Dojo is **personal system, shared**: opinionated for one human's workflow, freely
forkable, deliberately specific in places about tools and stacks its author uses.

## Architecture

```
dojo-skills/
├── README.md                    # problem-first; entry point
├── DOJO-MANUAL.md              # rationale; the "why" behind every rule
├── CHANGELOG.md                # package-wide Keep a Changelog format
├── LICENSE                     # MIT
├── CONTEXT.md                  # Glossary / Non-Goals / Decisions
├── HANDOFF.md                  # this file — living resume surface
├── learning-log.md             # per-wave briefs and debriefs (append-only)
├── progress.md                 # terse per-wave log (append-only)
├── findings.md                 # discoveries + halt diagnostics (append-only)
├── TASKS.md                    # resolved plan archive — trim (4–10) done; surviving-old (11–17) done or invalidated; this repo is plan-less by design (CONTEXT.md → Decisions)
├── docs/
│   ├── index.html              # static landing page (GitHub Pages-friendly)
│   └── adr/                    # architecture decision records (lazy; 0001-0003 as of Wave 1)
├── scripts/
│   ├── dojo-lint.sh            # static consistency checker (R1–R10; R10 replaces retired R6)
│   └── dojo-check.sh           # wave gate (lint + mechanics-eval + proof artifact)
├── evals/
│   ├── run-mechanics.sh        # automated mechanics eval; deterministic
│   └── scenarios/              # agent-replay scenarios with assertion scripts
├── hajime/                     # the 12 skills (dojo-*, kata-*, bare-named); trim target reached
├── randori/
├── kan/
├── tanren/
├── kata-red/
├── kata-green/                  # absorbs the refactor step + stuck branch as of Wave 5
├── kata-commit/
├── kokai/
├── kaizen/
├── dojo-principles/             # normative home of the dojo-check proof contract (Wave 1)
├── dojo-project/
└── dojo-conduct/
```

Each skill is a directory with a `SKILL.md` (the trigger-loaded contract), plus
optional `reference/` (on-demand) and `examples/` (also on-demand). The
`Promoted (local)` section at the bottom of `dojo-principles/SKILL.md` is the
consented home for insights promoted from project learning-logs; preserve it
across updates.

## Wave History

Append one line per committed wave. Format: `YYYY-MM-DD | wave N | <one-line outcome>`.
Most recent first.

2026-08-31 | closeout | durable surfaces reconciled: CONTEXT.md (router/sigil drift closed; anti-inflation charter), ADR 0002 invalidation note, RESUME.md one-line, DOJO-MANUAL §3 count + §5b re-measure, CHANGELOG v1.2.0, kata-commit item-4 clause (duty attaches to the commit, whatever commissioned it) | stale-decisions class closed by rule + cleanup | (this commit)
2026-08-31 | waves-13-14 | kan description claim-cut (no perf branch existed — description-only phrase); Wave 14 invalidated on inspection (cross-refs are routing pointers in descriptions, not body duplication); inherited plan queue emptied | chat-scoped plan executed outside the cycle; reconciled by the closeout | ebfe42b
2026-08-31 | banner-dedup | governance-load banner dedup — one banner in hajime, assumes-loaded notes in kaizen/kan/randori; Wave 11 (router) invalidated | chat-scoped plan executed outside the cycle; reconciled by the closeout | 9f33b18
2026-06-19 | wave 1 | single-source dojo-check template via dojo-principles (R10 replaces retired R6; ADRs 0001/0002/0003 + TASKS.md land with the wave) | commit c9355b4
2026-06-19 | wave 2 | classify every skill per invocation rule (ADR 0002); 7 user-invoked + 3 session-invoked; R11 single-table classifier | commit 4168c6e
2026-08-29 | wave 3 | land Wave-2 review fixes + repair R13 grep; Gate 0 in hajime, facts-vs-decisions in randori, kata-commit item 4 (CONTEXT.md), R12–R14 in dojo-lint, exec-bit index mode flipped for 6 scripts, `## Logging` heading restored in dojo-principles | dirty tree from interrupted kata-commit cleared; clean green baseline ready for the trim plan in `docs/proposals/` | fa5fcee
2026-08-29 | wave 4 | promote trim plan into TASKS.md as the active plan; 7 trim waves (4–10) + 7 surviving-old waves (11–17); predecessor writing-great-skills plan preserved as appendix | two-plan confusion resolved; single active plan | unlocks Wave 5 (first trim wave: absorb two deleted skills into kata-green) | c11bdfa
2026-08-29 | wave 5 | absorb two deleted skills into kata-green; the cycle is now red → green → commit; directories deleted | ~15 cross-references rewritten; the trim draft's hard constraint met | 17 → 15 skills; trim pattern established for waves 6–8 | d097c6f
2026-08-29 | wave 6 | absorb the algorithm-classification discipline into kata-red; directory deleted | ~12 cross-references rewritten | 15 → 14 skills | ca3e112
2026-08-29 | wave 7 | absorb the contribution-review discipline into dojo-conduct (new "Reviewing Code" section); directory deleted | ~9 cross-references rewritten | 14 → 13 skills | 8707329
2026-08-29 | wave 8 | merge the bugfix entry into hajime as a "feature or bugfix?" fork; directory deleted | ~12 cross-references rewritten; regression-test-first discipline preserved; **trim complete** | 13 → 12 skills | c424507
2026-08-29 | wave 9 | stub kokai to four Dojo-specific principles + pointer | body 5559 → 3478 bytes (38% reduction); kokai stays user-invoked | 12 skills; two trim waves remain (slim tanren, randori glossary pin) | 4b68454
2026-08-29 | wave 10 | slim tanren to entry gate, freeze rule, hand-back invariant; mechanics → reference | 9609 → 5494 bytes (43%); discipline in body, mechanics on-demand | 12 skills; one trim wave remains (randori glossary pin) | f81bf85
2026-08-29 | wave 11 | add conceptual-exclusion rule to randori's Glossary handling (pin what each term isn't, distinct from Non-Goals) | **trim complete** (all 7 trim waves landed) | 12 skills; surviving-old waves 12–18 on the trimmed surface | b4a9fac

## Key Concepts

- **Wave cycle:** `DEFINE → RED → GREEN → REFACTOR → COMMIT`. Each step is a skill;
  the agent stops for a decision between steps in supervised mode.
- **Gate density** (supervised only): `full` / `standard` / `light` — fewer stops,
  same content, engagement note suggests lighter density on reflexive approvals.
- **Enforce over instruct:** rules are scripts (dojo-check, dojo-lint, dojo-session
  freshness rule) where possible; `kata-commit` hard-gates on the proof artifact,
  not on a claim.
- **Negative space programming:** illegal states unrepresentable in types; the
  proof artifact and the freshness rule are examples applied to process.
- **Build once, repackage many:** the compiled artifact is the product; every
  distribution format wraps it. Applied here as: the skill directories are the
  product; `npx skills add` is one of several wrapper formats.
- **Proof contract, single-sourced (Wave 1):** the proof-contract invariant (what
  `.dojo/check-proof` must contain) is normative in `dojo-principles`; the per-project
  stack executor lives in `scripts/dojo-check.sh`; hajime and DOJO-MANUAL carry
  illustrative examples that point at the principle. Lint R10 enforces structural
  equivalence (every surface references the same identifiers), not byte-equality.
- **Skill-writing vocabulary (Wave 1):** adopted from Matt Pocock's
  `writing-great-skills` (MIT). Glossary terms: `leading word`, `branch`,
  `router skill` (term kept; the skill was never built — Wave 11 invalidated),
  `single source of truth`. The sigil proposal (`_enforce_`/`_proof_`/`_bound_`)
  was invalidated post-trim; natural phrases stay canonical. Three ADRs
  (0001–0003) document the design decisions.
- **Anti-inflation charter (2026-08-31):** binding non-goals in CONTEXT.md — no router
  (until user-invoked > ~7), no new skill without a surviving failure mode, no
  capability claim without a body branch, no spec-first flow, never cut the XP skeleton
  (red-first, proof+freshness, stuck-at-two, divergence halts, engagement note) for
  tokens — trim prose, never rules.
- **Wave numbering:** TASKS.md wave numbers are canonical for plan work;
  dojo-session.md counts its own waves (off by one during the trim: TASKS Wave 4 =
  session Wave 5). Plan-less work is logged by change name, not number (progress.md).
- **Skill invocation rule (Wave 2):** every SKILL.md is classified as model-,
  user-, or session-invoked per ADR 0002. The 5 user-invoked skills
  (randori, kaizen, kan, tanren, kokai) carry
  `disable-model-invocation: true`; their descriptions no longer load every
  turn (~480 words off the always-on context tax). The 3 session-invoked
  skills (dojo-principles, dojo-project, dojo-conduct) carry a YAML rationale
  comment above the `name:` field (the YAML flag is binary; the comment is
  what distinguishes them from model-invoked in prose). Lint R11 enforces
  the rule via a single `R11_CLASSIFY` table.
- **Skip-to-implementation failure family (Wave 3):** the closed loop hajime
  Gate 0 → randori facts-vs-decisions → randori end-of-grill confirmation gate.
  Same root cause (the agent skips the planning phase when given a detailed
  starting prompt), three independent doors, one fix family. Gate 0 makes the
  first response to a human be the rigor+mode questions; facts-vs-decisions
  stops the agent from grilling itself on a question answerable from the repo;
  end-of-grill confirmation makes a finished plan a hand-off, not a starting
  gun.
- **Stale-decisions class (Wave 3):** waves that invalidate a Glossary or
  Decisions entry (rename a rule, retire a mechanism, change a recorded choice)
  must correct that entry at commit time — `kata-commit` durable-artifact item 4
  now owns this. kaizen owns *new* decisions; kata-commit owns keeping existing
  ones true. Closes the staleness class found in this repo's own CONTEXT.md
  (R10 references contradicted R6's retirement).
- **Lint R12–R14 (Wave 3):** R12 — `skill → Section` cross-references resolve to
  a real heading (eaten-heading class, prose-anchor analog of R4). R13 — no CR
  in tracked file content; the script uses `git grep | grep -q .` not
  `crlf=$(git grep ...)` because Git Bash's command substitution mangles output
  when the search pattern is CR. R14 — repo scripts executable in the git
  index (Windows `core.filemode=false` makes worktree `chmod +x` invisible to
  the index; the fix is `git update-index --chmod=+x`).

## Current State

- Package version: 1.2.0 (cut 2026-08-31 — CHANGELOG carries the full trim + closeout record).
- Working tree: clean; `dojo-check` gate **passing** — lint R1–R14, mechanics eval 12/12,
  fresh proof.
- Plan: **nothing pending.** Trim plan (Waves 4–10) done; surviving-old plan fully
  resolved — Wave 13 done (kan claim-cut), Waves 11/12/14/15/16/17 invalidated with
  reasons in TASKS.md. This repo is plan-less by design (CONTEXT.md → Decisions): new
  work arrives via `/kaizen` as needs emerge, not via a pre-baked TASKS.md.
- Skill count: 12. ADRs: 0001–0003 (0002 carries the 2026-08-31 router invalidation
  note; 0003's meta-skill wave was invalidated — the ADR stays as vocabulary provenance).
- Living artifacts: current — CONTEXT.md reconciled (router/sigil drift closed,
  anti-inflation charter added); RESUME.md restored to the one-line spec form.
- `docs/proposals/`: two executed plan files are tracked (`governance-dedup.plan.md`,
  `final-waves-13-14.plan.md`); `trim-edits/` and `trim.TASKS.md` remain untracked
  historical drafts.

## Improvement Backlog

Items the author wants to revisit at some point. Not a plan; not a commitment;
not a `TASKS.md`. Promote into a wave via `/kaizen` when the moment is right.

- Landing page (`docs/index.html`) — last regenerated from an external pages
  repo; the source of truth for visuals lives elsewhere. Re-pull as needed.
- Eval coverage — three scenarios exist (greenfield supervised, brownfield,
  autonomous-ceiling). Coverage is honest (artifact assertions only); expand
  only when a real protocol gap appears, not for its own sake.
- Promote section in `dojo-principles` — none yet. Earned by working sessions,
  not invented.
- Refactor assessment — when a wave ends, the assessment is *brief + one
  decision*. Avoid overproducing ceremony.
- `scripts/dojo-lint.sh` R4 false-positives on ADR filenames — the regex
  `\b(dojo|kata|hajime)-[a-z][a-z-]*[a-z]\b` matches ADR file names like
  `0001-dojo-check-source-of-truth.md` as if they were skill directories.
  Hit during Wave 1's refactor step when `DOJO-MANUAL.md` referenced the
  ADR by full filename. Fix candidates: tighten the regex to require the
  matched token to be an existing directory; or add ADR paths to R4's
  whitelist. Defer — current workaround is to reference ADRs by number
  only ("see ADR 0001 in `docs/adr/`").
- Wave 3 design note (from external review, 2026-07-10) — **resolved 2026-08-31, without
  the router:** the router wave was invalidated; the banner dedup kept the inline
  imperative (one banner in hajime) rather than a pointer chain — the note's warning
  about pointer chains is what the assumes-loaded notes implement.
- Wave 4 counter-proposal (from external review, 2026-07-10) — **resolved 2026-08-29:**
  the sigil tokens were invalidated post-trim; natural phrases stay canonical. Remaining
  micro-item: kata-red says "failing check", other files say "failing test" — pick the
  canonical when touching those files (not worth a lint rule).
- Wave 8 pushback (from external review, 2026-07-10) — **resolved 2026-08-29:** the
  rationale-footer wave was invalidated post-trim.
- kata-red algorithm-check slim — **declined 2026-08-31:** the design target is a
  cheap/fast model (glm-5.3-flash, medium thinking) and small local models; the
  algorithm taxonomy is deliberate scaffolding (structure rescues weak models). Revisit
  only with a receipt showing the deployed model self-supplies it.
- Post-Wave-10 kaizen candidates (from external review, 2026-07-10):
  (a) Fowler smells as leading words in green's refactor step cleanup list
  and the review principle in dojo-conduct — prior-rich terms (mysterious
  name, duplicated code, feature envy, data clumps, primitive obsession,
  speculative generality, message chains, middle man), ~10 lines, strong
  reported results upstream;
  (b) review as two *named* axes — standards conformance (AGENTS.md /
  principles) vs spec fidelity (the TASKS.md wave goal);
  (c) randori scoping mode: type each catalogued unknown
  (ask-human / research / prototype / task) with blocking order and a
  one-session-size requirement in scoping-questions.md — the Wayfinder essence,
  kept file-based and solo-first.
