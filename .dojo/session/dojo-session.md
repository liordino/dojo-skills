# Dojo Session

mode: supervised
rigor: real
type: feature
wave: 2
step: RED
gate_density: standard
wave_ceiling: 4
intent: git flow works the same way in every Dojo project — one plan branch per plan, wave commits on it, merge at plan-complete session close, push human-only — so main always holds complete, proof-gated work, plans park or die at branch cost, and the human stays the only publisher.
goal: the flow is wired — hajime creates or resumes the plan branch at session init and merges at plan-complete close (supervised: propose; autonomous: self); kata-commit gains the main-guard (a wave commit while on main → halt, the branch was never created). Proven by grep assertions on the new steps + mechanics eval green + lint green.
commit_style: conventional
test_written:
test_status:
attempts: 0
pre_existing_failures: none
