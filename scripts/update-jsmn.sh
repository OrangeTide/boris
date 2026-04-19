#!/bin/sh
# Update the vendored copy of jsmn from upstream.
#
# Usage:
#   scripts/update-jsmn.sh           # fetch latest master
#   scripts/update-jsmn.sh <ref>     # fetch a specific tag/branch/commit
#
# Vendored files live in src/thirdparty/jsmn/. Only jsmn.h, LICENSE,
# and README.md are kept; the upstream tests/examples are discarded.

set -eu

REPO="https://github.com/zserge/jsmn.git"
REF="${1:-master}"

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
root_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
dest="$root_dir/src/thirdparty/jsmn"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "Cloning $REPO ($REF) ..."
git clone --quiet --depth 50 "$REPO" "$tmp/jsmn"
git -C "$tmp/jsmn" checkout --quiet "$REF"

commit=$(git -C "$tmp/jsmn" rev-parse HEAD)
described=$(git -C "$tmp/jsmn" describe --tags --always 2>/dev/null || echo "$commit")
date=$(git -C "$tmp/jsmn" log -1 --format=%cs)

mkdir -p "$dest"
install -m 0644 "$tmp/jsmn/jsmn.h"     "$dest/jsmn.h"
install -m 0644 "$tmp/jsmn/LICENSE"    "$dest/LICENSE"
install -m 0644 "$tmp/jsmn/README.md"  "$dest/README.md"

cat > "$dest/UPSTREAM" <<EOF
repo:   $REPO
commit: $commit
ref:    $REF ($described)
date:   $date

Vendored files: jsmn.h, LICENSE, README.md
Update with: scripts/update-jsmn.sh
EOF

echo "Updated jsmn to $described ($commit)"
