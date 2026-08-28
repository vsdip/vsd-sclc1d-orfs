#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$REPO_ROOT/pdks/sclc1d"
mkdir -p /tmp/orfs

git config --global --add safe.directory "$REPO_ROOT" || true

#
# Everything that does NOT require the confidential SCL PDK
# is prepared automatically during Codespace creation.
#
bash "$REPO_ROOT/scripts/setup-reference-openlane.sh"

echo
echo "================================================"
echo " VSD SCL C1D Codespace ready"
echo "================================================"
echo
echo "User steps:"
echo
echo "1. Upload the SCL 1.2um PDK ZIP"
echo
echo "2. Install:"
echo '   make install-pdk PDK_ZIP="SCL 1.2 µm PDK.zip"'
echo
echo "3. Verify:"
echo "   make doctor"
echo
echo "4. Start reference OpenLane from:"
echo "   cd /workspaces/OpenLane-scl-ref"
echo
