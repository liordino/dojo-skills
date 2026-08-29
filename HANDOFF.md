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
├── TASKS.md                    # the plan: 10 waves, every wave a verifiable outcome
├── docs/
│   ├── index.html              # static landing page (GitHub Pages-friendly)
│   └── adr/                    # architecture decision records (lazy; 0001-0003 as of Wave 1)
├── scripts/
│   ├── dojo-lint.sh            # static consistency checker (R1–R10; R10 replaces retired R6)
│   └── dojo-check.sh           # wave gate (lint + mechanics-eval + proof artifact)
├── evals/
│   ├── run-mechanics.sh        # automated mechanics eval; deterministic
│   └── scenarios/              # agent-replay scenarios with assertion scripts
├── hajime/                     # the 16 skills (dojo-*, kata-*, bare-named)
├── hajime-bugfix/
├── randori/
├── kan/
├── waza/
├── tanren/
├── kata-red/
├── kata-green/
├── kata-refactor/
├── kata-commit/
├── kata-stuck/
├── kokai/
├── kensha/
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

2026-06-19 | wave 1 | single-source dojo-check template via dojo-principles (R10 replaces retired R6; ADRs 0001/0002/0003 + TASKS.md land with the wave) | commit c9355b4
2026-06-19 | wave 2 | classify every skill per invocation rule (ADR 0002); 7 user-invoked + 3 session-invoked; R11 single-table classifier | commit 4168c6e
2026-08-29 | wave 3 | land Wave-2 review fixes + repair R13 grep; Gate 0 in hajime, facts-vs-decisions in randori, kata-commit item 4 (CONTEXT.md), R12–R14 in dojo-lint, exec-bit index mode flipped for 6 scripts, `## Logging` heading restored in dojo-principles | dirty tree from interrupted kata-commit cleared; clean green baseline ready for the trim plan in `docs/proposals/` | next: Wave 4 promotes the trim plan into TASKS.md as the active plan (supersedes pending Wave 5 of the writing-great-skills plan)

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
  `writing-great-skills` (MIT). New glossary entries: `leading word`, `branch`,
  `router skill`, `single source of truth`, plus the leading words `_enforce_` and
  `_proof_`. Three ADRs (0001–0003) document the design decisions; Wave 4 will
  retire the English phrases in favour of the leading words.
- **Skill invocation rule (Wave 2):** every SKILL.md is classified as model-,
  user-, or session-invoked per ADR 0002. The 7 user-invoked skills
  (randori, kaizen, kan, waza, tanren, kensha, kokai) carry
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

- Package version: 1.1.0 (see `CHANGELOG.md`); `[Unreleased]` accumulates the
  next set of additions.
- Most recent commit: Wave 3 lands after this section is updated (housekeeping
  - Wave-2 review fixes); recorded in Wave History above.
- Working tree: clean as of Wave 3 commit (Gate 0, facts-vs-decisions, item 4,
  R12–R14, exec-bit flips, Logging-section restoration, durable-artifact
  updates all landed).
- `dojo-check` gate: **established and passing** — lint R1–R14, mechanics eval
  12/12, fresh proof.
- Plan: TASKS.md currently holds the 10-wave writing-great-skills plan (Waves
  1–2 done, 8 pending). The trim plan lives in `docs/proposals/trim.TASKS.md`
  (untracked) and will be promoted into TASKS.md at Wave 4, replacing the
  pending list with 14 waves: 7 trim + 7 surviving-old.
- ADRs: 0001 (proof-contract SoT), 0002 (skill-invocation rule — implemented
  in Wave 2), 0003 (meta-skill as bridge) committed.
- Living artifacts: `CONTEXT.md`, `HANDOFF.md`, `learning-log.md`, `progress.md`,
  `findings.md`, `TASKS.md`, `docs/adr/` all current.

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
- Wave 3 design note (from external review, 2026-07-10) — when the router lands
  and the 9 inline governance banners come out, keep a one-line inline
  *imperative* ("Load `dojo-principles`, `dojo-project`, `dojo-conduct` now —
  index: `/dojo`") rather than a pure pointer to the router. A pointer chain
  (skill → router → governance) is the exact may-not-follow unpredictability
  ADR 0002 quotes, applied to the most load-bearing directive in the system.
  Also: ship Wave 3 soon — since Wave 2, the 7 user-invoked skills have hidden
  descriptions and no index yet.
- Wave 4 counter-proposal (from external review, 2026-07-10) — the sigil tokens
  `_enforce_` / `_proof_` / `_bound_` contradict the glossary's own definition
  of a leading word ("recruiting priors the model already holds"): sigils have
  no priors. Keep the natural phrases canonical ("enforce over instruct",
  "proof artifact"), define each once in the glossary, and lint *variant drift*
  instead (ban "check artifact", "verification file", etc.). First known drift
  to fix under that rule: kata-red says "failing check", other files say
  "failing test" — pick the canonical and enforce it.
- Wave 8 pushback (from external review, 2026-07-10) — per-H2 rationale footers
  fail the deletion test the plan champions: ~14 always-loaded lines whose only
  consumer is a human who owns the manual, agent behavior unchanged, and the
  per-file "Rationale lives in DOJO-MANUAL.md" pointer already exists. Drop, or
  invert into a manual-side index.
- Post-Wave-10 kaizen candidates (from external review, 2026-07-10):
  (a) Fowler smells as leading words in kata-refactor's cleanup list and
  kensha's quality pass — prior-rich terms (mysterious name, duplicated code,
  feature envy, data clumps, primitive obsession, speculative generality,
  message chains, middle man), ~10 lines, strong reported results upstream;
  (b) kensha review as two *named* axes — standards conformance (AGENTS.md /
  principles) vs spec fidelity (the TASKS.md wave goal);
  (c) randori scoping mode: type each catalogued unknown
  (ask-human / research / prototype / task) with blocking order and a
  one-session-size requirement in scoping-questions.md — the Wayfinder essence,
  kept file-based and solo-first.
