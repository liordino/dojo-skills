# Dojo — A Disciplined Development System for AI Agents

> **A personal system, shared.** I built Dojo for my own work and my own way of pairing with
> coding agents, and I'm publishing it only because someone might find it useful — or might
> want to improve it together. It is not trying to be a universal framework: it's opinionated,
> and deliberately specific in places about the tools and stacks *I* use. Fork freely, adapt
> mercilessly, and read every rule as "this is what works for me," not "this is what's correct."

Dojo turns an AI coding agent into a disciplined pair-programming partner. It enforces
test-driven development in approval-gated waves, builds a shared domain language, maintains
living project documentation, keeps long sessions sharp through a context-compaction cycle,
and carries a project from idea to shipped, installable release. Landing page:
[liordino.github.io/dojo-skills](https://liordino.github.io/dojo-skills/).

Built for headless agent harnesses with tool calling; language-agnostic. Developed against my
own harness (the Pi Coding Agent) — the `/command` and auto-trigger semantics vary between
harnesses, but anything that can load `SKILL.md` files and follow them works, with at worst
degraded auto-triggering. Dojo is also **solo-first**: one human, one agent, one repo. Dojo's
whole footprint is one folder — `.dojo/` holds every artifact: the durable record at its root,
the live run in `session/`, gate evidence in `proof/`. What of it is shared is the human's
*tracking posture* decision, never assumed; a fresh session reloads from disk.

## Philosophy

Three pillars:

- **Extreme Programming pair programming** — work proceeds in discrete, approval-gated waves.
  You navigate (define what correct looks like, approve each step); the agent drives (writes
  code, runs checks, narrates reasoning).
- **Test-Driven Development** — tests are the contract. A failing check written before
  implementation is the precise definition of "done."
- **Goal-Driven Execution** — every wave is a verifiable outcome, not a task list.

## Why waves instead of a rules file?

A flat AGENTS.md asks the agent to *remember* discipline; Dojo *mechanizes* it. The failure
modes of a rules file map one-to-one onto Dojo mechanisms: silent scope creep → declared
non-goals plus the kaizen gate; "tests passed" claims → the `dojo-check` proof artifact that
only a real green run produces; long-session context rot → the compaction cycle (everything
durable on disk, each wave reloads lean); plans drifting from reality → divergence halts and
re-grilling; rubber-stamp reviews → gates that ask for a decision with content, and an
engagement note that says so when you stop deciding.

## The names

A **dojo** (道場) is the training hall — the place and practice where discipline is built. A
**kata** (型) is a form practiced within it until internalized. Dojo is the system; the kata is
the wave cycle performed inside it (the `kata-*` steps); the named techniques (hajime, randori,
kan, kaizen, kokai) are moves practiced in the hall. The prefix tells you what a
skill is: `dojo-*` governs the whole hall, `kata-*` is a step in the form, a bare name is a
technique.

## Quickstart

```bash
npx skills add liordino/dojo-skills
```

Then run `/hajime` to start. It asks rigor, mode, and whether the work is feature or bugfix; bugfix routes through `/kan`.

## The wave cycle

```text
define → red → green (refactor inline) → commit → (next wave)
```

Each step is a skill (refactor runs inside green). The agent stops for your decision between
steps (supervised mode — with a configurable gate density: full, standard, or light) or runs to
completion (autonomous mode), with mandatory human gates when reality diverges from the plan. Multi-wave work lives in
`.dojo/TASKS.md` (written by randori, advanced by kata-commit, rewritten by kaizen), so the cycle
always knows what the next wave is.

## Install

```bash
npx skills add liordino/dojo-skills                                 # everything
npx skills add liordino/dojo-skills --list                          # see what's in the repo
npx skills add liordino/dojo-skills --skill hajime --skill kata-red # be selective
npx skills add liordino/dojo-skills -a pi                           # target a specific agent
```

The `skills` CLI reads the GitHub repo directly and copies the skill directories into your
agent's skills folder (see github.com/vercel-labs/skills). Prefer manual install? Copy the
skill directories yourself — each is a directory containing a `SKILL.md`.

On a fresh project `/hajime` scaffolds everything (.dojo/CONTEXT.md, the proof-writing `dojo-check`)
and runs the design grill. On an existing project it detects what's present and
resumes — including brownfield projects with pre-existing test failures, which are tracked
rather than blocking.

## Skills

| Skill | Role |
|---|---|
| `dojo-principles` | Cross-cutting engineering principles (the code), loaded every session |
| `dojo-project` | Project-level principles (structure, docs, config, distribution, preferences) |
| `dojo-conduct` | Operational rules (precedence, evidence gates, gate density, concise output, tools) |
| `hajime` | Session entry — asks rigor, mode, then feature or bugfix (bugfix routes through `/kan`) |
| `randori` | Interview-driven design grill — domain language, ADRs, the .dojo/TASKS.md plan |
| `kan` | Disciplined diagnosis loop — reproduce → minimise → hypothesise → fix |
| `tanren` | Iterative optimization loop — forge a better algorithm against a measurable metric |
| `kata-red` | Write the failing check (test-first) |
| `kata-green` | Minimum implementation, refactor step, and stuck branch inline (the cycle is red → green → commit) |
| `kata-commit` | Commit + living docs + wave advancement + compaction |
| `kokai` | Release & distribution — install surface, CI, tag-release, changelog |
| `kaizen` | Re-grill and update the plan on discoveries or pivots |

## Engineering principles (where they live)

Cross-cutting, in `dojo-principles`: code navigation (rg/ast-grep) · DRY as agent safety ·
leverage what exists / minimal delta · define the non-goals · deterministic over probabilistic ·
negative space programming · parse-don't-validate · function purity · structured logging ·
errors-as-values · total functions · comment provenance · explicit dependencies · ECS (opt-in).

Project-level, in `dojo-project`: problem-first documentation · structure & observability ·
hierarchical AGENTS.md · versioned-example/ignored-real config · build-once-repackage-many ·
standardized entrypoints · the global preferences store.

Step-specific, in the `kata-*` skills: invariant-based engineering (kata-red) · YAGNI,
idempotency, explicit types, error propagation, refactor step, stuck branch (kata-green).

## Living artifacts

Every artifact lives under `.dojo/` (the artifact map is lint-enforced, R17/ADR 0005):

- `.dojo/CONTEXT.md` — Glossary, Non-Goals, Decisions · `.dojo/adr/` — decision records
- `.dojo/TASKS.md` — the plan: every wave a verifiable outcome with a status · Improvement Backlog (revisit items; not a plan)
- `.dojo/progress.md` — the single terse per-wave log · `.dojo/learning-log.md` — per-wave debriefs (briefs in supervised sessions)
- `.dojo/findings.md` — discoveries and halt diagnostics
- `.dojo/session/dojo-session.md` — current wave state, run-scoped · `.dojo/session/resume.md` — autonomous-pause pointer
- `.dojo/proof/` — gate evidence: `check-proof`, `check-output.log`

What of this is tracked is the repo's tracking posture — a human decision (hide-all /
hide-ephemeral / track-all), never an agent default.

## Optional tools

Dojo is self-contained — these pair well with it but are never required:

- **ast-grep** — structural code search (falls back to ripgrep)
- **graphify** — codebase knowledge graph (falls back to direct navigation). The one tool with
  active treatment: Dojo suggests refreshing its map exactly when the code structure changes.
- **caveman** — output token compression; its *principle* (terse output) is internalized in
  dojo-conduct, so the standalone tool is optional.
- **A specialized UI skill for your framework** — the refactor step in kata-green detects
  the UI framework and invokes whatever matching skill you have installed, falling back to
  general principles.

## Updating Dojo

Skill files are replaced wholesale on update, with one exception: the **Promoted (local)**
section at the end of `dojo-principles` is yours — insights you've promoted from project
learning-logs. Preserve it across updates (re-apply it after `npx skills add`, or keep it in a
fork). See CHANGELOG.md for what changed between versions. `scripts/dojo-lint.sh` checks the
package's internal consistency — run it if you edit the skills.

After updating, verify the installed copies still match the repo:

```bash
scripts/install-parity.sh <your-skills-dir>   # content-parity check; EOL-tolerant
```

Drift means the install is stale — re-run `npx skills add liordino/dojo-skills`. The check is
content-based, not byte-based: the installer may normalize line endings, and that is not drift.

## Testing This Package

If you edit a skill and want to check you haven't broken a protocol guarantee:

```bash
./scripts/dojo-lint.sh      # internal consistency: names, headings, enums, canonical templates
./evals/run-mechanics.sh    # the dojo-check + proof contract, on a fixture repo, fully automated
```

`evals/scenarios/` has three agent-replay scenarios (greenfield, brownfield, autonomous
ceiling) with assertion scripts for the resulting artifacts — useful after a bigger change.
Both add zero per-wave context cost: lint and evals are dev-time tooling, never loaded by the
agent.

## Credits

`randori` and `kan` were inspired by Matt Pocock's `grill-with-docs` and `diagnose` skills
(both MIT), reimplemented and adapted to Dojo's wave cycle and living-document architecture.
The hierarchical AGENTS.md pattern (Local Agent Contracts) is adapted from agent0ai's DOX (MIT).

## License

MIT — see [LICENSE](./LICENSE).
