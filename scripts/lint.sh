#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

echo "Linting all packages and applications..."

# Use turborepo to run linting in all packages
pnpm turbo run lint
