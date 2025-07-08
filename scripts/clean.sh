#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

echo "Cleaning the project..."

# Remove all node_modules directories
find . -name "node_modules" -type d -prune -exec rm -rf '{}' +

# Remove all .next directories from Next.js apps
find . -name ".next" -type d -prune -exec rm -rf '{}' +

# Remove turborepo cache
rm -rf .turbo

echo "Project cleaned."
