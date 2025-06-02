#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting update process..."
echo "Current date and time (UTC): $(date -u '+%Y-%m-%d %H:%M:%S')"
echo "Running as user: $(whoami)"

SCRIPTS=("create-pages.sh" "create-products.sh" "merge-js.sh")

for script in "${SCRIPTS[@]}"; do
    script_path="$SCRIPT_DIR/$script"
    if [ -f "$script_path" ]; then
        echo "Setting executable permissions for $script"
        chmod +x "$script_path"
    else
        echo "❌ Error: $script not found in $SCRIPT_DIR"
        exit 1
    fi
done

for script in "${SCRIPTS[@]}"; do
    script_path="$SCRIPT_DIR/$script"
    echo ""
    echo "▶️ Running $script..."
    if "$script_path"; then
        echo "✅ $script completed successfully."
    else
        echo "❌ Error: $script failed with exit code $?."
        exit 1
    fi
done

echo ""
echo "🎉 Update process completed successfully!"
exit 0
