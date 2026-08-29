# S1 — Greenfield supervised feature (2 waves, stop after wave 1)

**Setup:** empty scratch repo (`git init`), any stack your agent can scaffold.

**Replay:**
1. `/hajime Build a tiny CLI greeter: 'greet NAME' prints 'Hello, NAME'; later, '--shout' uppercases it.`
2. Answer: rigor → real · mode → supervised · design → not done.
3. Confirm the scaffolded dojo-check when shown. Let randori grill; steer it to a 2-wave plan
   (wave 1 = plain greeting, wave 2 = --shout).
4. `/kata-red` → approve at the stop. `/kata-green` → choose refactor option 1 or 3
   (the refactor step inside green, if chosen) → `/kata-commit` → choose "Commit now".
5. Stop when wave 2's goal is presented. Run `bash <path>/s1-assert.sh` in the repo.

**Watch during replay (not assertable):** gates ask for decisions, brief lands in
learning-log, names use CONTEXT.md language.
