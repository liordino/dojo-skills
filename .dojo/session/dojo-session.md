# Dojo Session
mode: autonomous
rigor: real
type: bugfix
wave: 1
step: RED
gate_density: standard
wave_ceiling: 4
intent: "Promoted (local) is append-only, but the scar-tissue promotion replaced the determinize entry — restore it, guard the section against silent removals, and clean the pointer/provenance leftovers from the send-rule-and-sourcing plan."
goal: Wave 1 — the determinize principle is restored verbatim after the scar-tissue entry, and lint R21 fails when any Promoted (local) entry is removed (red-first proven by a seeded removal) and passes when entries are added or edited.
commit_style: conventional
test_written:
test_status:
attempts: 0
pre_existing_failures: none
diagnosis: The edit adding the scar-tissue principle consumed the adjacent determinize entry (replaced instead of appended); section bullet count stayed 6, so nothing detected it. Class: an edit meant to add content consumes what is next to it — second occurrence (first: 2026-07-10, the Logging heading).
reproduction: git diff f696432 HEAD -- dojo-principles/SKILL.md (replacement visible); lint R21 seeded-removal run fails before the fix.