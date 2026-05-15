#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

LOG_PATH="${1:-bitomega.log}"

./tools/gradle_with_jdk21.sh :app:testDebugUnitTest :terminal-emulator:testDebugUnitTest :shell-loader:testDebugUnitTest

if [[ ! -f "$LOG_PATH" ]]; then
  echo "warning: $LOG_PATH not found; skipping period-42 assertion" >&2
  exit 0
fi

if ! rg -q "period-42 confirmed" "$LOG_PATH"; then
  echo "period-42 marker not found in $LOG_PATH" >&2
  exit 1
fi

echo "period-42 confirmed in $LOG_PATH"
