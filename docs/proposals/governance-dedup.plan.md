# Plan — dedup the governance-load banner (thin approach, no router file)

Runnable plan for your harness. This replaces the abandoned Wave 11 (router
skill / index): you don't want an index, you want to stop repeating the
"load the governance trio" imperative. One wave, and it *removes* more than it
adds — in the spirit of the trim.

**Reality check first (already verified against the repo):** the banner is NOT in
nine files. The trim already thinned the tree. The exact line

    **Before anything else: load and apply `dojo-principles`, `dojo-project`, and `dojo-conduct` now.**

appears verbatim in exactly **4** files: `hajime`, `kaizen`, `kan`, `randori`.
(kata-red mentions the trio in a different context — a reload instruction during
compaction — and should be LEFT ALONE; it's not the banner. dojo-conduct *lists*
the trio in its precedence section — also not the banner, leave it.)

So this is a 4-file dedup, not a 9-file one. Small.

---

## The design decision: where does the single source of truth live?

Two honest options. Pick one before running.

**Option A — hajime owns it, the other three drop the banner.**
The trio only genuinely needs loading once per session, at the start. `hajime` is
the session entry point and already carries the banner — so it *keeps* it (this is
the real load imperative). `kaizen`, `kan`, `randori` drop their banner because by
the time any of them runs, hajime has already loaded the trio this session.
- Pro: smallest possible — deletes 3 banners, adds nothing, keeps one reliable
  imperative at the one place session-load actually happens.
- Con: if you ever invoke `/kan` or `/randori` in a *fresh* session without going
  through hajime first (possible — they're user-invocable), the trio wouldn't be
  loaded. Mitigate with a single terse line in those three: "Assumes the
  governance trio is loaded (hajime loads it; if starting here, load it first)."

**Option B — dojo-conduct states it as the rule, the four reference it.**
dojo-conduct is already always-relevant and already names the trio in its
precedence section. Add one line there making session-start load its stated rule,
and have the four banner-files carry a one-line *imperative* pointer, not the full
sentence.
- Pro: canonical home for "how loading works" is the conduct skill, which is where
  a reader looks for operational rules.
- Con: dojo-conduct isn't guaranteed loaded *before* the others in every harness,
  so "the rule lives in conduct" has a bootstrap wrinkle — the thing that tells you
  to load the trio is itself in the trio. Option A avoids this.

**Recommendation: Option A.** It's the thinner one, it avoids the bootstrap
wrinkle, and it matches "remove even more." The mitigation line keeps the
fresh-session-entry case safe without re-duplicating the full banner. The rest of
this plan assumes A; if you prefer B, the wave shape is the same, only the edit
text differs.

---

## Wave — dedup the governance-load banner (Option A)

status: pending

**Outcome:** the full "Before anything else: load and apply..." banner appears in
exactly one skill (`hajime`); `kaizen`, `kan`, `randori` carry at most a single
terse assumes-loaded line instead; no behavior changes (the trio still loads at
session start); lint + mechanics green.

**Edits:**

1. `hajime/SKILL.md` — **keep** the banner line as-is. It's the canonical load
   imperative. (No change, or optionally sharpen to note it's the session-start
   load point.)

2. `kaizen/SKILL.md`, `kan/SKILL.md`, `randori/SKILL.md` — **replace** the banner
   line:
   ```
   **Before anything else: load and apply `dojo-principles`, `dojo-project`, and `dojo-conduct` now.**
   ```
   with the terse assumes-loaded line:
   ```
   *Assumes the governance trio (`dojo-principles`, `dojo-project`, `dojo-conduct`) is loaded — hajime loads it at session start; if you're starting from here, load it first.*
   ```
   (One line, italic not bold — it's an assumption note, not a shouted imperative.
   The imperative to actually load still exists, once, in hajime.)

3. `kata-red/SKILL.md` — **leave alone.** Its line 28 mention is a compaction-reload
   instruction, a different thing. Do not touch.

4. `dojo-conduct/SKILL.md` — **leave alone.** Its precedence-section listing of the
   trio is not the banner.

**Verify:**
- `rg -c "Before anything else: load and apply" **/SKILL.md` returns exactly 1
  (hajime only).
- The three assumes-loaded lines are present in kaizen/kan/randori.
- No lint rule references the banner text (check R-rules don't assert the banner
  in >1 file — if some rule counted it, update that rule; likely none does).
- `bash scripts/dojo-lint.sh` + `bash evals/run-mechanics.sh` green.
- Sanity: start a fresh `/hajime` session — trio still loads (unchanged). Start a
  fresh `/randori` cold — the assumes-loaded line tells you to load first.

**Then:** mark the old Wave 11 (router/index) `invalidated` in TASKS.md with the
reason: "index not wanted; governance-load dedup done inline via the thin approach
instead — one banner in hajime, assumes-loaded notes elsewhere."

---

## Why this is the whole job

No `dojo/SKILL.md`, no index, no new file. Four files touched, three of them losing
a line. It's a dedup, not a feature — which is exactly the direction you wanted to
keep going. If it ever feels like the assumes-loaded notes are themselves clutter,
the next trim just deletes them too and relies on hajime being the only entry point
that matters.
