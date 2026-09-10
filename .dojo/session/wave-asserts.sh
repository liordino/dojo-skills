#!/usr/bin/env bash
# Wave 2 asserts — cross-surface prose currency.
set -e
pass=0; fail=0
chk() { if tr '
' ' ' < "$3" | grep -qF "$2"; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL: $1"; fi; }
no() { if grep -qF "$2" "$3"; then fail=$((fail+1)); echo "FAIL: $1"; else pass=$((pass+1)); fi; }

# (a) manual pointer — names source repo + repo-root file, no .dojo/ path
for f in dojo-conduct/SKILL.md dojo-project/SKILL.md; do
  chk "manual pointer names the source repo's own .dojo/ ($f)" 'at `.dojo/DOJO-MANUAL.md` in' "$f"
  chk "pointer disambiguates from the local project ($f)" "not in the local project's" "$f"
  no "no colon-path ambiguity in manual pointer ($f)" 'source repo: .dojo/DOJO-MANUAL.md' "$f"
done

# (b) freshness invariant reads advisory
chk "kata-commit: gate is the final dojo-check run" 'The gate is running `dojo-check`' kata-commit/SKILL.md
chk "kata-commit: mtime check is advisory" 'advisory' kata-commit/SKILL.md
no "kata-commit: no mtime-as-contract wording" 'no tracked source file (per `git status --porcelain` + mtimes) newer' kata-commit/SKILL.md
chk "principles: mtime advisory wording" 'cheap advisory signal' dojo-principles/SKILL.md
no "principles: no invariant wording" 'must be newer than\nevery tracked source file' dojo-principles/SKILL.md

# (c) tension named in dojo-principles
chk "tension named" "enforcement strength for agent safety" dojo-conduct/SKILL.md

echo "wave-2 asserts: $pass ok, $fail failed"
[ "$fail" -eq 0 ]
