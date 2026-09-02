---
name: kata-commit
description: >
  Commit the completed wave. Use after /kata-green. Triggers on: /kata-commit, "commit",
  "let's commit". Verifies the dojo-check proof, generates the commit message in the
  session's style, stages explicitly (never blind add -A), commits, updates the living docs,
  advances to the next TASKS.md wave, and manages the compaction cycle and wave ceiling.
  Supervised: human approves the commit. Autonomous: commits and continues or pauses at the
  ceiling.
---

# Dojo Commit — Commit the Wave

*You are in the COMMIT step.* Read dojo-session.md now for goal, mode, rigor, commit_style.

---

## Final gate: verified evidence

1. Run `dojo-check` one last time. Fails → do not commit; return to `/kata-green`. (rigor: poc
   → the gate is whatever the PoC's script runs, compile + lint.)
2. **Verify the proof** (enforce, don't trust — dojo-conduct): `.dojo/check-proof` must exist
   and be **fresh**. Operational rule: fresh = nothing was edited after the run that wrote it —
   no tracked source file (per `git status --porcelain` + mtimes) newer than the proof's `ts`.
   Edited anything since the check? It's stale: re-run. Missing entirely and the script never
   writes one? The script predates the canonical template — **upgrade it first** (add the proof
   block from /hajime §3, show the diff, confirm), then run it. Only a fresh proof clears the
   commit.

---

## Commit message

Apply `commit_style`: **terse** (one line) · **conventional** (type(scope): summary; default) ·
**detailed** (+ body: root cause / approach / check reference) · **narrative** (body as prose) ·
**custom** (as described at session start). Types always from: `feat fix refactor test chore
docs perf ci`. Bugfix bodies state the root cause from the diagnosis.

---

## Wave Closing Debrief

Lean and project-specific — pointers, not lectures:

- **What was done** — the specific types/methods/files, 1–2 lines.
- **Why the approach works** — and any rejected simpler approach or trade-off, named.
- **Systemic improvement opportunities** — how this wave's choices constrain or enable future
  waves (the local code-level items were already handled in the GREEN assessment; anything not
  acted on is in the backlog — don't repeat them).
- **Bigger picture status** — what is newly possible; the next dependency that unlocks.
- **Promotion candidates** — an insight that feels general beyond this project → flag for
  promotion into dojo-principles → Promoted. Supervised: raise it here. Autonomous: add to the
  end-of-run batch. Always a human-approved edit; never silent.

Append to `learning-log.md` under `## Wave [N] — Closing Debrief`. Supervised: also present
inline. Autonomous: log only. rigor: poc: skip the debrief; append lessons to `poc-lessons.md`
instead (what worked, what didn't, what the real build should do differently).

**Engagement note (supervised):** if every gate this wave was approved without modification,
record "approved without modification" in the log entry — visibility, not a scold. Several
consecutive such waves → name it: "Supervised mode may not be adding much right now — continue,
lower the gate density, or switch to autonomous and review at the end?" Reflexive approval is
autonomous mode wearing supervised's clothes; say so and let the human choose.

---

## Commit execution — explicit staging, never blind

Build the stage list: the files this wave touched plus the updated Dojo artifacts. **Never
`git add -A`.** Run `git status --porcelain` and check untracked/new files against the
denylist: `.env*`, `*.pem`, `*.key`, credential-looking names, files > 1 MB, anything under
`.dojo/`. A hit → do not stage it; surface it (supervised: show at the gate; autonomous: HALT
and report — a leaked secret is unrecoverable).

**Supervised** — present the message and the `git status` summary:

```
Suggested commit: [message]
  1. Commit now (git add <files> && git commit)
  2. Edit the message first
  3. I'll commit manually
```

Never commit without explicit instruction. **Autonomous** — stage the list, commit, log the
hash to progress.md.

---

## Update durable artifacts (the compaction write)

After the commit (or the human's manual commit), write everything durable to disk:

1. **progress.md** — append: wave N, type+summary, built, exposes, next dependency, commit hash.
2. **HANDOFF.md** — incremental, never a rewrite: append Wave History; overwrite Current
   State; update Architecture only on structural change; append Key Concepts only if genuinely
   new; append unacted opportunities and any reverted refactor to Improvement Backlog.
3. **Owning AGENTS.md** — only if the wave changed a subtree's structure, contracts, or
   footguns (dojo-project → Local Agent Contracts). Delete stale text immediately.
4. **CONTEXT.md** — only if the wave invalidated an existing Glossary or Decisions entry
   (renamed a rule, retired a mechanism, changed a recorded choice, invalidated a plan
   wave): correct that entry now. The duty attaches to the commit, not to how the change
   was commissioned — session waves, chat-scoped plans, and hand edits owe the same
   reconciliation. Stale entries are drift — kaizen owns *new* decisions; kata-commit
   owns keeping existing ones true.
5. **TASKS.md** (if present) — mark this wave `status: done`.

If this update is interrupted, the resume check (hajime §1) detects `step: DONE` + dirty Dojo
artifacts and completes it — never leave the spine half-written knowingly.

---

## Advance the wave

- **TASKS.md has a next `pending` wave:** write its outcome to dojo-session `goal:`, increment
  `wave:`, set `step: RED`, reset `test_written`/`test_status`. Supervised: present the next
  goal at the hand-off for confirmation. Autonomous: continue the loop (ceiling below).
- **No pending waves (or no TASKS.md):** set `step: DONE`. The plan is complete — report it.

## graphify (structural delta only — dojo-conduct)

If installed: diff added/removed files or changed public signatures → suggest
`graphify --update` (autonomous: run it). Body-only changes → skip silently.

## Wave ceiling and fresh sessions (context hygiene)

Count waves completed this session against `wave_ceiling` (dojo-session; default 4).

- **Supervised, ceiling reached or you notice re-reading files you should know:** suggest a
  fresh session — "Everything is committed and on disk; a new /hajime reloads from HANDOFF.md
  and progress.md. Start fresh, or continue?" A suggestion from wave count and the
  clean-checkpoint fact — never a claim about internal context quality, which cannot be
  reliably self-assessed.
- **Autonomous, ceiling reached:** pause at this clean checkpoint. Write **RESUME.md**: one
  line — "Paused after [N] waves at a clean checkpoint, [M] waves pending in TASKS.md. Run
  /hajime (autonomous) to continue." Log the same to progress.md and stop. A harness that
  relaunches /hajime continues the plan with fresh context.

## Release working context

The wave is durable: code in git, summary in progress.md, pedagogy in learning-log.md, state
in HANDOFF.md. This wave's in-context detail — diffs, iterations, discussion — is disposable;
the next `/kata-red` reloads from disk. **Not** disposable: the governance files — kata-red
reloads them if evicted.

## Hand off

**Supervised:** goal achieved · committed (hash or "manual") · artifacts updated · next wave's
goal (or plan complete) · fresh-session suggestion if flagged.
**Autonomous:** fold into the run summary; continue or pause per the ceiling.
