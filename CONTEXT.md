# Context — dojo-skills

## Glossary

- **dojo-skills** — this repository. The Dojo development system packaged as a set of
  installable agent skills (`dojo-*`, `kata-*`, and bare-named techniques), plus the manual,
  README, changelog, landing page, and dev-time tooling (`dojo-lint.sh`, `evals/`).
- **skill** — a directory containing a `SKILL.md` file (the load-on-trigger contract), plus
  optional `reference/` and `examples/` subdirectories. The agent loads `SKILL.md` at the
  named trigger; references are loaded on demand for zero recurring context cost.
- **wave** — one verifiable outcome in `TASKS.md`; one trip through the
  `DEFINE → RED → GREEN → REFACTOR → COMMIT` cycle.
- **dojo-check** — the canonical gate script. Always produces `.dojo/check-proof` as
  evidence; `kata-commit` hard-gates on it.
- **dojo-lint** — `scripts/dojo-lint.sh`; static internal-consistency checker for this
  package (R1–R9). Dev-time tooling, not a wave gate.
- **eval** — automated scenario under `evals/`; deterministic, no agent required. Honest
  split: judgment isn't testable, artifacts are.
- **author / package owner** — the human who develops Dojo on their own harness and
  publishes it; the implicit audience for any change here is also *future* agents that
  will install and use the skill set.

## Non-Goals

- **Not a general-purpose agent framework.** Dojo is opinionated and specific to one human's
  workflow. Other harnesses / stacks are tolerated where they don't add cost, but Dojo will
  not grow to be "framework-agnostic" or "stack-agnostic" for its own sake.
- **Not a teaching platform.** The skill files are terse rules (rationale in `DOJO-MANUAL.md`).
  No tutorials, no exhaustive prose.
- **Not a curated marketplace.** We don't take contributions lightly; quality and cohesion
  of the system outweigh adding skills. New techniques require a clear gap (decision in
  randori, not bolt-on).
- **Not a substitute for the user's own judgment.** Gates ask for a decision with content,
  not assent. Dojo never silently rubber-stamps.
- **Not testing "AI judgment" via evals.** The evals test *artifacts* and *deterministic
  protocol guarantees* — never whether the agent made a "good" decision.

## Decisions

- **Log sink.** `n/a` — this package ships no application code; it produces
  skill/markdown/HTML artifacts and runs lint + mechanics-eval scripts, none of which
  emit application log events. LogSink does not apply at this level. (If a future
  in-repo tool emits structured logs, choose then; default would be JSONL file.)
- **Package distribution.** Skill directories copied verbatim into the user's agent
  skills folder via `npx skills add <url>`. The `Promoted (local)` section in
  `dojo-principles` is the only file the user is expected to preserve across updates
  (preserved across updates by re-applying it after `npx skills add`, or by keeping it
  in a fork).
- **Documentation split.** Skill files = terse rules only (DOJO-MANUAL holds rationale);
  README = problem-first; CHANGELOG = Keep a Changelog format; CONTEXT.md = exactly
  Glossary/Non-Goals/Decisions; ADRs in `docs/adr/` for non-obvious decisions.
- **Content-repo gate.** `dojo-check` for this repo composes `dojo-lint` (static) +
  `evals/run-mechanics.sh` (proof-contract behavior). No fabricated compile/test step;
  the canonical proof-artifact contract from `hajime/SKILL.md` is preserved verbatim
  (lint R6 enforces the upstream canonical-template equivalence independently).
- **Mode / rigor default for sessions in this repo.** `real` / `supervised` /
  `gate_density: standard` (declared by the human at hajime start; recorded in
  `dojo-session.md` per wave). Plan-less by design: features are added via `/kaizen`
  as needs emerge, not via a pre-baked `TASKS.md`.
- **Commit style.** `conventional` (declared by the human at hajime start; recorded in
  `dojo-session.md` per wave).
- **Wave ceiling default.** 4 (per dojo-project preference default; recorded in
  `dojo-session.md` per wave).
