---
# invocation: session-invoked — see ADR 0002
name: dojo-principles
description: >
  Cross-cutting engineering principles for the code itself. Load at session start alongside
  dojo-project and dojo-conduct; every skill applies these in every step, language, and session.
  Contains: code navigation (rg/ast-grep), DRY, leverage/minimal-delta, non-goals,
  deterministic-over-probabilistic, negative space, parse-don't-validate, function purity,
  logging, errors-as-values, total functions, comment provenance, explicit dependencies, the ECS
  decision rule, and locally promoted insights. Operational rules live in dojo-conduct;
  project-level rules in dojo-project. Step-specific rules (invariants, YAGNI, idempotency,
  types, formatting) live in the kata-* skills.
---

# Dojo Principles — Cross-Cutting Engineering Rules

Rules only. Rationale and examples live in .dojo/DOJO-MANUAL.md.

## Code Navigation — rg and ast-grep

- `rg "name"` answers **text frequency**: naming distinctness. A good, specific name returns
  ≤ 5 relevant hits; more means the name is too generic. Use rg for comments and strings.
- `sg` (ast-grep, optional) answers **structure**: call sites, definitions, type usages — real AST
  nodes, never comments or strings. Use it before changing any signature, to find structural
  duplicates, and for safe rewrites (`sg -p 'old($X)' -r 'new($X)' --lang <l>`).
- Rule: question about *structure* → `sg`; question about *text frequency* → `rg`. If `sg` is
  absent, fall back to `rg` and verify matches manually.
- Pattern syntax and the full task table: `dojo-principles/reference/ast-grep.md` (load on demand).

## DRY — Don't Repeat Yourself (Agent Safety)

- Factor repeated logic into one reusable unit immediately.
- The same pattern appearing twice gets consolidated **before** a diverging third copy exists.

## Leverage What Exists — Build the Minimal Delta

- Survey before building: what in the codebase, environment, or upstream already provides part
  of this? Read the code / query the graph — never assume from scratch.
- Build the smallest delta that **fully** achieves the outcome. Start from existing data,
  artifacts, or seams. Minimal delta is not permission to under-deliver.
- Question both ends of the task boundary: it can often start later (from what exists) or end
  earlier than assumed.
- Name what you're tempted to build but don't need — and cut it.

## Define the Non-Goals

- State explicitly what someone might reasonably expect this to do that it won't. Record them in
  .dojo/CONTEXT.md → Non-Goals.
- Non-goals are a commitment: never drift across the line, never suggest building one; treat an
  attempt as a scope violation.
- Crossing the line is deliberate and recorded — via /kaizen with an ADR, never silent creep.

## Prefer Deterministic Over Probabilistic

- Deterministic possible → strongly prefer it (parsing, classification of known formats,
  validation almost never need a model).
- Probabilistic is the only option (genuinely fuzzy: natural language, image content, open
  generation) → use it, note the choice, proceed. Nothing to decide.
- Both plausible → a real judgment call. **The gate:** never silently pick probabilistic.
  Present both options + tradeoffs (testability, cost, latency, determinism, maintainability).
  Supervised: wait for the human. Autonomous: halt and surface if contestable; if clearly
  deterministic territory, use the deterministic solution and note it.

## Negative Space Programming (Make Invalid States Unrepresentable)

Strongest first:

- Illegal states unrepresentable in types: enums for closed sets; sum types / discriminated
  unions where each case carries exactly its valid fields — never nullable-field-plus-flags.
- Constrain at construction: validate once at the boundary, return a type that guarantees
  validity (the constructor is the only way to make one).
- Exhaustive matching, no silent fallthrough: a new variant must fail to compile, not route to
  a `default`.
- No partial construction: an object is fully valid the moment it exists.
- Narrow types over wide ones: validate at the boundary where the language can't constrain.
- Relationship to fail-fast: design the bad state out first; assert against what you couldn't
  design out second.

## Parse, Don't Validate

- `parse(input) -> Result<Narrow, Error>`, never `validate(input) -> bool` with the raw value
  passed onward. Downstream code receives already-proven types and never re-checks.
- Push parsing to the system boundary; the output type is *narrower* than the input —
  narrowing is the point (`string → Email`, `int → Port`, `JSON → Order`).

## Function Purity and Side-Effect Isolation

- Functional core, imperative shell: IO, network, DB, randomness, time live in a thin shell at
  the boundary; the logic in the middle is pure.
- A function needing time takes time as a parameter; one needing randomness takes a seed.
- Pure functions need no mocks. Needing a mock to test a function means a side effect should be
  lifted out.

## Enforce Over Instruct — the Proof Contract

This is the canonical home of the **dojo-check proof contract**. Anything that defines what
a green run proves lives here; nothing else restates it.

The artifact: `.dojo/proof/check-proof` — written by `scripts/dojo-check.sh` after a fully green
run (`set -e` + `set -o pipefail` reaches the proof block only on success). It contains
exactly three lines:

```
ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)
exit=0
output_sha256=$(sha .dojo/proof/check-output.log | awk '{print $1}')
```

- `ts` is the wall-clock time the proof was written (ISO-8601 UTC).
- `exit=0` records that every check passed; a non-zero run never rewrites the file.
- `output_sha256` is the sha256 of `.dojo/proof/check-output.log` — the full stdout/stderr of the
  check run. The log is the *input*; the proof is the *seal*.

The **freshness invariant** is part of the contract: the proof's `ts` must be newer than
every tracked source file. `kata-commit` enforces this before any commit — a stale proof
cannot pass the gate. Edit anything after the run, the proof is no longer fresh; re-run
dojo-check.

**Where the contract is referenced from:** `scripts/dojo-check.sh` writes it (the per-project
stack executor); `hajime/SKILL.md` and `.dojo/DOJO-MANUAL.md` carry *illustrative* cargo-shaped
examples that point here; `hajime/reference/dojo-check.ps1` carries the Windows variant
(same contract, PowerShell). The PowerShell reference and any future per-stack variants
must reference `check-proof`, `output_sha256`, and `check-output.log` to keep agreement;
`scripts/dojo-lint.sh` R10 enforces the structural equivalence.

When in doubt about the contract, change it here — the proof rule is one place.

## Logging — Structured, at the Boundary

- Logging is a side effect: the shell logs; the pure core stays silent (propagate outward as a
  value if something deep is worth logging).
- Structured JSON Lines — one object per line: `ts` (ISO-8601), `level`, `event`
  (snake_case), plus event-specific keys. Levels are the standard four (error = couldn't
  complete, with context · warn = recovered/degraded · info = significant lifecycle, lean ·
  debug = dev tracing, off in prod).
- Context in every line: what, where, and the identifying ids needed to trace it.
  **Never log secrets or PII** — no passwords, tokens, keys, auth headers, bodies that may
  contain them. Hard rule.
- Sink is an injected `LogSink.write(event)` interface, chosen per project and recorded in
  .dojo/CONTEXT.md → Decisions. Any remote sink degrades to a local JSONL file when unreachable; a
  logging failure never propagates as an application failure.

## Errors as Values vs Exceptions

- Expected, recoverable failures return values: `Result<T,E>` (Rust), `(T, error)` (Go),
  Result/Option types (C#/TS). The failure is in the signature; the caller must handle it.
- Exceptions/panics are reserved for the truly exceptional: invariant violations, programmer
  errors, unrecoverable corruption — the fail-fast cases.
- Never use exceptions for control flow.

## Total Functions (Total at the Edges, Fail-Fast Inside)

- At the boundary: be total — expected failure becomes `Result`/`Option`, part of the type.
- Internally: fail-fast on the impossible — assert and crash; do not contort invariants into
  defensive `Option` returns.
- Prefer narrowing the input over widening the output: `divide(a, b: NonZeroInt)` is total
  because the bad input can't be constructed.

## Comment Provenance

- Provenance = what the code can't say: why this approach, what bug motivated it, what
  constraint forces this order, what upstream issue it works around. Write these freely.
- Docstrings with intent + usage example for all non-trivial public interfaces.
- Never prune agent-written provenance comments unless they restate the obvious. Never write
  obvious comments.
- Decision rule: explains *why* → keep. Restates the code → delete.

## Explicit Dependencies and Stateless Processors

- A unit never instantiates its own hard dependencies; it receives them.
- Prefer stateless processors (data in → data out) over DI ceremony; a pure function has no
  dependency problem. Containers (where native, e.g. ASP.NET) are a composition root only,
  never the architecture driver.
- Config values are centralized; a value in 24 files needs a 24-file commit.

## ECS Architecture (Opt-In, Restricted Scope)

Apply only when **all** hold: a tick/update loop drives the system; entities are numerous and
compositionally varied; data-oriented / cache-friendly layout is a concrete requirement; strict
state/behavior separation is a correctness need. Never for REST APIs, CLIs, daemons, scripts,
pipelines, or frontend trees. The entity/component/system rules and the legacy escape hatch:
`dojo-principles/reference/ecs.md` (load on demand).

## Promoted (local)

Insights promoted from project learning-logs by explicit human approval (see dojo-project).
This section is yours; preserve it across Dojo updates.

- **Names describe function; configuration describes policy.** Never bake a policy choice
  (what is ignored, shared, or deployed where) into an identifier, file, or folder name —
  names must survive every policy change without renaming. The policy lives in its own
  surface, presented with each option's consequence, applied by the human; and the
  *effective* policy is verified against recorded intent (evidence, e.g.
  `git check-ignore -v`) rather than assumed from file contents. (dojo-skills consolidation,
  2026-09-03; ADR 0005)
