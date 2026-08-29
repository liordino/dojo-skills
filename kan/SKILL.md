---
name: kan
disable-model-invocation: true
description: >
  Disciplined diagnosis loop for hard bugs and performance regressions. Use when something is
  broken and the cause is not obvious. Triggers on: /kan, or automatically from hajime's
  bugfix fork after "feature or bugfix?", or from green's stuck branch when the blocker is
  a bug. Follows reproduce → minimise → hypothesise → instrument → fix → regression-test. The reproduction becomes the
  kata-red regression test. Respects supervised/autonomous mode and divergence detection.
  Feeds findings into findings.md.
---

# Kan — Disciplined Diagnosis

**Before anything else: load and apply `dojo-principles`, `dojo-project`, and `dojo-conduct` now.**

Narrate every phase: hypotheses, evidence, elimination.

---

## The one thing that matters: a reproducible signal

> If you have a fast, deterministic, agent-runnable pass/fail signal for the bug, you will
> find the cause. If you don't, no amount of staring at code will save you.

Everything else is mechanical — bisection, hypothesis-testing, and instrumentation all consume
that signal. Spend disproportionate effort getting one. Be aggressive, be creative, refuse to
give up. This is the skill; the rest is procedure.

---

## The loop

### 1. Reproduce

A deterministic pass/fail signal for the *exact* reported bug — not a nearby failure. Cheapest
harness that reaches it: a failing test at whatever seam works (unit/integration/e2e) · a
curl/HTTP script against a dev server · a CLI invocation with a fixture, diffing stdout
against known-good · a headless browser script asserting on DOM/console/network · replaying a
captured trace through the code path in isolation · a throwaway harness (minimal subsystem,
mocked deps, one function call).

Cannot reproduce → stop. Do not hypothesise blind. Supervised: ask for a captured artifact
(log, HAR, core dump), environment access, or permission to instrument. Autonomous: halt and
log to findings.md what's needed. Do not guess.

### 2. Minimise

Shrink to the smallest form that still triggers it. A one-line repro points almost directly at
the cause.

### 3. Hypothesise

Specific and falsifiable — "the parser drops the last token when input has no trailing
newline," never "something's wrong with the parser." Rank by likelihood.

### 4. Instrument

Test each hypothesis against the signal — logging, asserts, breakpoints. The signal decides,
not intuition. Eliminate until one stands.

### 5. Fix

Fix the cause, not the symptom — the **smallest change that fixes the cause, reusing what's
there**. If the proper fix genuinely requires more than a targeted change, that's a divergence
(below), not license to widen scope. The fix itself runs in the kata cycle: kan identifies and
confirms; kata-green implements.

### 6. Regression-test

The reproduction from step 1 *is* the regression test: fails now, must pass after the fix.
Hand it to kata-red as the wave's failing test.

---

## After diagnosis: what would have prevented this?

If the answer is structural — no good test seam, tangled callers, hidden coupling — record it
with specifics in HANDOFF.md → Improvement Backlog. The bug is a symptom worth recording even
when fixing the structure is a separate wave.

---

## Divergence

Root cause differs from the reported symptom in a way that changes the plan — a deeper design
problem, or a fix that means design change rather than patch:
**Supervised:** present what you found; recommend `/kaizen`.
**Autonomous:** halt, write to findings.md and HANDOFF.md, surface, recommend `/kaizen`.
Never expand scope autonomously into a design change.

---

## Hand off

Present: confirmed root cause, the reproduction (now the regression test), the prevention note
if any. Supervised: wait for approval before the fix begins. Hand the regression test to
`/kata-red`.
