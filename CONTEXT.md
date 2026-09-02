# Context — dojo-skills

## Glossary

- **dojo-skills** — this repository. The Dojo development system packaged as a set of
  installable agent skills (`dojo-*`, `kata-*`, and bare-named techniques), plus the manual,
  README, changelog, landing page, and dev-time tooling (`dojo-lint.sh`, `evals/`).
- **skill** — a directory containing a `SKILL.md` file (the load-on-trigger contract), plus
  optional `reference/` and `examples/` subdirectories. The agent loads `SKILL.md` at the
  named trigger; references are loaded on demand for zero recurring context cost.
- **wave** — one verifiable outcome in `TASKS.md`; one trip through the
  red → green → commit kata (refactor inline in green; the DEFINE phase —
  hajime/randori/kan planning — precedes step one).
- **dojo-check** — the canonical gate script. Always produces `.dojo/check-proof` as
  evidence; `kata-commit` hard-gates on it. *Source-of-truth split (see Decisions):* the
  proof-contract invariant (what `.dojo/check-proof` must contain) is normative in
  `dojo-principles`; the three stack commands are per-project in `scripts/dojo-check.sh`;
  `hajime/SKILL.md`'s inline block is illustrative.
- **dojo-lint** — `scripts/dojo-lint.sh`; static internal-consistency checker for this
  package. The numbered R-rule set lives in the script itself (retired numbers are not
  reused). Dev-time tooling, not a wave gate.
- **eval** — automated scenario under `evals/`; deterministic, no agent required. Honest
  split: judgment isn't testable, artifacts are.
- **author / package owner** — the human who develops Dojo on their own harness and
  publishes it; the implicit audience for any change here is also *future* agents that
  will install and use the skill set.
- **leading word** — a compact, pretrained concept (often a kanji name) that an agent
  reasons with while running a skill. Repeated through a skill's body, it accumulates a
  distributed definition and anchors behaviour in fewest tokens by recruiting priors
  the model already holds. Source: Matt Pocock's `writing-great-skills` (MIT).
- **branch** — a distinct way a skill is invoked; different runs taking different paths
  through it. Each branch earns its own trigger phrase in the description; collapsing
  synonyms to one branch keeps context load honest. Source: same.
- **router skill** — (Pocock vocabulary) a user-invoked skill whose body is an index of
  other skills by name and trigger, for when user-invoked skills pile up past what the
  human can remember. Dojo deliberately has none: the router wave was invalidated
  (2026-08-31) — five user-invoked skills are within human memory, and the
  governance-banner dedup was done inline instead. See Non-Goals (anti-inflation charter).
- **single source of truth (SoT)** — for any given meaning, one authoritative place;
  changing behaviour is a one-place edit. Where a meaning must appear in multiple
  places, the secondary sites are pointers and (where possible) lint-enforced
  equivalences. Source: same.
- **enforce-over-instruct** — when a rule can be enforced by a script (a hook, a generated
  artifact, a state check), prefer that to prompting. Dojo's mechanisms for it: lint
  R1–R14, the dojo-check proof artifact, the freshness rule in kata-commit.
- **proof artifact** — the `.dojo/check-proof` file (sha256'd pass/fail with
  `ts`/`exit`/`output_sha256`) written by a green run; the concrete evidence that gates
  a commit. "Tests passed" is prose; the proof is evidence.
- **non-goal** — a deliberate, recorded boundary. Items in `## Non-Goals` bind every
  future session and autonomous run; crossing the line is a scope change handled by
  `/kaizen` with an ADR. The noun is the artefact the project edits.
- **session-invoked** — a skill pre-loaded at session start (the three `dojo-*` files),
  neither model-invoked (the agent reaches it from prose matching) nor user-invoked
  (the human types the name). The YAML flag is binary; these stay model-invoked for
  mechanical reasons, but the *reasoning* belongs in the ADR for the invocation rule.

## Non-Goals

- **Not a general-purpose agent framework.** Dojo is opinionated and specific to one human's
  workflow. Other harnesses / stacks are tolerated where they don't add cost, but Dojo will
  not grow to be "framework-agnostic" or "stack-agnostic" for its own sake.
- **Not a teaching platform.** The skill files are terse rules (rationale in `DOJO-MANUAL.md`).
  No tutorials, no exhaustive prose.
- **Not a curated marketplace.** We don't take contributions lightly; quality and cohesion
  of the system outweigh adding skills. New techniques require a clear gap (decision in
  randori, not bolt-on).
- **Not a substitute for the user's own judgment.** Gates ask for a decision with content,
  not assent. Dojo never silently rubber-stamps.
- **Not testing "AI judgment" via evals.** The evals test *artifacts* and *deterministic
  protocol guarantees* — never whether the agent made a "good" decision.
- **The wave cycle is settled.** The red → green → commit loop (refactor inline in
  green), gate density, and the meaning of the proof artifact are not re-litigated by
  ordinary waves; none may redefine them. Cross this line only via `/kaizen` with an ADR.
- **Anti-inflation charter (2026-08-31 review; binding on future sessions and autonomous
  runs):**
  - No router skill — until user-invoked skills exceed ~7 (ADR 0002's own threshold) or
    prove unfindable without one. Crossing: `/kaizen` with an ADR.
  - No new skill — unless a documented failure mode survives every existing technique.
  - No capability claim in a description without a matching body branch — the fix is
    cutting the claim (kan, 2026-08-31), never growing a body to match stale marketing.
  - No spec-first flow — TASKS.md waves stay verifiable outcomes; a finished plan is a
    hand-off, not a starting gun.
  - Never cut red-first, proof+freshness, stuck-at-two, divergence halts, or the
    engagement note for token savings — trim prose, never rules.

## Decisions

- **Log sink.** `n/a` — this package ships no application code; it produces
  skill/markdown/HTML artifacts and runs lint + mechanics-eval scripts, none of which
  emit application log events. LogSink does not apply at this level. (If a future
  in-repo tool emits structured logs, choose then; default would be JSONL file.)
- **Package distribution.** Skill directories copied verbatim into the user's agent
  skills folder via `npx skills add <url>`. The `Promoted (local)` section in
  `dojo-principles` is the only file the user is expected to preserve across updates
  (preserved across updates by re-applying it after `npx skills add`, or by keeping it
  in a fork).
- **Documentation split.** Skill files = terse rules only (DOJO-MANUAL holds rationale);
  README = problem-first; CHANGELOG = Keep a Changelog format; CONTEXT.md = exactly
  Glossary/Non-Goals/Decisions; ADRs in `docs/adr/` for non-obvious decisions.
- **Content-repo gate.** `dojo-check` for this repo composes `dojo-lint` (static) +
  `evals/run-mechanics.sh` (proof-contract behavior). No fabricated compile/test step;
  the proof-contract invariant from `dojo-principles` is preserved (lint R10 verifies
  identifier agreement across all surfaces — see the dojo-check source-of-truth split
  decision below and ADR 0001).
- **Mode / rigor default for sessions in this repo.** `real` / `supervised` /
  `gate_density: standard` (declared by the human at hajime start; recorded in
  `dojo-session.md` per wave). Plan-less by design: features are added via `/kaizen`
  as needs emerge, not via a pre-baked `TASKS.md`.
- **Commit style.** `conventional` (declared by the human at hajime start; recorded in
  `dojo-session.md` per wave).
- **Wave ceiling default.** 4 (per dojo-project preference default; recorded in
  `dojo-session.md` per wave).
- **dojo-check source-of-truth split.** Three sources today, each normative for a
  distinct layer: the **proof-contract invariant** (what `.dojo/check-proof` must
  contain) lives in `dojo-principles`; the **three stack commands** live in the
  per-project `scripts/dojo-check.sh`; the inline bash block in `hajime/SKILL.md` is
  **illustrative**, not normative. `DOJO-MANUAL.md` mirrors the illustrative block for
  human readers and references `dojo-principles` for the contract. Lint R6 (byte-equality
  enforcement) is retired and replaced by an R that verifies each surface references the
  same proof-contract identifiers. ADR: `docs/adr/0001-dojo-check-source-of-truth.md`.
- **Skill invocation rule.** Model-invoked (default; YAML `disable-model-invocation`
  absent) when the agent reaches the skill from prose matching. User-invoked (`true`)
  when the skill is reached by the human typing its name. `dojo-*` governance files are
  *session-invoked* — pre-loaded at session start, neither; the binary flag keeps them
  model-invoked for mechanical reasons. Per-skill rationale lives in the YAML
  front-matter. ADR: `docs/adr/0002-skill-invocation-rule.md`.
- **Meta-skill as bridge, not fork.** `dojo-write-skill/SKILL.md` is a Dojo-native
  bridge to upstream `writing-great-skills` (MIT). It imports the upstream's vocabulary
  (leading word, branch, router skill, single source of truth) but restates none of its
  content; the upstream remains canonical for skill-writing knowledge. Attribution at
  the top of the file. Completion criterion: the skill passes its own checklist. ADR:
  `docs/adr/0003-meta-skill-bridge-not-fork.md`.
- **Skill-writing vocabulary is now part of the project's domain language.** Adopted
  from `writing-great-skills` (MIT) at the randori that produced `TASKS.md`. New glossary
  entries above; reversion is via `/kaizen` with an ADR if a wave finds a term doesn't
  earn its place.
