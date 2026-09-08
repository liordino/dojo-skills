# ADR 0006 — The branching convention: plan branches

- **Status:** accepted
- **Date:** 2026-09-08
- **Context:** the repo had no branching strategy. The facts on the ground: trunk-only by
  practice (one branch, zero merge commits, every wave a direct proof-gated commit), the site
  publishing to GitHub Pages on every push, no CI, no PR flow, one human plus agent sessions.
  The grill (randori, 2026-09-08) named four pains the convention must defend: (a) unproven
  work landing on a publishable main, (b) unsanctioned agent commits with no isolation to
  review or unwind, (c) experiments polluting mainline history, (d) drift — every project and
  session inventing its own git flow.

## Context

Two granularities were weighed against the human's own scenarios — *give up on a plan*,
*park a feature and work another*, *two features alternately across sessions*:

- **Model F — one branch per plan**, the plan's waves landing on it as commits, merged to
  `main` at plan completion.
- **Model W — one branch per wave**, merged back at each kata-commit.

F wins on the scenarios that matter: giving up a plan is deleting a branch (`main` never saw
any of it — not even completed waves), parking is a native branch state, and two features
alternate as two branches. W leaves already-merged waves on `main` when a plan dies, turning
abandonment into reverts, and drags merge logic into kata-commit — a deeper cut into the
settled cycle. F is also the smaller wiring: kata-commit keeps committing to the current
branch; only hajime grows create/resume/merge.

Merge autonomy: merges are the natural close of a hajime session — the agent is capable of
it (supervised: propose; autonomous: self), not a separate skill. Push stays human in every
case, including branches: the human is the only publisher. Usable work on abandoned branches
is harvested — lessons are often learned in abandoned code. Worktree-based same-machine
parallelism is wanted someday, deliberately deferred ("evolve slowly").

## Decision

1. **One plan branch per plan** (`plan/<slug>`), created by hajime at session start or
   resumed by it. Uniform: single-wave plans, bugfix plans, and PoC plans included — no
   trivial-fix exception. The plan's waves land on it as proof-gated commits.
2. **`main` is the integration line.** Only completed plan branches merge, at plan
   completion — every wave on them proof-gated. Nothing lands unproven, directly or
   partially. The invariant is normative in `dojo-principles` → The Integration Line; the
   lifecycle rules in `dojo-conduct` → The Branching Convention.
3. **Merge at plan-complete close of the hajime session.** Agent-capable: supervised mode
   proposes, the human approves or reproves; autonomous mode merges itself. No kata-merge
   skill.
4. **The agent never pushes** — branches or `main`. Push is the human's publish act.
5. **Parked ≠ abandoned.** A halted plan keeps its branch; the resuming session lands back
   on it. Forgotten branches are tolerated; `git branch` is the registry, no parking notes.
6. **Abandonment is the human's decision** (autonomous runs halt on divergence rather than
   abandoning). The agent executes the harvest: durable-record updates written on the branch
   (findings, lessons, `.dojo/poc-lessons.md`) land on `main` as their own commit; reusable code is
   carried back only if the human names it; then the branch dies.
7. **PR clause.** Wherever PRs exist, the agent may prepare and advise, but AI revision
   never replaces human presence: a human must be present at review and merge.
8. **Out of scope by design:** worktree-based same-machine parallel sessions (deferred to
   the backlog — revisit via kaizen), team/multi-human flow, release branches (releases are
   tags), and any publish/site coupling in the convention text (consumers vary per project).

## Consequences

- hajime gains branch create/resume and the close-of-session merge; kata-commit gains one
  guard (a wave commit while on `main` → halt, the branch was never created). The red →
  green → commit loop itself is untouched; this ADR is the settled-cycle sanction.
- A lint R (wave 3) asserts cross-surface agreement of the convention tokens.
- Retroactivity: none. This session's own waves land on `main` — the wiring is its wave 2;
  the convention starts with its first new plan.
- Installs receive the convention with their next install refresh; `install-parity.sh` will
  report DRIFT until then.

## Alternatives considered

- **Model W (branch per wave, merged at kata-commit).** Rejected: abandonment keeps landed
  waves on `main`; merge ceremony per wave with no second reviewer to serve; deeper cut into
  kata-commit.
- **Git-flow (develop/release branches).** Rejected: built for scheduled releases and
  parallel teams; releases here are tags.
- **A separate scratch-branch escape lane for experiments.** Dissolved: a PoC or risky spike
  is simply a plan branch that dies instead of merging — one mechanism, two endings.
- **PR pipeline + branch protection.** Rejected as machinery for a solo repo (review is the
  gates plus human approvals); the human-presence clause records the principle for repos
  that do use PRs. Protection config, if ever wanted, is human-applied (sharing boundary).
