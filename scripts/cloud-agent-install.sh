#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ ! -f project_plan.md ]]; then
  echo "Missing project_plan.md" >&2
  exit 1
fi

if [[ ! -f project.yml ]]; then
  echo "Missing project.yml" >&2
  exit 1
fi

echo "AyronCast iOS repository is configured."
echo "Build and run on macOS with Xcode 16+ (see README.md)."
