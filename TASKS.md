# Tasks — dojo-skills

intent: cut Dojo to the smallest set of things you consciously choose (the *trim* plan), then run the surviving additive waves from the predecessor writing-great-skills plan on the trimmed surface. Absorb auto-fired fragments into their real point of use; stub skills the model already knows; delete duplicated scaffolding. Conscious surface drops from 17 skills to 12; the kata cycle collapses from four steps to three (red → green → commit); six additive waves bring the package to router + leading-word collapse + kan description cleanup + dojo-* cross-ref cleanup + per-H2 rationale footers + diagnose + meta-skill on the trimmed surface.

## Wave 3 — Wave-2 review fixes + housekeeping

status: done
Closed the loop on the Wave-2 commit (4168c6e): the durable-artifact updates and the external-review fixes sat uncommitted for ~7 weeks. Landed hajime Gate 0, randori facts-vs-decisions + end-of-grill confirmation gate, kata-commit durable-artifact item 4 (CONTEXT.md), lint R12–R14, exec-bit index flip for 6 scripts (`git update-index --chmod=+x`), the `## Logging — Structured, at the Boundary` heading restoration in dojo-principles, and a repair to R13's grep form (the original `crlf=$(git grep ... $'\r' ...)` was broken on Git Bash — command substitution mangles output when the search pattern is CR). Tree is clean and `dojo-check` is green. Verified by: `bash scripts/dojo-check.sh` passes with fresh `.dojo/check-proof`; `git status --porcelain` shows only the untracked `docs/proposals/` (the trim plan's drafts); commit `fa5fcee`.

---

## Trim plan (active) — 17 skills → 12

Runnable wave plan for the Akita-inspired trim. Each wave leaves the lint gate green and the deleted-skill names absent from actively-followed prose (CHANGELOG and dated ADR/history notes are exempt) — that's the non-negotiable check on each.

**The hard constraint that dictates ordering:** four files get deleted (the algorithm-classification absorbed, the contribution-review absorbed, and the two absorbed into kata-green by Wave 5) and one merged (`hajime-bugfix`). References to them live in ~15 places (other skills, `dojo-lint.sh` R11/R12, ADR 0002, evals, README, HANDOFF, DOJO-MANUAL). **Every reference must be rewritten before its target is deleted, or lint fails mid-trim.** Each wave below is self-contained: it moves the surviving content, rewrites the references, updates lint/docs, and verifies green — no wave leaves a dangling pointer.

**Ordering rationale:** absorptions before deletions; lint-table + ADR + doc updates *in the same wave* as the deletion that necessitates them, never after.

## Wave 4 — absorb the refactor + stuck behaviour into kata-green

status: done
The two skills that only ever fire *from* kata-green became sections inside it. The cleanup checklist (SRP, names, DRY, formatter, provenance, UI pass) and its "no new behavior" guard folded into kata-green as a Refactor step; the two-attempt diagnostic + adjusted-approach options folded in as green's Stuck branch (triggered at `attempts == 2`). The cycle is now red → green → commit. The directories were deleted; references in kata-green / kata-commit / hajime / kan / tanren / evals / scripts/dojo-lint.sh (R11_CLASSIFY + R12_SKILLS) / ADR 0002 / README / DOJO-MANUAL / HANDOFF were rewritten. Verified by: deleted-skill names absent from actively-followed prose (the gate regex is clean outside CHANGELOG and the dated ADR note); lint R1–R14 + mechanics 12/12 pass. Skill count 17 → 15.

## Wave 5 — absorb the algorithm-classification discipline into kata-red

status: done
blocked-by: 4
The 6.6k of Mode A/B/C classification taxonomy was cut. The surviving discipline — *when
the approach matters, write the property-based test first; hand to tanren only if a scalar
metric exists* — moved into kata-red's existing algorithm-check section (now titled
"Algorithm check (when the approach matters)"), which already fires at the right moment.
The test-first artifact rule (property tests / tolerance+golden) is part of the same
section, structured as a ladder under each of the three moves (Recognize / Derive /
Approximate). The directory was deleted; references in kata-red / kata-green / tanren /
dojo-conduct (one mention) / ADR 0002 (dated absorption note) / README / DOJO-MANUAL /
HANDOFF were rewritten. Verified by: the gate name is absent from actively-followed prose
(CHANGELOG and the dated ADR note are exempt); lint R1–R14 + mechanics 12/12 pass. Skill
count 15 → 14.

## Wave 6 — absorb the contribution-review discipline into dojo-conduct

status: done
blocked-by: 5
The transferable core — *don't trust the PR description, read the diff; run the gate
(necessary, not sufficient)* — became a short principle in dojo-conduct ("Reviewing Code —
Read the Diff, Not the Description"). The rest of the prior skill (the review checklist) was
dojo-principles violations the model already checks. The directory was deleted; references
in kokai (pointing to the review principle in dojo-conduct), `scripts/dojo-lint.sh`
R11_CLASSIFY (dropping the user-invoked entry) and R12_SKILLS, ADR 0002 (dated absorption
note in the user-invoked enumeration), README, DOJO-MANUAL, HANDOFF Improvement Backlog —
all rewritten. Verified by: dojo-conduct carries the read-the-diff review principle; the
absorbed skill's name is absent from actively-followed prose (CHANGELOG and the dated ADR
note are exempt); lint R1–R14 + mechanics 12/12 pass. Skill count 14 → 13.

## Wave 7 — merge the bugfix entry into hajime as a "feature or bugfix?" fork

status: done
blocked-by: 6
The bugfix skill was ~70% back-references to hajime (§1 "identical", §3 "same items", §4
"options in /hajime §4"). It was folded into hajime as a fork: after rigor and mode, a
"feature or bugfix?" question routes bugfix sessions to `/kan` for diagnosis and sets the
regression-shaped wave goal ("[Bug] no longer occurs. Proven by a regression test that
fails now and passes after the fix."). One conscious entry point instead of two
(feature-vs-bugfix is a parameter, not a different door). The directory was deleted;
references in hajime (added bugfix fork, kan invocation, regression goal shape, `type:
bugfix` session fields), kata-red (description updated — bugfix now lives in the same skill),
kan (frontmatter "from hajime's bugfix fork"), `scripts/dojo-lint.sh` R11_CLASSIFY (dropped
the merged model-invoked entry) and R12_SKILLS (dropped the merged entry), ADR 0002 (dated
absorption note in the model-invoked enumeration), README (install line + skills table),
DOJO-MANUAL (the skills diagram, supporting-skills table, skill list, hajime entry, kan
entry, kan integration, two example sessions, invocation cheat sheet, session-flow diagram),
HANDOFF architecture tree — all rewritten. Verified by:
`/hajime` handles both feature and bugfix; the regression-test-first discipline survives in
the bugfix branch; the absorbed skill's name is absent from actively-followed prose
(CHANGELOG and the dated ADR note are exempt); lint R1–R14 + mechanics 12/12 pass. Skill
count 13 → 12.

## Wave 8 — stub kokai

status: done  # completed in code (git); status flag corrected post-run
Cut kokai from 5.5k to a thin standalone: keep only the Dojo-specific bits the model won't reconstitute on its own — problem-first README, build-once-repackage-many, CI-mirrors-dojo-check, the bin/deploy contract name — and drop the generic release-engineering playbook (install channels, signing specifics, changelog mechanics) the model already knows. Stays user-invoked (`/kokai`), just thin. No deletion, no dangling references (kokai keeps its name and trigger). Rewrite: the contribution-review cross-ref already handled in Wave 6. Verified by: kokai/SKILL.md carries the four Dojo-specific principles + a pointer, under ~1.5k; `/kokai` still invocable; lint + mechanics green. Count unchanged (12).

## Wave 9 — slim tanren

status: done  # completed in code (git); status flag corrected post-run
tanren's 9.5k SKILL.md duplicates mechanics already in `tanren/reference/tanren-loop.md`. Shrink the skill to the entry gate (the three refuse-unless conditions), the freeze-the-scorer/held-out-cases anti-gaming rule, and the hand-back-to-kata invariant — everything else points to the reference. The discipline (which the model won't self-supply) stays; the mechanics move behind the existing pointer. No deletion. Rewrite of the algorithm-classification reference already handled in Wave 5. Verified by: tanren/SKILL.md under ~4k, carries entry gate + freeze rule + ratify invariant; the reference file still holds the loop mechanics; lint R9 (tanren reference markers) still passes; lint + mechanics green.

## Wave 10 — randori: pin what a term ISN'T

status: done  # completed in code (git); status flag corrected post-run
Add the conceptual-exclusion rule to randori's CONTEXT.md/Glossary handling: pin what each term explicitly *excludes* or is-confused-with, not only what it means ("when we say X we do not mean Y" — e.g. "score" in music ≠ a test grade). This is a Glossary concern, distinct from Non-Goals (scope). Sharpens the highest-leverage output. No deletion, no reference changes. Verified by: randori's CONTEXT.md section states the pin-the-exclusion rule for Glossary terms; lint + mechanics green.

### What the trim plan does NOT touch (deliberately)

- **The red/green/commit spine, kaizen, kan, the trio** — kept as-is (kan may gain one line noting it's reachable from green's stuck branch; that's in Wave 4).
- **Within-file diets flagged but not done here** — the ECS block and log-sink detail in the trio, noted for a possible later round.
- **The constraints/effect-last/ergonomics proposal** — separate plan, separate runs. Trim first (smaller surface to add into), then that.
- **fable-judge self-verification** — still Part C of the other proposal; Wave 6 notes it may subsume the contribution-review stub, but it is not built here.

---

## Surviving-old plan — 7 waves on the trimmed surface

Waves from the predecessor writing-great-skills plan that are not superseded by the trim. They run after the trim completes (Wave 11 onward). All additive; no deletions; references to trim-deleted skills are inert by then.

>> Re-judgment note (2026-08-29, post-trim): the surviving-old waves 11–17 were
>> reviewed against the trimmed surface and the Akita "smallest conscious surface"
>> principle. **Pending (worth doing):** 11 router (stronger post-trim — the
>> cognitive-load cure now that only ~5 skills are user-invoked), 13 kan desc
>> cleanup, 14 cross-ref removal (both trimming). **Invalidated (re-inflation):**
>> 12 sigils, 15 rationale footers, 16 dojo-diagnose, 17 dojo-write-skill — reasons
>> inline. Do not autonomously execute invalidated waves.

## Wave 11 — `dojo/SKILL.md` router ships and the 9-site banner duplication is retired

status: pending
blocked-by: 10
The router skill exists at `dojo/SKILL.md`, user-invoked (per ADR 0002), carrying (a) a table of all skills with invocation type and one-line trigger phrase, (b) the session-start governance directive as its only procedural content (load `dojo-principles`, `dojo-project`, `dojo-conduct`), and (c) a one-line pointer to itself wherever an agent needs the index. The skills that currently carry the "Before anything else…" banner inline lose the inline banner and replace it with a one-line pointer to the router. Verified by: `rg "Before anything else: load and apply"` returns zero hits outside `dojo/SKILL.md`; the router's table covers all skills; the lint from prior waves still passes.

## Wave 12 — `_enforce_` and `_proof_` become leading words across the package

status: invalidated  # re-judged post-trim 2026-08-29: contradicts the glossary's own definition of a leading word (recruits priors the model already holds — sigils have none). Natural phrases stay canonical.
blocked-by: 11
The English phrases "enforce over instruct", "proof artifact", "fresh proof", "proof contract" are retired from prose and replaced by the leading words `_enforce_` and `_proof_`. Each leading word's definition lives once, in the relevant glossary entry in `CONTEXT.md`. `_non-goal_` keeps its noun form; the leading word for the *behaviour* (currently `_bound_` provisional) is picked during the wave and recorded in CONTEXT.md. Verified by: `rg -i "enforce.over.instruct|fresh proof|proof artifact"` returns zero hits outside the glossary entries and the ADRs that define them; `rg "_enforce_|_proof_"` returns hits across the skills where the phrases used to be; the lint rules from prior waves still pass.

**Counter-proposal noted in HANDOFF Improvement Backlog:** the sigil tokens `_enforce_` / `_proof_` / `_bound_` contradict the glossary's own definition of a leading word ("recruiting priors the model already holds"): sigils have no priors. Decision deferred to randori at Wave 12 time — keep the natural phrases canonical and lint *variant drift* instead (ban "check artifact", "verification file", etc.). Address at the wave, not silently.

## Wave 13 — `kan/SKILL.md` description no longer promises an unearned branch

status: pending
blocked-by: 12
Either (a) the description drops "and performance regressions" and the body gains a one-paragraph perf-regression branch that names what changes (different minimization, different "fix" criteria, regression-test shape), or (b) the description keeps the phrase and the body is updated to genuinely cover perf regressions end-to-end. Either way: the description matches the body. Verified by: `rg "performance regression"` in `kan/SKILL.md` returns at least one body hit matching every description hit (no orphan in either direction); lint R4 still passes (no broken cross-references).

## Wave 14 — three `dojo-*` skills lose their description-duplicating cross-reference sentences

status: pending
blocked-by: 13
`dojo-principles/SKILL.md`, `dojo-project/SKILL.md`, `dojo-conduct/SKILL.md` each drop the sentences at the end of their description that repeat "Code rules live in dojo-principles; operational rules live in dojo-conduct" and equivalents. The cross-reference work is done by the description's own pointer (which is the canonical source per the rule established in Wave 12). Verified by: `rg "Code rules live in|Code-level rules live in|operational rules live in"` returns hits only inside YAML front-matter descriptions, not in skill bodies; lint passes.

## Wave 15 — each `dojo-*` rule carries a `> Rationale: DOJO-MANUAL.md §X` footer pointer

status: invalidated  # re-judged post-trim 2026-08-29: fails the deletion test — ~14 always-loaded lines whose only consumer is a human who owns the manual; agent behaviour unchanged. Ceremony the trim exists to prevent.
blocked-by: 14
Every H2-bounded rule section in `dojo-principles/SKILL.md`, `dojo-project/SKILL.md`, and `dojo-conduct/SKILL.md` ends with a single-line footer of the form `> Rationale: DOJO-MANUAL.md §[Section Name]` pointing at the matching section in the manual. Convention recorded in `dojo-project → Project Structure and Observability` as the standard format. Verified by: a new lint rule asserts every H2 in the three `dojo-*` skill files is followed (before the next H2 or EOF) by a footer matching the pattern; lint passes.

**Pushback noted in HANDOFF Improvement Backlog:** per-H2 rationale footers fail the deletion test the plan champions: ~14 always-loaded lines whose only consumer is a human who owns the manual, agent behavior unchanged, and the per-file "Rationale lives in DOJO-MANUAL.md" pointer already exists. Drop, or invert into a manual-side index. Decision deferred to randori at Wave 15 time.

## Wave 16 — `dojo-diagnose/SKILL.md` exists with the five failure modes

status: invalidated  # re-judged post-trim 2026-08-29: a NEW skill right after cutting five to shrink surface; a skill-file-audit checklist reached for ~never. Fails 'would I remember to invoke this?'. 'Premature completion' is better served by fable-judge self-verification if ever built.
blocked-by: 15
`dojo-diagnose/SKILL.md` exists at the package root (or under `dojo-diagnose/`), user-invoked per ADR 0002, with the five failure modes from the upstream guide (premature completion, duplication, sediment, sprawl, no-op) — 1–2 Dojo-specific symptoms per mode, with no-op and sediment named as related-but-distinct (no-op = the diagnosis; sediment = the cause). Each symptom carries a one-line "diagnostic question" the agent can ask itself. No lint rule; checklist-only initially. Verified by: `rg "premature completion|duplication|sediment|sprawl|no-op"` in `dojo-diagnose/SKILL.md` returns at least one body hit per mode; total skill body under 300 words; lint from prior waves still passes.

## Wave 17 — `dojo-write-skill/SKILL.md` exists as the bridge

status: invalidated  # re-judged post-trim 2026-08-29: a permanent dependency-bridge to Pocock's writing-great-skills — the exact external-source-chasing deliberately ended this session. Also blocked-by 16 (invalidated).
blocked-by: 16
The meta-skill ships per ADR 0003: ~250 words, user-invoked per ADR 0002, opens with explicit attribution to upstream `writing-great-skills` (MIT), carries only the Dojo-specific bridge content (kanji leading-word scheme interaction, glossary integration, lint enforcement, invocation rule). Points at the upstream by path for the bulk of the framework. Completion criterion: the skill passes its own checklist — verified by running `dojo-diagnose/SKILL.md`'s checks against the meta-skill itself and noting the result in the wave's debrief. Verified by: the meta-skill exists, is under 300 words, opens with attribution, and references `writing-great-skills` by path; the lint from prior waves still passes.

---

## Appendix — predecessor writing-great-skills plan (historical)

The 10-wave writing-great-skills plan shaped the early shape of this repo: ADRs 0001/0002/0003, the dojo-check proof contract, the invocation rule, and the skill catalogue. Waves 1–2 of it are committed (c9355b4, 4168c6e); Waves 3–10 are reorganized above (trim absorbs the deletion-shaped work and adds router + diagnose + meta-skill; surviving-old waves 11–17 carry the additive work forward). Preserved here for traceability. **Do not follow this plan directly** — it is no longer the active plan.

- **Wave 1 (committed, c9355b4).** Single-source the dojo-check template via dojo-principles; R10 replaces retired R6.
- **Wave 2 (committed, 4168c6e).** Classify every skill per ADR 0002; R11 single-table classifier.
- **Wave 3** — `dojo/SKILL.md` router ships and the 9-site banner duplication is retired. *Moved to Wave 11.*
- **Wave 4** — `_enforce_` and `_proof_` become leading words. *Moved to Wave 12.*
- **Wave 5** — `tanren/SKILL.md` body shrinks. *Superseded by trim Wave 9 (more aggressive slim).*
- **Wave 6** — `kan/SKILL.md` description no longer promises an unearned branch. *Moved to Wave 13.*
- **Wave 7** — three `dojo-*` skills lose their description-duplicating cross-reference sentences. *Moved to Wave 14.*
- **Wave 8** — each `dojo-*` rule carries a `> Rationale: DOJO-MANUAL.md §X` footer pointer. *Moved to Wave 15.*
- **Wave 9** — `dojo-diagnose/SKILL.md` exists with the five failure modes. *Moved to Wave 16.*
- **Wave 10** — `dojo-write-skill/SKILL.md` exists as the bridge. *Moved to Wave 17.*

---

*Plan-shape note:* with the trim plan promoted into TASKS.md, the writing-great-skills skill still informs the meta-skill (Wave 17) by attribution. The `writing-great-skills` reference in Wave 17's verification block is the durable tie — the upstream remains the source of the skill-writing framework, Dojo-skills is the bridge.
