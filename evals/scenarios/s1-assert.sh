#!/usr/bin/env bash
set -u; F=0; ok(){ echo "  ok: $*"; }; die(){ echo "  FAIL: $*"; F=1; }
[ -f .dojo/TASKS.md ] && grep -q '^intent:' .dojo/TASKS.md && ok ".dojo/TASKS.md with intent" || die ".dojo/TASKS.md/intent missing"
awk '/^## Wave 1/{w=1} w&&/^status:/{print $2; exit}' .dojo/TASKS.md | grep -qx done && ok "wave 1 status: done" || die "wave 1 not marked done"
grep -q '^wave: 2' .dojo/session/dojo-session.md && grep -q '^step: RED' .dojo/session/dojo-session.md && ok "session advanced to wave 2 / RED" || die "session not advanced"
grep -q '^goal: .' .dojo/session/dojo-session.md && ok "next goal loaded" || die "goal empty"
[ "$(git log --oneline | wc -l)" -ge 1 ] && ok "commit exists" || die "no commit"
[ -f .dojo/proof/check-proof ] && ok "proof exists" || die "proof missing"
grep -q 'tracking posture' .dojo/CONTEXT.md && ok "tracking posture recorded" || die "tracking posture not recorded in .dojo/CONTEXT.md"
[ -z "$(git ls-files .dojo/session .dojo/proof .dojo/tanren)" ] && ok "ephemeral tier untracked" || die "ephemeral tier tracked under default posture"
grep -q '## Improvement Backlog' .dojo/TASKS.md && grep -q 'not a plan' .dojo/TASKS.md && ok "TASKS Improvement Backlog (relocated from HANDOFF)" || die "TASKS backlog missing"
grep -q '| wave 1 |' .dojo/progress.md && ok "wave 1 logged in .dojo/progress.md" || die ".dojo/progress.md missing wave 1"
grep -q 'Opening Brief' .dojo/learning-log.md && grep -q 'Closing Debrief' .dojo/learning-log.md && ok "brief+debrief logged" || die "pedagogy missing"
[ -s .dojo/progress.md ] && ok ".dojo/progress.md written" || die ".dojo/progress.md empty"
[ $F -eq 0 ] && echo "S1: PASS" || { echo "S1: FAIL"; exit 1; }
