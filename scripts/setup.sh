#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

echo "Setting up the development environment..."

# Install all dependencies using pnpm
pnpm install

echo "Setup complete. You can now run 'pnpm dev' to start the development servers."
