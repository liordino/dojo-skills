#!/usr/bin/env bash
# Dojo mechanics eval — fully automated, no agent required.
# Tests the deterministic enforcement layer AS SHIPPED:
#   the canonical dojo-check template is extracted live from hajime/SKILL.md,
#   so if the canonical block drifts, this eval fails loudly.
# Dev-side tool: assumes GNU coreutils (date -d, stat -c). Run from package root.
# Also exercises scripts/install-parity.sh against a fixture install (content parity,
# including CRLF normalization — the deploy edge may rewrite line endings; that is not drift).
set -u
PASS=0
FAILN=0
ok() {
  echo "  ok: $*"
  PASS=$((PASS + 1))
}
die() {
  echo "  FAIL: $*"
  FAILN=$((FAILN + 1))
}

ROOT="$(pwd)"
[ -f "$ROOT/hajime/SKILL.md" ] || {
  echo "run from the package root"
  exit 2
}
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "== Fixture repo =="
cd "$TMP"
git init -q . && git config user.email d@d && git config user.name dojo
mkdir -p src scripts
echo "hello" >src/app.txt
printf '.dojo/session/\n.dojo/proof/\n.dojo/tanren/\n' >.gitignore

echo "== Extract canonical template from hajime/SKILL.md =="
awk '/^```bash$/{b=1;buf="";next} /^```$/{if(b){if(buf ~ /check-proof/){print buf; exit}};b=0;next} b{buf=buf $0 "\n"}' \
  "$ROOT/hajime/SKILL.md" >scripts/dojo-check.sh
[ -s scripts/dojo-check.sh ] && ok "canonical block extracted" || die "canonical block not found"

# Swap ONLY the three stack commands (the template's own contract).
sed -i \
  -e 's#^  cargo build 2>&1$#  echo build-ok#' \
  -e 's#^  cargo clippy -- -D warnings 2>&1$#  echo lint-ok#' \
  -e 's#^  cargo test 2>&1$#  grep -q hello src/app.txt \&\& echo test-ok#' \
  scripts/dojo-check.sh
grep -q cargo scripts/dojo-check.sh &&
  die "canonical command lines changed in hajime — update this eval's sed swaps" ||
  ok "three stack commands swapped cleanly"
chmod +x scripts/dojo-check.sh
git add -A && git commit -qm "fixture"

fresh() { # kata-commit's freshness rule, implemented as specified
  local pt pe newest m f
  pt=$(grep '^ts=' .dojo/proof/check-proof | cut -d= -f2) || return 2
  pe=$(date -d "$pt" +%s) || return 2
  newest=0
  for f in $(git ls-files); do
    m=$(stat -c %Y "$f")
    [ "$m" -gt "$newest" ] && newest=$m
  done
  [ "$newest" -le "$pe" ]
}

echo "== Green run: proof produced and valid =="
./scripts/dojo-check.sh >/dev/null 2>&1
[ $? -eq 0 ] && ok "exit 0 on green" || die "green run did not exit 0"
[ -f .dojo/proof/check-proof ] && ok "proof written" || die "proof missing"
want=$(sha256sum .dojo/proof/check-output.log | awk '{print $1}')
got=$(grep '^output_sha256=' .dojo/proof/check-proof | cut -d= -f2)
[ "$want" = "$got" ] && ok "proof sha matches output log" || die "proof sha mismatch"
date -d "$(grep '^ts=' .dojo/proof/check-proof | cut -d= -f2)" >/dev/null 2>&1 &&
  ok "proof ts parseable" || die "proof ts unparseable"
fresh && ok "freshness rule: fresh right after run" || die "fresh proof reported stale"

echo "== Edit after run: rule must flag stale =="
sleep 1
echo "more" >>src/app.txt
fresh && die "stale proof reported fresh" || ok "freshness rule: edit detected as stale"

echo "== Re-run restores freshness =="
./scripts/dojo-check.sh >/dev/null 2>&1 && fresh &&
  ok "re-run restores fresh proof" || die "re-run failed or still stale"

echo "== Red run: gate must stay blocked =="
sleep 1
sed -i 's/hello/goodbye/' src/app.txt
old=$(grep '^ts=' .dojo/proof/check-proof)
if ./scripts/dojo-check.sh >/dev/null 2>&1; then die "check passed on broken fixture"; else ok "exit nonzero on failure"; fi
[ "$old" = "$(grep '^ts=' .dojo/proof/check-proof)" ] && ok "proof NOT rewritten on failure" || die "proof rewritten on failure"
fresh && die "blocked state reported fresh" || ok "freshness rule: commit gate correctly blocked"

echo "== Install parity: repo→runtime drift is detectable =="
PARITY="$ROOT/scripts/install-parity.sh"
if [ ! -x "$PARITY" ]; then
	die "install-parity.sh missing or not executable"
else
	INST="$TMP/install"
	mkdir -p "$INST"
	for d in "$ROOT"/*/; do
		[ -f "${d}SKILL.md" ] && cp -r "$d" "$INST/"
	done
	"$PARITY" "$INST" >/dev/null 2>&1 &&
		ok "fresh fixture install: exit 0, no drift" ||
		die "fresh fixture install reported drift"
	first_md=$(find "$INST" -name SKILL.md | head -1)
	sed -i 's/$/\r/' "$first_md"
	"$PARITY" "$INST" >/dev/null 2>&1 &&
		ok "CRLF-normalized copy still exits 0 (content parity, not byte parity)" ||
		die "EOL normalization flagged as drift"
	printf 'drift line\n' >>"$first_md"
	out=$("$PARITY" "$INST" 2>&1)
	rc=$?
	[ $rc -ne 0 ] && echo "$out" | grep -q 'DRIFT:' &&
		ok "stale content: nonzero exit + DRIFT line" ||
		die "stale content not detected (rc=$rc)"
	first_skill=$(basename "$(dirname "$first_md")")
	rm -rf "$INST/${first_skill:?}"
	out=$("$PARITY" "$INST" 2>&1)
	rc=$?
	[ $rc -ne 0 ] && echo "$out" | grep -q 'MISSING:' &&
		ok "missing skill dir: nonzero exit + MISSING line" ||
		die "missing skill dir not detected (rc=$rc)"
	second_skill=$(find "$INST" -mindepth 1 -maxdepth 1 -type d | head -1)
	touch "$second_skill/stray-file.txt"
	out=$("$PARITY" "$INST" 2>&1)
	rc=$?
	[ $rc -ne 0 ] && echo "$out" | grep -q 'EXTRA:' &&
		ok "extra file in skill dir: nonzero exit + EXTRA line" ||
		die "extra file not detected (rc=$rc)"
	cp -r "$INST" "$TMP/install.snapshot"
	"$PARITY" "$INST" >/dev/null 2>&1
	if diff -r "$INST" "$TMP/install.snapshot" >/dev/null 2>&1; then
		ok "reports only: install dir untouched by a run"
	else
		die "install dir was mutated by a run"
	fi
	"$PARITY" >/dev/null 2>&1
	rc=$?
	[ $rc -eq 2 ] && ok "usage error (no target dir): exit 2" || die "missing-arg run exited $rc, expected 2"
fi

echo
echo "mechanics eval: $PASS ok, $FAILN failed"
[ "$FAILN" -eq 0 ] && {
  echo "RESULT: PASS"
  exit 0
} || {
  echo "RESULT: FAIL"
  exit 1
}
