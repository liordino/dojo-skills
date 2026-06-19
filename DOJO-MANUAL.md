# Dojo System — Instructions Manual

**Version:** 1.1
**Author:** Liordino Neto

> Dojo is a personal system I built for my own work and decided to share. This manual is the
> *explanatory* layer: rationale, walkthroughs, examples. The skill files are the *normative*
> layer: terse rules the agent loads. When they seem to differ, the skill files win — and
> `scripts/dojo-lint.sh` exists to keep them from differing.

---

## Table of Contents

1. [Philosophy and Goals](#1-philosophy-and-goals)
2. [System Architecture](#2-system-architecture)
3. [Prerequisites and First-Time Setup](#3-first-time-setup)
4. [The dojo-session.md File](#4-the-dojo-sessionmd-file)
5. [The dojo-check Script](#5-the-dojo-check-script)
5b. [Artifact Hierarchy and Context Management](#5b-artifact-hierarchy-and-context-management)
6. [Skill Reference](#6-skill-reference)
7. [Workflow Walkthroughs](#7-workflow-walkthroughs)
8. [Supporting Skills Integration](#8-supporting-skills-integration)
9. [Supervised vs Autonomous Mode](#9-supervised-vs-autonomous-mode)
10. [Quick Reference Card](#10-quick-reference-card)

---

## 1. Philosophy and Goals

### What the Dojo System Is

A modular development philosophy and agent interaction protocol built on three pillars:

**Extreme Programming (XP) pair programming** — work proceeds in discrete, approval-gated
waves. You are always the navigator: you define what correct looks like, set the scope, and
decide at the gates. The agent is always the driver: it writes code, runs checks, and narrates
its reasoning. Neither role is optional.

**Test-Driven Development (TDD)** — tests are the contract; the implementation satisfies it. A
failing check written before implementation is the most precise expression of "what done
means." Without it, the agent defines "done" on its own terms, which drifts.

**Goal-Driven Execution** — every wave is a verifiable outcome, not a task list. "A user with
no items in their cart must receive a CartEmptyError at checkout" is a wave goal; "add cart
validation" is not. The agent derives the path; you define correct.

### Three Goals This System Serves

**1. A controlled process you can learn from.** Every step is discrete and narrated; the wave
briefs point you at concepts worth researching. The agent is a colleague, not a vending machine.

**2. Easier maintenance.** Seventeen small, focused skill files instead of one big document.
Each file has one job; a rule change touches one file. Rationale lives here in the manual so
the skills stay terse — which also keeps the agent's per-wave context cost down (see §5b).

**3. Autonomous operation.** Set a goal and let the agent run the cycle. The `dojo-session.md`
state spine, the deterministic `dojo-check` gate with its proof artifact, the `TASKS.md` plan,
divergence halts, and the wave ceiling with `RESUME.md` continuation all exist to make that
safe. You control the boundary between supervised and autonomous.

### What "Dojo" Means

Dojo literally means "place of the Way" — a hall for immersive, experiential learning. A kata
is a structured sequence practiced until internalized: not a ruleset you consult, but a form
you execute automatically. That is the intent. These are not guidelines to consider; they are
the form.

---

## 2. System Architecture

### The 17 Skills

```
┌─────────────────────────────────────────────────────┐
│                  ALWAYS LOADED                      │
│   dojo-principles · dojo-project · dojo-conduct     │
└─────────────────────────────────────────────────────┘
                          │
          ┌───────────────┴───────────────┐
          │                               │
    FEATURE ENTRY                   BUGFIX ENTRY
          │                               │
         /hajime                      /hajime-bugfix
 (asks rigor + sup/auto)           (asks sup/auto)
          │                               │
     randori (design)               kan (diagnosis)
          │                               │
          └───────────────┬───────────────┘
                          │
                    WAVE CYCLE
              ┌───────────┼───────────┐
              │           │           │
          /kata-red   /kata-green  /kata-refactor
              └───────────┴───────────┘
                          │
                    /kata-commit ──▶ advances TASKS.md, next wave
                          │
              /kata-stuck ←── from kata-green after 2 failures

   On demand: /waza (algorithms) · /tanren (optimize) · /kaizen (plan change) · /kokai (release) · /kensha (PR audit)
```

### The State Spine: dojo-session.md

Every skill reads `dojo-session.md` when it loads and writes to it when it exits — the shared
memory of the session. It lets skills pick up exactly where the previous one left off, lets
autonomous mode resume after a context reset, and lets you inspect or steer the session by
editing one small file. It is per-machine working state and is **gitignored** (hajime sets
this up); `HANDOFF.md` is the durable, shared resume surface.

### The Deterministic Gate: dojo-check

The only fully deterministic mechanism in the system. A script in the project repo running
compile → lint → test, exiting 0 on full success — and, on success, writing a **proof
artifact** (`.dojo/check-proof`: timestamp + hash of the run output). The agent reads exit
code, output, and proof; it never drives the compiler or test runner directly, which keeps its
behavior predictable and stack-agnostic. Gates verify the proof, not the agent's claim.

### Supporting Skills (called from within the cycle)

| Skill | Called from | Purpose |
|---|---|---|
| `randori` | `hajime` | Interview-driven design, domain language, ADRs, TASKS.md |
| `kan` | `hajime-bugfix`, `kata-stuck` | Disciplined diagnosis loop |
| `waza` | `kata-red`, `kata-green` | Algorithm recognition, derivation, approximation |
| `tanren` | `waza` | Iterative optimization against a measurable metric (gated) |
| `kaizen` | divergence halts, pivots | Re-grill; rewrite the plan |
| graphify (optional tool) | `hajime`, `kata-commit` | Codebase knowledge graph, refreshed on structural delta |
| specialized UI skill (optional) | `kata-refactor` | Framework-detected UI quality pass |

---

## 3. First-Time Setup

**Core Dojo skills (all 17, self-contained — no external dependencies):** dojo-principles ·
dojo-project · dojo-conduct · hajime · hajime-bugfix · randori · kan · waza · tanren · kokai ·
kensha · kaizen · kata-red · kata-green · kata-refactor · kata-commit · kata-stuck.

**Tools Dojo pairs well with (acknowledgments, not dependencies — dojo-conduct):** ast-grep
(falls back to ripgrep) · graphify (the one tool with active suggestions) · caveman (its terse
principle is internalized) · a specialized UI skill for whatever framework you work in.

### Per-Project Setup (run once per repo)

#### Step 1: Nothing to install — Dojo scaffolds itself

On the first `/hajime`, Dojo creates its own structure: `CONTEXT.md` (Glossary / Non-Goals /
Decisions), `scripts/dojo-check.sh` (with the proof artifact), `HANDOFF.md`,
`learning-log.md`, and `.gitignore` entries for `.dojo/` and `dojo-session.md`. `docs/adr/`
appears lazily with the first ADR; `TASKS.md` appears when randori plans multi-wave work.

#### Step 2: dojo-check — your three commands inside the canonical wrapper

`hajime` detects your stack and scaffolds the script automatically, showing it to you for
confirmation before use. The canonical wrapper (with the proof artifact) is in §5; only the
three stack commands change. Typical commands:

```
Rust:     cargo build                cargo clippy -- -D warnings      cargo test
C#/.NET:  dotnet build               dotnet format --verify-no-changes dotnet test
Go:       go build ./...             golangci-lint run                 go test ./...
Node/TS:  npm run build              npm run lint                      npm test
C/C++:    make build                 make lint                         make test   (confirm yours)
```

The script lives at `scripts/dojo-check.sh`, is committed, and must be executable
(`chmod +x`). On Windows, run it under Git Bash or WSL — or use the PowerShell variant at
`hajime/reference/dojo-check.ps1` (same contract; swap the same three commands). Optionally expose it as `make dojo-check`.

#### Step 3: Verify the baseline

Run it manually once. All green → ready. No tests yet → the agent adds a trivial passing test
first. **Pre-existing failures on a brownfield repo do not block Dojo:** they are recorded in
`dojo-session.md` under `pre_existing_failures`, and every gate then requires *no new
failures* — with a recommended "stabilization wave 0" to green the baseline properly.

#### Step 4: Update AGENTS.md

```
# Dojo
dojo-check: ./scripts/dojo-check.sh
Domain glossary + non-goals + decisions: CONTEXT.md
ADRs: docs/adr/        Plan: TASKS.md
Session state: dojo-session.md (gitignored)
```

---

## 4. The dojo-session.md File

Created by the hajime variants, updated by every step skill, gitignored.

### Full Specification

```markdown
# Dojo Session

mode: supervised            # supervised | autonomous
rigor: real                 # real | poc
type: feature               # feature | bugfix
wave: 1                     # advanced by kata-commit from TASKS.md
step: RED                   # RED | GREEN | REFACTOR | COMMIT | STUCK | DONE
gate_density: standard      # full | standard | light (supervised only)
wave_ceiling: 4             # waves per session before a fresh-session checkpoint
intent:                     # one sentence — the problem this solves, and for whom
goal:                       # the current wave's verifiable outcome
commit_style: conventional  # terse | conventional | detailed | narrative | custom
test_written:               # populated by kata-red (or "manual: ..." for non-automatable waves)
test_status:                # failing ✓ | passing ✓
attempts: 0                 # failed dojo-check runs this GREEN; 2 triggers kata-stuck
pre_existing_failures:      # baseline failures tracked, not owned, by this session

# Bugfix-only
diagnosis:                  # root cause from kan
reproduction:               # minimal reproduction steps
```

### Field Notes

**mode** — supervised stops at gates; autonomous runs, halting only on divergence, stuck, or
the ceiling. Set by hajime; editable mid-session (see §9).
**rigor** — `poc` loosens tests/pedagogy/ceremony and tightens scope; orthogonal to mode (an
autonomous PoC spike is valid).
**step** — current position; each skill updates it on exit. `STUCK` is written by kata-stuck
so resume checks recognize an interrupted blocker.
**gate_density** — how many stops a supervised wave has (defined in dojo-conduct): full = 6,
standard = 4, light = 2. Content is never skipped, only batched.
**attempts** — incremented by kata-green per failed run; reset to 0 by kata-green on pass (or
by you, to grant more tries); at 2, kata-stuck fires.
**pre_existing_failures** — which failures predate the session, so the agent knows what it is
and isn't responsible for. Used by both feature and bugfix sessions.

You can inspect or edit the file at any time — reset `attempts`, change `mode` or
`gate_density` — the next step skill picks it up.

---

## 5. The dojo-check Script

### Purpose

The single deterministic gate. It answers: "is the codebase in a valid state right now?" —
and proves it. Called at four points: session start (baseline) · after RED (new check fails
for the right reason, no new failures elsewhere) · after GREEN (everything passes) · before
COMMIT (final gate, proof verified).

### The illustrative template

This is the same cargo-shaped example hajime scaffolds. The **proof-contract invariant**
(what `.dojo/check-proof` must contain, and what it proves) is normative in
`dojo-principles → Enforce Over Instruct — the Proof Contract` — change it there, not
here. This block shows the shape; swap only the three stack commands:

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

**Why the proof:** the gate produces *evidence*, not a claim. `.dojo/check-proof` exists fresh
only after a fully green run; kata-commit verifies freshness (proof newer than every edit)
before any commit, and upgrades older scripts that predate the template. Doing the real work
is easier than faking the artifact — which is the honest bar in a harness with shell access.

**Anatomy of a good script:** compile first (categorically different failures), lint second
(fast), tests last; exit 1 on first failure with diagnosable output; headless (no prompts);
no missing environment requirements; consistent parseable output.

`scripts/dojo-lint.sh` R10 enforces that `dojo-principles`, `scripts/dojo-check.sh`, this
manual, the hajime scaffold, and the PowerShell reference all reference the same
proof-contract identifiers (`check-proof`, `output_sha256`, `check-output.log`) — the
*structural* agreement. The surfaces are free to diverge in prose so long as they all
reference the same identifiers. See ADR 0001 in `docs/adr/` for the rationale and the
migration history from the prior byte-equality check.

### Targeted runs (optional, for large suites)

```bash
# scripts/dojo-check-fast.sh — e.g. only the current module's tests
#!/usr/bin/env bash
set -e
cargo build
cargo test "${MODULE:-}" 2>&1
```

kata-red/green/refactor may use it for the inner loop; the full `dojo-check` (and its proof)
still gates every commit. Document it in AGENTS.md if you add it.

---

## 5b. Artifact Hierarchy and Context Management

### Why this matters

An agent's context degrades as it fills — unevenly and gradually. Fifteen waves of diffs, test
iterations, and narration would bury the thread. The solution is not a bigger window; it is
**writing everything durable to disk and letting the agent forget**. Completed work lives in
files; the context holds only the current wave.

### The files

| File | Scope | Updated | Purpose |
|---|---|---|---|
| `dojo-session.md` | Current wave | Every step | Working state (gitignored, per-machine) |
| `TASKS.md` | Whole plan | randori, kata-commit, kaizen | Every wave as a verifiable outcome + status |
| `progress.md` | Per wave | Each commit | Terse log: built, exposes, next dependency |
| `learning-log.md` | Per wave | Each wave | Briefs (concepts to explore) + debriefs |
| `HANDOFF.md` | Whole project | Each commit | Living document — pick the project up cold |
| `CONTEXT.md` | Whole project | randori, kaizen | Glossary · Non-Goals · Decisions |
| `docs/adr/` | Whole project | As decided | Decision records with rationale |
| `findings.md` | As needed | Diagnosis, halts | Discoveries and halt diagnostics |
| `.dojo/tanren/` | During optimization | tanren loop | Scratch: candidates + untracked results ledger + champion |
| `scoping-questions.md` | Pre-design | randori scoping mode | Unknowns to resolve, and with whom |
| `poc-lessons.md` | PoC only | kata-commit (poc) | What the real build should do differently |
| `RESUME.md` | Autonomous pause | kata-commit | One-line continuation pointer |

### HANDOFF.md — the living project document

Updated incrementally at each wave's close, never rewritten. A fresh agent or returning human
reads it and is oriented without replaying history. Stable skeleton: Project Overview (once,
from CONTEXT.md) · Architecture (as structure grows) · Wave History (appended) · Key Concepts
(appended when new) · Current State (overwritten) · Improvement Backlog (accumulated).
Walking away mid-project costs nothing.

### The compaction cycle

`kata-commit` (wave close) writes everything durable to disk — code to git, summary to
progress.md, pedagogy to learning-log.md, state to HANDOFF.md — then signals that the wave's
working context is released. `kata-red` (next wave) reloads from disk and treats prior-wave
conversation as disposable. Each wave starts lean regardless of how many came before. The
governance files are never treated as wave context — kata-red reloads them if evicted.

### Wave ceiling, fresh sessions, RESUME.md

At each commit, kata-commit counts waves against `wave_ceiling` (default 4, configurable in
preferences/session). Supervised: it *suggests* a fresh session — all state is on disk, so a
new `/hajime` loses nothing. Autonomous: it pauses at the clean checkpoint and writes
`RESUME.md` ("run /hajime autonomous to continue"), so a wrapper or you can relaunch with
fresh context and the plan continues from TASKS.md. The trigger is wave count and the
clean-checkpoint fact — never the agent self-assessing its own degradation, which is unreliable.

### The cost of the system itself (and how it's kept down)

Discipline isn't free: the skills themselves occupy context. As of v1.1 the standing load is
roughly — governance trio (always loaded): ~18 KB ≈ 4.5k tokens; the four kata step files
across one wave: ~22 KB ≈ 5.6k tokens; total recurring ≈ 10k tokens per wave (about 36% less
than v1.0), plus ~11 KB for hajime once at entry. Three mechanisms keep it down: skills are
normative-only (rationale lives in this manual, which the agent never loads); detail moves to
on-demand reference files (e.g. `dojo-principles/reference/ast-grep.md`); and the compaction
cycle ensures the *project's* context stays small so the system's share stays affordable. If
you trim further, trim prose, never rules.

### graphify update cadence

The structural map only goes stale when structure changes. kata-commit inspects the wave's
diff: new/removed files or changed public signatures → suggest (autonomous: run)
`graphify --update`; body-only changes → skip silently. You never pay graphify's cost for
changes that don't move the graph.

### Where pedagogy goes

Wave briefs (kata-red) and debriefs (kata-commit) always land in `learning-log.md`. Supervised
they're also presented inline; autonomous they go to the log only — lean context for the
agent, full learning record for you.

---

## 6. Skill Reference

Each entry is a map, not a mirror — the normative text is the skill file itself.

**dojo-principles** — load at session start. Cross-cutting engineering rules for the code:
navigation (rg/ast-grep), DRY, minimal delta, non-goals, deterministic-over-probabilistic,
negative space, parse-don't-validate, purity, logging, errors-as-values, total functions,
comment provenance, explicit dependencies, ECS rule — plus your **Promoted (local)** insights.
Step-specific rules (invariants, YAGNI, idempotency, types, formatting) live in the kata files
that apply them. Normative text: `dojo-principles/SKILL.md`.

**dojo-project** — load at session start; consult at lifecycle points. The project around the
code: problem-first docs, structure and entrypoints, hierarchical AGENTS.md, config
example/real pattern, build-once-repackage-many, the preferences store and the
preferences-vs-insights promotion rule. Normative text: `dojo-project/SKILL.md`.

**dojo-conduct** — load at session start. How the agent behaves: the **precedence hierarchy**
(human > governance > project facts > skill text > memory), enforce-over-instruct (evidence,
not claims), gate design and **gate density**, concise operational output, and the optional
tools (graphify's active treatment defined here). Normative text: `dojo-conduct/SKILL.md`.

**hajime** — `/hajime [optional feature description]`. Feature entry: resume/crash check,
preferences, rigor (real/PoC) + mode + design questions, the scaffolding checklist (CONTEXT.md,
canonical dojo-check + proof, gitignore, graphify offer, HANDOFF/learning-log), brownfield
baseline handling, commit-style and log-sink questions, plan audit or randori, session init,
hand-off (autonomous: divergence rules, candidates batches). Normative: `hajime/SKILL.md`.

**hajime-bugfix** — `/hajime-bugfix [bug description]`. Bugfix entry: same checklist via the
same canonical templates, kan diagnosis instead of randori, regression-test-first wave goal,
bugfix fields in the session file. Normative: `hajime-bugfix/SKILL.md`.

**randori** — `/randori`, or from hajime. Always supervised. Scope-and-leverage gate first;
one-question-at-a-time grill with recommendations; builds CONTEXT.md (Glossary / Non-Goals /
Decisions, `(provisional)` markers allowed); ADRs only for hard-to-reverse + surprising + real
trade-off; outputs the intent line and **TASKS.md** (multi-wave) or the single wave goal.
Scoping mode outputs `scoping-questions.md` when answers live with other people. Normative:
`randori/SKILL.md`.

**kan** — `/kan`, or from hajime-bugfix / kata-stuck. Reproduce → minimise → hypothesise →
instrument → fix → regression-test. Will not proceed without a deterministic, agent-runnable
pass/fail signal for the exact bug; the reproduction becomes kata-red's regression test;
prevention notes go to the backlog; design-change discoveries are divergences. Normative:
`kan/SKILL.md`.

**waza** — `/waza`, or auto from kata-red/kata-green. Classify, then: Recognition (name the
canonical problem; the DP check), Derivation (reduction → paradigm checklist →
correct-by-construction → symbolic trace), or Approximation (method + explicit tolerance +
why; tolerance is a product decision needing sign-off when supervised). Always hands kata-red
a test-first contract. Normative: `waza/SKILL.md`.

**tanren** — `/tanren`, or from waza when the goal is optimizing a measurable metric. Hard entry
gate: a scalar fitness metric, a fixed/fast/deterministic scorer, and a human-approved metric +
budget (required even when autonomous — defining "better" is a design decision). Freezes the
scorer and scores on held-out cases (anti-gaming); runs propose → score → keep-or-revert in
`.dojo/tanren/` (untracked ledger); stops on budget/target/stagnation/stuck; hands the winning
implementation to kata-red to ratify with a real test and commits the winner only. Not a kata
wave — it produces a decision; the cycle ratifies it. Normative: `tanren/SKILL.md`; mechanics:
`tanren/reference/tanren-loop.md`.

**kata-red** — write the failing check: reloads context from disk, delivers the wave brief,
applies invariant rules and the strategy ladder (property-based → golden → example), handles
non-automatable waves explicitly, confirms red-for-the-right-reason. Normative:
`kata-red/SKILL.md`.

**kata-green** — minimum implementation: YAGNI, idempotency, explicit types, error rules,
structural navigation first, the determinism gate, two-attempt stuck protocol, and the
**refactor assessment** presented at its gate. Normative: `kata-green/SKILL.md`.

**kata-refactor** — clean without changing behavior: SRP/size, names (rg + sg verification),
structural DRY, formatter, provenance comments, framework-detected UI skill pass. Skippable
supervised; mandatory autonomous (with full revert on any breakage). Normative:
`kata-refactor/SKILL.md`.

**kata-commit** — the wave close: proof-verified final gate, message in the session style,
**explicit staging with a secrets denylist** (never `git add -A`), the debrief + engagement
note, durable-artifact updates, **TASKS.md advancement to the next wave**, graphify delta
check, wave ceiling / RESUME.md, context release. Normative: `kata-commit/SKILL.md`.

**kata-stuck** — after two failed attempts: sets `step: STUCK`, presents the full diagnostic
(attempts, raw output, ranked hypotheses, what would resolve it) and 2–3 adjusted approaches;
supervised asks for direction, autonomous tries the least-risky option once then halts.
Normative: `kata-stuck/SKILL.md`.

**kaizen** — `/kaizen`, always supervised. Reads current reality, grills the change, assesses
impact honestly (including invalidated committed waves), rewrites TASKS.md, updates CONTEXT.md
/ ADRs / HANDOFF.md / dojo-session.md, then asks auto-vs-supervised when resolving an
autonomous halt. Never writes code. Normative: `kaizen/SKILL.md`.

**kokai** — `/kokai`. Release and distribution: problem-first README first, installation
surface (binary + language-native + OS packages as warranted), CI mirroring dojo-check,
tag-triggered idempotent releases, Keep-a-Changelog flow, the `bin/deploy` contract.
Supervised by default — channels, signing, deploy targets are human calls. Normative:
`kokai/SKILL.md`.

**kensha** — `/kensha`. Contribution inspection: audit the code, not the description. Single-PR
mode (correctness, regressions, quality, coverage, doc sync) or batch mode (dead code,
duplication, magic values, stale docs). Runs the gate, delivers an assessment + recommendation;
merging and sign-off are always the human's. Normative: `kensha/SKILL.md`.

---

## 7. Workflow Walkthroughs

### 7.1 Supervised Feature — Step by Step (gate_density: standard)

**Scenario:** validate payment methods at checkout.

**Step 1 — Start**

```
You: /hajime Add payment method validation to checkout
```

The agent: no dojo-session.md → fresh · asks rigor → real · mode → supervised (density
standard from your preferences) · design → not done · scaffolds/verifies CONTEXT.md and
dojo-check, baseline green ✓ · offers graphify, you accept · runs randori:

```
Agent: "Should validation happen before or after the order total is calculated?
My recommendation: before — no point totaling an order that can't be paid. Your call?"
You: "Before, agreed."
Agent: "Error type for a missing payment method? I'd recommend a typed
PaymentMethodMissingError over a generic validation error — callers can handle it
specifically. Agree?"
You: "Yes."
[... non-goals suggested and confirmed, two more questions ...]
```

Randori writes TASKS.md (two waves) and the intent line; hajime writes dojo-session.md:

```
Agent: "Plan: Wave 1 — a checkout attempt with no payment method on file raises
PaymentMethodMissingError before order total calculation. Wave 2 — expired methods are
rejected with PaymentMethodExpiredError. Baseline green. Run /kata-red when ready."
```

**Step 2 — RED (one stop: brief + failing check)**

```
You: /kata-red
```

The agent reloads from disk, then presents together: the wave brief (what/why/concepts:
"parse-don't-validate", "guard clauses"/bigger picture), the test written in CONTEXT.md
language, and the dojo-check output — new test failing for the right reason, 47 existing
passing. STOP. You approve.

**Step 3 — GREEN (one stop: diff + assessment + decision)**

```
You: /kata-green
```

```
Agent: "Approach: a PaymentMethodMissingError type and one guard at the top of checkout.
YAGNI: no validation framework. ... All 48 tests pass; fresh .dojo/check-proof written.

Refactor opportunities:
1. The guard inlines the 'has payment method' predicate — a second caller next wave would
   duplicate it. Improvement: extract hasPaymentMethod(customer).
2. Nothing else — minimal and well-scoped.

Want to refactor?  1. Yes, handle the above  2. Yes, with instructions  3. No, straight to commit
```

You pick 1.

**Step 4 — REFACTOR (stop)**
Agent extracts the predicate, dojo-check stays green, presents the diff. You approve.

**Step 5 — COMMIT (gate, then advancement)**

```
Agent: "Proof verified fresh. Staging 3 files (status summary below — no denylist hits).
Suggested commit:
  feat(checkout): raise PaymentMethodMissingError when no payment method on file
  1. Commit now   2. Edit message   3. I'll commit manually"
You: 1
Agent: "Wave 1 committed (a1b2c3d). Artifacts updated; TASKS.md wave 1 → done.
Debrief: [what/why/systemic note/status] (also in learning-log.md).
Next wave loaded from TASKS.md — Wave 2: expired payment methods are rejected with
PaymentMethodExpiredError. Confirm and run /kata-red, or stop here."
```

### 7.2 Supervised Bugfix

```
You: /hajime-bugfix Orders get double discounts when the checkout request is retried on a
network timeout. Line 47 of OrderService.cs.
```

Checklist runs; baseline: 34 passing, 2 pre-existing failures (unrelated — recorded, not
owned). Kan reproduces deterministically ("calling applyDiscount twice drops the total by 20"),
minimises, and names the root cause: a relative operation with no idempotency guard. You
approve the diagnosis. Wave goal: "applyDiscount is idempotent — proven by a regression test."
Then `/kata-red` (regression test `applyDiscount_isIdempotent_whenCalledTwice` fails, 34 others
unchanged) → `/kata-green` (guard + flag; 35 pass, 2 pre-existing still tracked) →
`/kata-commit`:

```
fix(orders): prevent discount from applying twice on retry

Root cause: applyDiscount had no idempotency guard; total -= amount applied on every call.
Added DiscountApplied flag checked before mutation.
Regression: applyDiscount_isIdempotent_whenCalledTwice
```

### 7.3 Autonomous Feature

Choosing autonomous in `/hajime` still runs design supervised: if no TASKS.md exists, randori
grills first, you confirm the plan, and only then autonomy begins; if one exists, it is audited
and gaps are named before the run. During the run the agent loops the cycle, kata-commit
advancing the goal from TASKS.md. It HALTS — at a clean point, with findings.md and HANDOFF.md
written — on divergence (false assumption, invalidated wave, pivot), on approach toward a
declared non-goal, on a contestable determinism-gate call, or at STUCK after its one adjusted
attempt. At the wave ceiling it pauses cleanly and writes RESUME.md so a relaunch continues
the plan with fresh context. You resolve divergences with `/kaizen`, which asks whether to
resume autonomous or switch to supervised. The end-of-run report covers: built, tests,
decisions, commits, anything needing review, plus preference and promotion candidate batches
for per-item approval.

### 7.4 Autonomous Bugfix

```
You: /hajime-bugfix (autonomous) The payment webhook fires twice for some orders. Happens on
retries; order_id is in the payload.
```

The agent diagnoses, writes the regression test, fixes, commits. If it cannot reproduce
deterministically, it halts and states exactly what artifact or access it needs. It never
commits a fix it isn't confident in, and never expands a patch into a design change — that's
a divergence and a `/kaizen`.

---

## 8. Supporting Skills Integration

**randori (design)** — called by hajime when the design isn't done. One question at a time,
each with a recommended answer; explores the codebase/graph instead of asking what code can
answer. Output: CONTEXT.md entries, ADRs, the intent line, and TASKS.md — the domain
vocabulary then names everything (tests, variables, commits) for the whole session.

**kan (diagnosis)** — called by hajime-bugfix, and by kata-stuck when the blocker is a bug.
Will not move past reproduce without a deterministic signal; the reproduction *is* the
regression test kata-red writes.

**tanren (optimization)** — called by waza, and only when the gate is met: a scalar fitness
metric, a frozen deterministic scorer, and a human-approved metric + budget. It runs an
isolated propose → score → keep-or-revert loop in `.dojo/tanren/` and never touches the main
spine until its winner is ratified by a normal kata wave. It is the one place the shelved
model-routing idea would pay off most (cheap inner loop, strong steer), but it depends on no
such thing. Irrelevant to pure-correctness problems — those end at waza Step 3.

**graphify (optional)** — offered by hajime when existing code has no cache (skipped entirely
on greenfield); refreshed by kata-commit only on structural delta. Replaces expensive
exploration with cheap graph queries on large or unfamiliar codebases; cache persists across
sessions. Absent it, navigation falls back to rg/sg.

**Multi-session persistence** — hajime initializes `progress.md` and `findings.md` for work
that may span waves or sessions; randori writes `TASKS.md`. These survive context resets: a
resumed session reads them (plus HANDOFF.md) and is oriented without re-exploring.

**Specialized UI skills (optional)** — invoked by kata-refactor when a wave touched UI: it
detects the framework and runs whatever matching skill you have installed, with the right lens
(visual polish where the framework has aesthetics to polish; structural/binding correctness
where it doesn't). None installed → general refactor principles apply. Irrelevant for
backend/CLI/daemon work.

**caveman (optional)** — its principle, terse operational output, is internalized in
dojo-conduct; the standalone tool adds multi-mode compression on top if you want it.

---

## 9. Supervised vs Autonomous Mode

**Use supervised when:** learning the codebase or domain · design decisions pending · you want
to follow every step · the change is high-risk (payments, security, migrations) · the goal
isn't fully specified. Supervised is the default; when in doubt, use it. Tune the **gate
density** (full / standard / light — dojo-conduct) instead of abandoning supervision: lighter
density batches the same content into fewer stops.

**Use autonomous when:** the goal is well-defined and well-scoped · the domain language is
established · risk is low and the suite is trustworthy · you'd rather review a completed wave
than sit through it.

**Switching mid-session:** edit `dojo-session.md` (`mode:`, or `gate_density:`) — the next
step skill picks it up; this is the human-override layer of the precedence hierarchy. One
guard: if you flip to autonomous and the plan was never audited (no TASKS.md, or randori never
ran), the agent runs hajime's plan audit before autonomy begins — autonomy starts after the
plan is set, never before. The engagement note may also *suggest* a lighter density or
autonomous mode when your approvals have become reflexive; the choice is always yours.

---

## 10. Quick Reference Card

### Invocation Cheat Sheet

| Command | When |
|---|---|
| `/hajime [description]` | Start a feature session (asks rigor, mode, design) |
| `/hajime-bugfix [description]` | Start a bugfix session (asks mode) |
| `/kata-red` | Write the failing check (after the goal is defined) |
| `/kata-green` | Implement minimally (after RED) |
| `/kata-refactor` | Clean up (skippable supervised; mandatory autonomous) |
| `/kata-commit` | Verify proof, commit, update docs, advance the plan |
| `/kata-stuck` | Surface a blocker (auto after 2 failed attempts) |
| `/randori` | Design grill / scoping reconnaissance (auto from hajime) |
| `/kan` | Disciplined diagnosis (auto from hajime-bugfix) |
| `/waza` | Algorithm: recognize / derive / approximate (auto from red/green) |
| `/tanren` | Optimize an algorithm against a measurable metric (gated; from waza) |
| `/kaizen` | Re-grill and rewrite the plan (pivots, divergence halts) |
| `/kokai` | Release & distribution setup |
| `/kensha` | Audit a PR or a batch of merges |

### Session Flow

```
/hajime | /hajime-bugfix
        ▼
 checklist ── baseline: green, or failures recorded (no NEW failures from here on)
        ▼
 randori (feature) | kan (bugfix)  ──▶  TASKS.md + dojo-session.md
        ▼
 /kata-red ─▶ /kata-green ──▶ pass? ──NO(×2)──▶ /kata-stuck
        ▲            │ YES
        │            ▼
        │     /kata-refactor (per decision/mode)
        │            ▼
        │      /kata-commit ── proof fresh? ──NO──▶ re-run / upgrade script
        │            │ YES
        │            ▼
        └── next pending wave from TASKS.md ── none ──▶ DONE (or ceiling ▶ RESUME.md)
```

### dojo-session.md Quick Spec

```markdown
# Dojo Session
mode: supervised | autonomous        rigor: real | poc        type: feature | bugfix
wave: N        step: RED | GREEN | REFACTOR | COMMIT | STUCK | DONE
gate_density: full | standard | light        wave_ceiling: 4
intent: [one sentence]               goal: [verifiable outcome]
commit_style: terse | conventional | detailed | narrative | custom
test_written:   test_status: failing ✓ | passing ✓   attempts: 0
pre_existing_failures: [list or "none"]
diagnosis: [bugfix]   reproduction: [bugfix]
```

### dojo-check

Canonical template (with the proof artifact): §5. Stack commands: §3. Fast variant for big
suites: §5. The proof gates every commit.

### Conventional Commits Types

`feat` new behavior · `fix` bug fix · `refactor` no behavior change · `test` tests only ·
`chore` build/deps/config · `docs` docs only · `perf` performance · `ci` pipelines
