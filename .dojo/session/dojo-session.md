# Dojo Session
mode: autonomous
rigor: real
type: bugfix
wave: 1
step: DONE
gate_density: standard
wave_ceiling: 4
intent: R21 cannot catch the replacement that motivated it - count stayed 6. Upgrade to identity via title presence, and fix R12's per-line pointer matching while at it (shared join helper).
goal: R21 upgraded from count to identity (every Promoted (local) title at HEAD still present in the tree, named on failure) via a shared wrapped-line-joining helper also used by R12; both rules proven red-first against the ACTUAL failures (replacement seed for R21, wrapped-pointer seed for R12), and the supersession norm stated in the section intro.
commit_style: conventional
test_written:
test_status:
attempts: 0
pre_existing_failures: none
diagnosis: The edit adding the scar-tissue principle consumed the adjacent determinize entry (replaced instead of appended); section bullet count stayed 6, so nothing detected it. Class: an edit meant to add content consumes what is next to it — second occurrence (first: 2026-07-10, the Logging heading).
reproduction: count-based R21 passes the actual incident's commit shape (replace determinize with a new entry, 6->6); R12 passes a wrapped pointer whose captured section name substring-matches the renamed heading.