# TASKS — consent-boundary clarifications after the rule-clarifications close

**Intent:** three follow-ups surfaced by reading the rule-clarifications diff
(f696432): kokai's send rule was defined by analogy to a push rule that just
changed, the push rule is restated on six surfaces, and one principle survived
only in git history. First follow-up plan under the ADR 0006 addendum — new
plan branch, nothing commits directly to `main`.

## Wave 1 — kokai send rule stands alone; push rule single-sourced; scar-tissue principle promoted

status: done (2026-09-21)

- **Kokai send rule** (`kokai/SKILL.md` → the release judgment layer): remove the
  "same boundary as never-push" analogy. The rule stands on its own: the agent
  never sends a release communication on its own initiative; on an explicit
  instruction to send, it states exactly what will be sent (recipients or
  channel, and the full message) and then sends. Channel-agnostic — email, a
  GitHub release, a chat post. The decision is the publish act and stays the
  human's.
- **Push rule single-sourcing.** In the two LOADED surfaces other than
  dojo-conduct, drop the restatement, keep a pointer:
  - `dojo-principles/SKILL.md` → The Integration Line: remove the push sentence;
    add "push" to the lifecycle pointer's list (create, resume, merge, park,
    abandon, harvest → dojo-conduct → The Branching Convention).
  - `hajime/SKILL.md` (plan-complete merge paragraph): reduce the push text to a
    pointer to dojo-conduct → The Branching Convention.
  - dojo-conduct stays the one loaded statement; ADR 0006, DOJO-MANUAL, and
    .dojo/CONTEXT.md are decision record and docs — untouched.
  - R19 gains negative checks: 'branch, commit range, tags' must not appear in
    dojo-principles or hajime. R12 already verifies the pointers resolve — confirm.
- **Promote the scar-tissue principle** to `dojo-principles/SKILL.md` → Promoted
  (local), approved by the human. Scar-tissue-first is the default for
  reversible failures — don't add a rule for a failure you haven't had.
  Irreversible failures are the exception, guarded pre-emptively, because
  waiting for the scar means eating the unrecoverable outcome. Receipts: the
  kata-commit secrets denylist, the published-tag / unrequested-release guards
  in kokai. House style: session type + date, never the project of origin.

Gate: lint + mechanics (R12 and R19 included). Merge at plan close. Do not push.
## Plan — restore determinize; guard Promoted (local); pointer hygiene

**Intent:** the scar-tissue promotion (883a17f) replaced the determinize entry
instead of appending after it — Promoted (local) is append-only and must be
guarded against silent removals; three pointer/provenance leftovers from the
same plan get fixed. New plan branch per the ADR 0006 addendum; nothing
commits directly to main.

### Wave 1 — restore the determinize principle; lint-guard Promoted (local)

- Restore the "Determinize what has a stable right answer" entry verbatim from
  f696432 (git show f696432:dojo-principles/SKILL.md), with the scar-tissue
  entry after it. Promoted (local) is append-only.
- New lint rule R21: the number of entries in dojo-principles → Promoted
  (local) (bullets opening `- **`) must never be lower than at HEAD. Edits to
  an entry pass; removals fail. Prove red-first by seeding the removal of an
  existing entry, running lint, confirming R21 fails, then restoring.
- status: done (2026-09-21)

### Wave 2 — pointer hygiene and provenance correction

- hajime: replace "Pushing — including a post-merge push — is the human's"
  with the bare pointer "Pushing, including after a merge: dojo-conduct → The
  Branching Convention." — a pointer carries no claim, so a paraphrase cannot
  drift against the rule it points at.
- kokai: the bold lead-in "the human sends it" contradicts the paragraph under
  it (the agent never sends on own initiative; sends only on explicit
  instruction, stating what and to whom first). Reword the lead-in so it and
  the body agree.
- Provenance: the scar-tissue entry cites the rule-clarifications session; the
  reasoning originated in the release-entrypoint session (closed 2026-09-21,
  merged 340ac44). Correct the citation.
- status: done (2026-09-21)

## Plan — R21 from count to identity; R12 wrapped-pointer fix

**Intent:** R21 cannot catch the replacement that motivated it (6 entries
before, 6 after — the count is unchanged). Upgrade R21 to title identity and
fix R12's per-line pointer matching through one shared wrapped-line helper.
New plan branch per the ADR 0006 addendum.

### Wave 1 — identity guard + shared join helper, proven against the actual failures

- Shared helper: join soft-wrapped lines within a bullet/paragraph (each
  `- ` bullet starts a logical line, continuations append with a space).
- R21: every entry title (bold lead of each joined `- **` bullet) in
  dojo-principles → Promoted (local) at HEAD must still be present in the
  working tree; additions and body edits pass; a removed or retitled entry
  fails, naming the missing title.
- R12: extract `skill → Section` from joined content, not per line.
- Supersession norm in the Promoted (local) intro: entries are never removed
  or retitled; a replacement keeps the old entry, annotates its body
  "superseded by <new title> (date)", and adds the new one.
- Red-first against the ACTUAL failures: seed the replacement exactly as it
  happened and show count-based R21 passes it (the hole), then fail after the
  upgrade; seed a body-only edit and confirm it passes; wrap a pointer
  mid-section-name and rename its target heading, show R12 currently passes,
  then fails after the fix.
- status: done (2026-09-21)

## Plan — R21 exact-title comparison; join_wrapped paragraph boundaries; group-by-mechanism promotion

**Intent:** two defects in the r21-identity work (de1c2af) — R21 checks HEAD titles
as substrings of the whole joined tree section (asymmetric: false passes on a
removed entry quoted in another's body, and on a retitle that extends the old
title), and join_wrapped joins across blank lines and headings despite its
"bullets/paragraphs" contract. Then an approved promotion. Fix R21 before
promoting, so the new entry lands under a correct guard. New plan branch per
the ADR 0006 addendum; nothing commits directly to main.

### Wave 1 — R21 symmetric exact-line comparison

- Fix: run r21_titles on both sides and compare exact lines (grep -Fx), not
  substring of the joined section.
- Red-first: seed (a) an entry removed while another entry's body quotes its
  title — current rule passes it; seed (b) a retitle that extends the old
  title ("X" → "X, refined") — current rule passes it. After the fix both
  seeds fail. The actual-incident seed (clean replacement) keeps failing.
- status: pending

### Wave 2 — join_wrapped: blank lines and headings start a new logical line

- The comment and findings entry say "bullets/paragraphs"; the code does
  bullets only. Make blank lines and headings start a new logical line.
- Red seed: a pointer at the end of a line with no punctuation, followed by a
  new paragraph — R12 must capture only the pointer's own section name.
- Re-run the existing R12 and R21 seeds to confirm nothing regressed.
- status: pending

### Wave 3 — promote "group failures by mechanism, not by symptom"

- Append to dojo-principles → Promoted (local), human-approved wording;
  house style (session type + date); receipts name the four instances.
- Correct the R21 finding's "first occurrence" label in .dojo/findings.md to
  point at the family.
- status: pending

### Wave 4 — scan .dojo/findings.md for other recurring families never promoted

- Report-only: surface families with their instances; no promotion without
  explicit consent.
- status: pending

Gate: dojo-check green each wave. Merge at plan close. Do not push.
