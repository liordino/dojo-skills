# ADR 0002 — Skill invocation rule (model-invoked vs user-invoked vs session-invoked)

- **Status:** accepted
- **Date:** 2026-06-19
- **Context:** the randori that produced `TASKS.md` (skill-quality pass)

## Context

Every skill in this repo currently has `disable-model-invocation` *absent* in its
YAML front-matter — i.e. all 17 skills are model-invoked. That means every skill's
`description` field sits in the agent's context window every turn, costing ~73
words per skill on average (per the audit, ~1,170 words of always-on tax across the
package).

Matt Pocock's `writing-great-skills` (MIT) names the trade sharply: model-invoked
skills pay context load; user-invoked skills pay cognitive load (the human is the
index that must remember the skill exists). The two loads trade off; piling up
user-invoked skills past what the human can remember is cured by a router skill.

Today we have neither side of the trade optimized. The descriptions carry content
that the agent will rarely auto-trigger from prose (e.g. `kensha`'s "review this PR"
trigger is one a human types, not one an agent reasons to on its own), but we pay
the context cost as if the agent were going to fire them from prose.

## Decision

A three-bucket rule, applied per skill:

1. **Model-invoked** (`disable-model-invocation` absent) — the agent reaches the
   skill from prose matching its description. Used when the agent is likely to
   reach for the skill without explicit user instruction. In Dojo today:
   `kata-red`, `kata-green`, `kata-commit`, `hajime`, `hajime-bugfix`. The wave
   cycle fires these automatically; the session-start entries must be reachable
   when the user says "let's start." (Trim Wave 5 / 2026-08-29: `kata-refactor`
   and `kata-stuck` were absorbed into `kata-green`; they no longer exist as
   separate model-invoked skills.)

2. **User-invoked** (`disable-model-invocation: true`) — the human types the
   name; the agent does not reach the skill on its own. Used for periodic,
   named-technique skills that fire from explicit user instruction. In Dojo
   today: `randori`, `kaizen`, `kan`, `tanren`, `kensha`, `kokai`. The
   router skill (`dojo/SKILL.md`) carries the indexing that lets the agent find
   these when relevant without paying the per-skill context cost. (Trim
   Wave 6 / 2026-08-29: the algorithm-classification discipline was absorbed into
   kata-red; the previously-named `waza` no longer exists as a separate skill.)

3. **Session-invoked** (pre-loaded at session start, neither model- nor
   user-invoked in the strict sense) — the three `dojo-*` governance files
   (`dojo-principles`, `dojo-project`, `dojo-conduct`) are loaded every session
   by hajime's and the kata skills' explicit "Before anything else…" directive.
   The YAML flag is binary; these stay **model-invoked** for mechanical reasons
   (no third flag exists), but the *reasoning* for keeping them model-invoked
   despite the typical rule is that they're loaded every session regardless. A
   future Dojo proposal could add a third flag; until then, this category is
   noted in the per-skill rationale.

**Per-skill rationale** lives in the YAML front-matter as a short comment
above the `name:` field, or — if too long for a comment — in a one-paragraph
note in the skill body's first section. The rule, not the per-skill decision,
is what this ADR records; per-skill choices are kata-commit material.

The router skill (`dojo/SKILL.md`) carries the table of all skills with
invocation type and trigger phrases, so an agent that needs to find a
user-invoked skill can do so without that skill's description paying the
always-on cost.

## Consequences

- Roughly 480 words off the always-on context tax (the named-technique and
  periodic skills flipped to user-invoked).
- New skills added in the future get an explicit invocation decision at
  randori / kaizen time, not by default.
- The `dojo-*` session-invoked category is an honest naming of a real
  situation that the binary YAML flag can't express; future harness support
  for a third flag would let us model it directly.
- User-invoked skills pile-up is bounded by the router skill — when more than
  ~10 user-invoked skills exist, the cognitive-load cure kicks in. We are
  currently at 7 user-invoked skills post-Wave 2; comfortable headroom.

## Alternatives considered

- **Flip only `kensha` and `kokai` (the obviously-safe two).** Rejected
  because the rule that distinguishes them from the other 5 user-invoked
  candidates wasn't articulated; doing the flip without the rule means a
  future maintainer has to re-derive the rule from per-skill history.
- **Flip all skills to user-invoked except hajime/kata-* and rely on a
  router.**Rejected because the kata-* skills genuinely do need the agent
  to reach them automatically — the wave cycle's "next step" depends on it.
  Without model-invocation on the kata skills, the agent doesn't know to
  advance from GREEN to REFACTOR.
- **Add a third YAML flag for session-invoked.** Rejected as out of scope
  (the flag would be harness-specific, not a Dojo decision). Noted as a
  future proposal; not blocking this ADR.
