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

#
# Reference OpenLane checks
#

REF_OPENLANE="/workspaces/OpenLane-scl-ref"
REF_COMMIT="ff5509f65b17bfa4068d5336495ab1718987ff69"
REF_IMAGE="ghcr.io/the-openroad-project/openlane:${REF_COMMIT}-amd64"

if [[ ! -d "$REF_OPENLANE/.git" ]]; then
    echo "[ERROR] Reference OpenLane installation missing."
    exit 1
fi

ACTUAL_REF_COMMIT="$(git -C "$REF_OPENLANE" rev-parse HEAD)"

if [[ "$ACTUAL_REF_COMMIT" != "$REF_COMMIT" ]]; then
    echo "[ERROR] Wrong reference OpenLane commit."
    echo "Expected: $REF_COMMIT"
    echo "Actual:   $ACTUAL_REF_COMMIT"
    exit 1
fi

if [[ ! -f "$REF_OPENLANE/designs/gcd_scl_ref/config.tcl" ]]; then
    echo "[ERROR] gcd_scl_ref design is missing."
    exit 1
fi


if ! grep -q 'SCL_DRT_SINGLE_PROCESS' \
    "$REF_OPENLANE/scripts/openroad/droute.tcl"; then

    echo "[ERROR] SCL detailed-routing compatibility patch missing."
    exit 1
fi

if ! grep -q 'SCL_SKIP_GRT_STA' \
    "$REF_OPENLANE/scripts/tcl_commands/routing.tcl"; then

    echo "[ERROR] SCL post-GRT STA compatibility patch missing."
    exit 1
fi


RAW_PDK="$REPO_ROOT/pdks/sclc1d/current"

if [[ ! -d "$RAW_PDK/sclc1d" ]]; then
    echo "[ERROR] Reference raw PDK link is missing."
    exit 1
fi

CORE_LEF="$RAW_PDK/sclc1d/libs.ref/digital_c1d/lef/core_c1d.lef"

COMPAT_CORE_LEF="$RAW_PDK/sclc1d/libs.tech/openlane/digital_c1d/core_c1d_vsd.lef"

if [[ ! -f "$COMPAT_CORE_LEF" ]]; then
    echo "[ERROR] SCL OpenLane compatibility LEF is missing."
    echo "Run: make install-pdk PDK_ZIP=/path/to/SCL_PDK.zip"
    exit 1
fi

if grep -q 'RECT 12.050 28.754 14.950 48.700' "$COMPAT_CORE_LEF"; then
    echo "[ERROR] Compatibility LEF still contains off-grid OR2101/VDD geometry."
    exit 1
fi

if ! grep -q 'RECT 12.050 28.755 14.950 48.700' "$COMPAT_CORE_LEF"; then
    echo "[ERROR] Expected corrected OR2101/VDD geometry not found."
    exit 1
fi

echo "[OK] SCL OpenLane compatibility LEF present."


MACRO_COUNT="$(
    grep -ciE '^[[:space:]]*macro[[:space:]]+' "$CORE_LEF"
)"

if [[ "$MACRO_COUNT" -ne 68 ]]; then
    echo "[ERROR] Unexpected SCL standard-cell LEF macro count: $MACRO_COUNT"
    exit 1
fi

if [[ ! -f \
"$RAW_PDK/sclc1d/libs.tech/openlane/digital_c1d/vsd_sclc1d_compat.tcl" ]]; then
    echo "[ERROR] Reference PDK compatibility overlay missing."
    exit 1
fi

if ! docker image inspect "$REF_IMAGE" >/dev/null 2>&1; then
    echo "[ERROR] Reference OpenLane Docker image is missing."
    exit 1
fi

echo
echo "Reference OpenLane: $ACTUAL_REF_COMMIT"
echo "Reference PDK LEF macros: $MACRO_COUNT"
echo "Reference design: gcd_scl_ref"

echo "[OK] Environment and PDK checks passed."
