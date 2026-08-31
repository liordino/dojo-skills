# Plan — close out the last two surviving-old waves (13, 14)

Runnable plan for your harness. These are the final two pending waves from the old
writing-great-skills plan. Inspecting them against the *current* trimmed files
changed the verdict on one of them — read before running.

**Stale dependencies (clear these regardless):** Wave 13 was `blocked-by: 12`
(invalidated — sigils) and Wave 14 was `blocked-by: 13` (a serialization choice,
never a real dependency — disjoint files). Both blockers are fictional now. Clear
the `blocked-by` fields as part of this.

---

## Wave 13 — fix kan's description/body mismatch (DO — as a claim-cut)

status: pending  (blocked-by: cleared — was 12, now invalidated)

**The defect (real):** `kan/SKILL.md`'s description promises "Disciplined diagnosis
loop for hard bugs **and performance regressions**." The body has no
perf-regression branch — its only regression content is step 6 "Regression-test,"
which is about the *reproduction becoming a kata-red test*, not performance. A
skill claiming a capability its body doesn't deliver is the no-op/premature-
completion failure mode — worth fixing.

**The fix — cut the claim, do NOT add a perf branch.** kan doesn't do performance
work and (per the smallest-conscious-surface direction) shouldn't grow a new
branch to justify a description clause. Drop the promise to match the body.

Edit `kan/SKILL.md`, description (frontmatter), first line:
```
Disciplined diagnosis loop for hard bugs and performance regressions. Use when something is
```
→
```
Disciplined diagnosis loop for hard bugs. Use when something is
```

If — and only if — you actually *want* kan to handle performance regressions (a
real capability decision, not a docs fix), the alternative is to add a genuine
perf-regression section to the body. Default: don't. Cut the claim.

**Verified by:** kan's description no longer says "performance regressions"; the
body is unchanged; `rg "performance regression" kan/SKILL.md` returns nothing;
lint + mechanics green.

---

## Wave 14 — INVALIDATE (inspection showed no real duplication)

status: invalidated  (blocked-by: cleared)

**Why invalidated, not run.** The old plan described this as "three dojo-* skills
carry description/body sentences duplicating 'code rules live in dojo-principles;
operational rules live in dojo-conduct' — drop the duplicating body sentences."
Against the current trimmed files, that premise is false:

- The cross-reference sentences exist **only in the frontmatter descriptions**, not
  duplicated in the bodies. There are no "duplicating body sentences" to drop.
- In the description, the pointer is **doing its job**: the description is what an
  agent reads when deciding which governance file to load. "Code rules live in
  dojo-principles; operational in dojo-conduct" is a *routing* pointer — it sends a
  lookup to the right file. That's navigation, not redundancy.
- The three are not identical — each points outward from its own skill to the other
  two. Cutting them would remove real disambiguation to save three short clauses,
  making the descriptions slightly *worse* at their one purpose (routing).

So there's nothing redundant to cut here. Mark it invalidated with the reason:
"inspection 2026-08-29: premise stale — the cross-refs live only in the
descriptions (where they route correctly), not duplicated in the bodies; nothing
to trim." (If the bodies duplicated the pointer when the old plan was written,
the trim already removed it.)

---

## After running

1. Wave 13: kan description trimmed, gates green.
2. Wave 14: marked invalidated in TASKS.md with the reason above.
3. Clear the now-fictional `blocked-by` fields on both.
4. This empties the pending queue — TASKS.md has no `pending` waves left. The whole
   surviving-old plan is now either done or invalidated. Clean slate.

That's the last of the inherited plan closed out — nothing left armed for a future
autonomous run to pick up.
