# tanren — Loop Mechanics, Ledger, and Worked Example

Load on demand. The normative rules live in `tanren/SKILL.md`; this file is the how.

## Scratch layout

```
.dojo/tanren/
  run.json         # frozen approved contract: metric (+direction), threshold, budget — written once at entry
  score.sh         # the frozen fitness scorer for this run (scratch; promote to scripts/ only on purpose)
  results.tsv      # the ledger — append-only, ONE row per attempt, left UNTRACKED by git
  best.json        # current champion: metric + snapshot/path of the winning algorithm file
  candidates/      # optional: snapshots of attempts worth keeping for inspection
```

Everything here is scratch for the duration of one optimization run. Only the *winner* leaves,
via the normal kata commit. `.dojo/` is already gitignored by hajime, so the ledger is untracked
automatically — mirroring Karpathy's autoresearch, where the results file is deliberately not
committed and the code history is the research trail.

## results.tsv schema

Tab-separated, header first. One row per scored attempt, including the baseline as iteration 0.

```
iter	hypothesis	metric	props_ok	kept	notes
0	baseline (current impl)	1840ms	yes	-	starting point
1	memoize subproblem table	1210ms	yes	yes	clear win, advanced
2	iterative bottom-up DP	1185ms	yes	yes	small further gain
3	pack state into bitset	1190ms	yes	no	no improvement, reverted
4	prune dominated states	0980ms	yes	yes	best so far
```

`metric` is whatever the frozen scorer prints (lower-is-better or higher-is-better — state which
in the header note). `props_ok` is the necessary-correctness check: `no` means the candidate is
disqualified regardless of its metric. `kept` records the advance/revert decision on the
**held-out** subset.

## Scoring contract (the frozen scorer)

`.dojo/tanren/score.sh` — written/confirmed before iteration 1, then frozen. It must:
- run headless, exit 0 on a successful scoring run;
- print the metric in a fixed, parseable form (e.g. a single number, or `metric=NNN`);
- evaluate the algorithm on the **held-out** set for the kept/revert decision;
- run the necessary-property checks and signal failure clearly.

The proposer never edits this file or its data during a run. If the scorer itself needs to
change, that ends the current run — a moved goalpost invalidates the ledger. It is scratch by
default; if the metric is worth a permanent guard, promote a copy into `scripts/` and wire it
into dojo-check deliberately, after the run.

```bash
#!/usr/bin/env bash
# score.sh — FROZEN during a run. Prints the fitness metric for the current algorithm.
set -e
# 1. build if needed
# 2. run necessary-property checks on held-out cases; fail loudly if broken
# 3. measure and print the metric (single parseable value)
#    e.g.: hyperfine / time for runtime, a harness for accuracy, /usr/bin/time -v for memory
```

## Keep-or-revert mechanics

Two equally valid implementations; pick per project:

**Scratch-dir (recommended for Dojo).** The algorithm file is edited in place; the champion's
copy is held in `best.json`/`candidates/`. On revert, restore the file from the champion
snapshot. No git churn during the loop; the wave's single commit captures the winner. This keeps
real history clean — dozens of dead ends never enter it.

**Branch advance/reset (Karpathy's original).** Work on a throwaway branch; on improvement keep
the commit (advance), on no-improvement `git reset --hard` back to the prior good state. Faithful
to autoresearch, but only use it on a disposable branch you discard after extracting the winner —
never let exploratory commits reach a working branch.

Either way: **the main branch and the Dojo spine (TASKS.md, dojo-session.md) see nothing until
the winner is ratified.** Loop state is not a wave step; do not invent a `running` task status or
a search state in the step enum.

## Worked example (Mode C — approximation)

Goal: a render approximation must stay within 2% SSIM of a golden reference while cutting frame
time. Metric = frame time (lower better); necessary property = SSIM ≥ 0.98 vs golden, no NaNs.

1. Freeze `score.sh`: renders the held-out scene set, asserts SSIM ≥ 0.98, prints mean
   frame time. Human approves metric (frame time), threshold (any improvement ≥ 3%), budget
   (12 iterations).
2. Baseline row 0: 14.2 ms, props ok.
3. Iterate: LOD bias, sample-count cuts, early-out heuristics — each scored on held-out scenes.
   Candidates that drop SSIM below 0.98 are `props_ok=no`, rejected no matter how fast.
4. Stop at the budget (or a stagnation run of 3). Champion: 9.6 ms at SSIM 0.985.
5. Hand to `/kata-red`: write the durable tests — SSIM-within-tolerance vs the golden set, plus
   "output has correct dimensions and no NaNs." `/kata-green` already passes; commit the winner,
   record the approximation method + tolerance in CONTEXT.md → Decisions.

## Anti-gaming checklist

- Scorer and data frozen; proposer edits only the algorithm. ✓
- Kept/revert decided on held-out cases, not the visible ones. ✓
- Necessary correctness properties gate every candidate before the metric counts. ✓
- A metric improvement with broken properties is a rejection, not a win. ✓
- Suspiciously large jumps get inspected, not auto-accepted — they are often a leak between the
  algorithm and the scorer (the optimizer found the test, not the solution).
