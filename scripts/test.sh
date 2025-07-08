#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

echo "Running all tests..."

# Use turborepo to run tests in all packages
pnpm turbo run test
