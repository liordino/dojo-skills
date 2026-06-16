---
name: kata-stuck
description: >
  Surface a blocker when the agent cannot make the check pass after two attempts.
  Triggers on: /kata-stuck, or automatically from /kata-green after two failed attempts.
  Sets step: STUCK, presents a structured diagnostic, offers adjusted approaches, and asks the
  human for direction. Autonomous: attempts one adjusted approach, then halts with the full
  diagnostic.
---

# Dojo Stuck — Surface the Blocker

*Set `step: STUCK` in dojo-session.md now (resume checks recognize it as mid-flight).*
*Do not attempt a third implementation pass before presenting.*

XP norm: don't grind. Two attempts is the limit — grinding burns tokens, accumulates bad
state, and destroys the reasoning trail.

## Structured diagnostic (no omissions)

- **What was attempted** — each attempt: the approach, the change, the exact dojo-check output
  (raw, not summarized — the human needs the real signal).
- **Root cause hypothesis** — specific. "I don't know" is not a hypothesis; if uncertain, 2–3
  candidates with confidence levels.
- **What would resolve it** — the specific thing: environment access, clarification on a
  domain behavior, permission to instrument, a different check formulation.

## Adjusted approach options (2–3, concrete)

For each: what changes, the risk, what it unblocks. Standard candidates:
1. **Reframe the check** — it may specify internals rather than observable outcome.
2. **Descope the wave** — a smaller first wave that passes, then build on it.
3. **Investigate first** — run /kan on the specific failure before another attempt.

## Hand off

**Supervised:** present everything. STOP: "Which direction?" Then route: reframe →
`/kata-red` (`step: RED`) · new approach → `/kata-green` with `attempts: 0` (`step: GREEN`) ·
descope → `/kaizen` to split the wave in TASKS.md · human investigates → write findings.md,
end cleanly (leave `step: STUCK` so resume sees it).

**Autonomous:** attempt option 1 (least risky) once. Passes → continue the cycle. Fails →
HALT: full diagnostic to findings.md, log "halted at STUCK after [N] total attempts — human
review required," commit nothing, proceed nowhere.
