# Changelog

All notable changes to the Dojo skill package. Format: [Keep a Changelog](https://keepachangelog.com); versioning is package-wide.

## [Unreleased]

### Added

- **`tanren` skill** (鍛錬 — "forge by iteration") — an optional, gated iterative-optimization
  loop (propose → score → keep-or-revert) for algorithm problems that have a *measurable
  fitness metric*, not merely binary correctness. Inspired by the propose/score/keep-or-revert
  pattern popularized by Karpathy's `autoresearch` and the FunSearch/AlphaEvolve lineage, adapted
  to Dojo's evidence discipline. Hard entry gate (scalar metric + frozen deterministic scorer +
  human-approved metric and budget, required even when autonomous); freezes the scorer and scores
  on held-out cases to resist metric-gaming; runs in an isolated `.dojo/tanren/` scratch area
  with an untracked results ledger; stops on budget/target/stagnation/stuck; and hands the
  winning implementation back to the kata cycle to ratify with a durable test (commits the winner
  only). It is explicitly *not* a kata wave — it produces a decision; a normal wave ratifies it.
  waza now hands off to it when classification finds an optimization objective rather than one
  correct answer.
- **`tanren/reference/tanren-loop.md`** — loop mechanics, ledger schema, the frozen-scorer
  contract, keep-or-revert variants (scratch-dir vs Karpathy's branch advance/reset), a worked
  approximation example, and the anti-gaming checklist. Loaded on demand.
- `dojo-lint.sh` R9 — checks the tanren reference exists and still carries its safety-critical
  markers (frozen scorer, held-out, budget/stagnation).
- **`evals/run-mechanics.sh`** — fully automated eval that extracts the canonical dojo-check
  template live from `hajime/SKILL.md`, runs it on a fixture repo, and asserts the entire
  proof contract (written-on-green, sha matches output, freshness rule, no rewrite on
  failure). Fails loudly if the canonical template drifts.
- **`evals/scenarios/`** — three agent-replay scenarios (greenfield supervised, brownfield,
  autonomous-ceiling) with assertion scripts checking the resulting artifacts (TASKS.md
  state, dojo-session advancement, RESUME.md, gitignore, proof). Honest split: judgment isn't
  testable, artifacts are.
- **`hajime/reference/dojo-check.ps1`** — PowerShell variant of the canonical dojo-check
  template for Windows-only sessions; bash remains canonical. On-demand reference, zero
  recurring context cost (same pattern as `dojo-principles/reference/ast-grep.md`).
- `dojo-lint.sh` R8 — checks the PowerShell reference exists and still contains the proof
  contract markers.
- **`docs/adr/`** — architecture decision records. Three ADRs ship with this cycle:
  `0001-dojo-check-source-of-truth` (the proof-contract SoT split), `0002-skill-invocation-rule`
  (model- vs user- vs session-invoked), `0003-meta-skill-bridge-not-fork` (the meta-skill is a
  bridge to upstream `writing-great-skills`, not a fork).
- **`TASKS.md`** — the multi-wave plan. Surfaced by the audit-driven randori: 10 waves ordered
  by risk and dependency, each a single verifiable outcome.
- **`dojo-lint.sh` R10** — replaces the retired R6 byte-equality check. Asserts every
  normative surface (dojo-principles, scripts/dojo-check.sh, hajime, DOJO-MANUAL, the
  PowerShell reference) references the same proof-contract identifiers (`check-proof`,
  `output_sha256`, `check-output.log`). Structural equivalence, not byte-equality.
- **Skill-writing vocabulary adopted from `writing-great-skills` (Matt Pocock, MIT).** New
  glossary entries in CONTEXT.md: `leading word`, `branch`, `router skill`, `single source of
  truth`, plus the leading words `_enforce_` and `_proof_`. Bridge, not fork; ADRs cite the
  upstream; the meta-skill (Wave 10) carries the attribution.

### Changed
- **dojo-check template source-of-truth split** (Wave 1 of 10). The proof-contract invariant
  is normative in `dojo-principles → Enforce Over Instruct — the Proof Contract`; per-project
  stack commands live in `scripts/dojo-check.sh`; hajime's inline block and DOJO-MANUAL's
  mirror are illustrative examples that point at the principle. Surfaces can diverge in prose
  so long as they reference the same identifiers (R10 enforces agreement).
- **`dojo-lint.sh` R6 retired.** Byte-equality between hajime's bash block and the manual's
  block is no longer the contract; R10 (structural-equivalence via identifier presence) replaces
  it. The new check matches what the wave's goal actually claims.

## [1.1.0] — 2026-06-12

A consistency and hardening release driven by a full external audit of v1.0. Skills are now
purely normative (terse rules); rationale lives in DOJO-MANUAL.md. Recurring per-wave context
cost dropped ~36% with no rule removed.

### Fixed

- **The wave loop now has an iterator.** randori writes `TASKS.md` (every wave a verifiable
  outcome with `status: pending|done|invalidated`); kata-commit marks waves done and advances
  the next pending goal into `dojo-session.md`. Previously no skill created the plan or
  advanced `goal:` between waves.
- **dojo-check proof deadlocks.** hajime-bugfix and both manual templates scaffolded scripts
  without the proof artifact that kata-commit hard-gates on. One canonical template now lives
  in hajime §3, mirrored (and lint-verified identical) in manual §5; kata-commit upgrades
  legacy scripts instead of blocking forever.
- **Brownfield adoption.** hajime no longer refuses to start on a non-green baseline: it
  records `pre_existing_failures` (previously bugfix-only), enforces *no new failures*, and
  offers a stabilization wave 0.
- **CONTEXT.md contract contradiction.** Now exactly three sections — Glossary, Non-Goals,
  Decisions — consistently across randori, hajime (log sink), dojo-principles (non-goals),
  dojo-project, and kaizen.
- **dojo-conduct truncation.** The graphify "active treatment" contract is now actually
  written in the governing skill (was a dangling sentence).
- **Description/manual drift:** dojo-conduct's description now advertises the precedence
  hierarchy (and no longer a nonexistent rationale section); manual skill summaries are maps
  with pointers, not mirrored rule lists; "16" skills (was "10"); removed the orphan "issue
  tracker configuration"; "root cause from kan" (was the pre-rename skill name); dead `DEFINE`
  state removed and `STUCK` actually written by kata-stuck; walkthrough 7.1 now shows the real
  refactor-assessment gate; dangling sentence fragments completed.
- **Spec DRY violations:** kata-red's duplicated Algorithm-check section, kata-green's
  duplicated waza trigger, the quick-reference's duplicate `/waza` row, waza's incoherent
  step numbering.
- **Plan-file split-brain:** the secondary plan filename is gone; `TASKS.md` everywhere.

### Changed

- **`mode` split into `mode` (supervised|autonomous) and `rigor` (real|poc)** — orthogonal
  axes; PoC sessions now have defined gating, and kata-refactor gained a PoC branch
  (formatter only).
- **Commit staging is explicit** — never `git add -A`. `git status` review at the gate plus a
  secrets/size denylist; autonomous halts on a hit.
- **`dojo-session.md` is gitignored** (per-machine state); HANDOFF.md is the resume surface.
  hajime scaffolds both ignore entries.
- **Proof freshness is operationally defined** (no edits after the run that wrote it) and the
  canonical template hashes portably (`sha256sum` → `shasum -a 256` fallback; Windows via Git
  Bash/WSL noted).
- **Resume is crash-aware:** dirty-tree mid-flight offers resume vs reset-to-commit;
  interrupted artifact updates after a commit are detected and completed.
- **Preferences store path** is now `~/.config/dojo/preferences.md` (old `kata/` path migrated
  on first read).
- README reframed: a personal system, shared — plus solo-first scope, harness-portability
  honesty, and "why waves instead of a rules file."
- Named third-party UI skills generalized to "whatever specialized UI skill is installed";
  stack/language tooling specifics retained by design.

### Added

- **Gate density** (`full|standard|light`, dojo-conduct): fewer supervised stops, same
  content, with the engagement note suggesting lighter density on reflexive approvals.
- **Configurable wave ceiling** + **RESUME.md**: autonomous runs pause at a clean checkpoint
  with a one-line continuation pointer instead of silently stopping.
- **Non-automatable waves** have a defined path in kata-red (script assertion / golden diff /
  recorded manual verification) — never a wave with no check.
- **Promoted (local)** section in dojo-principles — the consented home for promoted insights,
  preserved across updates.
- **`(provisional)` glossary markers** in randori, challengeable in later sessions.
- **`scripts/dojo-lint.sh`** — enforce-over-instruct applied to Dojo itself: stale-name,
  duplicate-heading, dangling-section, skill-reference, state-enum, and canonical-template
  checks. Run it after editing any skill.
- **`dojo-principles/reference/ast-grep.md`** — pattern syntax and task table, loaded on
  demand instead of every session.
- This CHANGELOG, and a "Cost of the system" section (manual §5b) with measured context
  numbers.

## [1.0.0]

Initial system: the 16 skills, the wave cycle, the manual.
