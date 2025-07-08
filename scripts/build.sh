#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

echo "Building all packages and applications..."

# Use turborepo to build everything
pnpm turbo run build
