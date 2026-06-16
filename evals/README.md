# Dojo Evals

Two layers, honestly scoped: **an LLM's judgment can't be unit-tested, but its artifacts can.**

## Layer 1 — mechanics (automated, no agent)

```bash
./evals/run-mechanics.sh   # from the package root
```

Tests the deterministic enforcement layer as shipped: extracts the canonical dojo-check
template live from `hajime/SKILL.md` (so canonical drift fails the eval), runs it on a fixture
repo, and asserts the proof contract — proof written only on green, sha matches the log, the
kata-commit freshness rule detects edits-after-run, failure never rewrites the proof. GNU
coreutils assumed (dev-side tool).

## Layer 2 — scenarios (agent-replayed, end-state asserted)

Each scenario is a replay script for you + your agent, plus an assertion script for the
resulting artifacts. Run the replay in a scratch repo, then run the assert from inside it:

| Scenario | Exercises | Assert |
|---|---|---|
| `scenarios/s1-greenfield-supervised.md` | scaffold, randori → TASKS.md, full wave, advancement | `s1-assert.sh` |
| `scenarios/s2-brownfield.md` | pre-existing failures recorded, no-new-failures gate | `s2-assert.sh` |
| `scenarios/s3-autonomous-ceiling.md` | autonomous loop, wave ceiling, RESUME.md | `s3-assert.sh` |

A failing assert after a skill edit means the edit broke a protocol guarantee. Asserts check
artifacts only — gate wording, narration quality, and judgment calls still need your eyes
during the replay.
