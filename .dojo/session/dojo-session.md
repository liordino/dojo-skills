# Dojo Session
mode: autonomous
rigor: real
type: bugfix
wave: 4
step: DONE
gate_density: standard
wave_ceiling: 4
intent: R21's comparison is asymmetric (HEAD titles extracted, tree checked as substring of the joined section) and join_wrapped ignores paragraph boundaries; both fixed red-first, then the approved group-by-mechanism promotion lands under a correct guard.
goal: R21 compares exact entry titles on both sides (seeds a and b fail after the fix, incident seed keeps failing); join_wrapped starts a new logical line at blank lines and headings (R12 captures only the pointer's own section name); group-by-mechanism promoted; unpromoted families reported.
commit_style: conventional
test_written:
test_status:
attempts: 0
pre_existing_failures: none
diagnosis: R21 checks HEAD titles as substrings of the whole joined tree section — a title quoted in another entry's body or extended by a retitle passes although the entry is gone. join_wrapped appends every non-bullet line to the current logical line, across blank lines and headings, so a wrapped pointer's captured section name runs into the next paragraph.
reproduction: seed (a) removal + quoted title elsewhere, seed (b) extending retitle — both pass the current R21; seed (c) pointer at line end followed by a new paragraph — R12 captures the wrong name.
