#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

echo "Formatting the codebase..."

# This assumes you have a formatting script defined in your root package.json
# or that you have a tool like Prettier installed.
# If not, you might need to install it: pnpm add -w prettier
pnpm turbo run format
