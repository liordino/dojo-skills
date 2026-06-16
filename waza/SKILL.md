---
name: waza
description: >
  Recognize and handle algorithmic problems — when to use a known algorithm, when to derive a
  new one, and when to deliberately approximate. Triggers when about to write non-trivial logic
  where the approach matters: naive complexity where better exists; anything touching graphs,
  trees, search, optimization, geometry, scheduling, or parsing; or any time the agent is
  inventing a procedure rather than wiring known pieces. Triggers on: /waza, or automatically
  from kata-red/kata-green when an algorithm moment is detected. Produces a test-first
  artifact: the properties or tolerances the algorithm must satisfy go to kata-red before
  implementation. Hands off to tanren when the goal is optimizing a measurable metric rather
  than reaching one correct answer. Supervised: suggest and wait. Autonomous: proceed, logging
  the choice.
---

# Waza — Algorithmic Technique

**Before anything else: load and apply `dojo-principles`, `dojo-project`, and `dojo-conduct` now.**

*技 — skilled technique. Invoked when the work crosses from wiring known pieces into genuine
algorithm territory. Pick the right move — recognize, derive, or approximate — never hand-roll
a naive procedure when the approach matters.*

Narrate your reasoning; the choice of approach is the interesting part.

---

## When this fires

Any of: logic with worse complexity than necessary (O(n²) where O(n log n) exists; naive
recursion recomputing subproblems) · a known algorithmic domain (graphs, trees, search,
sorting, optimization, geometry, scheduling, intervals, strings/parsing, combinatorics,
numerical methods) · inventing a procedure rather than composing known operations · exact
solution looks intractable, NP-hard, or pricier than its value.

---

## Step 1 — Classify

- **A known problem in disguise?** Most novel-looking problems are a textbook problem wearing
  different vocabulary. What is this *secretly* — shortest path? interval scheduling?
  bipartite matching? topological sort? → Mode A.
- **Genuinely novel — nothing fits?** → Mode B.
- **Exact is impossible, intractable, or unnecessary?** → Mode C.
Not exclusive — a derivation may end in an approximation.

## Step 2 — Execute the mode

### Mode A — Recognition
Name the canonical problem; state the established algorithm(s), their complexity, and the
tradeoff (time vs space, simplicity vs speed, worst vs average); recommend one and why.
**The DP check (most-missed recognition):** optimal substructure? overlapping subproblems?
Both → it's DP; memoize or tabulate. This is the most common "O(exponential) where
O(polynomial) exists" — always run it when writing a recursive solution.

### Mode B — Derivation (work the moves in order)
1. **Reduction, always first.** Map the unknown problem onto a known one, solve, map back.
   Most novel problems reduce.
2. **Paradigm checklist:** divide & conquer (independent subproblems, combine) · DP (Mode A
   check) · greedy (only with an exchange argument or matroid structure — greedy is often
   wrong) · backtracking (decision search with prunable bad paths) · brute force then optimize
   (a correct O(n²) baseline is a valid first wave; optimizing is a later wave with the
   baseline as regression oracle).
3. **Correct-by-construction:** define the invariant each step must preserve; build the
   loop/recursion around it. Invariant preserved + termination guaranteed = correct by
   construction, not by hope.
4. **Verify by symbolic execution:** trace the half-built algorithm on representative inputs
   to find breaks before committing.

### Mode C — Approximation
The discipline is approximating *deliberately*, never accidentally (much of graphics/geometry
is the deliberate art of good-enough). Required for any approximation:
- **State the method** (heuristic, approximation algorithm with proven ratio, sampling,
  iterative refinement, domain approximation like LOD/perceptual).
- **State the error tolerance explicitly** — how far from exact, in what metric.
- **State why exact isn't needed or feasible.**
**Supervised: the tolerance requires human sign-off** — "how approximate is acceptable" is a
product decision. Present method + tolerance + reasoning; STOP for explicit approval.
**Autonomous:** choose a conservative tolerance, log method/tolerance/reasoning to findings.md
and HANDOFF.md, proceed — unless the tolerance is a genuine product judgment call, which is a
divergence: halt and surface.

## Optimization loop — hand to tanren (conditional, not the default)

Most algorithm work ends at Step 3: one correct approach, pinned by a test. Hand to `/tanren`
**only** when the goal is to optimize a *measurable* quality, not just to be correct — and only
when a scalar fitness metric exists (runtime, memory, approximation error, accuracy, a domain
score). This is the Mode C case (a tolerance/quality number) and the slice of Mode B framed as
"make this faster / tighter / more accurate," where Step 2's brute-force baseline becomes the
regression oracle the loop improves on. Pure correctness has nothing to hill-climb — stay on the
normal path. Tanren has a hard entry gate (frozen scorer + human-approved metric and budget) and
returns a winning implementation for kata-red to ratify; it does not replace Step 3.

## Step 3 — Produce the test-first artifact (hand to kata-red)

Every mode hands the testable contract to kata-red *before* implementation:
- **Recognition / Derivation → property-based tests:** the properties the algorithm must
  satisfy for all inputs — optimality where provable, invariants (sorted/valid/in-bounds),
  round-trips, algebraic laws. The properties are often clearer than the algorithm and guide
  the derivation.
- **Approximation → tolerance + necessary properties + golden reference:** you can't
  property-test "optimal" for a heuristic — no oracle. Assert within-tolerance of a known
  reference; assert *necessary* properties that hold even when not optimal (a TSP heuristic
  still yields a valid tour; an approximate render still has correct dimensions, no NaNs);
  use golden testing under kata-red's reference rule (ask for / create / suggest — never
  fabricate).

---

## Hand off

**Supervised:** present classification, chosen mode + approach, tradeoffs, the test-first
contract; for approximation get tolerance sign-off. STOP for approval before `/kata-red`.
**Autonomous:** select, log full reasoning to learning-log.md and findings.md, write the
contract, proceed to `/kata-red`.
