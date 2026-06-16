---
name: kensha
description: >
  Audit an incoming contribution (pull request) or a batch of recently merged changes. Use
  when reviewing a contributor's PR, or after a long session / several merges, to catch dead
  code, duplication, magic values, missing coverage, and stale docs. Triggers on: /kensha,
  "review this PR", "audit the code", "check this contribution". The agent audits and advises;
  the human always decides whether to merge, fix, or reject. For the release pipeline use
  /kokai.
---

# Kensha — Contribution Inspection (検査)

**Before anything else: load and apply `dojo-principles`, `dojo-project`, and `dojo-conduct` now.**

*検査 — inspection. Audits a contribution against the code as it actually is, never against
what its description claims. The agent is the tireless reviewer; the human signs off.*

---

## The core discipline

A PR description says what the author *thinks* they did. **Do not trust the description; read
the diff.** The whole value of the review is the real code, not a summary of the author's
summary.

## Mode A — Single PR review

Audit the diff against:
- **Does it make sense?** Does it do what it claims, correctly?
- **Regressions?** Could it break existing behavior; are existing tests still valid and green?
- **Quality drop?** dojo-principles violations (DRY, negative space, purity, naming,
  idempotency), magic values, tangled boundaries.
- **Coverage adequate?** New behavior with tests; edge cases covered.
- **Docs in sync?** README/docs/CONTEXT.md updated where the change demands it.
State what should happen — the human decides.

## Mode B — Post-session / batch audit

Across everything recently changed: dead code · unnecessary duplication (sg structural search
where available) · magic/hardcoded values needing names or provenance · missing coverage on
the changed surface · principle violations · stale documentation.

## Run the gate

Run `scripts/dojo-check.sh` (or the project's CI gates) against the contribution for the
deterministic signal. A green gate is necessary, not sufficient — the judgment items above
still need the read.

## Output: assessment; the human decides

Structured: what it does · what's solid · what's concerning (specifics + file references) ·
test/coverage state · docs state · recommendation. Common dispositions (context, never the
agent's unilateral choice): small issue → fix on the PR, explain, merge · mergeable-but-
imperfect → merge + immediate correction commit · large divergence → don't merge; draft the
reply explaining why and the right direction. The agent drafts replies, suggests dispositions,
and makes fixes when directed — merging, rejecting, and sign-off are always the human's.

## Hand off

Deliver assessment + recommendation. A directed fix runs through the normal kata cycle (a
small wave). A systemic finding goes to HANDOFF.md → Improvement Backlog.
