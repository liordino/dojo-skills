---
name: hajime-bugfix
description: >
  Start a bugfix session. Use when fixing a bug. Triggers on: /hajime-bugfix, "there's a bug",
  "something is broken", "fix this". Asks supervised or autonomous, runs the session-start
  checklist (same scaffolds as /hajime, including the proof-writing dojo-check), runs the kan
  diagnosis loop to find root cause, then the first kata-red test becomes the regression test
  proving the bug. For feature work use /hajime.
---

**Before anything else: load and apply `dojo-principles`, `dojo-project`, and `dojo-conduct` now.**

# Hajime Bugfix — Bugfix Session Start

*You are starting the DIAGNOSE phase of the kata cycle. Bugfix type.*

Narrate your reasoning — this is pair programming.

---

## 1. Resume check

Identical to /hajime §1 (it may be a prior feature or bugfix session — switching track is
seamless at `step: DONE`): check `dojo-session.md` + `git status --porcelain`; handle clean
DONE, interrupted-commit DONE, and mid-flight (resume vs reset-and-restart) the same way.

---

## 2. Preferences and mode

Read `~/.config/dojo/preferences.md` if present (pre-fill; convenience only).
```
How do you want to run this bugfix?
  1. Supervised — you approve the diagnosis before the fix begins
  2. Autonomous — I diagnose, fix, and commit without stopping
```
Diagnosis itself is reproduction-driven and runs the same either way. Bugfixes are
`rigor: real` (a throwaway experiment is /hajime PoC, not a bugfix). Set `gate_density` from
preferences in supervised mode.

---

## 3. Session-start checklist

Same items as /hajime §3, same canonical templates — CONTEXT.md (three-section skeleton),
**dojo-check scaffolded from the canonical template in /hajime §3, proof artifact included**,
`.gitignore` covering `.dojo/` and `dojo-session.md`, graphify offer (it helps locate the bug),
HANDOFF.md + learning-log.md. One difference at the **baseline run**:

- Document already-failing tests in `pre_existing_failures`. A failure on the reported bug is
  expected — note it and continue. Failures on unrelated things: document, do not fix this
  session, do not let them grow.

## 4. Commit style

Ask once (options and consent rule in /hajime §4); store as `commit_style`. Default
`conventional`.

---

## 5. Kan diagnosis

*The most important step. Do not skip or rush it.*

Invoke `/kan`: **reproduce → minimise → hypothesise → instrument → fix → regression-test**.
Its central discipline: a fast, deterministic, agent-runnable pass/fail signal for the exact
bug before anything else. Kan respects mode, writes findings to findings.md, and feeds its
reproduction to kata-red as the regression test.

**Supervised:** kan presents findings; you approve the diagnosis before the fix begins.
**Autonomous:** kan logs findings and proceeds — unless it cannot reproduce, in which case it
halts and states what artifact or access it needs.

---

## 6. Initialize the session

The bugfix wave goal always has this shape: "[Bug] no longer occurs. Proven by a regression
test that currently fails and passes after the fix."

Write `dojo-session.md` with the /hajime §6 field set plus the bugfix fields, i.e.
`type: bugfix`, `rigor: real`, and:
```markdown
diagnosis: [root cause from kan]
reproduction: [how to reproduce]
```

---

## 7. Hand off

Summarize: root cause, reproduction confirmed, wave goal, baseline state, mode.

**Supervised:** "Diagnosis complete. Ready to write the regression test. Run **/kata-red**."

**Autonomous:** `/kata-red` (regression test first) → `/kata-green` (fix) → `/kata-commit`.
HALT and recommend `/kaizen` if the fix reveals a different root cause than diagnosed, or the
bug needs a design change rather than a patch — never expand scope autonomously. Green's
stuck branch halts after its one adjusted attempt. Never commit a broken fix.
