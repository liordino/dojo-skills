---
# invocation: session-invoked — see ADR 0002
name: dojo-project
description: >
  Project-level principles: how a project is structured, documented, configured, distributed, and
  how Dojo stores personal preferences. Load alongside dojo-principles at session start, and
  consult at lifecycle points (project setup, randori design, kokai release). Covers problem-first
  documentation, project structure and observability, local agent contracts (hierarchical
  AGENTS.md), the versioned-example/ignored-real config pattern, build-once-repackage-many, the
  global preferences store, and the preferences-vs-insights promotion rule. Code-level rules live
  in dojo-principles; operational rules in dojo-conduct.
---

# Dojo Project — Project-Level Principles

Rules only. Rationale lives in the dojo-skills source repo, at `.dojo/DOJO-MANUAL.md` in
that repo — not in the local project's `.dojo/`.

## Problem-First Documentation

- The README leads with the problem and the audience, not the tech. Implementation detail
  belongs in `docs/`, after the problem is established.
- If the problem can't be stated in one sentence, that's a design smell, not a docs smell —
  feed the question into randori before code.
- The surface the user touches (install, problem statement, honest docs) outranks internal
  engineering for whether a project lives or dies.

## Project Structure and Observability

- Use framework-conventional directory structure; record deviations in AGENTS.md.
- Keep source files small (split past a few hundred lines); agents read in slices.
- Observable commands: one command per gate (`make test`, `make lint`, `make dojo-check`).
- Idempotent setup: `bin/setup` works on a clean machine without guidance.
- Standardized, agent-legible entrypoints: same names, same contract in every project —
  `bin/setup` prepares, `bin/deploy` ships, a tag cuts a release. Contents are stack-specific;
  names and contract are constant. Predictable structure is what makes delegation safe.
- Content/docs-only repos may substitute their published surfaces (README, CONTEXT) for
  `bin/` entrypoints and AGENTS.md; record the substitution in `.dojo/CONTEXT.md` → Decisions.
- `README.md`: architecture, component map, key flows (Mermaid/ASCII). Not a tutorial.
- `AGENTS.md` / `CLAUDE.md`: imperative bullets only — build/test/lint commands, deviations,
  files not to touch, footguns. Dense; re-read every query.
- `.dojo/CONTEXT.md`: exactly three sections — **Glossary**, **Non-Goals**, **Decisions**. Nothing
  else (contract defined in randori).
- `.dojo/adr/`: decision records; read before touching any module in a decision's area.

## Local Agent Contracts (hierarchical AGENTS.md)

- Root AGENTS.md is the project-wide contract. A child AGENTS.md owns local rules for its
  subtree — created only when a folder becomes a durable boundary. Small projects keep only root.
- Before editing any path, read its chain root → target. Closer wins on local detail; no child
  may weaken a parent.
- After a change that alters a subtree's structure, contracts, or footguns: update its owning
  AGENTS.md; delete stale text immediately. Contracts, not diary entries.
- No index files — the filesystem is the index.

## Config: Versioned Example, Ignored Real

- Commit `config/*.example` (structure + fictitious values). Gitignore the real one (hosts,
  users, paths, tokens). Never commit real configuration containing secrets or environment
  specifics.

## Build Once, Repackage Many

- The compiled artifact (per architecture) is the product; every distribution format wraps that
  same artifact. Compile once, reuse in every packaging step — one source of truth, no
  divergence. (Packaging mechanics live in kokai.)

## Global Preferences Store (personal, machine-local)

- Durable facts about how the human likes to work live at `~/.config/dojo/preferences.md`
  (markdown, human-editable; migrate any old `~/.config/kata/preferences.md` on first read).
  Examples: commit style, log sink, mode, gate density, wave ceiling, stack, tooling.
- Read at session start (hajime variants) to turn cold questions into confirm-or-override.
- Written only with explicit consent. Supervised: propose saving when a durable preference is
  noticed. Autonomous: accumulate candidates; present as a batch in the end-of-run report.
- A convenience, never a dependency: machine-local, never in a repo; projects carry everything
  they need in their own files.

### Preferences vs insights — what may be globalized

- **Preferences** (about you) are safe to globalize: they don't rot or conflict.
- **Insights** (about a technical situation) stay per-project in .dojo/learning-log.md. An insight
  earns global status only by **promotion into dojo-principles → Promoted (local)** — a
  deliberate, human-approved, versioned edit. That section is preserved across Dojo updates.
