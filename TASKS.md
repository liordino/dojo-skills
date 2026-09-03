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

## Improvement Backlog

Items the author wants to revisit at some point. Not a plan; not a commitment;
not a `TASKS.md` wave. Promote into a wave via `/kaizen` when the moment is right.

- Landing page (`docs/index.html`) — last regenerated from an external pages
  repo; the source of truth for visuals lives elsewhere. Re-pull as needed.
  **Re-pull conflict (2026-09-03):** the HANDOFF.md artifact card was hand-replaced
  here with the no-snapshot-document note; the upstream pages repo still carries the
  old card. Patch upstream (or expect the re-pull to resurrect it) before the next pull.
- Eval coverage — three scenarios exist (greenfield supervised, brownfield,
  autonomous-ceiling). Coverage is honest (artifact assertions only); expand
  only when a real protocol gap appears, not for its own sake.
- Promote section in `dojo-principles` — none yet. Earned by working sessions,
  not invented.
- Refactor assessment — when a wave ends, the assessment is *brief + one
  decision*. Avoid overproducing ceremony.
- `scripts/dojo-lint.sh` R4 false-positives on ADR filenames — the regex
  `\b(dojo|kata|hajime)-[a-z][a-z-]*[a-z]\b` matches ADR file names like
  `0001-dojo-check-source-of-truth.md` as if they were skill directories.
  Hit during Wave 1's refactor step when `DOJO-MANUAL.md` referenced the
  ADR by full filename. Fix candidates: tighten the regex to require the
  matched token to be an existing directory; or add ADR paths to R4's
  whitelist. Defer — current workaround is to reference ADRs by number
  only ("see ADR 0001 in `docs/adr/`").
- Wave 3 design note (from external review, 2026-07-10) — **resolved 2026-08-31, without
  the router:** the router wave was invalidated; the banner dedup kept the inline
  imperative (one banner in hajime) rather than a pointer chain — the note's warning
  about pointer chains is what the assumes-loaded notes implement.
- Wave 4 counter-proposal (from external review, 2026-07-10) — **resolved 2026-08-29:**
  the sigil tokens were invalidated post-trim; natural phrases stay canonical.
- **"failing check" vs "failing test"** — **resolved 2026-09-03:** census showed the
  normative surfaces (README philosophy, DOJO-MANUAL, kata-red/kata-green) already used
  "failing check"; the five outliers (dojo-conduct ×2, hajime, kan ×2) normalized. Canonical:
  "failing check" — broader than "test" (the RED artifact need not be a test-suite test) and
  it recruits the dojo-check gate concept. Literal test-fixture prose keeps "test".
- HANDOFF surface (2026-09-02) — **resolved in the same wave it was raised:** deleted;
  the backlog moved here. A cold reader orients from README + CONTEXT.md + TASKS.md +
  progress.md + git log (ADR 0004 addendum).
