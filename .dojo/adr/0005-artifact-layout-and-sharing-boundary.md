# ADR 0005 — One-folder footprint: the `.dojo/` artifact layout and the sharing boundary

- **Status:** accepted
- **Date:** 2026-09-03
- **Context:** the consolidation review (2026-09-03) — Dojo's artifacts lived in two places:
  the durable record at the repo root and per-machine state split between a gitignored
  dot-folder (proof artifacts) and a root-level session file. Adoption touched six root
  files, "what is Dojo's footprint" had no single answer, and invisible use — running the
  discipline without colleagues knowing — required ignoring several paths.

## Context

Three forces shaped the decision:

1. **One folder = one footprint.** In every repo where Dojo is used, everything it produces
   and reads should be one folder, so "ignore it" is the complete invisibility switch and
   "delete it" is complete removal.
2. **Names describe function; the ignore file describes policy.** Baking ignore status into
   a name (e.g. a folder called "local" or "ignored") conflates the two; the user may ignore
   all of `.dojo/`, any subset, or none — the names must not change with that choice.
3. **The sharing boundary.** The agent does the work; the human owns anything that decides
   what is shared, committed, or published. Ignore files, git history, remotes, CI, LICENSE —
   presented, never autonomously edited. Shared history has a second leak surface too:
   commit text that narrates the tooling.

## Decision

1. **Layout.** Every Dojo artifact lives under `.dojo/`: the durable record at its root
   (`.dojo/CONTEXT.md`, `.dojo/TASKS.md`, `.dojo/progress.md`, `.dojo/learning-log.md`, `.dojo/findings.md`,
   `.dojo/poc-lessons.md`, and this package's `.dojo/DOJO-MANUAL.md`); function-named subfolders for the
   rest — `.dojo/adr/` for decision records, `.dojo/session/` for the live run
   (`.dojo/session/dojo-session.md`,
   `.dojo/session/resume.md`, `.dojo/session/scoping-questions.md`), `.dojo/proof/` for gate
   evidence (`check-proof`,
   `check-output.log`), `.dojo/tanren/` (optimization loop workspace). Filenames are kept
   (`.dojo/session/dojo-session.md`, `check-proof`) so the established vocabulary and the R10
   identifiers survive; only paths change.
2. **The map is machine-checked.** `scripts/dojo-lint.sh` R17 single-sources the artifact
   map (path + tier), asserts every reference on a living surface is path-qualified, bans
   stale legacy paths there (a permanent, mechanical version of the post-rename grep),
   cross-checks kata-commit's staging denylist against the ephemeral tier, and verifies the
   recorded tracking posture against `git check-ignore` behavior. History surfaces
   (CHANGELOG, progress, learning-log) are exempt — they legitimately read old names.
3. **The tracking posture.** Per repo, the human decides: hide-all (invisible mode — the
   record is machine-local; deleting the footprint means starting fresh, and the posture is
   also the backup policy) / hide-ephemeral (the record travels in git; run state stays
   local — default solo) / track-all (everything travels; concurrent mid-wave edits on two
   machines conflict at pull and the human picks one machine's truth). The decision is
   recorded in .dojo/CONTEXT.md → Decisions, presented with each option's consequence, applied by
   the human in whichever ignore surface they keep — repo `.gitignore` (tracked, shared) ·
   `.git/info/exclude` (per-clone, invisible: the anonymous route, whose lifecycle matches
   the artifacts' — both exist where you use Dojo) · a global excludes file (all your
   machines) · `.dojo/.gitignore` (travels with the folder; only on explicit choice) — and
   verified with `git check-ignore -v`. The agent never edits an ignore file.
4. **The resume pointer joins the ephemeral tier** as `.dojo/session/resume.md`: it is run-scoped,
   per-machine state, and no longer dirties the tree at an autonomous pause. Under this
   repo's track-all posture it stays tracked.
5. **Commit text.** Commits describe the change in the project's language, never the tooling
   that produced it; tool attribution is the human's explicit choice (dojo-conduct → The
   Sharing Boundary). Soft rule — not lint-enforced.
6. **One tool-homed exception.** graphify's cache stays at the project root
   (`graphify-out/`): verified empirically — `update` takes no output flag and silently
   ignores `--out`; `GRAPHIFY_OUT` relocates CLI commands only, while the `/graphify` skill
   hardcodes the path in ~40 places including its build scripts and git hooks, so a
   relocated cache forks silently. The exception is about *location*; the cache's tracking
   follows the recorded posture like everything else (this package repo, track-all, commits
   it). Revisit if graphify ships a consistent output flag; then it is one move plus one
   map-line edit.

## Consequences

- Adoption and removal are one-folder operations; the cold-reader path
  (README → record → git log) is unchanged in substance, qualified in path.
- hajime scaffolds into `.dojo/`, asks the posture question at the beginning, offers a
  one-time migration for pre-consolidation repos, and never edits ignore files; its denylist
  backstop (kata-commit) keeps ephemeral files unstaged regardless of ignore state.
- R16's parity gate was found dead (it sat after the lint script's exit and never ran) and
  now lives before the verdict; R17 joins it there.
- R4 stops false-positiving on ADR filename slugs (long-standing backlog item).

## Alternatives considered

- **Keep ADRs in the `docs/` tree** (industry convention; human-facing). Rejected for the
  uniform-footprint property: one folder must be the complete, erasable footprint, and ADRs
  are Dojo-produced artifacts like the rest. The teaching text updates in lockstep.
- **Keep README/CHANGELOG at the root** — adopted; they are publication surfaces of the
  package (GitHub renders the root README; kokai teaches CHANGELOG-at-root), not discipline
  artifacts, the same class as `docs/index.html`.
- **A `.dojo/local/` tier** (ignore-status naming). Rejected: names must describe function,
  not policy — the posture varies per repo and must never be baked into a name.
- **Rely on `.dojo/` being ignored for untracked scratch (tanren ledger).** Rejected: the
  discipline must not assume any ignore status; the ledger's fate is the recorded posture.
