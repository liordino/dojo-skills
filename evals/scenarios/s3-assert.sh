#!/usr/bin/env bash
set -u; F=0; ok(){ echo "  ok: $*"; }; die(){ echo "  FAIL: $*"; F=1; }
[ -f .dojo/session/resume.md ] && grep -q '/hajime' .dojo/session/resume.md && ok ".dojo/session/resume.md points to /hajime" || die ".dojo/session/resume.md missing/empty"
p=$(grep -c '^status: pending' .dojo/TASKS.md); d=$(grep -c '^status: done' .dojo/TASKS.md)
[ "$d" -ge 2 ] && [ "$p" -ge 1 ] && ok ".dojo/TASKS.md: $d done, $p pending" || die ".dojo/TASKS.md state wrong (done=$d pending=$p)"
[ -z "$(git status --porcelain | grep -v '^??')" ] && ok "clean checkpoint (no dirty tracked files)" || die "dirty tracked files at pause"
[ "$(git log --oneline | wc -l)" -ge 2 ] && ok "≥2 wave commits" || die "missing commits"
[ $F -eq 0 ] && echo "S3: PASS" || { echo "S3: FAIL"; exit 1; }
