# Dojo Session

mode: supervised
rigor: real
type: feature
wave: 1
step: GREEN
gate_density: standard
wave_ceiling: 4
intent: git flow works the same way in every Dojo project — one plan branch per plan, wave commits on it, merge at plan-complete session close, push human-only — so main always holds complete, proof-gated work, plans park or die at branch cost, and the human stays the only publisher.
goal: the branching convention is recorded and sanctioned — ADR 0006 (the why), dojo-conduct (plan-branch lifecycle: create/resume, wave commits, merge at plan-complete close, push human-only, abandonment harvest, human-presence-at-PR clause), dojo-principles (integration invariant), .dojo/CONTEXT.md (plan-branch glossary term with exclusions, non-goals, Decisions entry). Proven by grep assertions per surface + lint green + dojo-check green.
commit_style: conventional
test_written: 11 wave-1 content assertions (/tmp/w1-asserts.sh) — adr_0006_plan_branch_exists; conduct_uses_plan_branch_term / push_is_human_only / merge_times_at_plan_completion / abandonment_harvest_rule / pr_needs_human_presence; principles_invariant_uses_plan_branch / names_proof_gate; context_glossary_pins_plan_branch / decisions_record_convention / nongoals_bound_branch_flow
test_status: failing ✓ (11/11 RED, right reason: tokens absent)
attempts: 0
pre_existing_failures: none
