# TASKS — determinize what has a stable right answer (inward pass)

**Intent:** where Dojo leans on LLM judgment for a question that has a *checkable* answer,
replace the judgment with a deterministic check and leave the LLM to interpret the result.
Every conversion must name the failure it prevents.

**Candidate test:** does the question have a right answer that does **not** depend on intent?
Yes → scriptable. No → stays with the model.

**Scope guard:** inward pass only — this repo's own discipline. No outward tooling.

## Wave 1 — the evidence pass (read-only; builds nothing)

status: done

Read-only inventory across the 12 skills, three governance files, and existing
dojo-check/lint surfaces: every place a skill instructs the agent to *judge, verify,
confirm, check, ensure*. For each: surface + quoted instruction, the question asked,
intent-dependent verdict, existing-rule check (R1–R19), named failure + whether it
actually happened (cite findings/learning-log/CHANGELOG), rough cost / false-positive risk.

**Output:** triage table in `.dojo/findings.md`, three buckets:

1. Scriptable, with a real recorded failure
2. Scriptable, theoretical only (park, do not build)
3. Intent-dependent (stays with the model)

**Then STOP for human triage.** No check is built in this wave.

**Verified by:** table exists; every entry carries intent-dependence verdict + existing-rule
check; bucket-1 entries cite a real recorded instance; no script or lint rule added; lint +
proof green on an otherwise unchanged tree.

**Touch:** read-only across `*/SKILL.md`, `scripts/dojo-lint.sh`, `.dojo/*`; writes one document.

## Wave 2 — the effective-ignore audit (re-aimed at triage 2026-09-10)

status: done (re-aimed at triage; conversion shipped)

The triage gate rejected the drafted staged-set candidate (evidence mismatch — a globally
ignored file never reaches `git add -A`) and approved this conversion instead, supported by
the same two 2026-09-03 instances read as one class: the global excludesfile makes
`git status` lie about the working tree in both directions (junk present-but-invisible;
durable file recorded as tracked but masked).

1. Adds the deterministic check — a numbered `dojo-lint.sh` rule: enumerate what the
   effective ignore configuration (repo + global + excludes) actually masks
   (`git status --ignored --porcelain` + `git check-ignore -v` over the durable record)
   and assert agreement with the artifact map's ephemeral tier — nothing durable masked,
   nothing junk present-but-invisible. The failure message names the offending rule (the
   `check-ignore -v` output).
2. Proves it with a seeded violation (R19 pattern): seed → check fails with its exact
   message → restore → green. Record the exact message in the debrief.
3. Softens the replaced prose only where the check truly replaces it (hajime's posture
   verification gains the pointer; no prose is force-rewritten).
4. Check reports the masked path + rule; the model decides. Never encode the fix.

**Verified by:** check exists and is numbered; seeded-violation proof ran (exact message
recorded); lint + mechanics green.

## Wave N+1 — record the principle

status: done — the entry is in Promoted (local) with its receipt

Promote the principle into `dojo-principles` → Promoted (local), house style
(session type + date): determinize what has a stable right answer; check = sensor,
model = interpreter; only where the answer doesn't depend on intent, and only once a
real failure showed the check is needed. Include the second-order reason: a check
collapses the context the judgment needed — fewer tokens, no retry-round.

**Verified by:** entry exists in Promoted (local) with a receipt; provenance norm respected;
lint + mechanics green.

## Empty-bucket-1 clause

If Wave 1's triage returns an empty bucket 1, the plan closes with no conversions — a real
result, not a failure. The inventory (especially bucket 3) is durable value.

## Non-goals

- No outward tooling (project-local checkers for consumer projects).
- No check without a named, recorded failure — bucket 2 stays parked.
- No re-implementation of R1–R19 — covered candidates are recorded as covered.
- No encoding of taste — intent-dependent questions stay with the model.
- No git-hook work — denylist/never-push/plan-branch guards stay prose until real drift.
