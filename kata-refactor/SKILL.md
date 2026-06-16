---
name: kata-refactor
description: >
  Clean up the implementation without changing behavior. Skippable in supervised mode (the
  human decides at the GREEN assessment); mandatory in autonomous mode. Triggers on:
  /kata-refactor, "refactor", "clean up", "polish". Reads dojo-session.md for mode, rigor,
  gate density. Tests stay green throughout. Applies SRP, naming, DRY, formatting, and a
  framework-detected specialized UI skill if one is installed.
---

# Dojo Refactor — Clean Without Changing Behavior

*You are in the REFACTOR step.* Read dojo-session.md now. Tests stay green throughout.
Narrate what you're cleaning and why.

**The constraint: no new behavior.** Something worth adding → note it for the next wave.
Behavior added here skips RED and has no check — the exact failure mode this cycle prevents.

**rigor: poc:** run the formatter only; skip the rest — a throwaway is not polished.

---

## What to clean (priority order)

1. **Small units + SRP** — functions > 20 lines: extract. Files > 300 lines: split by
   responsibility. A class doing more than one thing: separate. Needs "and" to describe: split.
2. **Names** — `rg "name" .` returning > 5 relevant hits → rename more specifically. Names off
   the CONTEXT.md glossary → rename to match. Verify renames structurally with
   `sg -p 'oldName($$$)'` so every real call site moved.
3. **DRY** — find structural duplicates with `sg` (same shape, different names — text grep
   misses them); any pattern appearing twice gets extracted now, not "later" (later = a
   diverging third copy). `sg -p 'old' -r 'new'` for safe bulk rewrites; dojo-check after.
4. **Formatting** — run the project formatter (`cargo fmt` / `gofmt` / `dotnet format` /
   `prettier` / `black`). No debates; the formatter decides.
5. **Comment provenance** — add the *why* for any non-obvious GREEN decision; delete comments
   that restate code; update docstrings if the public interface changed.
6. **Specialized UI pass** — if this wave touched UI: detect the framework from the files and
   project, and invoke whatever specialized UI skill is installed for it. None installed →
   apply the general principles above to the UI code. Match the lens to the framework:
   visual-polish skills where the framework has real aesthetics to polish; correctness-focused
   review (structure, binding, separation) where it doesn't.

---

## Execution

1. Make the changes; run `dojo-check` after each meaningful change (`dojo-check-fast` for the
   inner loop is fine; full check before hand-off). Any test breaks → the refactor changed
   behavior: revert that change and reassess.
2. Update dojo-session.md: `step: COMMIT`.

## Autonomous mode — refactor is mandatory

No human weighs the opportunities, so apply the GREEN assessment automatically, then run
dojo-check. Still green → `/kata-commit`. Broken → **revert the refactor entirely**, keep the
working GREEN implementation, log to progress.md ("Refactor reverted in wave [N] — [attempt]
broke [test]"), add the opportunity to HANDOFF.md → Improvement Backlog, proceed to commit.
Never commit a broken refactor — minimal working beats clean broken.

## Hand off

**Supervised:** present the diff; narrate what was cleaned and why. STOP per gate density.
Suggest: "Refactor complete, all green. Run **/kata-commit**."
**Autonomous:** log to progress.md; proceed to `/kata-commit`.
