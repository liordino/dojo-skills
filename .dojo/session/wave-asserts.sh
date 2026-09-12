#!/usr/bin/env bash
# Wave 1 asserts — determinize evidence pass (read-only inventory triage).
set -e
pass=0
fail=0
chk() { if tr '\n' ' ' <"$3" | grep -qF "$2"; then pass=$((pass + 1)); else
  fail=$((fail + 1))
  echo "FAIL: $1"
fi; }
no() { if grep -qF "$2" "$3" 2>/dev/null; then
  fail=$((fail + 1))
  echo "FAIL: $1"
else pass=$((pass + 1)); fi; }

TABLE=$(ls .dojo/findings.md 2>/dev/null || echo .dojo/determinize-candidates.md)
[ -f "$TABLE" ] || {
  echo "FAIL: triage table document exists"
  exit 1
}
pass=$((pass + 1))

# (a) three buckets present
chk "bucket 1 heading" "Scriptable, with a real recorded failure" "$TABLE"
chk "bucket 2 heading" "Scriptable, theoretical only" "$TABLE"
chk "bucket 3 heading" "Intent-dependent" "$TABLE"

# (b) table header carries the required fields per entry
chk "surface field" "surface" "$TABLE"
chk "instruction field" "instruction" "$TABLE"
chk "intent-dependence verdict field" "intent-dependent" "$TABLE"
chk "existing-rule check field (R-rules)" "existing rule" "$TABLE"
chk "failure field" "failure" "$TABLE"
chk "cost / false-positive field" "cost" "$TABLE"

# (c) bucket 1 entries cite a real recorded instance (durable-record evidence)
BUCKET1=$(awk '/Scriptable, with a real recorded failure/,/Scriptable, theoretical only/' "$TABLE")
if tr '\n' ' ' <<<"$BUCKET1" | grep -qE 'learning-log|findings 2026-|CHANGELOG'; then pass=$((pass + 1)); else
  fail=$((fail + 1))
  echo "FAIL: bucket 1 cites durable-record evidence"
fi

# (d) surfaces swept are counted (12 skills + 3 governance + tooling)
if grep -qF "Surfaces swept" "$TABLE"; then pass=$((pass + 1)); else
  fail=$((fail + 1))
  echo "FAIL: surfaces-swept count recorded"
fi

# (e) the triage stop is recorded — nothing built in this wave
chk "stop-for-triage recorded" "STOP for human triage" "$TABLE"

# (f) tree discipline: only the triage document (+ session state) may differ
DIRTY=$({ git status --porcelain | grep -v -E '^\?\? \.dojo/(findings|session)/|^\s*M \.dojo/(findings\.md|session/)' | grep -v -E ' \.dojo/(proof|session)/'; } || true)
if [ -n "$DIRTY" ]; then
  fail=$((fail + 1))
  echo "FAIL: unexpected tree changes: $DIRTY"
else pass=$((pass + 1)); fi

echo "wave-1 asserts: $pass ok, $fail failed"
[ "$fail" -eq 0 ]
