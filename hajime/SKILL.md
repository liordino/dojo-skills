---
name: hajime
description: >
  Start a development session. Use when beginning new feature work or fixing a bug.
  Triggers on: /hajime, "let's start", "new feature", "I want to build", "there's a bug",
  "fix this", "something is broken". Asks rigor (real or PoC) and mode (supervised or
  autonomous); then whether the work is feature or bugfix. Bugfix sessions route through /kan
  for diagnosis and shape the wave goal as a regression test (the bug is reproducible, fails
  now, passes after the fix). Feature sessions ask whether the design is done. Runs the
  session-start checklist (scaffolds .dojo/CONTEXT.md, dojo-check with proof artifact),
  grills via randori if needed (always supervised; produces .dojo/TASKS.md for multi-wave work), and
  initializes .dojo/session/dojo-session.md.
---

**Before anything else: load and apply `dojo-principles`, `dojo-project`, and `dojo-conduct` now.**
They govern this entire session.

# Hajime — Feature Session Start

*You are starting the DEFINE phase of the kata cycle.*

Narrate your reasoning at every step. The human is your pair — think out loud.

---

## 0. Gate zero — questions before anything

Your first *action* is the resume check below (Dojo's own state only: .dojo/session/dojo-session.md, git
status). Your first *response* to the human is the §2 route questions (rigor, mode, design,
feature-or-bugfix) — plus, in the same message, the packaging confirm block from §2 when the
preferences store answers it — and nothing else. Until they are answered: do not explore or read the project's source code, do not
scaffold, do not write or implement anything. A design document, starting prompt, or file path
passed as the argument is **input to this process** — it feeds the plan step (§5) — never a
substitute for running it; receiving a detailed spec does not authorize skipping to
implementation. Catch yourself reading source files or planning code before rigor and mode are
set → stop and ask.

---

## 1. Resume check

Look for `.dojo/session/dojo-session.md` in the project root, and run `git status --porcelain`.

- **Found, `step: DONE`, clean tree** — last wave committed cleanly. Starting fresh is safe.
- **Found, `step: DONE`, dirty durable-artifact edits** (.dojo/progress.md / .dojo/learning-log.md /
  .dojo/TASKS.md edits uncommitted)
  — a kata-commit was interrupted after the git commit. Finish its artifact updates first, then
  proceed.
- **Found, any other step** — a wave is mid-flight. If the tree is also dirty, the run may have
  been interrupted: offer (a) resume from [step] as-is, or (b) reset to the last commit
  (`git checkout -- .`) and restart the wave from RED. State the consequence plainly: "Starting
  fresh overwrites only the in-flight wave's state in .dojo/session/dojo-session.md; all project documents
  and committed code are preserved."
- **Found a pre-consolidation layout** (Dojo artifacts at the repo root — the durable record as
  root-level files, ADRs under `docs/`, a root-level session file) — a repo predating the
  one-folder footprint (ADR 0005). Offer the one-time migration — move each artifact to its
  `.dojo/` home per the artifact map (lint R17 holds it; the durable record to `.dojo/`'s root,
  ADRs to `.dojo/adr/`, the session file to `.dojo/session/`) — then run the posture question
  (§3 item 4). Never migrate without the human's go-ahead.
- **Not found** — proceed.

Also verify the **tracking posture** (ADR 0005): it is recorded in .dojo/CONTEXT.md → Decisions;
`git check-ignore -v` on the artifact paths is the evidence of what git actually does. A divergence
between the recorded posture and observed behavior — tracked state git ignores, or the reverse — is
surfaced here, never assumed away.

---

## 2. Preferences, rigor, mode, design

**Read the global preferences store** at `~/.config/dojo/preferences.md` if it exists (migrate
`~/.config/kata/preferences.md` if found there). Use it to pre-fill every question below —
confirm-or-override instead of cold questions. It is a convenience; never depend on it.

**Rigor — real work or throwaway?**

```
What are we building? — full discipline (tests, durable docs, the works)
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
Is the design already done
  1. Yes — I'll audit and work from the existing plan
  2. No — we'll grill it out first (always supervised, even for an autonomous run)
```

Grilling is always supervised. Autonomy begins only after the plan is set and confirmed.

**Feature or bugfix?** (Ask *after* rigor + mode are set, before the plan step.)

```
What kind of work is this? — new behaviour, change in scope. Routes to §3 (checklist) then §5 (randori / plan audit).
  2. Bugfix — something is broken; the goal is a regression test that fails now and passes after the fix.
     Routes to §3 (checklist, same), §5b (kan diagnosis, replaces randori), then §6 (bugfix fields).
```

Bugfixes are `rigor: real` (a throwaway experiment is /hajime PoC, not a bugfix). The rest of
this skill is feature-oriented; bugfix forks are noted in §3, §5b, and §6 inline.

**Packaging — one confirm block, not separate stops.** When the preferences store answers
them, present together: `gate_density` · `commit_style` · log-sink (only if .dojo/CONTEXT.md →
Decisions lacks one). Each line carries its one-line consequence — a decision with content,
not assent:

```text
Defaults from your preferences — density: standard · commits: conventional · log sink:
text-file JSONL. [confirm, or name the ones to change]
```

Confirmed here, §4 and §4b are answered — no separate stops. With no preferences stored,
§4/§4b ask cold as written. Route decisions (rigor, mode, design, feature-or-bugfix) are
never batched into assent — they change what the session does, not how it talks.

---

## 2b. PoC adjustments (rigor: poc)

**Loosens:** tests minimal (only the risky core claim, or none if exploratory) — gate is
compile + lint; pedagogy off (no briefs/debriefs); kokai off; ceremony minimal; skip
the commit-style and log-sink questions (defaults).

**Tightens:** randori's Step 0 scope gate runs hard — "what is the single thing this PoC must
prove, and what is the absolute minimum to prove it?" The code is explicitly designed to be
discarded: no gold-plating, no infrastructure.

**Produces:** `.dojo/poc-lessons.md` — what was learned, what the real build should do differently.
That file, not the code, is the durable output. When the question is answered, recommend (don't
force) a fresh `/hajime` feeding .dojo/poc-lessons.md into randori; advise against building the real
thing on top of the prototype. Keep-or-discard is the human's call.

---

## 3. Session-start checklist

Work through each item; report status. These steps are yours to execute, agent — the only human
touchpoint is confirming the dojo-check script.

### .dojo/CONTEXT.md

If missing, create with exactly this skeleton (contract in randori; listed in dojo-project):

```markdown
# Context — [project name]
## Glossary
## Non-Goals
## Decisions
```

Exactly three H2 sections — more is contract drift; fix before proceeding (randori owns
the contract).

`.dojo/adr/` is created lazily on the first ADR.

### dojo-check (the scaffolded gate)

```text
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
mkdir -p .dojo/proof
{
  cargo build 2>&1
  cargo clippy -- -D warnings 2>&1
  cargo test 2>&1
} | tee .dojo/proof/check-output.log
# Reached only if every check passed (set -e + pipefail):
sha() { sha256sum "$1" 2>/dev/null || shasum -a 256 "$1"; }
{
  echo "ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "exit=0"
  echo "output_sha256=$(sha .dojo/proof/check-output.log | awk '{print $1}')"
} > .dojo/proof/check-proof
```

   The proof is evidence, not a claim — kata-commit verifies it before committing. On Windows,
   run under Git Bash or WSL — or use the PowerShell variant at
   `hajime/reference/dojo-check.ps1` (same contract; swap the same three commands).
4. **Tracking posture (human-owned — the agent never edits an ignore file).** Dojo's whole
   footprint is `.dojo/` (plus graphify's tool-homed `graphify-out/` when built). What of it is
   shared is the human's call, made here once per project and recorded in .dojo/CONTEXT.md →
   Decisions as the *tracking posture*:

- **hide-all** — invisible mode: nothing of Dojo in shared history (work repos, or anywhere
     the discipline stays private). The record is machine-local; a fresh clone starts cold, and
     deleting the footprint means starting fresh — the posture is also the backup policy: any
     posture that tracks the record gets its history for free; hide-all declines deliberately.
   - **hide-ephemeral** — the durable record travels in git; `session/`, `proof/`, `tanren/`,
     and graphify's regenerable cache stay local. Default for solo repos.
- **track-all** — everything travels, run state included; concurrent mid-wave edits on two
     machines conflict at pull, and the human picks one machine's truth.
   Present the ignore patterns for the choice and the *locations* the patterns may live in,
   each with its consequence — repo `.gitignore` (tracked, shared with collaborators) ·
   `.git/info/exclude` (per-clone, invisible — the anonymous route; its lifecycle matches the
   artifacts': both exist exactly where you use Dojo) · a global excludes file (all your
   machines, all repos) · `.dojo/.gitignore` (travels with the folder; created only on explicit
   choice). The human applies it — in any of these, never the agent. Then verify with
   `git check-ignore -v` and report the file:line doing the ignoring; divergence from the
   recorded posture is surfaced, never assumed away. Backstop: kata-commit's denylist keeps
   ephemeral files unstaged regardless of ignore state.
1. `chmod +x scripts/dojo-check.sh`. Show the script; ask "Does this look right for your
   stack?" Do not proceed until confirmed.
2. Run it to establish the **baseline**:

- All green → proceed.
- No tests yet → create a trivial passing test, re-run.
- **Pre-existing failures** (brownfield) → record them in .dojo/session/dojo-session.md under
     `pre_existing_failures`, then offer: (a) a **stabilization wave 0** to green the baseline
     first (recommended), or (b) proceed with the rule that every gate requires *no new
     failures* — pre-existing ones are tracked, not fixed silently, not allowed to grow.

### graphify (optional tool — active treatment per dojo-conduct)

Empty/greenfield project → skip entirely; kata-commit will suggest it once code exists.
Existing code + cache present → skip silently. Existing code + no cache → offer to run it now
("builds a structural graph, paid once, skippable"); run if no objection. Runs *before* randori
so the grill is informed by real structure.

### Living artifacts

Create if absent: **.dojo/learning-log.md** (header: "# Learning
Log — [project]. Debriefs; briefs in supervised sessions. Append-only."), and always
**.dojo/progress.md** (the single per-wave log) plus **.dojo/findings.md** (discoveries and halt
diagnostics — kata-commit and the halt protocols append to them). There is no snapshot
document: a cold reader orients from .dojo/CONTEXT.md, .dojo/TASKS.md, .dojo/progress.md, and git log.

---

## 4. Commit style (skip if rigor: poc)

**If confirmed in §2's packaging block, skip.** Ask once per session; store as
`commit_style`. If a preference exists but wasn't confirmed there, confirm it instead of
asking cold; if the human states a new lasting preference, propose saving it (consent rule
in dojo-project).

```
How do you like your commit messages?
  TERSE        fix: prevent double discount on retry
  CONVENTIONAL fix(orders): prevent discount from applying twice on retry        [default]
  DETAILED     conventional + body with root cause / approach / test reference
  NARRATIVE    detailed, body as prose
  — or describe your own.
```

## 4b. Log sink (skip if rigor: poc; ask once per project)

**If confirmed in §2's packaging block, skip.** If .dojo/CONTEXT.md → Decisions already records a
log sink: skip silently. Otherwise ask once, record
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

**If the design exists:** read .dojo/TASKS.md and **audit before trusting** — declared done is not
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
fills .dojo/CONTEXT.md, writes ADRs, **and writes .dojo/TASKS.md** (the plan: every wave as a verifiable
outcome with `status:` fields) whenever the work spans more than one wave. Always supervised.

---

## 5b. The plan (bugfix fork — replaces §5's randori)

*The most important step. Do not skip or rush it.*

Bugfix sessions skip randori and go straight to `/kan`: **reproduce → minimise → hypothesise →
instrument → fix → regression-test**. Its central discipline: a fast, deterministic,
agent-runnable pass/fail signal for the exact bug before anything else. Kan writes findings to
.dojo/findings.md and feeds its reproduction to kata-red as the regression test.

**Supervised:** kan presents findings; you approve the diagnosis before the fix begins.
**Autonomous:** kan logs findings and proceeds — unless it cannot reproduce, in which case it
halts and states what artifact or access it needs.

The bugfix wave goal always has this shape: *"[Bug] no longer occurs. Proven by a regression
test that currently fails and passes after the fix."*

---

## 6. Initialize the session

Write `.dojo/session/dojo-session.md` (wave 1's goal comes from .dojo/TASKS.md, or from randori for single-wave
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

**Bugfix fork (replace `type: feature` and add):**

```markdown
type: bugfix
diagnosis: [root cause from kan]
reproduction: [how to reproduce]
```

Present the goal. Supervised: confirm it. Autonomous: confirm the full plan before any
autonomy begins.

---

## 7. Hand off

Summarize: what was learned (if grilled), the wave 1 goal, baseline status, mode and density.

**Supervised:** "Ready to write the failing check. Run **/kata-red** when you're ready."

**Autonomous:** begin `/kata-red` → `/kata-green` → `/kata-commit`, looping per wave;
kata-commit advances the goal from .dojo/TASKS.md between waves. HALT at a clean point,
write to .dojo/findings.md (and .dojo/TASKS.md → Improvement Backlog if systemic), and recommend `/kaizen` whenever: reality diverges from
the plan (false assumption, invalidated wave, needed pivot); work heads toward a declared
non-goal (.dojo/CONTEXT.md); or a probabilistic approach is about to replace a plausible
deterministic one. Never rewrite the plan autonomously. Green's stuck branch halts after
its one adjusted attempt. At the wave ceiling, kata-commit pauses at a clean checkpoint
and writes .dojo/session/resume.md.

**Bugfix hand-off:** "Diagnosis complete. Ready to write the regression test. Run
**/kata-red**" (supervised) or `/kata-red` → `/kata-green` → `/kata-commit` (autonomous).
HALT and recommend `/kaizen` if the fix reveals a different root cause than diagnosed, or the
bug needs a design change rather than a patch — never expand scope autonomously. Never commit
a broken fix.

During the run, accumulate (never act mid-run): **preference candidates** (durable about-you
defaults) and **insight promotion candidates** (per-project insights general enough for
dojo-principles → Promoted). Present both as per-item approval batches in the end-of-run
report. Nothing is globalized or promoted without explicit consent.
