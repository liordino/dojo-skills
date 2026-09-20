# Dojo Session

mode: supervised
rigor: real
type: bugfix
wave: 1
step: DONE
gate_density: standard
wave_ceiling: 4
intent: an undiagnosed intermittent red on lint R16 (2026-09-10, 0-rate across ~145 counted-loop runs) cannot be fixed yet — the gate is instrumented so its next occurrence names its own mechanism (exit code, stderr, readability), and the record is corrected: re-run norm struck, classification re-verified.
goal: R16 and sibling file-reading marker greps emit grep exit code + stderr + input-file readability on failure (fail path only, zero cost on green); no tolerance/retry/re-run allowance exists anywhere in findings, skills, or scripts; findings classify this as two verified MSYS text-mode bugs plus one undiagnosed intermittent red, instrumented and awaiting its next occurrence. Proven by a seeded-violation assert (red shows evidence text), a norm-strike sweep (0 hits), and green lint + mechanics.
commit_style: conventional
test_written: wave-asserts (.dojo/session/wave-asserts.sh) — A1 seeded R16 marker red carries evidence (exit=1, stderr, readable); A1b gq I/O red carries exit=2 + stderr + readable=no; A2 no re-run/retry norm in skills/scripts/.dojo; A3 classification corrected + awaiting-next-occurrence recorded; A4 lint green on unchanged tree
test_status: passing ✓ (5/5; seeded violations failed with evidence before fix, pass after)
attempts: 1
pre_existing_failures: none
diagnosis: not yet diagnosable — 0/145 counted-loop rate; probes negative for the prior CR/text-mode fingerprint (zero CR bytes, plain-text greps on LF files). Not fixable at source yet; instrumented by human decision (kan verdict: option 2). Bug stays OPEN by design.
reproduction: none deterministic — recorded in .dojo/findings.md as awaiting next occurrence with instrumentation in place.
