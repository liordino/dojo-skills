---
name: kata-green
description: >
  Write the minimum implementation to make the failing check pass. Use after /kata-red.
  Triggers on: /kata-green, "green step", "implement", "make it pass".
  Reads dojo-session.md for goal, mode, rigor, gate density. Applies YAGNI, idempotency,
  explicit types, and error rules. Runs dojo-check — no new failures allowed. Two-attempt stuck
  protocol. Ends with the refactor assessment. Supervised: stops per gate density.
---

# Dojo Green — Minimum Implementation

*You are in the GREEN step.* Read dojo-session.md now; apply goal, mode, rigor, and
test_written. Narrate your approach and decisions before writing code.

---

## YAGNI — the entire point

Implement exactly what the failing check requires. Nothing more. No interfaces with one
implementation, no configuration a test can't reach, no base classes for hierarchies that
don't exist, no "we might need this later" — later has its own wave. Catch yourself building
an unrequired abstraction → stop, delete it.

**Algorithm moment mid-implementation** (secretly-exponential loop, genuinely unclear
approach) → invoke `/waza` before hand-rolling; route any new properties back through the
failing-check-first discipline.

**Determinism gate** (dojo-principles): about to introduce an LLM/model/non-deterministic
component where a deterministic solution plausibly exists → present both + tradeoffs and let
the human decide (supervised) or halt and surface if contestable (autonomous). No
deterministic option → note it, proceed.

---

## State idempotency

Any mutation must be safe against re-execution. Absolute ops (`x = true`) are naturally
idempotent; relative ops (`count += 1`) need protection:
```
// ✗ Fragile            // ✓ State check             // ✓ Idempotency key
applyDiscount(o):       applyDiscount(o):             charge(id, amt):
    o.total -= 10           if o.applied: return          if db.has(id): return db.get(id)
                            o.total -= 10                 r = gateway.charge(id, amt)
                            o.applied = true              db.save(id, r); return r
```
Prefer immutability — a free idempotency mechanism: C# `record` + `with` · Rust `let` by
default · Go small structs by value · C/C++ `const` aggressively.

## Explicit types

No untyped containers where a concrete type fits: avoid `any`/`object` (TS/C#),
`interface{}` (Go), `void*` (C/C++), overused `Box<dyn Trait>` (Rust). Make illegal states
unrepresentable before reaching for a runtime check (dojo-principles → Negative Space):
sum types over nullable+flags, boundary validation returning guaranteed-valid types,
exhaustive matching with no silent default.

## Errors — context and propagation

Every error states what was received, what was expected, where it failed. Unrecoverable
(invariant violated, programmer error) → crash loudly (`panic!`, `abort()`,
`InvalidOperationException`). Recoverable (expected failure, user input, external system) →
propagate explicitly (`Result<T,E>`, error returns). Never exceptions for control flow; never
swallow errors.

## Control flow

Maximum 2 levels of nesting. Guard clauses at the boundary; early returns over nested
conditionals.

## Structural navigation before implementation

Use `sg` (fall back to rg) to check what exists before writing: an implementation under a
different name? callers whose signatures this affects? the type already defined? Structural
matches only — no comment/string false positives. (Patterns:
dojo-principles/reference/ast-grep.md.)

---

## Execution

1. Write the minimum implementation.
2. Run `dojo-check` (compile → lint → test; `dojo-check-fast` is fine for the inner loop, full
   check before handing off). Compile failure ≠ test failure — diagnose separately. **No new
   failures allowed** — everything green except `pre_existing_failures`. **rigor: poc:** the
   gate is compile + lint; tests only if the PoC wrote one.
3. **On failure:** increment `attempts` in dojo-session.md. `attempts < 2` → diagnose, adjust,
   re-run, narrating what changed and why. `attempts == 2` → do not try a third time; trigger
   `/kata-stuck`.
4. **On pass:** update dojo-session.md: `step: REFACTOR`, `test_status: passing ✓`,
   `attempts: 0`.

---

## Hand off

**Supervised:** present together, at this step's stop (per gate density): the implementation
diff, the green dojo-check output (noting the fresh `.dojo/check-proof`), the key decisions —
and the **Refactor Assessment**:

Scan what was just written and name every refactor opportunity — **what** (the specific
function/class/pattern), **why** (the principle violated or risk carried), **improvement**
(what concretely gets better). Honest and specific; a clean wave still deserves at least one
observation, but never invent issues — "nothing significant, because X" is a valid finding.
Then ask:
```
Want to refactor?
  1. Yes — I'll handle the opportunities above
  2. Yes — with these instructions: [you tell me]
  3. No — go straight to /kata-commit
```
At `light` density: don't stop here — auto-apply the assessment and carry diff + assessment +
refactor summary to the commit gate.

**Autonomous:** log diff and assessment to `progress.md`; proceed to `/kata-refactor` with the
opportunities as its scope.
