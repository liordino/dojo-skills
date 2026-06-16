---
name: kata-red
description: >
  Write the failing check for the current wave. Use after /hajime or /hajime-bugfix has defined
  the wave goal. Triggers on: /kata-red, "write the test", "red step".
  Reads dojo-session.md for goal, mode, rigor, and gate density. Applies invariant-based
  engineering and the test-strategy rules; runs dojo-check to confirm the new check fails for
  the right reason. Supervised: stops per gate density. Autonomous: proceeds immediately.
---

# Dojo Red — Write the Failing Check

*You are in the RED step of the kata cycle.*

## Reload working context from disk

A fresh wave reloads from durable files, never from prior-wave conversation:
1. `dojo-session.md` — goal, **intent** (keep it in mind for every micro-decision), mode,
   rigor, gate_density, commit style.
2. `progress.md` — what previous waves built and expose.
3. `HANDOFF.md` → Current State.
4. `CONTEXT.md` — domain language (used in all names) and **Non-Goals** (the divergence check
   cannot fire without them in context).
5. The **AGENTS.md chain** for the paths this wave touches (dojo-project → Local Agent
   Contracts).
6. The governance files — if compaction or a fresh session may have evicted
   `dojo-principles`/`dojo-project`/`dojo-conduct`, reload them. Compaction releases *wave*
   context; governance stays active every wave.

Prior-wave conversation (old diffs, debriefs, test iterations) is disposable — it is on disk.

Narrate what you're testing and why before writing any code.

---

## Wave Opening Brief

Frame the wave, lean — point, don't lecture:
- **What:** the specific types/files/behaviours this wave builds. 1–2 sentences.
- **Why:** why it exists and why now; what it enables. 1–2 sentences.
- **Concepts to explore:** a bare list, by name only (e.g. "functional core, imperative
  shell"), for the human to research. Explain inline only if the human set that preference.
- **Bigger picture:** one sentence — what precedes, what follows, what breaks without it.

Append to `learning-log.md` under `## Wave [N] — Opening Brief`.

**Supervised:** at `full` density, present and STOP before writing the check; at
`standard`/`light`, present the brief together with the failing check at this step's single
stop. **Autonomous:** write to the log only. **rigor: poc:** skip the brief; write a check
only for the single risky core claim, else go straight to a minimal spike in kata-green.

---

## Invariant-based engineering (the contract you're writing)

The check specifies **what must be true**, not how to achieve it.

| Context | Tool |
|---|---|
| System boundary — external input | Guard clause / early return + descriptive error |
| Internal domain logic — must always hold | Assert / invariant check (absence here is a bug) |

```
processOrder(order):
    if order == null: throw ArgumentError("processOrder: order must not be null")   // boundary
calculateTax(order):
    assert(order.items.length > 0, "calculateTax: order " + order.id + " has no items") // invariant
```
Production-safe assertion per language: C/C++ custom macro or `abort()` (assert is stripped by
NDEBUG) · C# `throw new InvalidOperationException` (Debug.Assert stripped in Release) · Go
`panic` · Rust `assert!`/`panic!`/`unreachable!` · JS/TS `node:assert` or `throw`.

---

## Algorithm check (waza trigger)

If this wave involves an algorithmic problem — naive complexity where better exists; graphs,
trees, search, optimization, geometry, scheduling, parsing; or inventing a procedure rather
than wiring known pieces — **invoke `/waza` first.** It classifies (recognition / derivation /
approximation) and returns the properties or tolerances the algorithm must satisfy; write the
checks against that contract. Plain wiring, CRUD, glue: skip waza.

---

## Check rules

- **One behavior per check.** Multiple concerns fail silently on the wrong one.
- **Name describes behavior:** `applyDiscount_isIdempotent_whenCalledTwice`, never
  `testApplyDiscount`.
- **Don't mock what you don't own** — mock at system boundaries only.
- **Use CONTEXT.md domain language** in every name and assertion.
- **Bugfix:** the regression test goes first and reproduces the *exact* failure mode.

## Choosing the strategy (preference order)

1. **Property-based — strongly preferred where a property exists.** Idempotency
   `f(f(x))==f(x)` · round-trip `decode(encode(x))==x` · invariants (sorted/bounded/valid) ·
   algebraic laws. Frameworks: proptest/quickcheck (Rust), FsCheck/CsCheck (C#), gopter (Go),
   fast-check (TS). Coordinate/geometry math, idempotency rules, and parsers are prime
   candidates.
2. **Golden / snapshot — where correctness is a reference, not a property** (rendering,
   layout, serialization). When the reference is missing: **ask** the human for it, **create**
   it if you can produce a known-correct output deterministically, or **suggest** candidates
   for the human to confirm. Never fabricate a reference — a wrong golden makes a green test lie.
3. **Example-based — everything else.**

**Priority when multiple checks are needed:** invariant → idempotency → contract →
integration (sparingly).

**Non-automatable waves** (docs, config, visual outcomes): the wave goal must state its
verification. Prefer wiring a script assertion or golden diff into dojo-check; only if
genuinely not automatable, record `test_written: manual: [verification]` and the human
confirms it at the gate. Never leave a wave with no defined check at all.

---

## Execution

1. Write the check(s).
2. Run `dojo-check` (or the targeted runner, e.g. `dojo-check-fast` if the project defines
   one — full dojo-check still gates the commit).
3. Confirm: new check **fails for the right reason**; existing tests still pass (no *new*
   failures beyond `pre_existing_failures`).
   - Passes immediately → the implementation exists or the check is wrong. Diagnose first.
   - Existing tests broke → you introduced a compile error or conflict. Fix before presenting.
4. Update dojo-session.md: `step: GREEN`, `test_written: [names]`, `test_status: failing ✓`.

---

## Hand off

**Supervised:** present the check and the failing output; explain what it proves and why it
fails now. STOP per gate density. Suggest: "Red for the right reason. Run **/kata-green**."
**Autonomous:** log to `progress.md`; proceed to `/kata-green` immediately.
