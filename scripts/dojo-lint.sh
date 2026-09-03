#!/usr/bin/env bash
# dojo-lint — internal consistency checks for the Dojo skill package.
# Enforce over instruct, applied to Dojo itself. Run from the package root.
set -u
FAIL=0
say() { printf '%s\n' "$*"; }
err() {
	say "FAIL: $*"
	FAIL=1
}

FILES=$(
	ls */SKILL.md 2>/dev/null
	ls README.md DOJO-MANUAL.md 2>/dev/null
)
[ -z "$FILES" ] && {
	say "dojo-lint: run from the package root."
	exit 2
}

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
	case " $WHITELIST " in *" $r "*) continue ;; esac
	[ -d "$r" ] || err "reference to non-existent skill '$r'"
done

# R5 — step values written by skills must be in the enum
ENUM="RED GREEN REFACTOR COMMIT STUCK DONE"
steps=$(grep -rhoE '^\s*step: [A-Z]+' */SKILL.md | awk '{print $2}' | sort -u)
for s in $steps; do
	case " $ENUM " in *" $s "*) ;; *) err "step value '$s' outside enum ($ENUM)" ;; esac
done

# R10 — dojo-check proof-contract identifiers must appear in every normative surface
# (ADR 0001 — proof contract is single-sourced in dojo-principles; every other surface
# references the same identifiers). Replaces the R6 byte-equality check after Wave 1.
R10_FAIL=0
R10_SURFACES='dojo-principles/SKILL.md scripts/dojo-check.sh hajime/SKILL.md DOJO-MANUAL.md hajime/reference/dojo-check.ps1'
R10_MARKERS='check-proof output_sha256 check-output.log'
for sf in $R10_SURFACES; do
	if [ ! -f "$sf" ]; then
		err "R10: surface '$sf' missing"
		R10_FAIL=1
		continue
	fi
	for mk in $R10_MARKERS; do
		if ! grep -q -- "$mk" "$sf"; then
			err "R10: surface '$sf' does not reference proof-contract identifier '$mk'"
			R10_FAIL=1
		fi
	done
done
[ "$R10_FAIL" -eq 0 ] || err "R10: dojo-check proof-contract identifiers must appear in every surface (see ADR 0001)"

# R7 — mode/rigor enums in skills (placeholder lines with '[' are skipped)
bad=$(grep -rhE '^\s*(mode|rigor): ' */SKILL.md | grep -v '\[' | grep -vE ': (supervised|autonomous|real|poc)\b' || true)
[ -n "$bad" ] && err "mode/rigor value outside enum:"$'\n'"$bad"

# R8 — PowerShell dojo-check reference exists, still carries the proof contract, and its
# proof-contract field names match the canonical template in hajime/SKILL.md — extracted
# live (same awk run-mechanics.sh uses), so template or ps1 drift fails loudly instead of
# relying on a "keep in sync" comment.
PS1=hajime/reference/dojo-check.ps1
if [ ! -f "$PS1" ]; then
	err "missing $PS1"
else
	for marker in 'check-proof' 'output_sha256' 'check-output.log'; do
		grep -q -- "$marker" "$PS1" || err "$PS1 missing marker '$marker'"
	done
	canon_fields=$(awk '/^```bash$/{b=1;buf="";next} /^```$/{if(b){if(buf ~ /check-proof/){printf "%s", buf; exit}};b=0;next} b{buf=buf $0 "\n"}' hajime/SKILL.md |
		grep -oE '"[a-z_0-9]+=' | tr -d '"=' | sort -u)
	ps1_fields=$(grep -oE '"[a-z_0-9]+=' "$PS1" | tr -d '"' | sed 's/=$//' | sort -u)
	if [ "$canon_fields" != "$ps1_fields" ]; then
		err "$PS1 proof-contract fields diverge from canonical template: canonical=[$canon_fields] ps1=[$ps1_fields]"
	fi
	grep -q '"exit=0"' "$PS1" || err "$PS1 missing literal 'exit=0' (proof written only on green)"
fi

# R9 — tanren reference exists and still carries its safety-critical markers
TR=tanren/reference/tanren-loop.md
if [ ! -f "$TR" ]; then
	err "missing $TR"
else
	for marker in 'held-out' 'FROZEN' 'results.tsv' 'gaming'; do
		grep -qi -- "$marker" "$TR" || err "$TR missing marker '$marker'"
	done
fi

# R11 — every skill declares its invocation type per ADR 0002.
# Three categories (model-, user-, session-invoked); each skill is in exactly one.
# Model-invoked: must NOT carry `disable-model-invocation: true`.
# User-invoked: must carry `disable-model-invocation: true`.
# Session-invoked: must NOT carry the flag AND must carry a YAML comment of the form
#   `# invocation: session-invoked — see ADR 0002`
# above the `name:` field. The exact wording matches the grep regex below; if you
# change it here, update the regex.
#
# Single source of truth: R11_CLASSIFY below. If you add a new skill, add one entry.
R11_CLASSIFY='randori:user kaizen:user kan:user tanren:user kokai:user dojo-principles:session dojo-project:session dojo-conduct:session kata-red:model kata-green:model kata-commit:model hajime:model'
# Helper: print just the YAML front-matter (between the two --- fences).
R11_fm() {
	awk 'BEGIN{fm=0} /^---$/{if(fm==0){fm=1; next} else {exit}} fm==1{print}' "$1"
}
# Helper: look up a skill's category in R11_CLASSIFY; echoes user|session|model or "" if absent.
R11_category() {
	local name="$1"
	local match
	match=$(echo "$R11_CLASSIFY" | grep -oE "(^| )${name}:(user|session|model)( |$)" | head -1)
	if [ -z "$match" ]; then
		echo ""
	else
		echo "$match" | grep -oE ':(user|session|model)' | head -1 | tr -d ':'
	fi
}
R11_FAIL=0
for sf in */SKILL.md; do
	name=$(basename "$(dirname "$sf")")
	fm=$(R11_fm "$sf")
	if echo "$fm" | grep -qE '^disable-model-invocation:[[:space:]]*true'; then
		has_dmi=yes
	else
		has_dmi=no
	fi
	if echo "$fm" | grep -qE '^#[[:space:]]*invocation:[[:space:]]*session-invoked'; then
		has_inv=yes
	else
		has_inv=no
	fi
	category=$(R11_category "$name")
	case "$category" in
	user)
		[ "$has_dmi" = yes ] || {
			err "R11: $sf is user-invoked per ADR 0002 but lacks 'disable-model-invocation: true'"
			R11_FAIL=1
		}
		;;
	session)
		[ "$has_dmi" = no ] || {
			err "R11: $sf is session-invoked per ADR 0002 but carries 'disable-model-invocation: true'"
			R11_FAIL=1
		}
		[ "$has_inv" = yes ] || {
			err "R11: $sf is session-invoked per ADR 0002 but lacks the '# invocation: session-invoked — see ADR 0002' rationale comment"
			R11_FAIL=1
		}
		;;
	model)
		[ "$has_dmi" = no ] || {
			err "R11: $sf is model-invoked per ADR 0002 but carries 'disable-model-invocation: true'"
			R11_FAIL=1
		}
		;;
	*)
		err "R11: $sf is not classified in R11_CLASSIFY — add '<name>:<user|session|model>' to the table above"
		R11_FAIL=1
		;;
	esac
done
[ "$R11_FAIL" -eq 0 ] || err "R11: skill invocation rule (ADR 0002) is not satisfied"

# R12 — "skill → Section" cross-references must resolve to a real heading in that skill.
# Catches the eaten-heading class: an edit deletes/renames an H2 that other files point at
# (the bug class R3 was born from, now enforced for prose anchors). Substring match against
# H2/H3 lines, so a reference may name a heading's distinctive prefix.
R12_SKILLS='dojo-principles|dojo-project|dojo-conduct|hajime|randori|kan|tanren|kaizen|kokai|kata-red|kata-green|kata-commit'
refs=$(grep -rhoE "($R12_SKILLS) → [A-Za-z][A-Za-z0-9 '/-]*" $FILES | sort -u)
while IFS= read -r ref; do
	[ -z "$ref" ] && continue
	skill=${ref%% → *}
	section=$(printf '%s' "${ref#* → }" | sed 's/[[:space:]]*$//')
	[ -f "$skill/SKILL.md" ] || continue
	grep -E '^##+ ' "$skill/SKILL.md" | grep -qF -- "$section" ||
		err "R12: dangling cross-reference '$skill → $section' — no matching heading in $skill/SKILL.md"
done <<R12EOF
$refs
R12EOF

# R13 — no CR (\r) in tracked text content. CRLF in a shell script's shebang breaks execution
# on Linux ('/usr/bin/env: bash\r: No such file'); .gitattributes prevents the class at add
# time, this is the backstop for anything that slips past it. Checks the index (what will be
# committed), so Windows working-tree checkouts don't false-positive.
#
# Implementation note: Git Bash's command substitution ($()) mangles output when the search
# pattern is CR — `crlf=$(git grep ... $'\r' ...)` returns every file as a false positive.
# Pipe directly to `grep -q .` instead. The pipe boundary keeps Git's CR handling intact.
if git rev-parse --git-dir >/dev/null 2>&1; then
	if git grep --cached -Il $'\r' -- . 2>/dev/null | grep -q .; then
		crlf=$(git ls-files -z | xargs -0 grep -l $'\r' 2>/dev/null || true)
		err "R13: CR (\\r) in tracked file content:"$'\n'"$crlf"
	fi
fi

# R14 — repo scripts must be executable in the git index. Windows (core.filemode=false) cannot
# set this by chmod on the file; the fix is: git update-index --chmod=+x <file>
if git rev-parse --git-dir >/dev/null 2>&1; then
	for f in scripts/dojo-check.sh scripts/dojo-lint.sh evals/run-mechanics.sh evals/scenarios/*.sh; do
		[ -f "$f" ] || continue
		mode=$(git ls-files -s -- "$f" | awk '{print $1}')
		[ -z "$mode" ] && continue
		[ "$mode" = "100755" ] || err "R14: $f not executable in index (mode $mode) — run: git update-index --chmod=+x $f"
	done
fi

# R15 — CONTEXT.md carries exactly the randori contract: the three H2 sections
# (Glossary / Non-Goals / Decisions) and nothing else. Dogfoods the contract the
# skills teach; randori owns the contract, hajime verifies it at scaffold.
if [ -f CONTEXT.md ]; then
	h2s=$(grep -cE '^## ' CONTEXT.md)
	[ "$h2s" -eq 3 ] || err "R15: CONTEXT.md must have exactly 3 H2 sections (Glossary/Non-Goals/Decisions); found $h2s"
	for s in 'Glossary' 'Non-Goals' 'Decisions'; do
		grep -qE "^## $s" CONTEXT.md || err "R15: CONTEXT.md missing '## $s'"
	done
fi

if [ "$FAIL" -eq 0 ]; then
	say "dojo-lint: PASS — all consistency checks green."
	exit 0
else
	say "dojo-lint: FAIL — fix the findings above."
	exit 1
fi
