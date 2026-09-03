# ADR 0001 — Split source of truth for the dojo-check template

- **Status:** accepted
- **Date:** 2026-06-19
- **Context:** the randori that produced `.dojo/TASKS.md` (skill-quality pass)

## Context

The canonical dojo-check template — the bash block that runs the three stack
commands and writes `.dojo/proof/check-proof` with `ts`/`exit`/`output_sha256` — appears
in three places today:

- `hajime/SKILL.md` §3 (inline fenced bash block, loaded into every agent's context
  when hajime fires)
- `.dojo/DOJO-MANUAL.md` (the same block, mirrored for human readers)
- `scripts/dojo-check.sh` (this repo's actual implementation; stack commands differ
  because this is a content repo with no compile step)

Plus `hajime/reference/dojo-check.ps1` (PowerShell variant). Lint R6 enforces
byte-equality between the hajime block and the manual block.

The byte-equality approach is a *working compromise* that papers over a real
ambiguity: which of the three is normative? Today all three are, by enforcement;
none of them is, by being independent copies. The arrangement is fragile (any
edit must touch all three) and confuses the audience — an agent reading hajime
sees cargo commands even when the project is a Node shop.

## Decision

Three sources, each normative for a distinct layer:

1. **Proof-contract invariant** — what `.dojo/proof/check-proof` must contain, and what
   the sha256 covers — lives in `dojo-principles` (the Enforce Over Instruct
   section). This is the layer that scales across every project: every `dojo-check`
   in any repo writes the same shape of proof.
2. **Three stack commands** — `cargo build / clippy / test`, or whatever the
   project's stack requires — live in the per-project `scripts/dojo-check.sh`. Each
   project's stack is its own choice; the proof contract stays portable.
3. **Illustrative block** in `hajime/SKILL.md` and `.dojo/DOJO-MANUAL.md` — a cargo-shaped
   example, clearly labelled as illustrative, that points at `dojo-principles` for
   the contract. Human readers learn the shape; agents that need the rule load
   `dojo-principles`.

Lint R6 (byte-equality enforcement) is **retired**. Replaced by an R that verifies
each surface (hajime block, manual block, scripts/dojo-check.sh, the PowerShell
reference) references the same proof-contract identifiers (`check-proof`,
`output_sha256`, `check-output.log`). The check is *structural*, not byte-equal.

## Consequences

- An agent in a Node shop that loads hajime no longer sees cargo commands in its
  context — the illustrative block can carry a footnote that says "stack commands
  are per-project; see your `scripts/dojo-check.sh`."
- Editing the proof contract becomes a single-place change in `dojo-principles`;
  the linter checks that all surfaces still agree.
- The hajime block can shrink (the cargo specifics can be a one-line footnote or
  moved into the manual), reducing context load.
- This is a real change in meaning for "canonical" in three files. Worth an ADR
  precisely because it's surprising without context — "wait, hajime used to be
  normative for the template, now it isn't?"

## Alternatives considered

- **`scripts/dojo-check.sh` is the SoT; SKILL.md and manual carry pointers.**
  Rejected because hajime's audience is agents who don't read scripts unless told
  to; the skill needs the contract in its own body to anchor the agent's
  understanding.
- **Inline block in hajime is the SoT; the script is generated/copied.**
  Rejected because it puts stack-specific commands in every agent's context — the
  same context-load problem the audit flagged elsewhere.
- **Keep the byte-equality arrangement.** Rejected because it papers over the
  ambiguity rather than resolving it, and any one of three places can drift if a
  maintainer forgets the linter.
