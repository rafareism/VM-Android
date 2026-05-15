#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

# Canonical local build entrypoint aligned with AGENTS.md.
# Produces both release unsigned snapshot and signed release APK
# with arm32+arm64 ABI coverage checks.
exec ./tools/ci/build_verify_apks.sh "$@"
