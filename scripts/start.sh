#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting development servers..."

# This command is typically used to run all dev scripts in a turborepo setup
pnpm dev
