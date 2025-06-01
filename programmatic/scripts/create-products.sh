#!/bin/bash

LANGUAGES=("tr" "en")
DIST_BASE="../../dist"
DATA_BASE="../../data"

generate_html() {
    local lang="$1"
    local title="$2"
    local desc="$3"
    local keywords="$4"

    cat << EOF
<!DOCTYPE html>
<html lang="$lang">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${title}</title>
  <meta name="description" content="${desc}">
  <meta name="keywords" content="${keywords}">
  <link rel="stylesheet" href="/static/site.css"/>
  <link rel="icon" href="/favicon.png" type="image/png"/>
</head>
<body>
  <div id="loading">loading...</div>
  <script src="/static/site.js"></script>
</body>
</html>
EOF
}

for lang in "${LANGUAGES[@]}"; do
    JSON_FILE="${DATA_BASE}/${lang}/products.json"
    DIST_DIR="${DIST_BASE}/${lang}/products"

    if [ ! -f "$JSON_FILE" ]; then
        echo "⚠️ Skipping $lang: $JSON_FILE not found"
        continue
    fi

    echo "🌐 Processing products for language: $lang"

    rm -rf "$DIST_DIR" && mkdir -p "$DIST_DIR"

    if ! jq '.' "$JSON_FILE" > /dev/null 2>&1; then
        echo "❌ Invalid JSON format in $JSON_FILE"
        continue
    fi

    jq -c '.products[]' "$JSON_FILE" | while read -r product; do
        name=$(echo "$product" | jq -r '.name')
        url=$(echo "$product" | jq -r '.url')
        meta_desc=$(echo "$product" | jq -r '.metaDesc')
        meta_keywords=$(echo "$product" | jq -r '.keywords')

        title="${name} | Özüm'le"

        echo "📦 Creating: $url.html ($lang)"

        output_file="${DIST_DIR}/${url}.html"
        generate_html "$lang" "$title" "$meta_desc" "$meta_keywords" > "$output_file"

        echo "✓ Created $(basename "$output_file")"
    done
done

echo "======================================================="
echo "✅ All product pages for all languages generated!"
