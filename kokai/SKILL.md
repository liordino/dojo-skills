---
name: kokai
disable-model-invocation: true
description: >
  Set up the release and distribution lifecycle — the post-code stage that turns committed
  code into something a stranger can install, trust, and update. Use when a project is ready
  to ship or publish, or when adding a release pipeline. Triggers on: /kokai, "ship it", "cut
  a release", "publish this", "set up releases", "make this installable". Supervised by
  default — distribution choices are human decisions. For reviewing incoming contributions,
  see "Reviewing Code" in dojo-conduct.
---

# Kōkai — Release and Distribution (公開)

*公開 — to make public. Mostly one-time setup per project, plus light upkeep. Supervised by
default — channels, signing, and deploy targets are human calls.*

The model already knows the generic release-engineering playbook (signing specifics,
package-manager conventions, GitHub Actions YAML, Dockerfiles, etc.). Kokai keeps only the
**four Dojo-specific principles** a generic playbook won't reconstitute on its own. The rest
is the agent's general knowledge; reach for it without ceremony.

---

## The four Dojo-specific principles

1. **Problem-first README first** (dojo-project). Lead with the problem and the audience in
   one sentence, never the stack. Can't state it in a sentence → return to randori/kaizen
   before continuing. Stack/architecture detail moves to `docs/` for contributors.
2. **CI mirrors `scripts/dojo-check.sh`** — the same compile → lint → test gate that runs
   locally runs on every push and PR, so a stranger's contribution is gated by the same
   standard. Add the ecosystem's audit scan as a fifth step (`cargo audit`, `pip-audit`,
   `npm audit`, etc.). Release runs on tag, separately from CI.
3. **Build once, repackage many** (dojo-project). Compile per architecture once; every
   packaging step (binary tarball, language-native install, OS packages, Docker) wraps
   that same artifact. Byte-identical channels, less CI surface, simpler rollback.
4. **The `bin/deploy` contract** (dojo-project). One standardized entrypoint per project —
   what makes "deploy this" actionable without guessing. The contract is what Dojo
   standardizes; the *target* (Kubernetes, a single VPS, Cloud Run, fly.io, etc.) is a
   project/infra decision. Use `config/*.example` + gitignored real config so deploy
   config is publishable without leaking secrets.

Everything else — install channels, signing, changelog mechanics, release pipeline shape,
versioning scheme — is the generic playbook the model knows. Reach for it; don't restate it
here. **Changelog**: keep `CHANGELOG.md` in Keep a Changelog format, one section per version;
draft from conventional-commit history, human-curated. **Release trigger**: tag-driven
(`v*.*.*`); pipeline is idempotent (re-running detects "already exists" and continues);
never auto-publish without a deliberately pushed tag.

---

## Hand off

Summarize: README problem statement + the four principles applied; CI gate mirrors
dojo-check; release pipeline shape; `bin/deploy` contract. Record durable decisions in
.dojo/CONTEXT.md → Decisions; ADR anything with a real tradeoff (channel choice, signing posture).
Supervised: confirm each major choice before writing pipeline files. Autonomous: set
conservative defaults (binary + language-native install; CI mirrors dojo-check; tag release;
Keep-a-Changelog); surface signing, OS-packages, and deploy target for human decision.
