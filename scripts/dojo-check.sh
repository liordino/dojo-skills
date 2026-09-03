#!/usr/bin/env bash
# dojo-check — content-repo gate for the dojo-skills package.
#
# This repo ships no application code (no compile, no unit tests). The meaningful
# gates for a skill package are:
#   1. dojo-lint.sh      — static internal consistency (R1–R15)
#   2. evals/run-mechanics.sh — proof-contract behavior end-to-end
#
# Both compose into the standard dojo-check proof contract (.dojo/proof/check-proof +
# .dojo/proof/check-output.log). kata-commit hard-gates on this artifact.
#
# The canonical dojo-check template (cargo-shaped) lives in hajime/SKILL.md and
# .dojo/DOJO-MANUAL.md; lint R6 enforces they stay identical. This file is the
# content-repo analogue — same proof contract, honest commands.
set -e
set -o pipefail
mkdir -p .dojo
{
	echo "== dojo-lint (static consistency) =="
	./scripts/dojo-lint.sh
	echo "== evals/run-mechanics (proof-contract behavior) =="
	./evals/run-mechanics.sh
} 2>&1 | tee .dojo/proof/check-output.log
# Reached only if every check passed (set -e + pipefail):
sha() { sha256sum "$1" 2>/dev/null || shasum -a 256 "$1"; }
{
	echo "ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
	echo "exit=0"
	echo "output_sha256=$(sha .dojo/proof/check-output.log | awk '{print $1}')"
} >.dojo/proof/check-proof
