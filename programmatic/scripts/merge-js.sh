#!/bin/bash

# Read 
helper_content=$(cat ./programmatic/helper.js)
basket_content=$(cat ./programmatic/basket.js)
pages_content=$(cat ./programmatic/pages.js)
product_content=$(cat ./programmatic/product.js)
main_content=$(cat ./programmatic/main.js)

# Merge
output_file="./static/site.js"
echo "$main_content" > "$output_file"
echo "$helper_content" >> "$output_file"
echo "$basket_content" >> "$output_file"
echo "$pages_content" >> "$output_file"
echo "$product_content" >> "$output_file"

echo "Merged files into $output_file"