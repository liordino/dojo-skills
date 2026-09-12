#!/usr/bin/env bash
# Wave 3 asserts — the determinize principle is recorded in Promoted (local).
set -u
pass=0
fail=0
chk() { if tr '\n' ' ' <"$3" | tr -s ' ' | grep -qF "$2"; then pass=$((pass + 1)); else
  fail=$((fail + 1))
  echo "FAIL: $1"
fi; }

P=dojo-principles/SKILL.md

# (a) the entry exists inside the Promoted (local) section
PROMOTED=$(awk '/^## Promoted \(local\)/,/^## [^P]/' "$P")
[ -n "$PROMOTED" ] || { echo "FAIL: Promoted section found"; exit 1; }
pass=$((pass + 1))
chk "the principle's name" "Determinize what has a stable right answer" /dev/stdin <<<"$PROMOTED"
chk "sensor/interpreter split stated" "the check reports the fact, the model decides" /dev/stdin <<<"$PROMOTED"
chk "evidence precondition stated" "a real failure" /dev/stdin <<<"$PROMOTED"
chk "second-order reason (context collapse)" "collapses the context" /dev/stdin <<<"$PROMOTED"
chk "receipt names the conversion" "R20" /dev/stdin <<<"$PROMOTED"
chk "provenance: session type + date" "(determinize session, 2026-09-10)" /dev/stdin <<<"$PROMOTED"

echo "wave-3 asserts: $pass ok, $fail failed"
[ "$fail" -eq 0 ]