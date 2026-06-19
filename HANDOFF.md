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

## Current State

- Package version: 1.1.0 (see `CHANGELOG.md`); `[Unreleased]` accumulates the
  next set of additions.
- Most recent commit: c9355b4 (`refactor(check): single-source the dojo-check template via dojo-principles`).
- Working tree: clean as of Wave 1 commit.
- `dojo-check` gate: **established and passing** — lint R1–R10, mechanics eval 12/12, fresh proof.
- Plan: TASKS.md present with 10 waves; Wave 1 done; Wave 2 (invocation rule) is the next.
- ADRs: 0001 (proof-contract SoT), 0002 (skill-invocation rule), 0003 (meta-skill as bridge) committed with Wave 1.
- Living artifacts: `CONTEXT.md`, `HANDOFF.md`, `learning-log.md`, `progress.md`, `findings.md`, `TASKS.md`, `docs/adr/` all current.

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
