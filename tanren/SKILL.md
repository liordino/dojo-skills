---
name: tanren
disable-model-invocation: true
description: >
  Iteratively forge a better algorithm by propose → score → keep-or-revert, when a problem has a
  measurable fitness metric to optimize (performance, approximation quality, a tuned heuristic) —
  not merely binary correctness. Triggers on: /tanren, or from kata-red's algorithm check when
  a scalar metric is the goal rather than a single correct answer. Hard entry gate: a fixed,
  fast, deterministic scorer and a human-approved metric + budget must exist first. Runs the
  loop in an isolated scratch area, then hands the winning implementation back to the kata
  cycle to ratify with a real test. Never edits its own scorer; never invents what "better" means.
---

# Tanren — Forge by Iteration

*鍛錬 — forging and tempering. Tanren searches many candidates against one honest measure and
keeps the best within a budget — not a kata wave. Mechanics live in
`tanren/reference/tanren-loop.md` (load on demand); this skill carries the discipline.*

---

## Entry gate — refuse unless ALL hold

Tanren is expensive and easy to misuse. Do not enter the loop unless every one of these is true;
if any fails, say which and return to the normal kata flow.

1. **There is a scalar fitness metric.** "Better" is a number you can compute — runtime, memory,
   allocation count, approximation error, accuracy/F1, a domain score. If the goal is only
   "correct vs incorrect," there is nothing to hill-climb: this is plain correctness work,
   not tanren.
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
- **Score on held-out cases the proposer cannot see.** Improvement that appears only on visible
  cases is overfitting — reject it.
- The scorer lives in the run's scratch area (`.dojo/tanren/score.sh`), is frozen the moment the
  loop starts, and is part of the disposable experiment, not the repo. If its measurement is
  worth keeping as a permanent performance-regression guard, that is a *deliberate* promotion
  into `scripts/` and dojo-check afterwards (the human's call), never the default.

---

## Hand back to the kata cycle (ratify the winner)

Tanren does not commit. It produces a **winning design held in scratch + its evidence ledger**,
and the normal cycle ratifies it as a settled decision. The invariant that keeps this honest:
**the winner is not integrated into tracked source until the ratifying GREEN**, so RED is
genuinely red and the durable test proves it has teeth.

1. The winner stays in `.dojo/tanren/` as the chosen design. The tracked source stays at the
   pre-tanren baseline — do not commit the winner from inside the loop.
2. `/kata-red` writes the durable contract that pins it — the property/tolerance contract from
   the algorithm check — against that baseline. It is genuinely RED: the tracked source doesn't
   carry the winner yet, or still has the slower/old version a performance-bound assertion fails.
3. `/kata-green` integrates the winner from scratch into the tracked source — the algorithm is
   already designed and proven, so GREEN is the *integration*, not fresh problem-solving — which
   turns the check green. Green's refactor step cleans it; `/kata-commit` commits the integrated
   winner **only** — never the dead-end candidates or the loop's scratch ledger. Record the chosen
   approach and its metric in the commit body and .dojo/CONTEXT.md → Decisions.

---

## Hand off

**Supervised:** present the entry-gate check (metric, scorer, approved budget), then — after the
loop — the champion, its metric vs baseline, the held-out evidence, and the rejected approaches
worth remembering. STOP for approval before handing to `/kata-red` to ratify.
**Autonomous:** confirm the human pre-approved metric + budget (refuse if not); run the loop to a
stopping criterion; log the full ledger summary to .dojo/findings.md and .dojo/learning-log.md; proceed to
`/kata-red` to ratify the winner. Never commit from inside the loop.

State lives in `.dojo/tanren/` (`run.json`, `score.sh`, `results.tsv`, `best.json`). Load
`tanren/reference/tanren-loop.md` for the full mechanics: ledger schema, propose/score/keep-or-
revert per iteration, stopping criteria, worked example.
