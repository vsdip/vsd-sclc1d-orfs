#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PDK_ROOT="${1:-}"

if [[ -z "$PDK_ROOT" ]]; then
    echo "Usage: $0 /path/to/open_pdks"
    exit 1
fi

BASE_CFG="$PDK_ROOT/sclc1d/libs.tech/openlane/config.tcl"
LIB_DIR="$PDK_ROOT/sclc1d/libs.tech/openlane/digital_c1d"
LIB_CFG="$LIB_DIR/config.tcl"

OVERLAY_SRC="$REPO_ROOT/reference/pdk/sclc1d-openlane-overrides.tcl"
OVERLAY_DST="$LIB_DIR/vsd_sclc1d_compat.tcl"

echo
echo "[INFO] Configuring SCL PDK for reference OpenLane..."

test -f "$BASE_CFG"
test -f "$LIB_CFG"
test -f "$OVERLAY_SRC"

#
# The supplied PDK contains a machine-specific /home/scl PDK_ROOT.
# OpenLane's make mount already supplies the correct PDK_ROOT.
# Therefore remove the hardcoded assignment.
#
python3 - "$BASE_CFG" "$LIB_CFG" <<'PY'
import re
import sys
from pathlib import Path

for filename in sys.argv[1:]:
    p = Path(filename)
    s = p.read_text()

    s = re.sub(
        r'^[ \t]*set[ \t]+::env\(PDK_ROOT\)[^\n]*$',
        '# VSD: PDK_ROOT is supplied by OpenLane make mount',
        s,
        flags=re.MULTILINE,
    )

    p.write_text(s)
PY

#
# Install the VSD compatibility overlay inside the PDK itself.
# This means it is visible inside the nested OpenLane container.
#
cp "$OVERLAY_SRC" "$OVERLAY_DST"

SOURCE_LINE='source "$::env(PDK_ROOT)/sclc1d/libs.tech/openlane/digital_c1d/vsd_sclc1d_compat.tcl"'

if ! grep -Fq 'vsd_sclc1d_compat.tcl' "$LIB_CFG"; then
    {
        echo
        echo "# VSD SCL C1D OpenLane compatibility"
        echo "$SOURCE_LINE"
    } >> "$LIB_CFG"
fi

#
# OpenLane 1.0.x expects these files.
#
touch "$LIB_DIR/no_synth.cells"
touch "$LIB_DIR/drc_exclude.cells"

echo "[OK] Reference OpenLane PDK configuration installed."
