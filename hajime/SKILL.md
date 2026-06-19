---
name: hajime
description: >
  Start a feature development session. Use when beginning new feature work.
  Triggers on: /hajime, "let's start", "new feature", "I want to build".
  Asks rigor (real or PoC) and mode (supervised or autonomous), then whether the design is done.
  Runs the session-start checklist (scaffolds CONTEXT.md, dojo-check with proof artifact,
  HANDOFF.md), grills via randori if needed (always supervised; produces TASKS.md for multi-wave
  work), and initializes dojo-session.md. For bugfixes use /hajime-bugfix.
---

**Before anything else: load and apply `dojo-principles`, `dojo-project`, and `dojo-conduct` now.**
They govern this entire session.

# Hajime — Feature Session Start

*You are starting the DEFINE phase of the kata cycle.*

Narrate your reasoning at every step. The human is your pair — think out loud.

---

## 1. Resume check

Look for `dojo-session.md` in the project root, and run `git status --porcelain`.

- **Found, `step: DONE`, clean tree** — last wave committed cleanly. Starting fresh is safe.
- **Found, `step: DONE`, dirty Dojo artifacts** (HANDOFF/progress/learning-log edits uncommitted)
  — a kata-commit was interrupted after the git commit. Finish its artifact updates first, then
  proceed.
- **Found, any other step** — a wave is mid-flight. If the tree is also dirty, the run may have
  been interrupted: offer (a) resume from [step] as-is, or (b) reset to the last commit
  (`git checkout -- .`) and restart the wave from RED. State the consequence plainly: "Starting
  fresh overwrites only the in-flight wave's state in dojo-session.md; all project documents
  and committed code are preserved."
- **Not found** — proceed.

---

## 2. Preferences, rigor, mode, design

**Read the global preferences store** at `~/.config/dojo/preferences.md` if it exists (migrate
`~/.config/kata/preferences.md` if found there). Use it to pre-fill every question below —
confirm-or-override instead of cold questions. It is a convenience; never depend on it.

**Rigor — real work or throwaway?**

```
What are we building?
  1. Real software — full discipline (tests, durable docs, the works)
  2. Proof of concept — a throwaway experiment to answer one question fast
```

Sets `rigor: real|poc`. PoC adjustments are in section 2b — but PoC still gets a mode.

**Mode:**

```
How do you want to run this session?
  1. Supervised — I stop at gates for your decision (density: full/standard/light, see dojo-conduct)
  2. Autonomous — I run the cycle to completion, halting only on divergence
```

Sets `mode`. In supervised mode also set `gate_density` from preferences (default `standard`).

**Design:**

```
Is the design already done — is there a TASKS.md or equivalent plan to execute?
  1. Yes — I'll audit and work from the existing plan
  2. No — we'll grill it out first (always supervised, even for an autonomous run)
```

Grilling is always supervised. Autonomy begins only after the plan is set and confirmed.

---

## 2b. PoC adjustments (rigor: poc)

**Loosens:** tests minimal (only the risky core claim, or none if exploratory) — gate is
compile + lint; pedagogy off (no briefs/debriefs); kokai off; HANDOFF/ceremony minimal; skip
the commit-style and log-sink questions (defaults).

**Tightens:** randori's Step 0 scope gate runs hard — "what is the single thing this PoC must
prove, and what is the absolute minimum to prove it?" The code is explicitly designed to be
discarded: no gold-plating, no infrastructure.

**Produces:** `poc-lessons.md` — what was learned, what the real build should do differently.
That file, not the code, is the durable output. When the question is answered, recommend (don't
force) a fresh `/hajime` feeding poc-lessons.md into randori; advise against building the real
thing on top of the prototype. Keep-or-discard is the human's call.

---

## 3. Session-start checklist

Work through each item; report status. These steps are yours to execute, agent — the only human
touchpoint is confirming the dojo-check script.

### CONTEXT.md

If missing, create with exactly this skeleton (contract in randori; listed in dojo-project):

```markdown
# Context — [project name]
## Glossary
## Non-Goals
## Decisions
```

`docs/adr/` is created lazily on the first ADR.

### dojo-check (the scaffolded gate)

```
[ ] scripts/dojo-check.sh exists and is executable
```

If missing:

1. Create `scripts/`.
2. Detect the stack: `Cargo.toml` → Rust · `*.csproj`/`*.sln` → C# · `go.mod` → Go ·
   `package.json` → Node/TS · `CMakeLists.txt`/`Makefile` → C/C++ (ask for exact commands) ·
   nothing recognized → ask the human. Never skip the script — a project without dojo-check
   has no gate.
3. Create `scripts/dojo-check.sh` — compile → lint → test **plus the proof artifact**. The
   example below is illustrative (cargo-shaped); the proof-contract invariant it implements
   lives in `dojo-principles → Enforce Over Instruct — the Proof Contract`, which is the
   normative definition. Swap only the three stack commands:

```bash
#!/usr/bin/env bash
set -e
set -o pipefail
mkdir -p .dojo
{
  cargo build 2>&1
  cargo clippy -- -D warnings 2>&1
  cargo test 2>&1
} | tee .dojo/check-output.log
# Reached only if every check passed (set -e + pipefail):
sha() { sha256sum "$1" 2>/dev/null || shasum -a 256 "$1"; }
{
  echo "ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "exit=0"
  echo "output_sha256=$(sha .dojo/check-output.log | awk '{print $1}')"
} > .dojo/check-proof
```

   The proof is evidence, not a claim — kata-commit verifies it before committing. On Windows,
   run under Git Bash or WSL — or use the PowerShell variant at
   `hajime/reference/dojo-check.ps1` (same contract; swap the same three commands).
4. Ensure `.gitignore` covers `.dojo/` **and `dojo-session.md`** (per-machine state; HANDOFF.md
   is the shared resume surface).
5. `chmod +x scripts/dojo-check.sh`. Show the script; ask "Does this look right for your
   stack?" Do not proceed until confirmed.
6. Run it to establish the **baseline**:

- All green → proceed.
- No tests yet → create a trivial passing test, re-run.
- **Pre-existing failures** (brownfield) → record them in dojo-session.md under
     `pre_existing_failures`, then offer: (a) a **stabilization wave 0** to green the baseline
     first (recommended), or (b) proceed with the rule that every gate requires *no new
     failures* — pre-existing ones are tracked, not fixed silently, not allowed to grow.

### graphify (optional tool — active treatment per dojo-conduct)

Empty/greenfield project → skip entirely; kata-commit will suggest it once code exists.
Existing code + cache present → skip silently. Existing code + no cache → offer to run it now
("builds a structural graph, paid once, skippable"); run if no objection. Runs *before* randori
so the grill is informed by real structure.

### Living artifacts

Create if absent: **HANDOFF.md** (skeleton below, Project Overview synthesized from CONTEXT.md)
and **learning-log.md** (header: "# Learning Log — [project]. Wave briefs and debriefs.
Append-only."). If the work may span multiple waves or sessions, also initialize `progress.md`
and `findings.md` now (kata-commit and the halt protocols append to them).

```markdown
# Project Handoff — [project name]
## Project Overview
## Architecture
## Wave History
## Key Concepts
## Current State
## Improvement Backlog
```

---

## 4. Commit style (skip if rigor: poc)

Ask once per session; store as `commit_style`. If a preference exists, confirm it instead of
asking cold; if the human states a new lasting preference, propose saving it (consent rule in
dojo-project).

```
How do you like your commit messages?
  TERSE        fix: prevent double discount on retry
  CONVENTIONAL fix(orders): prevent discount from applying twice on retry        [default]
  DETAILED     conventional + body with root cause / approach / test reference
  NARRATIVE    detailed, body as prose
  — or describe your own.
```

## 4b. Log sink (skip if rigor: poc; ask once per project)

If CONTEXT.md → Decisions already records a log sink: skip silently. Otherwise ask once, record
the answer there, and write an ADR (it's architectural):

```
How should this project's application logs be handled? (All options are JSON Lines.)
  1. Text file (JSONL) — default; simple, forward anywhere later
  2. stdout — containerized / 12-factor apps
  3. Database — a logs table with a structured column
  4. Log service — with automatic local-file fallback
```

Note in the Decision: code depends on a `LogSink` interface, never a destination; remote sinks
require local fallback (dojo-principles → Logging).

---

## 5. The plan

**If the design exists:** read TASKS.md and **audit before trusting** — declared done is not
verified done, and an autonomous run amplifies vagueness:

- Each wave states a **single verifiable outcome** — you can name the one check that proves it.
  ("A Customer with no payment method gets PaymentMethodMissingError at checkout" passes;
  "add payment validation" does not.)
- The intent is stateable in one sentence.
- No "and"-goals spanning unrelated surfaces — oversized entries get split.
Flag specific gaps and recommend a short `/randori` pass to sharpen just those — *especially*
before an autonomous run. The human may proceed as-is, but gaps are named first, never
silently trusted.

**If not:** invoke `/randori`. It interviews one question at a time with recommendations,
fills CONTEXT.md, writes ADRs, **and writes TASKS.md** (the plan: every wave as a verifiable
outcome with `status:` fields) whenever the work spans more than one wave. Always supervised.

---

## 6. Initialize the session

Write `dojo-session.md` (wave 1's goal comes from TASKS.md, or from randori for single-wave
work):

```markdown
# Dojo Session
mode: [supervised|autonomous]
rigor: [real|poc]
type: feature
wave: 1
step: RED
gate_density: [full|standard|light]
wave_ceiling: [from preferences; default 4]
intent: [one sentence — the problem this solves, and for whom]
goal: [wave 1's verifiable outcome]
commit_style: [terse|conventional|detailed|narrative|custom: ...]
test_written:
test_status:
attempts: 0
pre_existing_failures: [list or "none"]
```

Present the goal. Supervised: confirm it. Autonomous: confirm the full plan before any
autonomy begins.

---

## 7. Hand off

Summarize: what was learned (if grilled), the wave 1 goal, baseline status, mode and density.

**Supervised:** "Ready to write the failing test. Run **/kata-red** when you're ready."

**Autonomous:** begin `/kata-red` → `/kata-green` → `/kata-refactor` → `/kata-commit`, looping
per wave; kata-commit advances the goal from TASKS.md between waves. HALT at a clean point,
write to findings.md and HANDOFF.md, and recommend `/kaizen` whenever: reality diverges from
the plan (false assumption, invalidated wave, needed pivot); work heads toward a declared
non-goal (CONTEXT.md); or a probabilistic approach is about to replace a plausible
deterministic one. Never rewrite the plan autonomously. The stuck protocol (kata-stuck) halts
after its one adjusted attempt. At the wave ceiling, kata-commit pauses at a clean checkpoint
and writes RESUME.md.

During the run, accumulate (never act mid-run): **preference candidates** (durable about-you
defaults) and **insight promotion candidates** (per-project insights general enough for
dojo-principles → Promoted). Present both as per-item approval batches in the end-of-run
report. Nothing is globalized or promoted without explicit consent.
