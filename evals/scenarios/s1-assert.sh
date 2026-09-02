#!/usr/bin/env bash
set -u; F=0; ok(){ echo "  ok: $*"; }; die(){ echo "  FAIL: $*"; F=1; }
[ -f TASKS.md ] && grep -q '^intent:' TASKS.md && ok "TASKS.md with intent" || die "TASKS.md/intent missing"
awk '/^## Wave 1/{w=1} w&&/^status:/{print $2; exit}' TASKS.md | grep -qx done && ok "wave 1 status: done" || die "wave 1 not marked done"
grep -q '^wave: 2' dojo-session.md && grep -q '^step: RED' dojo-session.md && ok "session advanced to wave 2 / RED" || die "session not advanced"
grep -q '^goal: .' dojo-session.md && ok "next goal loaded" || die "goal empty"
[ "$(git log --oneline | wc -l)" -ge 1 ] && ok "commit exists" || die "no commit"
[ -f .dojo/check-proof ] && ok "proof exists" || die "proof missing"
grep -qx '.dojo/' .gitignore && grep -qx 'dojo-session.md' .gitignore && ok "gitignore entries" || die "gitignore incomplete"
grep -q '## Current State' HANDOFF.md && grep -q '## Improvement Backlog' HANDOFF.md && ! grep -q '## Wave History' HANDOFF.md && ok "HANDOFF snapshot sections (ADR 0004)" || die "HANDOFF incomplete"
grep -q '| wave 1 |' progress.md && ok "wave 1 logged in progress.md" || die "progress.md missing wave 1"
grep -q 'Opening Brief' learning-log.md && grep -q 'Closing Debrief' learning-log.md && ok "brief+debrief logged" || die "pedagogy missing"
[ -s progress.md ] && ok "progress.md written" || die "progress.md empty"
[ $F -eq 0 ] && echo "S1: PASS" || { echo "S1: FAIL"; exit 1; }
