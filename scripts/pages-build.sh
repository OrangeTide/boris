#!/bin/sh
#
# pages-build.sh -- Build HTML documentation from published markdown
#
# Usage: ./scripts/pages-build.sh [output_dir]
#
# Reads doc/published.txt for the list of documents to convert.
# Requires pandoc.

set -eu

SITE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="${1:-$SITE_DIR/_build/docs}"
DOC_DIR="$SITE_DIR/doc"
PUBLISHED="$DOC_DIR/published.txt"

if ! command -v pandoc >/dev/null 2>&1; then
	echo "Error: pandoc not found." >&2
	exit 1
fi

if [ ! -f "$PUBLISHED" ]; then
	echo "Error: $PUBLISHED not found." >&2
	exit 1
fi

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

TMPINDEX="$(mktemp)"
trap 'rm -f "$TMPINDEX"' EXIT

while IFS= read -r line || [ -n "$line" ]; do
	line="$(printf '%s' "$line" | sed 's/#.*//' | awk '{$1=$1}1')"
	[ -z "$line" ] && continue

	src="$DOC_DIR/$line"
	if [ ! -f "$src" ]; then
		echo "  warning: $src not found, skipping" >&2
		continue
	fi

	base="${line%.md}"
	out="$OUT_DIR/${base}.html"

	title="$(grep -m1 '^# ' "$src" | sed 's/^# //')"
	[ -z "$title" ] && title="$base"

	pandoc -s --toc --toc-depth=3 \
		--metadata "title=$title" \
		-f markdown -t html \
		--css=style.css \
		-o "$out" "$src"

	printf '<li><a href="%s.html">%s</a></li>\n' "$base" "$title" >> "$TMPINDEX"
	echo "  built: $line"
done < "$PUBLISHED"

cat > "$OUT_DIR/index.html" << INDEXEOF
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>boris -- Documentation</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<h1>boris -- Documentation</h1>
<ul>
$(cat "$TMPINDEX")
</ul>
</body>
</html>
INDEXEOF

cat > "$OUT_DIR/style.css" << 'CSSEOF'
body {
	max-width: 48em;
	margin: 2em auto;
	padding: 0 1em;
	font-family: system-ui, -apple-system, sans-serif;
	line-height: 1.6;
	color: #222;
}
code, pre {
	font-family: ui-monospace, "Cascadia Code", "Source Code Pro", monospace;
}
pre {
	background: #f5f5f5;
	padding: 1em;
	overflow-x: auto;
	border-radius: 4px;
}
h1, h2, h3 { margin-top: 1.5em; }
table {
	border-collapse: collapse;
	width: 100%;
	margin: 1em 0;
}
th, td {
	border: 1px solid #ddd;
	padding: 0.4em 0.8em;
	text-align: left;
}
th { background: #f5f5f5; }
nav#TOC {
	background: #f9f9f9;
	border: 1px solid #ddd;
	padding: 1em;
	margin-bottom: 2em;
	border-radius: 4px;
}
nav#TOC ul { margin: 0; padding-left: 1.5em; }
a { color: #0366d6; }
CSSEOF

echo ""
echo "Documentation built in: $OUT_DIR"
