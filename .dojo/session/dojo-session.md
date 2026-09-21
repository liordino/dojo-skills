# Dojo Session
mode: autonomous
rigor: real
type: bugfix
wave: 2
step: DONE
gate_density: standard
wave_ceiling: 4
intent: "Promoted (local) is append-only, but the scar-tissue promotion replaced the determinize entry — restore it, guard the section against silent removals, and clean the pointer/provenance leftovers from the send-rule-and-sourcing plan."
goal: Wave 2 � hajime's push text is a bare pointer (no claim), kokai's lead-in agrees with its body, and the scar-tissue provenance names the release-entrypoint session (2026-09-21).
commit_style: conventional
test_written:
test_status:
attempts: 0
pre_existing_failures: none
diagnosis: The edit adding the scar-tissue principle consumed the adjacent determinize entry (replaced instead of appended); section bullet count stayed 6, so nothing detected it. Class: an edit meant to add content consumes what is next to it — second occurrence (first: 2026-07-10, the Logging heading).
reproduction: git diff f696432 HEAD -- dojo-principles/SKILL.md (replacement visible); lint R21 seeded-removal run fails before the fix.