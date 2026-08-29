# Tasks — dojo-skills

intent: raise the quality of the Dojo skill set to the standard set by `writing-great-skills` (Matt Pocock, MIT), so the package's own skills practise what it preaches about predictability, leading words, and single sources of truth.

## Wave 1 — dojo-check is single-sourced

status: done
The dojo-check template's source-of-truth split is implemented: `dojo-principles` carries the proof-contract invariant, `scripts/dojo-check.sh` is the per-project stack executor with the content-repo's three stack commands, hajime's inline block is illustrative and points at `dojo-principles`, and lint R6 is retired and replaced by an R that verifies each surface references the same proof-contract identifiers. ADR 0001 already written; wave ships the implementation. Verified by: `./scripts/dojo-lint.sh` passes; `./scripts/dojo-check.sh` still produces a valid proof; the hajime block, the manual block, the script, and the PowerShell reference all reference `check-proof`/`output_sha256`/`check-output.log`.

## Wave 2 — every skill declares its invocation type

status: done
Every SKILL.md in the package carries either `disable-model-invocation: true` (user-invoked) or its absence (model-invoked) per the rule in ADR 0002; the three `dojo-*` session-invoked skills carry a one-line rationale comment in their YAML front-matter. Per-skill rationale is recorded. Verified by: a new lint rule enumerates every SKILL.md and asserts the flag is present (true or absent-with-rationale-comment) and that the per-skill rationale comment matches the rule's table; lint passes.

## Wave 3 — `dojo/SKILL.md` router ships and the 9-site banner duplication is retired

status: pending
The router skill exists at `dojo/SKILL.md`, user-invoked (per ADR 0002), carrying (a) a table of all skills with invocation type and one-line trigger phrase, (b) the session-start governance directive as its only procedural content (load `dojo-principles`, `dojo-project`, `dojo-conduct`), and (c) a one-line pointer to itself wherever an agent needs the index. The 9 skills that currently carry the "Before anything else…" banner inline (hajime, hajime-bugfix, kaizen, kan, kensha, kokai, randori, tanren, waza) each lose the inline banner and replace it with a one-line pointer to the router. Verified by: `rg "Before anything else: load and apply"` returns zero hits outside `dojo/SKILL.md`; the router's table covers all skills; the lint from Wave 2 still passes.

## Wave 4 — `_enforce_` and `_proof_` become leading words across the package

status: pending
The English phrases "enforce over instruct", "proof artifact", "fresh proof", "proof contract" are retired from prose and replaced by the leading words `_enforce_` and `_proof_`. Each leading word's definition lives once, in the relevant glossary entry in `CONTEXT.md`. `_non-goal_` keeps its noun form; the leading word for the *behaviour* (currently `_bound_` provisional) is picked during the wave and recorded in CONTEXT.md. Verified by: `rg -i "enforce.over.instruct|fresh proof|proof artifact"` returns zero hits outside the glossary entries and the ADRs that define them; `rg "_enforce_|_proof_"` returns hits across the skills where the phrases used to be; the lint rules from Waves 1–3 still pass.

## Wave 5 — `tanren/SKILL.md` body shrinks

status: pending
The ledger schema, scoring-contract mechanics, and worked example move from `tanren/SKILL.md` into `tanren/reference/tanren-loop.md` (the reference file already exists with some of this content; the wave expands it). `tanren/SKILL.md` keeps the entry gate, stopping criteria, hand-back to the kata cycle, and the rules that govern the scratch area's shape. Lint R9 still passes (it enforces safety markers in the reference file). Verified by: `tanren/SKILL.md` body-word count drops by at least 40%; the moved content is intact in `tanren/reference/tanren-loop.md`; lint R9 passes.

## Wave 6 — `kan/SKILL.md` description no longer promises an unearned branch

status: pending
Either (a) the description drops "and performance regressions" and the body gains a one-paragraph perf-regression branch that names what changes (different minimization, different "fix" criteria, regression-test shape), or (b) the description keeps the phrase and the body is updated to genuinely cover perf regressions end-to-end. Either way: the description matches the body. Verified by: `rg "performance regression"` in `kan/SKILL.md` returns at least one body hit matching every description hit (no orphan in either direction); lint R4 still passes (no broken cross-references).

## Wave 7 — three `dojo-*` skills lose their description-duplicating cross-reference sentences

status: pending
`dojo-principles/SKILL.md`, `dojo-project/SKILL.md`, `dojo-conduct/SKILL.md` each drop the sentences at the end of their description that repeat "Code rules live in dojo-principles; operational rules live in dojo-conduct" and equivalents. The cross-reference work is done by the description's own pointer (which is the canonical source per the rule established in Wave 4). Verified by: `rg "Code rules live in|Code-level rules live in|operational rules live in"` returns hits only inside YAML front-matter descriptions, not in skill bodies; lint passes.

## Wave 8 — each `dojo-*` rule carries a `> Rationale: DOJO-MANUAL.md §X` footer pointer

status: pending
Every H2-bounded rule section in `dojo-principles/SKILL.md`, `dojo-project/SKILL.md`, and `dojo-conduct/SKILL.md` ends with a single-line footer of the form `> Rationale: DOJO-MANUAL.md §[Section Name]` pointing at the matching section in the manual. Convention recorded in `dojo-project → Project Structure and Observability` as the standard format. Verified by: a new lint rule asserts every H2 in the three `dojo-*` skill files is followed (before the next H2 or EOF) by a footer matching the pattern; lint passes.

## Wave 9 — `dojo-diagnose/SKILL.md` exists with the five failure modes

status: pending
`dojo-diagnose/SKILL.md` exists at the package root (or under `dojo-diagnose/`), user-invoked per ADR 0002, with the five failure modes from the upstream guide (premature completion, duplication, sediment, sprawl, no-op) — 1–2 Dojo-specific symptoms per mode, with no-op and sediment named as related-but-distinct (no-op = the diagnosis; sediment = the cause). Each symptom carries a one-line "diagnostic question" the agent can ask itself. No lint rule; checklist-only initially. Verified by: `rg "premature completion|duplication|sediment|sprawl|no-op"` in `dojo-diagnose/SKILL.md` returns at least one body hit per mode; total skill body under 300 words; lint from prior waves still passes.

## Wave 10 — `dojo-write-skill/SKILL.md` exists as the bridge

status: pending
The meta-skill ships per ADR 0003: ~250 words, user-invoked per ADR 0002, opens with explicit attribution to upstream `writing-great-skills` (MIT), carries only the Dojo-specific bridge content (kanji leading-word scheme interaction, glossary integration, lint enforcement, invocation rule). Points at the upstream by path for the bulk of the framework. Completion criterion: the skill passes its own checklist — verified by running `dojo-diagnose/SKILL.md`'s checks against the meta-skill itself and noting the result in the wave's debrief. Verified by: the meta-skill exists, is under 300 words, opens with attribution, and references `writing-great-skills` by path; the lint from prior waves still passes.
