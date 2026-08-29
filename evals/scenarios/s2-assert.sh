#!/usr/bin/env bash
set -u; F=0; ok(){ echo "  ok: $*"; }; die(){ echo "  FAIL: $*"; F=1; }
v=$(grep '^pre_existing_failures:' dojo-session.md | cut -d: -f2- | xargs)
[ -n "$v" ] && [ "$v" != "none" ] && ok "pre_existing_failures recorded: $v" || die "pre-existing failure not recorded"
[ "$(git log --oneline | wc -l)" -ge 2 ] && ok "wave committed on top of baseline" || die "no new commit"
[ -f .dojo/check-proof ] && ok "proof exists despite red baseline" || die "proof missing"
grep -qi 'wave 1' progress.md && ok "progress logged" || die "progress missing"
[ $F -eq 0 ] && echo "S2: PASS" || { echo "S2: FAIL"; exit 1; }
