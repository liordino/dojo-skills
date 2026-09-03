---
name: kaizen
disable-model-invocation: true
description: >
  Re-grill and update a project in light of new circumstances, discoveries, or pivots. Use
  when something must change mid-project, a discovery invalidates the plan, you're extending a
  finished project, or an autonomous run halted on a divergence. Triggers on: /kaizen, "the
  plan needs to change", "I discovered something", "let's pivot", "add a feature to this
  project". Reads current reality (progress.md, TASKS.md, CONTEXT.md, ADRs, git
  log), grills the change with the human, then rewrites TASKS.md and updates CONTEXT.md, ADRs,
  and dojo-session.md. Always supervised — grilling is never autonomous.
---

# Kaizen — Re-Grill and Update Against New Reality

*Assumes the governance trio (`dojo-principles`, `dojo-project`, `dojo-conduct`) is loaded — hajime loads it at session start; if you're starting from here, load it first.*

*Updates the plan; never writes code — code changes happen in subsequent
kata waves.*

Narrate throughout — you are helping the human think through what changed and what it means.

---

## 1. Read current reality

Ground the conversation in what exists: TASKS.md (the plan, tombstone ledger, and
Improvement Backlog) · progress.md (what each wave built and exposes) ·
CONTEXT.md (Glossary, Non-Goals, Decisions) · docs/adr/ · recent git log.
Summarize the current state back in a few lines; confirm the picture is right before grilling.

## 2. Grill the change

One question at a time, with your recommended interpretation, exploring the codebase/graph for
what you can answer yourself. Cover: **what changed** (discovery, requirement, pivot, failed
assumption?) · **why now** · **the evidence** · **scope of impact** (adjustment or direction
change?). Use the Glossary's language.

## 3. Assess impact on the plan — honestly

Present explicitly:

- **Completed waves affected** — if a committed wave's assumptions no longer hold, name it; an
  invalidated wave may need a corrective wave. Never silently treat undermined code as
  still-correct.
- **Pending waves changed** — rewritten, reordered, removed.
- **New waves needed** — each as a verifiable outcome.
- **Obsolete waves** — removed.
If the change is expensive or invalidates significant work, say so plainly — the human needs
the real picture.

## 4. Update the artifacts (after the human confirms the direction)

1. **TASKS.md** — rewrite to the new reality, keeping the randori schema: annotate invalidated
   waves (`status: invalidated` — don't delete history), insert new waves, reorder on changed
   dependencies, remove obsolete pending waves, renumber coherently.
2. **CONTEXT.md** — update the Glossary/Decisions the change affects. Promoting a Non-Goal
   into a goal (or adding one) is exactly the deliberate, recorded scope change kaizen exists
   for: update the Non-Goals section explicitly and write an ADR for it.
3. **docs/adr/** — an ADR for the pivot itself: what changed, why, what was decided, the
   alternatives. Provenance for the turn.
4. **TASKS.md → Improvement Backlog** — any new revisit items; the pivot itself is a
   progress.md log line (ADR 0004).
5. **dojo-session.md** — `goal:` and `wave:` point at the next wave under the new plan;
   `step: RED`.

## 5. Hand off

Summarize: the change and why · waves added/modified/removed · the next wave.

**Normal between-waves change:** "Plan updated. Run **/kata-red** when ready."
**Autonomous-run halt resolution:** ask explicitly —

```
How should I proceed?
  1. Continue autonomous — resume from the revised plan
  2. Switch to supervised — wave-by-wave gates
```

Write the chosen `mode:` to dojo-session.md and hand off accordingly.
