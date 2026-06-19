---
name: kokai
disable-model-invocation: true
description: >
  Set up the release and distribution lifecycle — the post-code stage that turns committed
  code into something a stranger can install, trust, and update. Use when a project is ready
  to ship or publish, or when adding a release pipeline. Triggers on: /kokai, "ship it", "cut
  a release", "publish this", "set up releases", "make this installable". Covers problem-first
  README, installation surface, CI, tag-triggered releases, changelog, and the bin/deploy
  contract. Supervised by default — distribution choices are human decisions. For reviewing
  incoming contributions use /kensha.
---

# Kōkai — Release and Distribution (公開)

**Before anything else: load and apply `dojo-principles`, `dojo-project`, and `dojo-conduct` now.**

*公開 — to make public. Dojo takes a project from idea to committed code; kōkai takes it the
rest of the way: installable, trustable, understandable by a stranger. Mostly one-time setup
per project, plus light upkeep. Supervised by default — channels, signing, and deploy targets
are human calls.*

Narrate the tradeoffs; distribution choices have real ones.

---

## 1. Problem-first README (first — it matters most)

- Lead with the problem and the audience in one sentence, never the stack. Can't state it in a
  sentence → that's a design smell, not a docs smell: return to randori/kaizen.
- Stack/architecture/dependency detail moves to `docs/` for contributors.
- Write README and install docs in the language of the project's primary audience — a doc the
  user can't read is an install barrier.
- Include an installation section with multiple paths (filled once the pipeline exists).
Confirm the one-sentence problem statement with the human before proceeding.

## 2. Installation surface

Offer several paths; never force a full toolchain just to try the tool. Detect language/type
and propose relevant channels:

- **Always the lowest common denominator:** a prebuilt binary/artifact (tarball on PATH for
  CLIs; platform installer for desktop).
- **Language-native:** `cargo install` · `pip install`/`pipx` · `npm install` · `go install` ·
  the registry that applies.
- **OS package managers** where the audience warrants: Homebrew tap, AUR (prebuilt `-bin` +
  source), RPM/DEB via a declarative tool (e.g. nfpm) from the one binary, AppImage for
  desktop, Docker for services.
- **Version managers** (e.g. mise) come almost free if release tarballs follow a consistent
  platform-naming convention.
**Apply Build Once, Repackage Many** (dojo-project): compile per arch once; every packaging
step wraps that same artifact — byte-identical channels, less CI. Propose a sensible subset
for the audience (not ten channels for three users); supervised: confirm the list.

## 3. CI (every push and PR)

CI is the common floor that lets you accept a stranger's PR without fear: the same gates run
for everyone. Mirror `scripts/dojo-check.sh` remotely — compile → lint → test — plus the
ecosystem's audit scan (`cargo audit`, `pip-audit`, `npm audit`, `bundler-audit`, …). Keep CI
(push/PR) separate from release (tag).

## 4. Tag-triggered release (separate from CI)

Release fires only on a `v*.*.*` tag plus a manual dispatch option — what makes "ship v0.5.0"
one predictable, agent-runnable action. Pipeline: build targets (test on native; cross-compile
the rest without running foreign-arch tests) → package everything from the one artifact per
arch → sign what needs signing → create the release → publish to configured channels.
**Publish steps are idempotent:** re-running a tag detects "already exists" and continues —
the idempotency principle applied to release. Signing (surface, don't prescribe): macOS needs
signing + notarization or Gatekeeper blocks; Windows signing is expensive — unsigned + a
SmartScreen note in the README is acceptable for personal OSS; Linux generally needs none.
The human (or agent, told "ship v0.5.0") does bump → changelog → commit → tag → push; the
pipeline does the rest. Never auto-publish without a deliberately pushed tag.

## 5. Changelog that matters

`CHANGELOG.md` in Keep a Changelog format, one section per version. The release pipeline
extracts the current section into the release body, plus install instructions and per-artifact
checksums — the release explains itself. With conventional commits, draft sections from the
history grouped by type (feat/fix → Added/Fixed); the human curates the wording.

## 6. Deploy (principle, not prescription)

For services: one standardized `bin/deploy` entrypoint per project (typically build → push →
bring up the new version). Specifics (target, registry, orchestration) are project/infra
decisions, not prescribed — the *contract* is what Dojo standardizes, so "deploy this" is
actionable without guessing. Match the tool to the problem (a solo home-server project does
not need Kubernetes). Use versioned-example/ignored-real config so deploy config is
publishable without leaking secrets.

---

## Hand off

Summarize: README, channels, CI gates, release trigger + changelog flow, deploy entrypoint.
Record durable decisions in CONTEXT.md → Decisions; ADR anything with a real tradeoff.
Supervised: confirm each major choice (channels, signing, deploy target) before writing
pipeline files. Autonomous: set conservative defaults (binary + language-native install, CI,
tag release, changelog) and surface signing/OS-packages/deploy for human decision.
