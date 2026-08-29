---
name: kata-green
description: >
  Write the minimum implementation to make the failing check pass. Use after /kata-red.
  Triggers on: /kata-green, "green step", "implement", "make it pass".
  Reads dojo-session.md for goal, mode, rigor, gate density. Applies YAGNI, idempotency,
  explicit types, and error rules. Runs dojo-check — no new failures allowed. Two-attempt stuck
  branch and the refactor step inline (the cycle is now red → green → commit; refactor and
  stuck are sections inside green, not separate skills). Supervised: stops per gate density.
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
approach) → stop and pick the approach (kata-red's algorithm check); route any new properties
back through the failing-check-first discipline.

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
   re-run, narrating what changed and why. `attempts == 2` → do not try a third time — enter
   the **Stuck** branch below.
4. **On pass:** update dojo-session.md: `step: REFACTOR`, `test_status: passing ✓`,
   `attempts: 0`.

---

## Refactor (in-place — no longer a separate step)

If the human takes the refactor (supervised) or always (autonomous), clean the code just
written. **The constraint: no new behavior.** Something worth adding → note it for the next
wave. Behavior added here skips RED and has no check — the exact failure mode the cycle
prevents. **rigor: poc:** run the formatter only.

Clean in priority order:

1. **Small units + SRP** — functions > 20 lines: extract. Files > 300 lines: split by
   responsibility. "and" in the description: split.
2. **Names** — `rg "name" .` > 5 relevant hits → rename more specifically; names off the
   CONTEXT.md glossary → rename to match. Verify structurally with `sg -p 'oldName($$$)'`.
3. **DRY** — structural duplicates via `sg` (text grep misses same-shape/different-names);
   any pattern twice gets extracted now. `sg -p 'old' -r 'new'` for safe rewrites;
   dojo-check after.
4. **Formatting** — the project formatter decides; no debates.
5. **Comment provenance** — add the *why* for non-obvious GREEN decisions; delete comments
   restating code; update docstrings if the public interface changed.
6. **Specialized UI pass** — UI touched → detect the framework, invoke whatever UI skill
   is installed; none → general principles. (dojo-conduct pairs-well-with.)

Run `dojo-check` after each meaningful change (`dojo-check-fast` inner loop; full before
hand-off). A test breaks → the refactor changed behavior: revert that change and reassess.
**Autonomous:** apply the assessment, re-run; still green → commit; broken → revert the
refactor entirely, keep the working GREEN, log to progress.md, add the opportunity to HANDOFF
Improvement Backlog, proceed. Never commit a broken refactor — minimal working beats clean
broken.

Set `step: COMMIT` when done (or immediately if refactor declined).

---

### Stuck — two attempts, then surface (no third pass)

`attempts == 2` → **stop. Do not attempt a third implementation pass.** Set `step: STUCK` in
dojo-session.md (resume checks recognize it as mid-flight). XP norm: don't grind — grinding
burns tokens, accumulates bad state, destroys the reasoning trail.

Present a structured diagnostic, no omissions:

- **What was attempted** — each attempt: approach, change, the *raw* dojo-check output
  (not summarized — the human needs the real signal).
- **Root cause hypothesis** — specific; "I don't know" is not one. Uncertain → 2–3
  candidates with confidence levels.
- **What would resolve it** — the specific thing: environment access, a domain
  clarification, permission to instrument, a different check formulation.

Offer 2–3 concrete adjusted approaches (what changes / the risk / what it unblocks). Standard
candidates:

1. **Reframe the check** — it may specify internals rather than observable outcome → back
   to `/kata-red` (`step: RED`).
2. **Descope the wave** — a smaller first wave that passes → `/kaizen` to split it in
   TASKS.md.
3. **Investigate first** — run `/kan` on the specific failure before another attempt.

**Supervised:** present everything, STOP: "Which direction?" Route per the choice (new
approach → back into green with `attempts: 0`; human investigates → write findings.md, end
cleanly leaving `step: STUCK`). **Autonomous:** attempt option 1 (least risky) once. Passes
→ continue. Fails → HALT: full diagnostic to findings.md, log "halted at STUCK after [N]
attempts — human review required," commit nothing.

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

**Autonomous:** apply the refactor assessment inline (the Refactor section above), run
dojo-check, then proceed to `/kata-commit`.
