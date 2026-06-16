#!/usr/bin/env bash
# dojo-lint — internal consistency checks for the Dojo skill package.
# Enforce over instruct, applied to Dojo itself. Run from the package root.
set -u
FAIL=0
say() { printf '%s\n' "$*"; }
err() { say "FAIL: $*"; FAIL=1; }

FILES=$(ls */SKILL.md 2>/dev/null; ls README.md DOJO-MANUAL.md 2>/dev/null)
[ -z "$FILES" ] && { say "dojo-lint: run from the package root."; exit 2; }

# R1 — banned stale tokens
for tok in 'task_plan' 'root cause from diagnose'; do
  hits=$(grep -rn -- "$tok" $FILES 2>/dev/null || true)
  [ -n "$hits" ] && err "stale token '$tok':"$'\n'"$hits"
done

# R2 — duplicate H2 headings within a file
for f in $FILES; do
  dups=$(grep -E '^## ' "$f" | sort | uniq -d)
  [ -n "$dups" ] && err "duplicate H2 in $f:"$'\n'"$dups"
done

# R3 — dangling section: a bold-only line whose next non-blank line is '---' or EOF
for f in $FILES; do
  awk -v file="$f" '
    /^\*\*[^*]+\*\*$/ { pend=$0; pline=NR; next }
    pend && /^[[:space:]]*$/ { next }
    pend { if ($0 ~ /^---[-]*$/) printf "FAILROW %s:%d: dangling bold section: %s\n", file, pline, pend; pend="" }
    END { if (pend) printf "FAILROW %s:%d: dangling bold section at EOF: %s\n", file, pline, pend }
  ' "$f" | while read -r row; do :; done
  rows=$(awk '
    /^\*\*[^*]+\*\*$/ { pend=$0; pline=NR; next }
    pend && /^[[:space:]]*$/ { next }
    pend { if ($0 ~ /^---[-]*$/) printf "%d: %s\n", pline, pend; pend="" }
    END { if (pend) printf "%d (EOF): %s\n", pline, pend }
  ' "$f")
  [ -n "$rows" ] && err "dangling bold section in $f:"$'\n'"$rows"
done

# R4 — referenced skill names must exist as directories (artifact names whitelisted)
WHITELIST="dojo-check dojo-check-fast dojo-session dojo-lint dojo-skills"
refs=$(sed 's/(#[a-z0-9-]*)//g' $FILES | grep -hoE '\b(dojo|kata|hajime)-[a-z][a-z-]*[a-z]\b' | sort -u)
for r in $refs; do
  case " $WHITELIST " in *" $r "*) continue;; esac
  [ -d "$r" ] || err "reference to non-existent skill '$r'"
done

# R5 — step values written by skills must be in the enum
ENUM="RED GREEN REFACTOR COMMIT STUCK DONE"
steps=$(grep -rhoE '^\s*step: [A-Z]+' */SKILL.md | awk '{print $2}' | sort -u)
for s in $steps; do
  case " $ENUM " in *" $s "*) ;; *) err "step value '$s' outside enum ($ENUM)";; esac
done

# R6 — canonical dojo-check template: hajime's block and the manual's must be identical
extract() { awk '/^```bash$/{b=1;buf="";next} /^```$/{if(b){if(buf ~ /check-proof/){print buf; exit}};b=0;next} b{buf=buf $0 "\n"}' "$1"; }
A=$(extract hajime/SKILL.md); B=$(extract DOJO-MANUAL.md)
if [ -z "$A" ] || [ -z "$B" ]; then err "canonical dojo-check block missing (hajime: $([ -n "$A" ] && echo found || echo MISSING); manual: $([ -n "$B" ] && echo found || echo MISSING))"
elif [ "$A" != "$B" ]; then err "canonical dojo-check template differs between hajime/SKILL.md and DOJO-MANUAL.md"; fi

# R7 — mode/rigor enums in skills (placeholder lines with '[' are skipped)
bad=$(grep -rhE '^\s*(mode|rigor): ' */SKILL.md | grep -v '\[' | grep -vE ': (supervised|autonomous|real|poc)\b' || true)
[ -n "$bad" ] && err "mode/rigor value outside enum:"$'\n'"$bad"

# R8 — PowerShell dojo-check reference exists and still carries the proof contract
PS1=hajime/reference/dojo-check.ps1
if [ ! -f "$PS1" ]; then err "missing $PS1"
else
  for marker in 'check-proof' 'output_sha256' 'check-output.log'; do
    grep -q -- "$marker" "$PS1" || err "$PS1 missing marker '$marker'"
  done
fi

# R9 — tanren reference exists and still carries its safety-critical markers
TR=tanren/reference/tanren-loop.md
if [ ! -f "$TR" ]; then err "missing $TR"
else
  for marker in 'held-out' 'FROZEN' 'results.tsv' 'gaming'; do
    grep -qi -- "$marker" "$TR" || err "$TR missing marker '$marker'"
  done
fi

if [ "$FAIL" -eq 0 ]; then say "dojo-lint: PASS — all consistency checks green."; exit 0
else say "dojo-lint: FAIL — fix the findings above."; exit 1; fi
