# S3 — Autonomous run hits the wave ceiling

**Setup:** scratch repo. In `~/.config/dojo/preferences.md` (or by editing dojo-session.md
right after init) set `wave_ceiling: 2`.

**Replay:**
1. `/hajime Build a four-step pipeline: parse, validate, transform, write — one step per wave.`
   → real · **autonomous** · design not done. Steer randori to a 4-wave TASKS.md; confirm the
   plan; let it run.
2. It should complete 2 waves and pause cleanly. Run `bash <path>/s3-assert.sh` in the repo.

**Watch:** no gate stops during the run; the pause is a clean checkpoint, not a mid-wave stall.
