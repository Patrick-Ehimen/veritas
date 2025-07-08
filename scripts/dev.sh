#!/bin/bash
# filepath: /Users/apple/Documents/fullstack-engineer/veritas/scripts/dev.sh

set -e

# Get the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function usage() {
  echo "Usage: $0 [command]"
  echo ""
  echo "Commands:"
  echo "  install      Install all dependencies"
  echo "  build        Build all packages"
  echo "  test         Run all tests"
  echo "  lint         Run linter"
  echo "  format       Format codebase"
  echo "  clean        Remove build artifacts"
  echo "  start        Start development server"
  echo "  help         Show this help message"
}

case "$1" in
  install)
    bash "${SCRIPT_DIR}/setup.sh"
    ;;
  build)
    bash "${SCRIPT_DIR}/build.sh"
    ;;
  test)
    bash "${SCRIPT_DIR}/test.sh"
    ;;
  lint)
    bash "${SCRIPT_DIR}/lint.sh"
    ;;
  format)
    bash "${SCRIPT_DIR}/format.sh"
    ;;
  clean)
    bash "${SCRIPT_DIR}/clean.sh"
    ;;
  start)
    bash "${SCRIPT_DIR}/start.sh"
    ;;
  help|*)
    usage
    ;;
esac