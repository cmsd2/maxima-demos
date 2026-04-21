#!/usr/bin/env bash
# Generate docs/pages/index.html from built HTML files.
set -euo pipefail

OUTPUT_DIR="${OUTPUT_DIR:-docs/pages}"

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
shopt -s nullglob globstar
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
