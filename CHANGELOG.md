# Changelog

All notable changes to the Dojo skill package. Format: [Keep a Changelog](https://keepachangelog.com); versioning is package-wide.

## [Unreleased]

### Added

- **`dojo-principles` — fourth Promoted entry: cross-repo wave closure.** *"A wave that
  spans repositories closes in every repository it touched"* — when one wave's work splits
  across repos (fix in one, test net in another), each repo's durable record carries the
  closure (commit, proof, counterpart hash) before the wave is done. Promoted with explicit
  human consent from a two-repo sync session (2026-09-05); source mirrored from the runtime
  copy, restoring content parity (install-parity green).
- **`dojo-principles` — fifth Promoted entry: mirror metadata is never the source of
  truth.** When a map indexes an authoritative, append-only collection, indices and counts
  derive from the collection at use-time and every mirror write is loud (upsert or checked
  insert); silently-failing key-writes compound one collision into a permanent desync.
  Promoted with explicit human consent from the same session (2026-09-05); the Promoted
  section's provenance norm is now session type + date, never the project of origin.
- **Site**: the Principles showcase gained the two new entries as cards — *One wave, every
  repo* and *Mirror metadata* — directly after the "Promoted insights" card they exemplify.

## [1.6.0] — 2026-09-03

Install fidelity: the repo→runtime edge is checkable (`scripts/install-parity.sh`), the
deploy-edge EOL hazard is structurally banned (lint R18), and the governance trio's text
now matches recorded practice.

### Added

- **`scripts/install-parity.sh`** — content-parity check between this repo's skill
  directories and an installed skills dir (`scripts/install-parity.sh <dir>`): per-skill
  OK, per-file MISSING/DRIFT/EXTRA, exit 0 parity / 1 drift / 2 usage. EOL-tolerant by
  design — the install path normalizes line endings (observed: LF → CRLF), so content
  parity is the invariant, not byte parity. Reports only; never mutates the target.
  Wired into the mechanics eval (7 fixture assertions, including a CRLF-normalized copy);
  documented in README → Updating Dojo.
- **Lint R18** — no `*.sh` inside skill directories: the install path copies skill dirs
  verbatim but may normalize line endings (observed: LF → CRLF), and a CRLF shebang is
  fatal off-Windows — the structural ban makes the deploy-edge hazard impossible instead
  of per-machine checked. Drift-injection verified (seeded violation fails, clean tree
  passes).

### Fixed

- Governance-trio currency fixes from the session-start content review: the glossary's
  "lint R1–R14" enumeration dropped (no rule-count baked into prose — it went stale at
  R15 and would have gone stale again at R18); the "rationale lives in
  .dojo/DOJO-MANUAL.md" pointer now names its home repo (it dangled in user projects —
  the manual ships with the repo, not with installed skills); dojo-project gains the
  content-repo carve-out this repo itself relies on (published surfaces may substitute
  for `bin/` entrypoints + AGENTS.md; substitution recorded in .dojo/CONTEXT.md →
  Decisions).

## [1.5.0] — 2026-09-03

One-folder footprint: all Dojo artifacts consolidated under `.dojo/` (ADR 0005); the
sharing boundary made explicit.

### Changed

- **Artifact layout (ADR 0005)** — the durable record moved to `.dojo/`'s root (CONTEXT,
  TASKS, progress, learning-log, findings, DOJO-MANUAL); ADRs to `.dojo/adr/`; the live run
  to `.dojo/session/` (`dojo-session.md`, `resume.md` — RESUME.md joins the ephemeral tier;
  `scoping-questions.md`); gate evidence to `.dojo/proof/` (`check-proof`,
  `check-output.log`); tanren's workspace unchanged at `.dojo/tanren/`; `graphify-out/`
  stays at the repo root (tool-homed exception; tracked here per the recorded posture). ~35
  surfaces rewritten in lockstep; lint
  **R17** now enforces the canonical artifact map (path + tier, stale-path ban on living
  surfaces, denylist agreement, posture verification).
- **The sharing boundary (dojo-conduct)** — named principle: the agent does the work; the
  human owns what is shared, committed, or published (ignore files, history, remotes, CI,
  license) and what commits say about tooling (attribution opt-in, soft default: none).
- **Tracking posture** — hajime presents the posture question at scaffold (hide-all /
  hide-ephemeral / track-all) with a location menu (`.git/info/exclude` first for anonymous
  use); the decision is recorded in CONTEXT.md → Decisions, applied by the human in
  whichever ignore surface they keep, and verified with `git check-ignore`. hajime never
  edits ignore files. This repo records `track-all`.
- **Migration offer** — hajime's resume check detects pre-consolidation artifacts at the
  repo root and offers a one-time move into `.dojo/`.

### Fixed

- **lint R16 was unreachable** — the block sat after the script's exit and never ran
  (wave-asserts P5 had been passing via R4, not R16); it now lives before the verdict.
- **lint R4** no longer false-positives on ADR filename slugs (long-standing backlog item).

## [1.4.0] — 2026-09-03

Deletion and mechanization wave pair: TASKS diet + proposals cleanup; HANDOFF surface
retired; ps1 sync mechanized.

### Changed

- **TASKS.md dieted to the open-wave surface** — closed waves compress to a tombstone
  ledger (what + how resolved + commit); per-wave verification prose lives only in
  progress.md per ADR 0004. 21 KB → 2.3 KB. Historical appendix deleted (git history is
  the record).
- **docs/proposals/ deleted** — both plan files were executed or invalidated; outcomes
  durably recorded in progress.md/CHANGELOG/tombstones. Plans are disposable by design.
- **HANDOFF.md deleted; Improvement Backlog relocated to TASKS.md** — HANDOFF's overview/
  architecture duplicated README and the filesystem; its Wave History was already gone per
  ADR 0004. The resume story is now explicit: a cold reader orients from README → CONTEXT.md →
  TASKS.md → progress.md → git log. Reload paths rewritten in hajime, kata-commit, kata-red,
  kata-green, kan, kaizen, dojo-conduct, DOJO-MANUAL, README, and the landing page; eval s1
  now asserts the relocated backlog. ADR 0004 addendum records the decision.
- **dojo-lint R8 strengthened** — the PowerShell dojo-check reference's proof-contract
  field names are now compared against the canonical template extracted live from
  hajime/SKILL.md (same extraction run-mechanics.sh uses); drift fails lint instead of
  relying on a "keep in sync" comment.

## [1.3.0] — 2026-08-31

Friction and artifact diet: fewer stops at session start, fewer per-wave writes, one
canonical cycle rendering. Standing recurring context ~45 KB ≈ 11.3k tokens per wave
(hajime ~15.7 KB ≈ 3.9k once at entry).

### Changed

- **hajime express-start:** the packaging preferences (gate density, commit style, log
  sink) confirm in one block inside the first message, each line carrying its one-line
  consequence — a decision with content, not assent. The route decisions (rigor, mode,
  design, feature-or-bugfix) stay deliberate questions: decisions that change the route
  are never batched into assent.
- **Artifact diet (ADR 0004):** `progress.md` is the single per-wave log (HANDOFF's Wave
  History migrated into it, the section now a pointer); HANDOFF is a snapshot that stops
  growing with wave count; learning-log briefs are supervised-only; debriefs collapse to
  three fields. Per-wave write targets drop from ~8 to 5.
- **dojo-principles:** the ECS rules moved to `reference/ecs.md` (on-demand; the body
  keeps the opt-in gate); logging compressed to the discipline. `kata-green`'s
  idempotency code example became one prose line — rules untouched.
- **kata-commit:** the engagement-note rubber-stamp threshold is now concrete ("three
  consecutive waves").
- **Lint R15:** `CONTEXT.md` carries exactly Glossary / Non-Goals / Decisions — the
  randori contract, dogfooded by the repo's own lint. R3's dead code removed.
- **Canonical cycle rendering:** red → green → commit, refactor inline in green —
  README, landing page, CONTEXT glossary, manual, and HANDOFF now agree.

### Fixed

- Landing page: the kata name-grid line matched the trimmed cycle; install command
  forms unified on the shorthand; site/README artifact lists merged; README links the
  live site; meta description added.

## [1.2.0] — 2026-08-31

The skill-quality pass (Waves 1–3), the Akita-inspired trim (Waves 4–10,
**17 → 12 skills**; the kata cycle is now red → green → commit), and the post-trim
closeout (banner dedup, kan claim-cut, inherited plan emptied). Recurring per-wave
context cost dropped with every round; the standing load is ~11.4k tokens per wave
plus ~3.7k for hajime at entry.

### Added

- **`tanren` skill** (鍛錬 — "forge by iteration") — an optional, gated iterative-optimization
  loop (propose → score → keep-or-revert) for algorithm problems that have a *measurable
  fitness metric*, not merely binary correctness. Inspired by the propose/score/keep-or-revert
  pattern popularized by Karpathy's `autoresearch` and the FunSearch/AlphaEvolve lineage, adapted
  to Dojo's evidence discipline. Hard entry gate (scalar metric + frozen deterministic scorer +
  human-approved metric and budget, required even when autonomous); freezes the scorer and scores
  on held-out cases to resist metric-gaming; runs in an isolated `.dojo/tanren/` scratch area
  with an untracked results ledger; stops on budget/target/stagnation/stuck; and hands the
  winning implementation back to the kata cycle to ratify with a durable test (commits the winner
  only). It is explicitly *not* a kata wave — it produces a decision; a normal wave ratifies it.
  waza now hands off to it when classification finds an optimization objective rather than one
  correct answer.
- **`tanren/reference/tanren-loop.md`** — loop mechanics, ledger schema, the frozen-scorer
  contract, keep-or-revert variants (scratch-dir vs Karpathy's branch advance/reset), a worked
  approximation example, and the anti-gaming checklist. Loaded on demand.
- `dojo-lint.sh` R9 — checks the tanren reference exists and still carries its safety-critical
  markers (frozen scorer, held-out, budget/stagnation).
- **`evals/run-mechanics.sh`** — fully automated eval that extracts the canonical dojo-check
  template live from `hajime/SKILL.md`, runs it on a fixture repo, and asserts the entire
  proof contract (written-on-green, sha matches output, freshness rule, no rewrite on
  failure). Fails loudly if the canonical template drifts.
- **`evals/scenarios/`** — three agent-replay scenarios (greenfield supervised, brownfield,
  autonomous-ceiling) with assertion scripts checking the resulting artifacts (TASKS.md
  state, dojo-session advancement, RESUME.md, gitignore, proof). Honest split: judgment isn't
  testable, artifacts are.
- **`hajime/reference/dojo-check.ps1`** — PowerShell variant of the canonical dojo-check
  template for Windows-only sessions; bash remains canonical. On-demand reference, zero
  recurring context cost (same pattern as `dojo-principles/reference/ast-grep.md`).
- `dojo-lint.sh` R8 — checks the PowerShell reference exists and still contains the proof
  contract markers.
- **`docs/adr/`** — architecture decision records. Three ADRs ship with this cycle:
  `0001-dojo-check-source-of-truth` (the proof-contract SoT split), `0002-skill-invocation-rule`
  (model- vs user- vs session-invoked), `0003-meta-skill-bridge-not-fork` (the meta-skill is a
  bridge to upstream `writing-great-skills`, not a fork).
- **`TASKS.md`** — the multi-wave plan. Surfaced by the audit-driven randori: 10 waves ordered
  by risk and dependency, each a single verifiable outcome.
- **`dojo-lint.sh` R10** — replaces the retired R6 byte-equality check. Asserts every
  normative surface (dojo-principles, scripts/dojo-check.sh, hajime, DOJO-MANUAL, the
  PowerShell reference) references the same proof-contract identifiers (`check-proof`,
  `output_sha256`, `check-output.log`). Structural equivalence, not byte-equality.
- **Skill-writing vocabulary adopted from `writing-great-skills` (Matt Pocock, MIT).** New
  glossary entries in CONTEXT.md: `leading word`, `branch`, `router skill`, `single source of
  truth`, plus the leading words `_enforce_` and `_proof_`. Bridge, not fork; ADRs cite the
  upstream; the meta-skill (Wave 10) carries the attribution.
- **hajime Gate 0** (§0) — the first response in a session is the rigor and mode questions,
  nothing else; no source exploration, scaffolding, or implementation before they're answered.
  A design document, starting prompt, or file path passed as the argument is *input to the
  process* (it feeds the plan step), never a substitute for running it. Closes the observed
  skip-to-implementation failure.
- **randori: facts vs decisions + end-of-grill confirmation gate.** "Explore before asking"
  upgraded to the leading words *facts are found; decisions are made* (never grill yourself);
  the hand-off now states **do not begin implementation until the human confirms shared
  understanding** — a finished plan is a hand-off, not a starting gun. Same failure family as
  Gate 0, other two doors.
- **kata-commit durable-artifact item 4: CONTEXT.md** — waves that invalidate an existing
  Glossary or Decisions entry must correct it at commit time (kaizen owns new decisions;
  kata-commit owns keeping existing ones true). Closes the staleness class found in this
  repo's own CONTEXT.md.
- **`.gitattributes`** — in-repo LF normalization (`* text=auto`, `*.sh eol=lf`,
  `*.ps1 eol=crlf`); CRLF in a shell shebang is fatal on Linux.
- **`dojo-lint.sh` R12–R14** — R12: every `skill → Section` cross-reference must resolve to a
  real heading in that skill (the eaten-heading class, prose-anchor analog of R4). R13: no CR
  in tracked file content (index-side backstop behind `.gitattributes`). R14: repo scripts must
  be executable in the git index (failure message carries the `git update-index --chmod=+x`
  fix). All three regression-tested by recreating their bug and watching them fail.

### Changed

- **dojo-check template source-of-truth split** (Wave 1 of 10). The proof-contract invariant
  is normative in `dojo-principles → Enforce Over Instruct — the Proof Contract`; per-project
  stack commands live in `scripts/dojo-check.sh`; hajime's inline block and DOJO-MANUAL's
  mirror are illustrative examples that point at the principle. Surfaces can diverge in prose
  so long as they reference the same identifiers (R10 enforces agreement).
- **`dojo-lint.sh` R6 retired.** Byte-equality between hajime's bash block and the manual's
  block is no longer the contract; R10 (structural-equivalence via identifier presence) replaces
  it. The new check matches what the wave's goal actually claims.
- **`dojo-lint.sh` R11** — enforces ADR 0002's three-bucket invocation rule across all 17
  SKILL.md files. Uses a single `R11_CLASSIFY` table as the source of truth (one entry per
  skill, one of `user|session|model`). Future skill additions classify themselves by adding
  one entry to the table — anything else fails the gate at PR time.
- **Skill invocation rule is now enforced** (Wave 2 of 10). Per ADR 0002:
  - 7 user-invoked skills (`randori`, `kaizen`, `kan`, `waza`, `tanren`, `kensha`, `kokai`)
    now carry `disable-model-invocation: true` in their YAML front-matter. Their descriptions
    no longer load every turn (~480 words off the always-on context tax).
  - 3 session-invoked skills (`dojo-principles`, `dojo-project`, `dojo-conduct`) carry a YAML
    rationale comment (`# invocation: session-invoked — see ADR 0002`) above the `name:`
    field. The YAML flag is binary; the comment is what distinguishes them from model-invoked
    to humans reading the front-matter.
  - 7 model-invoked skills (`kata-red`, `kata-green`, `kata-refactor`, `kata-commit`,
    `kata-stuck`, `hajime`, `hajime-bugfix`) unchanged in YAML form — they continue to rely on
    the default model-invocation. The session-invoked rationale comment is what distinguishes
    the three `dojo-*` governance files from the four wave-cycle kata-* files in prose.
- **The trim (TASKS.md Waves 4–10, 2026-08-29):** two skills absorbed into `kata-green`
  (the refactor step and the stuck branch — the cycle is now red → green → commit);
  the algorithm-classification discipline absorbed into `kata-red` (the algorithm check);
  the contribution-review discipline absorbed into `dojo-conduct` ("Reviewing Code");
  the bugfix entry merged into `hajime` as the "feature or bugfix?" fork. ~48
  cross-references rewritten in the same waves as the deletions.
- **Post-trim closeout (2026-08-31):** the governance-load banner deduplicated — one
  banner in `hajime`, assumes-loaded notes in `kaizen`/`kan`/`randori` (the router wave
  was invalidated; the index is not wanted). `kan`'s description claim-cut: "and
  performance regressions" removed — the body never had a perf branch. The surviving-old
  plan closed out: Wave 13 done; Waves 11/12/14/15/16/17 invalidated with reasons in
  TASKS.md. No pending waves remain.
- **kata-commit durable-artifact item 4** now also covers changes commissioned outside a
  running session (chat-scoped plans, hand edits) — the reconciliation duty attaches to
  the commit, not to how the change arrived.
- **Anti-inflation charter** added to `CONTEXT.md → Non-Goals` (conditional non-goals
  guarding against re-inflation: no router past ~7 user-invoked skills, no new skill
  without a surviving failure mode, no capability claim without a body branch, no
  spec-first flow, never cut the XP skeleton for tokens).

### Fixed

- **Wave 1 regression: the Logging section was eaten.** The new proof-contract H2 in
  `dojo-principles` replaced `## Logging — Structured, at the Boundary` instead of preceding
  it — seven logging rules dangled inside the proof-contract section, and hajime §4b's
  `dojo-principles → Logging` cross-reference pointed at nothing. Heading restored; the class
  is now lint-enforced (R12).
- **Uncommitted `.gitignore` CRLF pollution reverted** (editor line-ending conversion). Modern
  git tolerates CR in `.gitignore` patterns, so ignores still worked — but the class is real
  for shell scripts (CRLF shebang fails on Linux). `.gitattributes` added; R13 backstops.
  `graphify-out/` added to `.gitignore` as a regenerable local artifact.
- **Script exec bits.** All repo scripts were committed mode 100644 (Windows
  `core.filemode=false`); Linux/mac clones couldn't run `./scripts/dojo-lint.sh` as
  documented. Flipped to 100755 in the index; R14 enforces from now on. One-time fix on
  existing clones: `git update-index --chmod=+x scripts/*.sh evals/run-mechanics.sh
  evals/scenarios/*.sh`.
- **CONTEXT.md contradiction.** The scaffold-era Content-repo-gate Decision still claimed
  "lint R6 enforces" after ADR 0001 retired R6; the dojo-lint glossary entry still said
  "(R1–R9)". Both corrected to reference the R10 identifier-agreement check and the script as
  the rule-set home.
- **Stale-context closeout (2026-08-31).** CONTEXT.md glossary corrected: the router
  entry now records the invalidation instead of asserting `dojo/SKILL.md` exists; the
  invalidated `_enforce_`/`_proof_`/`_bound_` sigil vocabulary retired from the glossary.
  RESUME.md restored to its one-line spec form (it still announced seven pending waves
  that did not exist). DOJO-MANUAL §3 skill count corrected (14 → 12). HANDOFF Current
  State refreshed; forward-looking wave references unified on TASKS.md numbering.
  ADR 0002 gained a dated invalidation note for the router.

## [1.1.0] — 2026-06-12

A consistency and hardening release driven by a full external audit of v1.0. Skills are now
purely normative (terse rules); rationale lives in DOJO-MANUAL.md. Recurring per-wave context
cost dropped ~36% with no rule removed.

### Fixed

- **The wave loop now has an iterator.** randori writes `TASKS.md` (every wave a verifiable
  outcome with `status: pending|done|invalidated`); kata-commit marks waves done and advances
  the next pending goal into `dojo-session.md`. Previously no skill created the plan or
  advanced `goal:` between waves.
- **dojo-check proof deadlocks.** hajime-bugfix and both manual templates scaffolded scripts
  without the proof artifact that kata-commit hard-gates on. One canonical template now lives
  in hajime §3, mirrored (and lint-verified identical) in manual §5; kata-commit upgrades
  legacy scripts instead of blocking forever.
- **Brownfield adoption.** hajime no longer refuses to start on a non-green baseline: it
  records `pre_existing_failures` (previously bugfix-only), enforces *no new failures*, and
  offers a stabilization wave 0.
- **CONTEXT.md contract contradiction.** Now exactly three sections — Glossary, Non-Goals,
  Decisions — consistently across randori, hajime (log sink), dojo-principles (non-goals),
  dojo-project, and kaizen.
- **dojo-conduct truncation.** The graphify "active treatment" contract is now actually
  written in the governing skill (was a dangling sentence).
- **Description/manual drift:** dojo-conduct's description now advertises the precedence
  hierarchy (and no longer a nonexistent rationale section); manual skill summaries are maps
  with pointers, not mirrored rule lists; "16" skills (was "10"); removed the orphan "issue
  tracker configuration"; "root cause from kan" (was the pre-rename skill name); dead `DEFINE`
  state removed and `STUCK` actually written by kata-stuck; walkthrough 7.1 now shows the real
  refactor-assessment gate; dangling sentence fragments completed.
- **Spec DRY violations:** kata-red's duplicated Algorithm-check section, kata-green's
  duplicated waza trigger, the quick-reference's duplicate `/waza` row, waza's incoherent
  step numbering.
- **Plan-file split-brain:** the secondary plan filename is gone; `TASKS.md` everywhere.

### Changed

- **`mode` split into `mode` (supervised|autonomous) and `rigor` (real|poc)** — orthogonal
  axes; PoC sessions now have defined gating, and kata-refactor gained a PoC branch
  (formatter only).
- **Commit staging is explicit** — never `git add -A`. `git status` review at the gate plus a
  secrets/size denylist; autonomous halts on a hit.
- **`dojo-session.md` is gitignored** (per-machine state); HANDOFF.md is the resume surface.
  hajime scaffolds both ignore entries.
- **Proof freshness is operationally defined** (no edits after the run that wrote it) and the
  canonical template hashes portably (`sha256sum` → `shasum -a 256` fallback; Windows via Git
  Bash/WSL noted).
- **Resume is crash-aware:** dirty-tree mid-flight offers resume vs reset-to-commit;
  interrupted artifact updates after a commit are detected and completed.
- **Preferences store path** is now `~/.config/dojo/preferences.md` (old `kata/` path migrated
  on first read).
- README reframed: a personal system, shared — plus solo-first scope, harness-portability
  honesty, and "why waves instead of a rules file."
- Named third-party UI skills generalized to "whatever specialized UI skill is installed";
  stack/language tooling specifics retained by design.

### Added

- **Gate density** (`full|standard|light`, dojo-conduct): fewer supervised stops, same
  content, with the engagement note suggesting lighter density on reflexive approvals.
- **Configurable wave ceiling** + **RESUME.md**: autonomous runs pause at a clean checkpoint
  with a one-line continuation pointer instead of silently stopping.
- **Non-automatable waves** have a defined path in kata-red (script assertion / golden diff /
  recorded manual verification) — never a wave with no check.
- **Promoted (local)** section in dojo-principles — the consented home for promoted insights,
  preserved across updates.
- **`(provisional)` glossary markers** in randori, challengeable in later sessions.
- **`scripts/dojo-lint.sh`** — enforce-over-instruct applied to Dojo itself: stale-name,
  duplicate-heading, dangling-section, skill-reference, state-enum, and canonical-template
  checks. Run it after editing any skill.
- **`dojo-principles/reference/ast-grep.md`** — pattern syntax and task table, loaded on
  demand instead of every session.
- This CHANGELOG, and a "Cost of the system" section (manual §5b) with measured context
  numbers.

## [1.0.0]

Initial system: the 16 skills, the wave cycle, the manual.
