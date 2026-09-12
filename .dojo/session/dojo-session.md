# Dojo Session

mode: supervised
rigor: real
type: feature
wave: 2
step: COMMIT
gate_density: standard
wave_ceiling: 4
intent: where Dojo leans on LLM judgment for a question with a checkable answer, the evidence pass inventories every judge/verify instruction and triages it, so only real-failure-backed candidates become checks and the rest is settled as the model's to answer.
goal: the effective-ignore audit is lint-enforced — a numbered rule enumerates what the effective ignore configuration actually masks and asserts agreement with the artifact map's ephemeral tier (nothing durable masked, nothing junk present-but-invisible), failing with a message that names the offending rule — proven by a seeded violation RED→GREEN (exact message recorded) and a green lint/proof gate.
commit_style: conventional
test_written: lint R20 (scripts/dojo-lint.sh) — effective-ignore audit, two directions: worktree-ignored paths outside the ephemeral tier (junk present-but-invisible) and masked durable map entries; failure names the offending rule via check-ignore -v
test_status: passing ✓ (seeded violation: masked junk dir + masked durable file both failed R20 with the offending rule named; restore → green)
attempts: 0
pre_existing_failures: none
