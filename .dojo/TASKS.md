# TASKS — the release entrypoint (`bin/release`)

**Intent:** make "release this" actionable without guessing, the same way `bin/deploy`
makes "deploy this" actionable — by standardising the *contract*, never the
implementation. The mechanical release procedure belongs in a per-repo script; the
judgment around it (semver level, change summary, sending) stays with the human and
the model.

**No new skill.** `kokai` already owns release/distribution; its triggers already cover
"ship it" / "cut a release". No `kata-*` name — a release is not a wave step.

**Ordering:** the proving instance comes first, the contract second. Write one real
`bin/release`, use it for at least one actual release, then standardise what worked.
If reality diverges from the sketched interface, the contract follows reality.

## Wave 1 — one real `bin/release`, in one consumer repo

status: done — end-to-end verified by kumite's first genuine release (2026-09-21,
human-confirmed publish): level `minor`, version 0.1.0 → 0.2.0, tag v0.2.0 on
27b8c5c, artifact dist/kumite.exe, facts printed, publishing was the human's act.
Wave A gate hardening included: failed check deletes the proof (stale green can't
survive a red gate), real exit status recorded, proof contract stated as sealing the
PRE-BUMP tree with bin/release printing that fact (kumite 6bd15c2). Full record:
kumite `.dojo/progress.md` (2026-09-21 entry).

**Ran in kumite (C:\Users\liord\src\kumite), branch plan/release-entrypoint,
commits 032718f + 97adb22.** Human rescopes (2026-09-20): no due release exists, and
none may be invented — so the wave proves what is provable now and closes partial.
Autonomy covered script + refusal proofs + local plan-branch commits only; push,
remote tags, artifact placement, and sending remain the human's.

Delivered `bin/release <major|minor|patch>`: refuses loudly on dirty tree, not on the
integration line, no proof sealed over the exact tree being tagged, tag exists/
published; bumps `version.json`, tags, builds ldflags-stamped artifact, prints facts,
never communicates. Proven by `scripts/release-asserts.sh` 10/10 seeded violations +
local happy path (transient tag/commit undone, nothing published).

**Interface that actually emerged (differs from sketch — sketch loses):**
integration line is `autonomous` (kumite's `main` is an empty scaffold; human chose to
keep it as-is — the check is `KUMITE_INTEGRATION_BRANCH`, default `autonomous`); version
home is new (`version.json` + `main.Version` ldflags-stamp); gate scaffolded
(`scripts/dojo-check.sh`, proof seals `tree_sha256` = HEAD + working-tree delta, both
sides excluding `.dojo/`/`dist/`); published-tag check runs only when a remote exists.
Waves 2–3 were worded from this interface, not from the sketch.

## Wave 2 — codify the contract in `dojo-project`

status: done

The contract paragraph ( dojo-project → Project Structure and Observability) names
`bin/release <major|minor|patch>`, states the caller-supplied level, the mechanical
sequence in repo-neutral terms (version home, integration line, artifact, printed
facts), and the refuse-loudly guarantee — worded from Wave 1's emerged interface
("the repo's integration line", not `main`, per kumite's reality). The only artifact
mentions are in the explicit negation sentence (DLL/container/zip/none — examples of
what the contract does NOT assume).

## Wave 3 — the judgment layer in `kokai`

status: done

kokai gained "The release judgment layer — around `bin/release`" (~15 lines): gate
fresh at the exact tree; level derived from the changelog classification with the
stop-and-confirm escape on conflict; invoke and read facts, never restate the
procedure; the two irreversibility guards (no rewritten tag, no unrequested release);
draft-the-summary/agent-does-not-send boundary. Nothing depends on the untested
end-to-end path — the one piece that would (the changelog-derivation as a *computed*
sensor) is parked until a repo with a real CHANGELOG exercises it (kumite has none).

**Verified by:** section present with all required elements; lint + mechanics green.

---

## Run notes

- Wave 1 runs in a consumer repo; Waves 2–3 run in dojo-skills. Cross-repo principle: a
  wave spanning repositories closes in every repository it touched.
- Waves 2–3 run on this plan branch per ADR 0006 and merge at plan close.
- If Wave 1 reveals the sketched interface is wrong, **the sketch loses.** Waves 2–3
  describe what exists, not what this plan imagined.

## Adopted-without-a-scar rules (deliberate)

Gate-freshness, no-rewritten-tag, and no-unrequested-release are lifted from Akita's
release skill (2026-09-17). Scar-tissue-first is the right default for *reversible*
failures; irreversible ones are guarded pre-emptively, matching the kata-commit
denylist precedent (secrets). The changelog-derivation stands on the determinize
principle (2026-09-10) — classification already recorded, so the level is computable;
track it as a determinize candidate once `bin/release` exists.

## Non-goals (explicit)

- No new skill, no `kata-*` name for release work.
- No shared release library across the repos — three near-identical scripts beat one
  parameterised script with three configs. Resist the extraction.
- No language, toolchain, or artifact assumptions in the contract.
- The agent never sends the release communication. Drafting yes; sending no.
- No auto-inference of the semver level beyond the recorded changelog classification;
  conflicts stop for human confirmation; a bump no human saw is forbidden.
- No release automation beyond the entrypoint — no scheduled, release-on-merge, or
  otherwise unprompted releases.