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
├── TASKS.md                    # optional plan; absent by design in this repo
├── docs/
│   ├── index.html              # static landing page (GitHub Pages-friendly)
│   └── adr/                    # architecture decision records (lazy)
├── scripts/
│   ├── dojo-lint.sh            # static consistency checker for the package
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
├── dojo-principles/
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

<!-- future entries -->

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
- **Plan-less-by-design** (this repo): TASKS.md is absent. New work enters via
  `/kaizen` when needs emerge; `/randori` writes a plan only if the work spans
  multiple waves.

## Current State

- Package version: 1.1.0 (see `CHANGELOG.md`); `[Unreleased]` accumulates the
  next set of additions.
- Most recent commit: see `git log -1`.
- Working tree: clean (verified at session start).
- `dojo-check` gate: **not yet established** (this turn scaffolds it).
- Living artifacts: `CONTEXT.md` and `HANDOFF.md` exist as of this session;
  `learning-log.md` / `progress.md` / `findings.md` to be created when content
  warrants them (lazy per hajime §3).
- Design plan (`TASKS.md`): absent by design for this repo.

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
