#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$REPO_ROOT/pdks/sclc1d"
mkdir -p /tmp/orfs

git config --global --add safe.directory "$REPO_ROOT" || true

echo
echo "SCL C1D Codespace is ready."
echo
echo "Next steps:"
echo "  1. Upload the tested SCL 1.2um PDK ZIP."
echo "  2. Run:"
echo "     make install-pdk PDK_ZIP=/path/to/SCL_1.2um_PDK.zip"
echo "  3. Run:"
echo "     make doctor"
echo "  4. Run:"
echo "     make gcd"


echo
echo "Installing SCL reference environment..."
bash "$REPO_ROOT/scripts/install-scl-reference-tools.sh"

