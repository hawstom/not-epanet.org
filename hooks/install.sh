#!/bin/sh
# install.sh -- copy this directory's hooks into .git/hooks.
#
# A COPY, NOT core.hooksPath. hooksPath resolves into the working tree, so checking out a commit
# from before the hooks existed silently deletes every guard -- measured in the engcalcs repository,
# where a commit reached master unrefused for exactly that reason. It failed open and silently,
# which is the worst way for a guard to fail. The copy survives every checkout; `check.sh` reports
# it when the copy has gone stale.
set -e
here=$(cd "$(dirname "$0")" && pwd)
root=$(git -C "$here" rev-parse --show-toplevel)
dst=$(git -C "$root" rev-parse --git-path hooks)
mkdir -p "$dst"
for h in "$here"/*; do
	n=$(basename "$h")
	[ "$n" = "install.sh" ] && continue
	if [ -f "$dst/$n" ] && cmp -s "$h" "$dst/$n"; then echo "same      $dst/$n"
	else cp "$h" "$dst/$n" && chmod +x "$dst/$n" && echo "installed $dst/$n"; fi
done
