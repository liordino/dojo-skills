#!/usr/bin/env bash
# install-parity — content-parity check between this repo's skill directories and an
# installed skills directory (the runtime copies an agent actually loads).
#
#   scripts/install-parity.sh <installed-skills-dir>
#
# Exit codes: 0 parity · 1 drift detected · 2 usage error.
#
# The invariant is CONTENT parity, not byte parity: the install path may normalize
# line endings (observed: repo LF → installed CRLF), and that is not drift. Anything
# else is reported per file:
#   MISSING: <skill>/<path>   in the repo, absent from the install (stale install)
#   DRIFT: <skill>/<path>     present on both sides, content differs
#   EXTRA: <skill>/<path>     in the install only (leftover from a renamed/deleted file)
#
# Reports only: never mutates the target directory. Foreign skills installed alongside
# (directories that do not exist in this repo) are ignored — only repo-owned skill
# directories are compared.
set -u

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
[ $# -eq 1 ] || {
	echo "usage: scripts/install-parity.sh <installed-skills-dir>" >&2
	exit 2
}
TARGET="$1"
[ -d "$TARGET" ] || {
	echo "install-parity: target dir not found: $TARGET" >&2
	exit 2
}

drift=0
for src in "$REPO_ROOT"/*/SKILL.md; do
	[ -e "$src" ] || continue
	skill_dir="$(dirname "$src")"
	name="$(basename "$skill_dir")"
	dst="$TARGET/$name"
	skill_drift=0
	if [ ! -d "$dst" ]; then
		echo "MISSING: $name/"
		drift=1
		skill_drift=1
	fi
	# Relative paths of every repo-side file; diff each against the target.
	if [ -d "$dst" ]; then
		while IFS= read -r f; do
			rel="${f#"$skill_dir"/}"
			if [ ! -e "$dst/$rel" ]; then
				echo "MISSING: $name/$rel"
				drift=1
				skill_drift=1
			elif ! diff -q --strip-trailing-cr "$f" "$dst/$rel" >/dev/null 2>&1; then
				echo "DRIFT: $name/$rel"
				drift=1
				skill_drift=1
			fi
		done < <(find "$skill_dir" -type f | sort)
		# Target-side files with no repo counterpart are leftovers, not drift in content.
		while IFS= read -r f; do
			rel="${f#"$dst"/}"
			if [ ! -e "$skill_dir/$rel" ]; then
				echo "EXTRA: $name/$rel"
				drift=1
				skill_drift=1
			fi
		done < <(find "$dst" -type f | sort)
	fi
	[ "$skill_drift" -eq 0 ] && echo "OK: $name"
done

if [ $drift -eq 1 ]; then
	echo "install-parity: DRIFT detected — refresh the install (npx skills add liordino/dojo-skills)"
	exit 1
fi
echo "install-parity: content parity — install matches the repo"
exit 0
