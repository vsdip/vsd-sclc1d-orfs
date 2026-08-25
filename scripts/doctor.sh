#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLATFORM_DIR="$REPO_ROOT/flow/platforms/sclc1d"

TOOLS=(openroad yosys klayout python3 make unzip)

for tool in "${TOOLS[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "[ERROR] Missing tool: $tool"
        exit 1
    fi
done

FILES=(
    lef/tech_c1d.lef
    lef/core_c1d.lef
    lib/nldm_tt_27_1p5.lib
    gds/core_c1d.gds
    verilog/c1d.v
    scl_c1d.lyt
    scl_c1d.map
    rcx/scl_c1d.rcx.lib
)

for file in "${FILES[@]}"; do
    if [[ ! -f "$PLATFORM_DIR/$file" ]]; then
        echo "[ERROR] Missing PDK file: $PLATFORM_DIR/$file"
        exit 1
    fi
done

if ! grep -q '<lef-files' "$PLATFORM_DIR/scl_c1d.lyt"; then
    echo "[ERROR] scl_c1d.lyt is missing the lef-files placeholder."
    exit 1
fi

echo "OpenROAD: $(openroad -version 2>&1 | head -n 1)"
echo "Yosys:    $(yosys -V 2>&1 | head -n 1)"
echo "KLayout:  $(klayout -v 2>&1 | head -n 1)"
echo "Python:   $(python3 --version 2>&1)"
echo
echo "[OK] Environment and PDK checks passed."
