# TASKS — consent-boundary clarifications after the rule-clarifications close

**Intent:** three follow-ups surfaced by reading the rule-clarifications diff
(f696432): kokai's send rule was defined by analogy to a push rule that just
changed, the push rule is restated on six surfaces, and one principle survived
only in git history. First follow-up plan under the ADR 0006 addendum — new
plan branch, nothing commits directly to `main`.

## Wave 1 — kokai send rule stands alone; push rule single-sourced; scar-tissue principle promoted

status: done (2026-09-21)

- **Kokai send rule** (`kokai/SKILL.md` → the release judgment layer): remove the
  "same boundary as never-push" analogy. The rule stands on its own: the agent
  never sends a release communication on its own initiative; on an explicit
  instruction to send, it states exactly what will be sent (recipients or
  channel, and the full message) and then sends. Channel-agnostic — email, a
  GitHub release, a chat post. The decision is the publish act and stays the
  human's.
- **Push rule single-sourcing.** In the two LOADED surfaces other than
  dojo-conduct, drop the restatement, keep a pointer:
  - `dojo-principles/SKILL.md` → The Integration Line: remove the push sentence;
    add "push" to the lifecycle pointer's list (create, resume, merge, park,
    abandon, harvest → dojo-conduct → The Branching Convention).
  - `hajime/SKILL.md` (plan-complete merge paragraph): reduce the push text to a
    pointer to dojo-conduct → The Branching Convention.
  - dojo-conduct stays the one loaded statement; ADR 0006, DOJO-MANUAL, and
    .dojo/CONTEXT.md are decision record and docs — untouched.
  - R19 gains negative checks: 'branch, commit range, tags' must not appear in
    dojo-principles or hajime. R12 already verifies the pointers resolve — confirm.
- **Promote the scar-tissue principle** to `dojo-principles/SKILL.md` → Promoted
  (local), approved by the human. Scar-tissue-first is the default for
  reversible failures — don't add a rule for a failure you haven't had.
  Irreversible failures are the exception, guarded pre-emptively, because
  waiting for the scar means eating the unrecoverable outcome. Receipts: the
  kata-commit secrets denylist, the published-tag / unrequested-release guards
  in kokai. House style: session type + date, never the project of origin.

Gate: lint + mechanics (R12 and R19 included). Merge at plan close. Do not push.