#!/usr/bin/env bash
set -euo pipefail

usage() {
	echo "Usage: $0 <user@host[:dir]> [tarball]"
	echo ""
	echo "Uploads and unpacks a boris release to a remote server via SSH."
	echo ""
	echo "Arguments:"
	echo "  user@host   SSH destination (e.g. deploy@myserver.com)"
	echo "  dir         Remote directory name (default: boris)"
	echo "  tarball     Path to release tarball (default: auto-detect latest)"
	echo ""
	echo "Examples:"
	echo "  $0 jon@myserver.com                  # deploy to ~/boris/"
	echo "  $0 jon@myserver.com:mud              # deploy to ~/mud/"
	echo "  $0 jon@myserver.com:mud release.tar.xz"
	echo ""
	echo "On first deploy, edit ~/<dir>/shared/boris.cfg for your environment."
	exit 1
}

if [ $# -lt 1 ]; then
	usage
fi

# split user@host:dir on the LAST colon after @
DEST="$1"
if [[ "$DEST" == *@*:* ]]; then
	REMOTE="${DEST%:*}"
	DEPLOY_DIR="${DEST##*:}"
else
	REMOTE="$DEST"
	DEPLOY_DIR="boris"
fi

if [ -z "$DEPLOY_DIR" ]; then
	DEPLOY_DIR="boris"
fi

# find tarball
if [ $# -ge 2 ]; then
	TARBALL="$2"
else
	cd "$(dirname "$0")/.."
	TARBALL=$(ls -t boris-*-linux-*.tar.xz 2>/dev/null | head -1)
	if [ -z "$TARBALL" ]; then
		echo "Error: No release tarball found. Run scripts/build-release first."
		exit 1
	fi
fi

if [ ! -f "$TARBALL" ]; then
	echo "Error: Tarball not found: $TARBALL"
	exit 1
fi

RELEASE_NAME=$(basename "$TARBALL" .tar.xz)
echo "Deploying ${RELEASE_NAME} to ${REMOTE}:~/${DEPLOY_DIR}/"

# upload tarball
echo "Uploading $(du -h "$TARBALL" | cut -f1)..."
scp "$TARBALL" "${REMOTE}:/tmp/${RELEASE_NAME}.tar.xz"

# unpack and link on remote
ssh "$REMOTE" bash -s "$RELEASE_NAME" "$DEPLOY_DIR" <<'REMOTE_SCRIPT'
set -euo pipefail

RELEASE_NAME="$1"
DEPLOY_DIR="$2"

mkdir -p ~/"$DEPLOY_DIR"/releases ~/"$DEPLOY_DIR"/shared/data/chars ~/"$DEPLOY_DIR"/shared/data/users ~/"$DEPLOY_DIR"/shared/data/muddb
cd ~/"$DEPLOY_DIR"

# unpack release
tar xJf "/tmp/${RELEASE_NAME}.tar.xz" -C releases/
rm "/tmp/${RELEASE_NAME}.tar.xz"

# symlink persistent data directories into release
for d in chars users muddb; do
	rm -rf "releases/${RELEASE_NAME}/data/$d"
	ln -sfn "../../../shared/data/$d" "releases/${RELEASE_NAME}/data/$d"
done

# handle config: copy sample on first deploy, then symlink
if [ ! -f shared/boris.cfg ] && [ -f "releases/${RELEASE_NAME}/boris.cfg" ]; then
	cp "releases/${RELEASE_NAME}/boris.cfg" shared/boris.cfg
	echo "NOTE: Copied sample boris.cfg to ~/${DEPLOY_DIR}/shared/boris.cfg -- edit it."
fi
if [ -f shared/boris.cfg ]; then
	ln -sf "../../shared/boris.cfg" "releases/${RELEASE_NAME}/boris.cfg"
fi

# update current symlink
ln -sfn "releases/${RELEASE_NAME}" current

echo ""
echo "Deployed to ~/${DEPLOY_DIR}/current/"
echo ""
echo "To initialize a new MUD with sample data:"
echo "  cd ~/${DEPLOY_DIR}/current && ./bin/muddb-tool import data/muddb sample/"
echo ""
echo "To run:"
echo "  cd ~/${DEPLOY_DIR}/current && ./bin/boris"
REMOTE_SCRIPT

echo "Done."
