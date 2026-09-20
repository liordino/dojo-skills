#!/usr/bin/env bash
# Wave asserts — instrument-red-gate wave (2026-09-10).
# Verifiable outcome: R16 (and instrumented sibling marker greps) emit exit code +
# stderr + readability on failure; no re-run/retry norm anywhere; record corrected.
set -u
cd "$(dirname "$0")/../.." || exit 1
PASS=0; TOTAL=0
ok()  { TOTAL=$((TOTAL+1)); PASS=$((PASS+1)); say "PASS $1"; }
bad() { TOTAL=$((TOTAL+1)); say "FAIL $1"; }
say() { printf '%s\n' "$*"; }

# A1 — seeded R16 violation: the red must be self-diagnosing (evidence: grep exit,
# stderr, readability in the failure line). Seed by removing 'skills add' from a
# temp copy of README.md, run a temp copy of the lint against it.
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
cp README.md scripts/dojo-lint.sh "$TMP/"; mkdir -p "$TMP/docs"; cp docs/index.html "$TMP/docs/"
sed -i 's/skills add//' "$TMP/README.md"
out=$(
	cd "$TMP" && mkdir -p .dojo session proof evals 2>/dev/null
	bash "$TMP/dojo-lint.sh" 2>&1
)
TOTAL=$((TOTAL+1))
if echo "$out" | grep -q "FAIL: R16: install command fragment 'skills add'" &&
   echo "$out" | grep -q "evidence: grep exit=1" &&
   echo "$out" | grep -qE 'stderr=\[[^]]*\] readable=(yes|no)'; then
	# A temporary-copy run of a lint whose tree assumptions differ may fail on other
	# rules first — that is fine; the three asserted lines must be present regardless.
	PASS=$((PASS+1)); say "PASS A1 — seeded R16 red names its mechanism (exit=1, stderr, readable)"
else
	say "FAIL A1 — seeded R16 red lacks self-diagnosis evidence"; say "$out" | grep -i r16 | head -5
fi

# A1b — the I/O red path (unit): gq against a target absent at grep time must yield
# exit=2, populated stderr, readable=no — the undiagnosed flake's likely shape.
# (Full-lint form is impossible: with README.md absent the lint exits at its
# run-from-root guard before R16. A1 proves the err-line wiring end-to-end.)
TMP2=$(mktemp -d)
rm -rf "$TMP2"
gq_src=$(awk '/^GQ_EVIDENCE=""$/{f=1} f{print} f&&/^\}/{exit}' scripts/dojo-lint.sh)
TOTAL=$((TOTAL+1))
if ( eval "$gq_src"; gq /nonexistent-target/README.md 'skills add'; test $? -eq 2 &&
     echo "$GQ_EVIDENCE" | grep -qE 'grep exit=2 stderr=\[grep: /nonexistent-target/README.md: .*\] readable=no' ) 2>/dev/null; then
	PASS=$((PASS+1)); say "PASS A1b — I/O red carries exit=2, stderr, readable=no"
else
	say "FAIL A1b — I/O red not self-diagnosing"
fi

# A2 — no re-run/retry norm anywhere in the durable surfaces (findings norm struck;
# skills and scripts clean). The failure itself stays recorded as history.
TOTAL=$((TOTAL+1))
if ! grep -rqE "gets one re-run|re-run before it is treated as real|one re-run before" \
	./skills ./scripts ./evals .dojo/CONTEXT.md .dojo/TASKS.md .dojo/progress.md \
	.dojo/learning-log.md .dojo/findings.md .dojo/DOJO-MANUAL.md 2>/dev/null; then
	PASS=$((PASS+1)); say "PASS A2 — no re-run/retry allowance in skills, scripts, or .dojo"
else
	say "FAIL A2 — re-run/retry allowance still present:"
	grep -rnE "gets one re-run|re-run before it is treated as real|one re-run before" \
		./skills ./scripts ./evals .dojo/*.md 2>/dev/null | head -5
fi

# A3 — classification corrected: findings must not claim the undiagnosed red shares
# the text-mode class ("third instance" framing struck); must record awaiting-occurrence.
TOTAL=$((TOTAL+1))
if grep -q "NOT a third instance" .dojo/findings.md &&
   grep -q "awaiting its next occurrence" .dojo/findings.md &&
   ! grep "third instance" .dojo/findings.md | grep -qv "NOT a third instance"; then
	PASS=$((PASS+1)); say "PASS A3 — classification corrected, undiagnosed red marked awaiting next occurrence"
else
	say "FAIL A3 — findings classification not corrected"
fi

# A4 — lint itself is green on the unchanged tree (no tolerance added: the seeded
# violation above still fails hard, only with better evidence).
TOTAL=$((TOTAL+1))
if bash scripts/dojo-lint.sh 2>&1 | grep -q "PASS"; then
	PASS=$((PASS+1)); say "PASS A4 — lint green on the unchanged tree"
else
	say "FAIL A4 — lint not green on the unchanged tree"
fi

say "wave-asserts: $PASS/$TOTAL"
[ "$PASS" -eq "$TOTAL" ]