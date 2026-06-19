---
name: tanren
disable-model-invocation: true
description: >
  Iteratively forge a better algorithm by propose → score → keep-or-revert, when a problem has a
  measurable fitness metric to optimize (performance, approximation quality, a tuned heuristic) —
  not merely binary correctness. Triggers on: /tanren, or from waza when classification finds a
  scalar metric to optimize rather than a single correct answer. Hard entry gate: a fixed,
  fast, deterministic scorer and a human-approved metric + budget must exist first. Runs the
  loop in an isolated scratch area, then hands the winning implementation back to the kata
  cycle to ratify with a real test. Never edits its own scorer; never invents what "better" means.
---

# Tanren — Forge by Iteration

**Before anything else: load and apply `dojo-principles`, `dojo-project`, and `dojo-conduct` now.**

*鍛錬 — forging and tempering: a blade is made strong by repeated, disciplined hammering. Tanren
optimizes an algorithm the same way — many small attempts against one honest measure, keeping
only what is provably better.*

This is **not** a kata wave. TDD writes one binary contract and the minimum code to pass it.
Tanren searches many candidates against a *continuous* fitness measure and keeps the best within
a budget. The two are different shapes: tanren produces a **decision** (the winning
implementation + its evidence); a normal kata wave afterwards **ratifies** it with a real test.
Narrate your reasoning throughout.

---

## Entry gate — refuse unless ALL hold

Tanren is expensive and easy to misuse. Do not enter the loop unless every one of these is true;
if any fails, say which and return to the normal waza/kata flow.

1. **There is a scalar fitness metric.** "Better" is a number you can compute — runtime, memory,
   allocation count, approximation error, accuracy/F1, a domain score. If the goal is only
   "correct vs incorrect," there is nothing to hill-climb: this is plain waza, not tanren.
2. **A fixed, fast, deterministic scorer exists** (or is built first, in this step). It runs
   headless, returns the metric the same way every time, and is cheap enough to run many times.
3. **The human approved the metric and the budget.** *What counts as better* is a design
   decision — like a non-goal or a wave's verifiable outcome — so it is never invented mid-loop.
   Even in `mode: autonomous`, entering tanren requires explicit human sign-off on the fitness
   metric, the acceptance threshold, and the iteration/token/wallclock budget. Autonomy runs the
   loop; it does not get to decide what to optimize.

If the project has no measurable objective yet but you suspect one would help, that is a
randori/kaizen conversation, not a reason to enter the loop.

---

## Freeze the scorer (anti-gaming — non-negotiable)

An optimizer that can edit its own exam will cheat — this is the canonical failure of the whole
pattern, and it shows up as "the metric improved but the code is actually worse/overfit."

- The scorer (the fitness harness + its data) is **frozen** for the duration of the loop. The
  proposer may modify only the algorithm under optimization — never the scorer, never the
  evaluation data, never the metric definition. Treat the scorer like `dojo-check`: a contract,
  not a thing you rewrite to pass.
- **Score on held-out cases the proposer cannot see.** Split the evaluation set: the proposer
  may inspect a visible subset; the kept/revert decision is made on the held-out subset.
  Improvement that appears only on visible cases is overfitting — reject it.
- The scorer lives in the run's scratch area (`.dojo/tanren/score.sh`), is frozen the moment the
  loop starts, and — like dojo-check — is confirmed with the human before the first iteration
  when newly written. It is part of the disposable experiment, not the repo. If its measurement
  is worth keeping as a permanent performance-regression guard, that is a *deliberate* promotion
  into `scripts/` and dojo-check afterwards (the human's call), never the default.

---

## The loop — Propose, Score, Keep-or-Revert

State lives in a scratch area, **never** in the main spine. Create `.dojo/tanren/`:
`run.json` (the **frozen approved contract** — metric and direction, acceptance threshold, and
budget the human signed off on; written once at entry, the stopping criteria are evaluated
against it so a paused or context-compacted loop can recover its own limits from disk),
`score.sh` (the frozen scorer), `results.tsv` (the ledger — append-only, **left untracked by
git**, one row per attempt), `best.json` (the current champion: metric + the file snapshot or
its path), and candidate working files. Record the baseline (current implementation, or "none")
as row 0 before proposing anything. Mechanics, ledger schema, and a worked example:
`tanren/reference/tanren-loop.md`.

Each iteration:

1. **Propose.** Generate one change — a new approach (Mode B: "try DP with memoization over the
   current backtracking") or a tuned parameter/heuristic (Mode C: "decay factor 0.95 → 0.90").
   One hypothesis per iteration; state it before editing. Apply it to the candidate algorithm
   only — never the scorer, its data, or the metric definition. The tracked source stays at
   baseline; the candidate is the working surface (mechanics in the reference).
2. **Score.** Run the frozen scorer; capture the metric on the held-out subset. Append a row to
   `results.tsv`: iteration, hypothesis, metric, pass/fail of necessary properties, notes.
   A candidate that breaks a *necessary correctness property* (a TSP heuristic must still return
   a valid tour; an approximate result must have no NaNs and correct shape) scores as failed
   regardless of the fitness number — speed is worthless if the answer is invalid.
3. **Keep or revert.** Improved past the champion by the agreed threshold *and* properties hold
   → advance: update `best.json`, keep the change. Equal, worse, or properties broken → revert
   to the champion and discard. Either way the *reasoning* goes to the ledger; a rejected idea is
   data that should shape the next proposal.

Inner-loop economy: if a model router is configured (optional — see dojo-conduct), the
per-iteration propose/edit can run on the cheaper tier and the periodic "analyse the ledger and
steer the next proposals" step on the stronger tier. Absent a router, run it all on one model —
tanren never depends on routing.

---

## Stopping criteria — the loop is never open-ended

Stop and exit at the first of (all limits read from the frozen `run.json`):

- **Budget reached** — `max_iterations`, or the token/wallclock budget the human set. Hard cap.
- **Target met** — the metric reached the human's acceptance threshold.
- **Stagnation** — no improvement past the threshold for N consecutive iterations (default 3).
- **Stuck** — an irrecoverable error or a blocker the loop can't get past. Do not grind: write
  the full diagnostic to findings.md and behave like kata-stuck — surface to the human
  (autonomous: halt and report; never silently burn the rest of the budget).

On any stop, write the run summary (best metric, how many attempts, what worked and what didn't)
to learning-log.md and HANDOFF.md → Improvement Backlog. Keep `.dojo/tanren/` for inspection; it
is scratch, not a deliverable.

---

## Hand back to the kata cycle (ratify the winner)

Tanren does not commit. It produces a **winning design held in scratch + its evidence ledger**,
and the normal cycle ratifies it as a settled decision. The invariant that keeps this honest:
**the winner is not integrated into tracked source until the ratifying GREEN**, so RED is
genuinely red and the durable test proves it has teeth.

1. The winner stays in `.dojo/tanren/` as the chosen design. The tracked source is left at the
   pre-tanren baseline — do not commit the winner from inside the loop, and do not leave it
   sitting integrated before kata-red runs.
2. `/kata-red` writes the durable contract that pins it — the property/regression tests from
   waza Step 3 (necessary properties always; for approximation, within-tolerance of the agreed
   reference) — against that baseline. It is genuinely RED: the tracked source doesn't carry the
   winner yet, or still has the slower/old version a performance-bound assertion fails. This test
   lives in the repo forever; the tanren scorer and ledger are scratch and do not.
3. `/kata-green` integrates the winner from scratch into the tracked source — the algorithm is
   already designed and proven, so GREEN is the *integration*, not fresh problem-solving — which
   turns the check green. `/kata-refactor` cleans it; `/kata-commit` commits the integrated
   winner **only** — never the dead-end candidates or the untracked ledger. Record the chosen
   approach and its metric in the commit body and CONTEXT.md → Decisions (write an ADR if the
   choice was a real, surprising trade-off).

---

## Hand off

**Supervised:** present the entry-gate check (metric, scorer, approved budget), then — after the
loop — the champion, its metric vs baseline, the held-out evidence, and the rejected approaches
worth remembering. STOP for approval before handing to `/kata-red` to ratify.
**Autonomous:** confirm the human pre-approved metric + budget (refuse if not); run the loop to a
stopping criterion; log the full ledger summary to findings.md and learning-log.md; proceed to
`/kata-red` to ratify the winner. Never commit from inside the loop.
