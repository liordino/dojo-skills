#!/usr/bin/env bash
# Wave 1 asserts — hajime list structure is well-formed.
set -e
f=hajime/SKILL.md
pass=0; fail=0
chk() { if grep -qE "$2" "$f"; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL: $1"; fi; }

# 1 — rigor option block carries its first item
chk "rigor first item numbered" '^1\. What are we building\?'
# 2 — feature-or-bugfix option block carries its first item
chk "feature-or-bugfix first item numbered" '^1\. Feature — new behaviour'
# 3 — §3 checklist numbering is continuous 1..6 (no restart after the posture block)
chk "§3 item 5 is chmod" '^5\. `chmod \+x scripts/dojo-check\.sh`'
chk "§3 item 6 is baseline" '^6\. Run it to establish the \*\*baseline\*\*'
# 4 — the three tracking postures are siblings at one indent level
chk "hide-all sibling" '^   - \*\*hide-all\*\*'
chk "hide-ephemeral sibling" '^   - \*\*hide-ephemeral\*\*'
chk "track-all sibling" '^   - \*\*track-all\*\*'
# 5 — no two-space indented posture bullets remain
if grep -qE '^ ?- \*\*(hide-all|hide-ephemeral|track-all)\*\*' "$f"; then fail=$((fail+1)); echo "FAIL: posture child-indent remains"; else pass=$((pass+1)); fi

echo "wave-1 asserts: $pass ok, $fail failed"
[ "$fail" -eq 0 ]