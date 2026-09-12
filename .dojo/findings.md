# Findings — dojo-skills

Discoveries, halt diagnostics, and divergence records. Append-only.
Format: `YYYY-MM-DD | wave N | [discovery|halt|divergence] | description`
2026-07-10 | review | discovery | Wave 1 regression: the new proof-contract H2 in dojo-principles replaced `## Logging — Structured, at the Boundary` instead of preceding it; seven logging rules dangled inside the proof-contract section and hajime §4b's `dojo-principles → Logging` anchor pointed at nothing. Lint and evals both passed anyway (nothing checked heading *deletion*). Fixed: heading restored; the class is now enforced by lint R12 (every `skill → Section` cross-reference must resolve to a real H2/H3).
2026-07-10 | review | discovery | Uncommitted .gitignore had been CRLF-converted by an editor. Verified empirically: modern git (2.43) tolerates CR in .gitignore patterns, so ignores still worked — but CRLF in a shell script's shebang is fatal on Linux (`/usr/bin/env: 'bash\r'`). Reverted the worktree file; added .gitattributes (LF normalization, `*.sh eol=lf`); lint R13 backstops the index for anything that bypasses attributes.
2026-07-10 | review | discovery | All repo scripts were committed mode 100644 (Windows core.filemode=false), so Linux/mac clones cannot `./scripts/dojo-lint.sh` as documented. Index flipped to 100755 in this working copy; the live clone needs a one-time `git update-index --chmod=+x scripts/dojo-check.sh scripts/dojo-lint.sh evals/run-mechanics.sh evals/scenarios/*.sh`. Lint R14 enforces it from now on (its failure message carries the fix command).
2026-07-10 | review | discovery | CONTEXT.md carried two contradicting Decisions (scaffold-era "lint R6 enforces" vs ADR 0001's "R6 retired") plus a stale "(R1–R9)" in the dojo-lint glossary entry. Corrected. Systemic cause: kata-commit's durable-artifact checklist never owned CONTEXT.md, so waves that invalidate Glossary/Decisions entries leave them stale — kata-commit now carries item 4: correct any entry the wave invalidated.
2026-07-10 | review | discovery | External-review adoptions implemented for the skip-to-implementation failure family (three doors, one class): hajime gains Gate 0 (§0 — first response is rigor+mode; a design doc/starting prompt is input to the process, never a bypass); randori's "explore before asking" upgraded to the facts-are-found/decisions-are-made leading words (never grill yourself); randori's hand-off gains the explicit end-of-grill confirmation gate (a finished plan is a hand-off, not a starting gun).
2026-08-29 | wave 3 | discovery | The previous "CRLF pollution" finding was driven by R13's own broken grep, not real CR. `git grep --cached -Il $'\r' -- . | grep -q .` works correctly, but `crlf=$(git grep --cached -Il $'\r' -- .)` returns every tracked file as a false positive on Git Bash because command substitution mangles output when the search pattern is CR. `xxd` on every "CRLF-suspect" file (.gitignore, CHANGELOG.md, dojo-*/SKILL.md, etc.) showed pure LF; the uncommitted files are LF; the index is LF. The class R13 prevents is real (CRLF in a shell shebang is fatal on Linux) but this checkout had no instances. Fixed the script's grep form rather than chasing phantom CR; the reverted files in the dirty worktree were no-ops (already LF). Net: the forward-defence `.gitattributes` and the backstop R13 both stay; the false-positive finding above should be read as "R13 caught its own bug at GREEN."
2026-09-03 | session-start | discovery | Deployment drift: all 12 installed skills were pre-1.4.0 — a stale constitution governed sessions silently (old proof path, dead HANDOFF scaffold, missing Promoted entry). Human refreshed mid-session; content parity verified with diff --strip-trailing-cr. Class: install freshness is undetectable — nothing compares runtime copies to HEAD. Tracked as Wave 1 of the install-fidelity plan.
2026-09-03 | session-start | discovery | The install path normalizes line endings: installed copies are repo content + CR on every line (uniform CRLF; proven with tr -d '\r' | cmp). Harmless today — no .sh ships inside skill dirs, the .ps1 is CRLF by design — but any future skill-dir shell script would go out CRLF and hit the fatal-shebang class R13 guards in the index. Byte parity is the wrong invariant at the deploy edge; content parity is the right one. Tracked as Wave 1 (parity design) + Wave 2 (R18 structural ban).
2026-09-03 | session-start | discovery | Measurement lesson: MSYS grep -c $'\r' reported cr==total for every file it scanned (text-mode artifact), producing a false "CRLF working tree" conclusion that stood until xxd hex dumps and tr byte counts corrected it. Census claims need a second instrument before they become findings.
2026-09-03 | session-start | discovery | Content review of the governance trio: internally consistent, all artifact paths current, R10's claim verified against the lint script itself. Three currency fixes (tracked as Wave 2): .dojo/CONTEXT.md glossary says "lint R1–R14" (actual inventory R1–R17 — a kata-commit item-4 miss across three waves); the "rationale lives in .dojo/DOJO-MANUAL.md" pointer dangles outside this repo (the manual ships with the repo, not with installed skill dirs); dojo-project's bin/ + root-AGENTS.md rules lack the content-repo carve-out this repo itself relies on (ADR 0004 addendum reload story).
2026-09-03 | session-start | discovery | .ruff_cache/ at repo root — Python tool cache in a repo with no Python, invisible to git status via a global ignore — deleted by human instruction (F3).
2026-09-03 | session-start | discovery | .gitattributes was never tracked: the global excludesfile's `.gitattributes` rule masked it from git status, and R13 (which scans the index) cannot see untracked files. The v1.4.0 closeout recorded the eol=lf policy in CHANGELOG/progress — the record said tracked; reality said otherwise. Surfaced when the global file was removed. Fixed by plain git add (nothing ignores it anymore). Class: the line-ending policy file was itself subject to the hazard it prevents — on a fresh clone it would not exist.
2026-09-10 | determinize wave 1 | discovery | Evidence pass completed — triage table below.

# Determinize triage — inward pass (wave 1, 2026-09-10)

**Surfaces swept: 17** — 12 skills (`dojo-conduct`, `dojo-principles`, `dojo-project`,
`hajime`, `randori`, `kan`, `kaizen`, `kata-red`, `kata-green`, `kata-commit`, `kokai`,
`tanren`) + `scripts/dojo-check.sh` + `scripts/dojo-lint.sh` (R1–R19 inventoried as the
existing-rule check) + the durable-record trio read for failure evidence
(`.dojo/findings.md`, `.dojo/learning-log.md`, `CHANGELOG.md`). 152 raw judge/verify/
confirm/ensure/decide hits; most are gate-runs (already enforced), human-confirmation
gates (decisions, not facts), or proof-contract prose (R10-covered). The distinct
instructions are triaged below; grouped where several surfaces carry one instruction.

**Candidate test:** does the question have a right answer that does not depend on intent?

## Bucket 1 — Scriptable, with a real recorded failure

| surface | instruction | question asked | intent-dependent? | existing rule | failure prevented | evidence | cost / FP risk |
|---|---|---|---|---|---|---|---|
| kata-commit (staging) | "Run `git status --porcelain` and check untracked/new files against the denylist" — prose enforcement; the denylist lives in kata-commit's text and R17's map | are any ephemeral-tier files staged for commit? | no — staged-set ∩ ephemeral tier is a pure set comparison (`git diff --cached --name-only` vs the R17 map's ephemeral rows) | none — R17 checks map agreement, not the live staged set; evals test mechanics, not a live staging | an ephemeral file invisible to `git status` (masked by an ignore rule) slips into a staged set; blind `git add -A` is banned only by prose | real near-miss: findings 2026-09-03 — `.ruff_cache/` at repo root, invisible to git status via global ignore, deleted by the human before any commit; the hazard existed in reality, not theory | reads the staged file list + one map section; FP risk low (the ephemeral tier is a closed list); catches the class before kata-commit's own gate, not after |

## Bucket 2 — Scriptable, theoretical only (parked; no recorded instance)

| surface | instruction | question asked | intent-dependent? | existing rule | failure if it occurred | evidence | cost / FP risk |
|---|---|---|---|---|---|---|---|
| hajime §1 | classify dirty-tree files as durable-artifact edits vs ephemeral | which dirty files block the fresh start? | no — path vs the R17 artifact map is mechanical | none | resume check restarts a session while a kata-commit artifact update was interrupted | none recorded | small script over `git status --porcelain`; FP risk low |
| hajime §4b | "If CONTEXT.md → Decisions already records a log sink: skip silently" | is a log sink recorded? | no — grep Decisions for the heading | none | duplicate log-sink question asked (annoyance, not defect) | none recorded | trivial grep; near-zero value — the misask costs one question |
| kata-commit (branch guard) | "a wave commit while on main → halt, create plan/<slug>" | is the current branch a plan branch (or a clean merge point)? | no — `git symbolic-ref` comparison | prose only; R19 checks cross-surface agreement of the convention text, not the live branch | a wave commit lands on main | none recorded — guard wired 2026-09-08 and dogfooded | runtime check, not lint-shape; would need a scripts/ tool, not a repo-state rule |

## Bucket 3 — Intent-dependent (stays with the model; recorded so the question isn't re-asked)

| surface | instruction | why it stays with the model |
|---|---|---|
| hajime §5 (plan audit) | "each wave states a single verifiable outcome — you can name the one check that proves it" | what counts as "verifiable" and "one check" is judgment about intent; a rule encoding it would confidently mis-split real waves |
| kata-red §Execution | "Confirm: new check fails for the right reason" | "right reason" is interpretation of a failure against the wave goal — the model's job after the check reports |
| kata-red §golden | "never fabricate a reference — ask/create/suggest" | choosing a golden source is a product decision |
| kata-green (YAGNI, explicit types, error shape, nesting) | the whole implementation-taste cluster | taste; every candidate needs a threshold chosen by feel |
| kata-green §stuck | diagnose root cause; offer adjusted approaches | diagnosis is contextual by definition |
| kan §core | "a fast, deterministic, agent-runnable pass/fail signal for the exact bug" | judging what seam and what signal fits the bug is design |
| dojo-conduct §waivers | "name the term being waived" | semantic — what a waiver touches depends on the request |
| randori (grill) | "confirm the picture is right", "confirm each non-goal" | human-confirmation gates are decisions with content, not checkable facts |
| hajime §0 | "catch yourself reading source before rigor/mode are set → stop" | self-monitoring; no observable repo state to check |
| dojo-principles §code-nav | "fall back to rg and verify matches manually" | verification of search relevance is per-query judgment |
| kokai §CI | "CI mirrors dojo-check", audit-scan guidance | consumer-repo guidance; nothing in this repo to check |

## Triage result (verdict at the gate)

**STOP for human triage.** Bucket 1 holds exactly one candidate (the staged-set/denylist
enforcement). If the human approves it, it becomes wave 2 (one conversion: a small
scripts/ or eval-side check in the R19 seeded-violation style, kata-commit's prose reduced
to a pointer). If not — or if the near-miss citation is judged too thin — the plan closes
with no conversions, per the empty-bucket-1 clause; bucket 3 above is the durable record
of which questions are settled as the model's to answer.
2026-09-10 | determinize wave 1 triage | discovery | Evidence-mismatch correction (human verdict, verified by second instrument in a throwaway repo): bucket 1's drafted candidate — staged-set ∩ ephemeral tier — could not have caught its cited instance. `.ruff_cache/` (findings 2026-09-03) was masked by a global excludesfile, and a file masked by an ignore rule never reaches `git add -A`'s staged set (verified: masked dir absent from `git diff --cached --name-only` while unmasked files staged). The correct reading of the two 2026-09-03 instances is one class: the global excludesfile makes `git status` lie about the working tree in both directions — junk present-but-invisible (`.ruff_cache/`) AND a file recorded as tracked but actually masked (`.gitattributes`, false for a whole release). Wave 2 re-aimed at that class: enumerate what the effective ignore configuration actually masks and assert agreement with the artifact map's ephemeral tier; failure message names the offending rule via `git check-ignore -v`. This is the promoted effective-policy-not-assumed principle given a mechanism. Bucket 2 stays parked; bucket 3 stands as recorded.
**Verdict 2026-09-10:** bucket 1's candidate REJECTED as drafted (evidence mismatch, above);
wave 2 approved, re-aimed at the effective-ignore-opacity class.
2026-09-10 | determinize-w3 | discovery | Gate flake: one dojo-check run failed lint R16 ('skills add' fragment missing from README/docs) with an unchanged tree; standalone lint and an immediate re-run both passed 19/19. Same MSYS text-mode flake class as the 2026-09-03 measurement lesson (grep -c artifact, R13's grep bug) — third instance. A red gate on an unchanged tree gets one re-run before it is treated as real.
