# TASKS — rule clarifications from the release-entrypoint close

**Intent:** two convention gaps surfaced by closing the release-entrypoint plan —
post-close follow-ups had no sanctioned home, and the push rule lacked an
explicit-instruction clause — plus one hygiene item. This plan is itself the
first application of the follow-up rule (ADR 0006 addendum).

## Wave 1 — ADR 0006 addendum + push-rule rewording + progress.md hygiene

status: done (2026-09-21)

- ADR 0006 dated addendum: a follow-up to a closed plan opens a new plan branch;
  nothing commits directly to `main`; no-trivial-fix-exception holds after close.
  Cites 6525a4b as the prompting case — accepted as a named deviation, not redone.
- Push rule reworded on every carrying surface (ADR 0006, dojo-conduct, dojo-principles,
  hajime, DOJO-MANUAL §5c, .dojo/CONTEXT.md): never on the agent's own initiative; on
  explicit instruction, state exactly what will be pushed (branch, commit range, tags),
  then execute. R19 phrase checks updated to enforce the new wording.
- `.dojo/progress.md` showed modified: confirmed line-endings-only
  (`git diff --ignore-cr-at-eol` empty) and discarded via `git checkout --`.