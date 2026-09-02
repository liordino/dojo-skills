---
name: kata-red
description: >
  Write the failing check for the current wave. Use after /hajime has defined
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

**Supervised:** present the brief and append it to `learning-log.md` under
`## Wave [N] — Opening Brief`; at `full` density, STOP before writing the check; at
`standard`/`light`, present the brief together with the failing check at this step's single
stop. **Autonomous:** skip the brief — the commit body and the progress log carry what/why;
briefs exist for the researching human. **rigor: poc:** skip the brief; write a check
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

## Algorithm check (when the approach matters)

If this wave crosses from wiring known pieces into genuine algorithm territory —
naive complexity where better exists (O(n²) where O(n log n) does; recursion
recomputing subproblems); graphs, trees, search, optimization, geometry,
scheduling, parsing; or inventing a procedure rather than composing known ones —
**stop and pick the approach before writing the check.** Plain wiring, CRUD,
glue: skip this.

Three moves, in order:

- **Recognize.** Most novel-looking problems are a textbook problem in disguise —
  shortest path, interval scheduling, topological sort, matching. Name it; use the
  known algorithm. The most-missed one: optimal substructure + overlapping
  subproblems → it's DP, memoize (this is the usual "exponential where polynomial
  exists").
- **Derive** (nothing fits) — reduce to a known problem first; else pick the
  paradigm (D&C, DP, greedy *only* with an exchange argument, backtracking) and
  build around a stated invariant.
- **Approximate** (exact is intractable or unnecessary) — state the method, the
  **error tolerance** (in what metric), and why exact isn't needed. **Supervised:
  the tolerance needs human sign-off** — "how approximate is acceptable" is a
  product decision. STOP for it.

**Write the check against the approach, test-first:**

- Recognition/derivation → **property-based tests**: the properties the algorithm
  must satisfy for all inputs (optimality where provable; invariants
  sorted/valid/in-bounds; round-trips; algebraic laws). The properties are often
  clearer than the algorithm and guide it.
- Approximation → **tolerance + necessary properties + golden reference**: you
  can't property-test "optimal" without an oracle. Assert within-tolerance of a
  known reference; assert necessary properties that hold even when not optimal (a
  TSP heuristic still yields a valid tour). Golden reference under the reference
  rule below — never fabricate one.

**Optimizing a measurable metric, not just reaching correct?** If — and only if —
a scalar fitness metric exists (runtime, memory, approximation error, accuracy, a
domain score) and you want to *improve* it rather than just be correct, hand to
`/tanren` (hard entry gate: frozen scorer + human-approved metric and budget; it
returns a winner for kata-red to ratify). Pure correctness has nothing to
hill-climb — stay here.

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
