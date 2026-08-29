# Progress — dojo-skills

Terse per-wave log. Append-only. One line per wave.
Format: `YYYY-MM-DD | wave N | step | one-line outcome`

2026-06-17 | session-start | — | hajime checklist complete; dojo-check gate green; living docs scaffolded
2026-06-19 | wave 1 | refactor | single-source dojo-check template via dojo-principles; R10 replaces retired R6; ADRs 0001/0002/0003 + TASKS.md land with the wave | proof-contract SoT moved to principle file; structural-equivalence lint | enabler for wave 4 leading-word collapse | c9355b4
2026-06-19 | wave 2 | feat | classify every skill per invocation rule (ADR 0002); 7 user-invoked + 3 session-invoked; R11 single-table classifier | invocation rule now enforced | ~480 words off always-on context; enables wave 3 router with category-aware table | 4168c6e
2026-08-29 | wave 3 | fix | land Wave-2 review fixes + housekeeping; Gate 0, facts-vs-decisions, end-of-grill gate, kata-commit item 4 (CONTEXT.md), R12–R14, exec-bit index flip, Logging-section restoration, CONTEXT.md/HANDOFF/CHANGELOG/findings/progress updates | clean green baseline; skip-to-implementation failure family closed (three doors); stale-decisions class closed via item 4 | enables trim plan in `docs/proposals/` to start green from a clean tree | fa5fcee

2026-08-29 | wave 4 | docs | promote trim plan to active in TASKS.md; preserve writing-great-skills plan as appendix | single active plan replaces two-plan confusion; trim absorbs deletion-shaped waves, surviving-old carries additive waves | trims skill count 17 → 12 over 7 waves; 7 surviving-old waves on the trimmed surface | c11bdfa

2026-08-29 | wave 5 | refactor | absorb the two kata-green-fired skills into kata-green; delete both directories; rewrite ~15 cross-references | the cycle is now red → green → commit; the historical record (CHANGELOG + ADR) keeps the names | 17 → 15 skills; sets the pattern for the trim's remaining deletion waves (algorithm-classification absorbed, contribution-review absorbed, hajime-bugfix merged) | d097c6f

2026-08-29 | wave 6 | refactor | absorb the algorithm-classification discipline into kata-red; delete the directory; rewrite ~12 cross-references | the model-known taxonomy is cut; the discipline (stop, property/tolerance/golden, tanren gate) lives in kata-red at the right moment | 15 → 14 skills; sets the pattern for the remaining deletion waves | ca3e112

2026-08-29 | wave 7 | refactor | absorb the contribution-review discipline into dojo-conduct (new "Reviewing Code" section); delete the directory; rewrite ~9 cross-references | the discipline (read the diff, gate is necessary not sufficient, human decides) lives in conduct; the checklist was already in principles | 14 → 13 skills; one trim wave left | 8707329
