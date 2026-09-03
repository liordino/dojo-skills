# Dojo Session

mode: supervised
rigor: real
type: feature
wave: 12
step: DONE
gate_density: standard
wave_ceiling: 4
intent: consolidate all Dojo artifacts under one .dojo/ folder (ADR 0005) and make the sharing boundary explicit.
goal: layout consolidated per the artifact map; lint R17 + mechanics green; sharing boundary explicit; posture recorded (track-all) and verified.
commit_style: conventional
test_written: lint R17 (artifact map + stale-path ban + denylist agreement + posture verification); mechanics eval (proof contract on fixture)
test_status: passing ✓
attempts: 0
pre_existing_failures: none
last_commit: (this wave's closing commit)

---

## Run summary

**Consolidation complete (Waves A+B of ADR 0005).** Durable record at .dojo/ root (CONTEXT,
TASKS, progress, learning-log, findings, DOJO-MANUAL); ADRs at .dojo/adr/ (0005 written);
run state at .dojo/session/ (dojo-session.md, resume.md — RESUME.md joins the ephemeral
tier); gate evidence at .dojo/proof/; tanren workspace unchanged; graphify-out/ stays at
root (tool-homed exception, verified upstream-hardcoded). ~35 surfaces rewritten in
lockstep. The sharing boundary is explicit: conduct section + glossary + Non-Goal +
posture question in hajime (never edits ignore files; presents patterns and locations;
verifies with check-ignore).

**Halting at a clean point.** Commit authorized by the human; closing with this wave's commit.
