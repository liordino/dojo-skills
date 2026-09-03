# Tasks — dojo-skills

intent: TASKS is the open-wave surface only. Per ADR 0004, `progress.md` is the single
per-wave log — closed waves live there (with their verification prose and commit hashes),
not here. Each line below is a tombstone: what the wave was and how it resolved. There are
no pending waves; new work starts a new plan section.

## Tombstone ledger

- **Trim waves 3–10 (17 skills → 12)** — done 2026-08-29: hajime Gate 0 + review gates;
  refactor/stuck, algorithm-classification, contribution-review absorbed into kata-green /
  kata-red / dojo-conduct; bugfix merged into hajime's "feature or bugfix?" fork; kokai
  stubbed; tanren slimmed; randori gained the glossary pin-the-exclusion rule. Outcome and
  per-wave hashes: progress.md; commits fa5fcee…b4a9fac.
- **Wave 11 — dojo router** — invalidated 2026-08-31: index not wanted; governance-load
  dedup landed inline (one banner in hajime, assumes-loaded notes elsewhere). Commit 9f33b18.
- **Wave 12 — `_enforce_`/`_proof_` sigils** — invalidated 2026-08-29: contradicts the
  glossary's own definition of a leading word (recruits priors the model already holds —
  sigils have none). Natural phrases stay canonical.
- **Wave 13 — kan description perf claim** — done 2026-08-31: pure claim-cut; the
  description dropped the promise, no body branch added (kan doesn't do performance work).
  Commit ebfe42b.
- **Wave 14 — dojo-* cross-ref sentence removal** — invalidated 2026-08-31: premise stale;
  cross-refs live only in descriptions where they route correctly. Commit ebfe42b.
- **Wave 15 — per-H2 rationale footers** — invalidated 2026-08-29: fails the deletion test
  (~14 always-loaded lines whose only consumer is the human who owns the manual).
- **Wave 16 — dojo-diagnose** — invalidated 2026-08-29: a new skill right after cutting
  five; a checklist reached for ~never. Fails "would I remember to invoke this?".
- **Wave 17 — dojo-write-skill bridge** — invalidated 2026-08-29: permanent dependency-
  bridge to external `writing-great-skills` — the external-source-chasing deliberately
  ended this session.

## Open waves

None. New work starts here as a new plan section with the same per-wave shape:
self-contained waves, lint green at every step, no dangling pointers, byte-negative
preferred.
