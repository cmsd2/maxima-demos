#!/usr/bin/env bash
# Build notebooks: execute cells to generate outputs, then export to HTML.
#
# Usage: ./build.sh [--pdf] [notebook.macnb ...]
#
# With no notebook arguments, builds all notebooks in notebooks/.
# With arguments, builds only the specified notebook(s).
#
# Requires:
#   - aximar-mcp (from ../aximar/target/debug/ or on PATH)
#   - uv (for running nbconvert via the project's venv)

set -euo pipefail

AXIMAR_MCP="${AXIMAR_MCP:-aximar-mcp}"
OUTPUT_DIR="${OUTPUT_DIR:-docs/pages}"
FORMAT="maxima_html"

# Parse flags
args=()
for arg in "$@"; do
  if [[ "$arg" == "--pdf" ]]; then
    FORMAT="maxima_pdf"
  else
    args+=("$arg")
  fi
done

mkdir -p "$OUTPUT_DIR"

if [[ ${#args[@]} -gt 0 ]]; then
  # Build specified notebook(s)
  notebooks=("${args[@]}")
else
  # Build all notebooks (including subdirectories)
  shopt -s globstar nullglob
  notebooks=(notebooks/**/*.macnb)
  if [[ ${#notebooks[@]} -eq 0 ]]; then
    echo "No .macnb files found in notebooks/" >&2
    exit 1
  fi
fi

echo "==> Executing ${#notebooks[@]} notebook(s) with aximar-mcp..."
for nb in "${notebooks[@]}"; do
  echo "    $nb"
  "$AXIMAR_MCP" run --allow-dangerous "$nb"
done

echo "==> Exporting to ${FORMAT}..."
for nb in "${notebooks[@]}"; do
  name="$(basename "$nb" .macnb)"
  echo "    $nb -> $OUTPUT_DIR/$name"
  uv run jupyter nbconvert --to "$FORMAT" --output-dir "$OUTPUT_DIR" --output "$name" "$nb"
done

echo "==> Generating index.html..."
cat > "$OUTPUT_DIR/index.html" <<'HEADER'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Maxima Demos</title>
<style>
  body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif; max-width: 640px; margin: 2rem auto; padding: 0 1rem; color: #333; }
  h1 { font-size: 1.5rem; border-bottom: 1px solid #ddd; padding-bottom: 0.5rem; }
  h2 { font-size: 1.1rem; margin-top: 1.5rem; color: #555; }
  ul { list-style: none; padding: 0; }
  li { margin: 0.3rem 0; }
  a { color: #0366d6; text-decoration: none; }
  a:hover { text-decoration: underline; }
  footer { margin-top: 2rem; border-top: 1px solid #ddd; padding-top: 0.5rem; font-size: 0.85rem; color: #888; }
</style>
</head>
<body>
<h1>Maxima Demos</h1>
<p>Interactive notebooks showcasing scientific computing with
<a href="https://maxima.sourceforge.io">Maxima</a>.</p>
HEADER

# Group HTML files by notebook subdirectory
declare -A sections
shopt -s nullglob
for nb in notebooks/**/*.macnb; do
  name="$(basename "$nb" .macnb)"
  html="$OUTPUT_DIR/$name.html"
  [[ -f "$html" ]] || continue
  section="$(basename "$(dirname "$nb")")"
  sections[$section]+="$name"$'\n'
done

# Pretty-print section names and emit links
for section in $(echo "${!sections[@]}" | tr ' ' '\n' | sort); do
  label="$(echo "$section" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')"
  echo "<h2>$label</h2>" >> "$OUTPUT_DIR/index.html"
  echo "<ul>" >> "$OUTPUT_DIR/index.html"
  echo "${sections[$section]}" | sort | while read -r name; do
    [[ -z "$name" ]] && continue
    title="$(echo "$name" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')"
    echo "  <li><a href=\"$name.html\">$title</a></li>" >> "$OUTPUT_DIR/index.html"
  done
  echo "</ul>" >> "$OUTPUT_DIR/index.html"
done

cat >> "$OUTPUT_DIR/index.html" <<'FOOTER'
<footer>Built with <a href="https://github.com/cmsd2/aximar">Aximar</a>.
Licensed under <a href="https://creativecommons.org/publicdomain/zero/1.0/">CC0 1.0</a>.</footer>
</body>
</html>
FOOTER

echo "==> Done. Output in $OUTPUT_DIR/"
