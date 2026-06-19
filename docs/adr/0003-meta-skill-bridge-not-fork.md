# ADR 0003 — Meta-skill as bridge, not fork

- **Status:** accepted
- **Date:** 2026-06-19
- **Context:** the randori that produced `TASKS.md` (skill-quality pass)

## Context

A quality pass on the existing Dojo skills, graded against Matt Pocock's
`writing-great-skills` (MIT), produced ten findings. Several findings required
importing the upstream's vocabulary (leading word, branch, router skill, single
source of truth) into Dojo's domain language so that future skill authors in
this repo have Dojo-native terms to reason with. Without the bridge, the
vocabulary lives only in this randori and each future wave re-decides whether
to use it.

The natural temptation is to copy or fork the upstream's content into a
Dojo-flavoured skill so Dojo authors have a self-contained reference. That
makes Dojo a downstream fork of the upstream's content; the moment the upstream
changes a definition, the fork goes stale. Dojo's design posture — "personal
system, shared" plus the `Promoted (local)` discipline in `dojo-principles` —
argues against becoming a fork of someone else's content.

## Decision

`dojo-write-skill/SKILL.md` is a **bridge**, not a fork:

- **Imports the upstream's vocabulary** into Dojo's glossary (leading word,
  branch, router skill, single source of truth) and uses those terms in Dojo
  prose.
- **Does not restate the upstream's content**. The bulk of skill-writing
  knowledge — the information hierarchy, the no-op test, the failure modes in
  full, the leading-word hunt in detail — stays upstream. The meta-skill
  points at the upstream by path and attribution.
- **Carries only the parts that are Dojo-specific**: how the kanji leading-word
  scheme interacts with the upstream's leading-word concept; how
  `CONTEXT.md → Glossary` plays into the information-hierarchy decision; how
  `scripts/dojo-lint.sh` enforces what the upstream only describes; how the
  Dojo-internal `disable-model-invocation` rule (ADR 0002) maps onto the
  upstream's invocation trade.
- **Attribution at the top of the file**: the meta-skill is short (~250
  words), opens with a clear statement that the vocabulary, failure modes,
  and leading-word framework come from upstream, and links to the upstream.
- **Completion criterion**: the skill passes its own checklist — i.e. a
  reader using the meta-skill to write a new Dojo skill produces a skill
  that is consistent with `dojo-lint.sh`'s R-rules and that uses the adopted
  vocabulary correctly.

## Consequences

- The meta-skill stays small (~250 words) and ages well. When the upstream's
  vocabulary shifts, the bridge adapts; when a Dojo-specific concept changes,
  the bridge updates without touching the upstream.
- Dojo authors reach the meta-skill via `/dojo-write-skill` (user-invoked,
  per ADR 0002) and follow its bridge to the upstream when they need the full
  framework.
- A future divergence — Dojo using a leading word that means something
  subtly different from the upstream — is a real risk. The fix is an ADR
  that names the divergence and the resolution; silent divergence is
  explicitly forbidden by the meta-skill's design.
- The upstream gets credit in the meta-skill body (not just in README
  credits), which keeps the bridge relationship honest and discoverable.

## Alternatives considered

- **Re-author with attribution** (`dojo-write-skill/SKILL.md` restates the
  upstream's content in Dojo's voice, attributing each major claim).
  Rejected because it commits Dojo to keeping a fork in sync; the upstream
  will evolve and the fork will go stale or Dojo will fork off into a
  different vocabulary.
- **Fork-and-adapt the minimum viable subset** (`dojo-write-skill/SKILL.md`
  restates only the parts Dojo actually exercises). Rejected for the same
  reason as re-author-with-attribution — once a fork exists, it carries
  maintenance debt.
- **No meta-skill; the glossary terms alone carry the bridge.** Rejected
  because the meta-skill's value is as a *named entry point* the author
  reaches for when writing a new skill, not as a passive vocabulary.
  Vocabulary that isn't reachable won't be used.
