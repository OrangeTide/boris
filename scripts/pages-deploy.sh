#!/bin/sh
#
# pages-deploy.sh -- Build and serve documentation locally
#
# Usage: ./scripts/pages-deploy.sh [port]
#
# Builds the docs, then starts a local HTTP server for preview.
# Press Ctrl-C to stop the server.

set -eu

PORT="${1:-8000}"
SITE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="$SITE_DIR/_build/docs"

echo "==> Building docs..."
"$SITE_DIR/scripts/pages-build.sh" "$OUT_DIR"

echo ""
echo "==> Serving at http://localhost:$PORT/"
echo "    Press Ctrl-C to stop."
echo ""

cd "$OUT_DIR"
if command -v python3 >/dev/null 2>&1; then
	python3 -m http.server "$PORT"
elif command -v python >/dev/null 2>&1; then
	python -m SimpleHTTPServer "$PORT"
else
	echo "No python found. Open $OUT_DIR/index.html directly." >&2
	exit 1
fi
