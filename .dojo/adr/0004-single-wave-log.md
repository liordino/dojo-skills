# ADR 0004 — Single wave log; HANDOFF as snapshot

- **Status:** accepted
- **Date:** 2026-08-31
- **Context:** the per-wave durable writes were duplicated — `.dojo/progress.md` and HANDOFF's
  Wave History recorded the same line twice (the exact drift class Wave 3's kata-commit
  item 4 was created to close), and autonomous runs generated opening briefs nobody reads
  in the moment. HANDOFF also grew linearly with wave count, working against its
  snapshot purpose.
- **Decision:**
  - `.dojo/progress.md` is the single append-only per-wave log. HANDOFF.md drops Wave History
    and stays a snapshot: Project Overview, Architecture, Key Concepts, Current State,
    Improvement Backlog.
  - learning-log briefs are supervised-only (an autonomous wave carries its what/why in
    the commit body and the progress log — briefs exist for the researching human).
  - Debriefs collapse to three fields: what+why · systemic-or-promotion · bigger picture.
- **Consequences:** per-wave write targets drop from ~8 to 5; HANDOFF's size stops
  growing with wave count; learning-log growth roughly halves. The compaction promise is
  unchanged — every durable fact still has exactly one home, and the reload path
  (HANDOFF Current State + progress tail) is unaffected. `evals/scenarios/s1-assert.sh`
  was rewritten in the same wave to assert the new HANDOFF snapshot sections (the
  same-wave rule: no dangling reference survives the change that necessitates it).
- **Alternatives considered:**
  - Merge .dojo/progress.md into HANDOFF (rejected — the agent reload wants the terse log
    small and append-only; HANDOFF's snapshot job benefits from not growing).
  - Status quo (rejected — two histories was the observed drift source).

## Addendum (2026-09-02) — HANDOFF deleted

The HANDOFF.md snapshot surface itself was deleted. Its overview/architecture duplicate the
README and the filesystem; its Wave History was already removed by this ADR; its one unique
surface — the Improvement Backlog — moved to `.dojo/TASKS.md`. The reload path a fresh session
follows is README → .dojo/CONTEXT.md → .dojo/TASKS.md → .dojo/progress.md → git log; every surface has one job
and none duplicates another. `evals/scenarios/s1-assert.sh` asserts the relocated backlog in
the same wave (the same-wave rule).
