# S2 — Brownfield adoption (pre-existing failure tracked, not owned)

**Setup:** scratch repo with a tiny project whose test suite has ONE deliberately failing test
(unrelated to the feature below) committed before Dojo touches it.

**Replay:**
1. `/hajime Add a --version flag that prints 1.0.0.` → real · supervised · design not done.
2. At the baseline step, choose **proceed with no-new-failures** (decline stabilization wave 0).
3. Run one full wave through `/kata-commit` ("Commit now").
4. Run `bash <path>/s2-assert.sh` in the repo.

**Watch:** the agent never "fixes" the unrelated failure, and gates state "no NEW failures"
rather than "all green".
