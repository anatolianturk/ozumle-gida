#!/bin/bash

LANGUAGES=("tr" "en")

rm -rf ../../dist && mkdir -p ../../dist

generate_html() {
    local lang="$1"
    local title="$2"
    local description="$3"
    local keywords="$4"

    cat << EOF
<!DOCTYPE html>
<html lang="$lang">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${title}</title>
  <meta name="description" content="${description}">
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

extract_value() {
    local json="$1"
    local key="$2"
    local page="$3"
    echo "$json" | jq -r ".pages.\"$page\".\"$key\"" 2>/dev/null || echo ""
}

for lang in "${LANGUAGES[@]}"; do
    site_json_path="./data/${lang}/site.json"

    if [ ! -f "$site_json_path" ]; then
        echo "⚠️ Warning: $site_json_path not found, skipping $lang"
        continue
    fi

    echo "🔤 Processing language: $lang"

    site_json=$(cat "$site_json_path")
    pages=$(echo "$site_json" | jq -r '.pages | keys[]')

    for page in $pages; do
        title=$(extract_value "$site_json" "title" "$page")
        description=$(extract_value "$site_json" "description" "$page")
        keywords=$(extract_value "$site_json" "keywords" "$page")

        title="${title:-Untitled}"
        description="${description:-No description}"
        keywords="${keywords:-}"

        echo "📄 Generating page: $page ($lang)"
        
        output_file="../../dist/$lang/${page}.html"
        mkdir -p "$(dirname "$output_file")"

        generate_html "$lang" "$title" "$description" "$keywords" > "$output_file"

        echo "✓ Created $(basename "$output_file") in dist/$lang"
    done
done

echo "==========================================="
echo "✅ All pages for all languages have been generated successfully!"
