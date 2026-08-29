#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLATFORM_DIR="$REPO_ROOT/flow/platforms/sclc1d"
RAW_PDK_LINK="$REPO_ROOT/pdks/sclc1d/current"

EXPECTED_MY_DTECH_SHA256="14ce5806614bb31fbeb36f35da0d2fbccf3b1988ef1d2ffdfa66bb0ab4ecb8b1"

REF_OPENLANE="/workspaces/OpenLane-scl-ref"
REF_COMMIT="ff5509f65b17bfa4068d5336495ab1718987ff69"
REF_IMAGE="ghcr.io/the-openroad-project/openlane:${REF_COMMIT}-amd64"

fail()
{
    echo "[ERROR] $*"
    exit 1
}

ok()
{
    echo "[OK] $*"
}

version_value()
{
    local key="$1"
    local file="$2"

    awk -F= -v key="$key" \
        '$1 == key {sub(/^[^=]*=/, ""); print; exit}' \
        "$file"
}

# ============================================================
# Host tools
# ============================================================

TOOLS=(
    openroad
    yosys
    klayout
    python3
    make
    unzip
    docker
    sha256sum
)

for tool in "${TOOLS[@]}"; do
    command -v "$tool" >/dev/null 2>&1 \
        || fail "Missing tool: $tool"
done

# ============================================================
# Normalized ORFS platform assets
# ============================================================

PLATFORM_FILES=(

    lef/tech_c1d.lef
    lef/core_c1d.lef
    lef/io_c1d.lef
    lef/corner_c1d.lef

    lib/nldm_tt_27_1p5.lib
    lib/nldm_ss_125_2p45.lib
    lib/nldm_ff_m25_1p55.lib

    lib/scl1u_pads_typ.lib
    lib/scl1u_pads_min.lib
    lib/scl1u_pads_max.lib

    gds/core_c1d.gds
    gds/io_c1d.gds
    gds/scl_drc.txt

    verilog/c1d.v

    cdl/core_iolib_c1d.cdl
    cdl/res_model.subckt

    scl_c1d.lyt
    scl_c1d.lyp
    scl_c1d.map

    drc/c1d_digital.drc
    drc/c1d_digital.lydrc

    lvs/lvs_os_scl_c1d.lvs
    lvs/lvs.lylvs

    rcx/scl_c1d.rcx.lib

    klayout/klayoutrc
    klayout/source_klayout
    klayout/sh_py_script
    klayout/verilog2spice.py

    scripts_template/floorplan_c1d.tcl
    scripts_template/pdn_order.tcl
    scripts_template/pdn_c1d.tcl
    scripts_template/placement_c1d.tcl
    scripts_template/cts_c1d.tcl
    scripts_template/routing_c1d.tcl
    scripts_template/run_sta.tcl
)

for file in "${PLATFORM_FILES[@]}"; do
    [[ -f "$PLATFORM_DIR/$file" ]] \
        || fail "Missing platform PDK file: $PLATFORM_DIR/$file"
done

if ! grep -q '<lef-files' "$PLATFORM_DIR/scl_c1d.lyt"; then
    fail "scl_c1d.lyt is missing the ORFS <lef-files/> placeholder."
fi

ok "Normalized SCL implementation and verification assets present."

# ============================================================
# Raw PDK installation and provenance
# ============================================================

[[ -e "$RAW_PDK_LINK" ]] \
    || fail "Reference PDK link is missing: $RAW_PDK_LINK"

RAW_PDK="$(readlink -f "$RAW_PDK_LINK")"

[[ -d "$RAW_PDK/sclc1d" ]] \
    || fail "Invalid reference PDK root: $RAW_PDK"

VERSION_FILE="$PLATFORM_DIR/.pdk-version"

[[ -f "$VERSION_FILE" ]] \
    || fail "Missing PDK provenance file: $VERSION_FILE"

RECORDED_MY_DTECH_SHA256="$(
    version_value MY_DTECH_SHA256 "$VERSION_FILE"
)"

RECORDED_CORE_LEF_SHA256="$(
    version_value CORE_LEF_SHA256 "$VERSION_FILE"
)"

RECORDED_TECH_LEF_SHA256="$(
    version_value TECH_LEF_SHA256 "$VERSION_FILE"
)"

RECORDED_RCX_SHA256="$(
    version_value RCX_SHA256 "$VERSION_FILE"
)"

[[ -n "$RECORDED_MY_DTECH_SHA256" ]] \
    || fail "MY_DTECH_SHA256 is missing from .pdk-version"

if [[ "$RECORDED_MY_DTECH_SHA256" != "$EXPECTED_MY_DTECH_SHA256" ]]; then

    echo "[WARNING] Installed my_dtech payload is not the validated release."
    echo "Expected: $EXPECTED_MY_DTECH_SHA256"
    echo "Recorded: $RECORDED_MY_DTECH_SHA256"

    if [[ "${ALLOW_UNTESTED_PDK:-0}" != "1" ]]; then
        fail "Use ALLOW_UNTESTED_PDK=1 only for intentional experiments."
    fi
fi

ok "Validated my_dtech payload detected."

# ============================================================
# Complete raw SCL PDK assets required by reference document
# ============================================================

RAW_REQUIRED=(

    sclc1d/libs.ref/digital_c1d/lef/tech_c1d.lef
    sclc1d/libs.ref/digital_c1d/lef/core_c1d.lef
    sclc1d/libs.ref/digital_c1d/lef/io_c1d.lef
    sclc1d/libs.ref/digital_c1d/lef/corner_c1d.lef

    sclc1d/libs.ref/digital_c1d/lib/nldm_tt_27_1p5.lib
    sclc1d/libs.ref/digital_c1d/lib/nldm_ss_125_2p45.lib
    sclc1d/libs.ref/digital_c1d/lib/nldm_ff_m25_1p55.lib

    sclc1d/libs.ref/digital_c1d/lib/scl1u_pads_typ.lib
    sclc1d/libs.ref/digital_c1d/lib/scl1u_pads_min.lib
    sclc1d/libs.ref/digital_c1d/lib/scl1u_pads_max.lib

    sclc1d/libs.ref/digital_c1d/gds/core_c1d.gds
    sclc1d/libs.ref/digital_c1d/gds/io_c1d.gds

    sclc1d/libs.ref/digital_c1d/verilog/c1d.v

    sclc1d/libs.ref/digital_c1d/cdl/core_iolib_c1d.cdl
    sclc1d/libs.ref/digital_c1d/cdl/res_model.subckt

    sclc1d/digital_c1d/gds/scl_drc.txt

    sclc1d/libs.tech/openrcx/scl_c1d.rcx.lib

    sclc1d/libs.tech/klayout/klayoutrc
    sclc1d/libs.tech/klayout/source_klayout
    sclc1d/libs.tech/klayout/sh_py_script
    sclc1d/libs.tech/klayout/verilog2spice.py

    sclc1d/libs.tech/klayout/tech/scl_c1d.lyt
    sclc1d/libs.tech/klayout/tech/scl_c1d.lyp
    sclc1d/libs.tech/klayout/tech/scl_c1d.map

    sclc1d/libs.tech/klayout/tech/drc/c1d_digital.drc
    sclc1d/libs.tech/klayout/tech/drc/c1d_digital.lydrc

    sclc1d/libs.tech/klayout/tech/lvs/lvs_os_scl_c1d.lvs
    sclc1d/libs.tech/klayout/tech/lvs/lvs.lylvs

    sclc1d/scripts_template/floorplan_c1d.tcl
    sclc1d/scripts_template/pdn_order.tcl
    sclc1d/scripts_template/pdn_c1d.tcl
    sclc1d/scripts_template/placement_c1d.tcl
    sclc1d/scripts_template/cts_c1d.tcl
    sclc1d/scripts_template/routing_c1d.tcl
    sclc1d/scripts_template/run_sta.tcl
)

for file in "${RAW_REQUIRED[@]}"; do

    [[ -f "$RAW_PDK/$file" ]] \
        || fail "Missing raw SCL PDK asset: $RAW_PDK/$file"

done

ok "Complete SCL core, I/O, OpenRCX, KLayout DRC/LVS, and reference-script assets present."

# ============================================================
# Verify supplied raw reference files are unchanged
# ============================================================

RAW_CORE_LEF="$RAW_PDK/sclc1d/libs.ref/digital_c1d/lef/core_c1d.lef"
RAW_TECH_LEF="$RAW_PDK/sclc1d/libs.ref/digital_c1d/lef/tech_c1d.lef"
RAW_RCX="$RAW_PDK/sclc1d/libs.tech/openrcx/scl_c1d.rcx.lib"

ACTUAL_CORE_LEF_SHA256="$(
    sha256sum "$RAW_CORE_LEF" | awk '{print $1}'
)"

ACTUAL_TECH_LEF_SHA256="$(
    sha256sum "$RAW_TECH_LEF" | awk '{print $1}'
)"

ACTUAL_RCX_SHA256="$(
    sha256sum "$RAW_RCX" | awk '{print $1}'
)"

[[ -n "$RECORDED_CORE_LEF_SHA256" ]] \
    || fail "CORE_LEF_SHA256 missing from .pdk-version"

[[ -n "$RECORDED_TECH_LEF_SHA256" ]] \
    || fail "TECH_LEF_SHA256 missing from .pdk-version"

[[ -n "$RECORDED_RCX_SHA256" ]] \
    || fail "RCX_SHA256 missing from .pdk-version"

[[ "$ACTUAL_CORE_LEF_SHA256" == "$RECORDED_CORE_LEF_SHA256" ]] \
    || fail "Original core_c1d.lef has changed after installation."

[[ "$ACTUAL_TECH_LEF_SHA256" == "$RECORDED_TECH_LEF_SHA256" ]] \
    || fail "Original tech_c1d.lef has changed after installation."

[[ "$ACTUAL_RCX_SHA256" == "$RECORDED_RCX_SHA256" ]] \
    || fail "Original OpenRCX rules have changed after installation."

ok "Original SCL LEF and OpenRCX reference files are unchanged."

# ============================================================
# Manufacturing grid
# ============================================================

if ! grep -qiE \
    'MANUFACTURINGGRID[[:space:]]+0\.005' \
    "$RAW_TECH_LEF"
then
    fail "Expected MANUFACTURINGGRID 0.005 not found in tech_c1d.lef."
fi

ok "MANUFACTURINGGRID = 0.005 um."

# ============================================================
# VSD OpenLane compatibility LEF
# ============================================================

COMPAT_DIR="$RAW_PDK/sclc1d/libs.tech/openlane/digital_c1d"

COMPAT_CORE_LEF="$COMPAT_DIR/core_c1d_vsd.lef"
OVERLAY="$COMPAT_DIR/vsd_sclc1d_compat.tcl"
LIB_CFG="$COMPAT_DIR/config.tcl"

[[ -f "$COMPAT_CORE_LEF" ]] \
    || fail "SCL OpenLane compatibility LEF is missing. Run make install-pdk again."

[[ -f "$OVERLAY" ]] \
    || fail "SCL OpenLane compatibility overlay is missing."

[[ -f "$LIB_CFG" ]] \
    || fail "SCL OpenLane library config is missing."

grep -q 'vsd_sclc1d_compat.tcl' "$LIB_CFG" \
    || fail "OpenLane library config does not source the VSD compatibility overlay."

RAW_MACRO_COUNT="$(
    grep -ciE \
        '^[[:space:]]*macro[[:space:]]+' \
        "$RAW_CORE_LEF"
)"

COMPAT_MACRO_COUNT="$(
    grep -ciE \
        '^[[:space:]]*macro[[:space:]]+' \
        "$COMPAT_CORE_LEF"
)"

[[ "$RAW_MACRO_COUNT" -eq 68 ]] \
    || fail "Unexpected raw standard-cell LEF macro count: $RAW_MACRO_COUNT"

[[ "$COMPAT_MACRO_COUNT" -eq 68 ]] \
    || fail "Unexpected compatibility LEF macro count: $COMPAT_MACRO_COUNT"

# ============================================================
# Check every PIN RECT in compatibility LEF is on 0.005um grid
# ============================================================

OFFGRID_COUNT="$(
python3 - "$COMPAT_CORE_LEF" <<'PY'
import re
import sys
from decimal import Decimal
from pathlib import Path

p = Path(sys.argv[1])

grid = Decimal("0.005")

pin = None
in_pin = False
count = 0

for line in p.read_text(errors="replace").splitlines():

    s = line.strip()

    m = re.match(r"(?i)^PIN\s+(\S+)", s)

    if m:
        pin = m.group(1)
        in_pin = True
        continue

    if (
        in_pin
        and pin is not None
        and re.match(
            r"(?i)^END\s+" + re.escape(pin) + r"\s*$",
            s
        )
    ):
        pin = None
        in_pin = False
        continue

    if not in_pin:
        continue

    m = re.match(
        r"(?i)^RECT\s+"
        r"([-+0-9.eE]+)\s+"
        r"([-+0-9.eE]+)\s+"
        r"([-+0-9.eE]+)\s+"
        r"([-+0-9.eE]+)\s*;",
        s
    )

    if not m:
        continue

    values = [Decimal(x) for x in m.groups()]

    for value in values:

        scaled = value / grid

        if scaled != scaled.to_integral_value():
            count += 1
            break

print(count)
PY
)"

[[ "$OFFGRID_COUNT" -eq 0 ]] \
    || fail "Compatibility LEF still contains $OFFGRID_COUNT off-grid PIN geometries."

ok "Compatibility LEF macros: $COMPAT_MACRO_COUNT"
ok "Compatibility LEF off-grid PIN geometries: 0"

# ============================================================
# Verify OpenRCX / routing / KLayout compatibility overlay
# ============================================================

for marker in \
    core_c1d_vsd.lef \
    SCL_DRT_SINGLE_PROCESS \
    SCL_SKIP_GRT_STA \
    SPEF_EXTRACTOR \
    RCX_RULES \
    LAYERS_RC \
    KLAYOUT_TECH \
    KLAYOUT_PROPERTIES \
    KLAYOUT_DEF_LAYER_MAP \
    PRIMARY_SIGNOFF_TOOL
do

    grep -q "$marker" "$OVERLAY" \
        || fail "Reference PDK overlay is missing: $marker"

done

ok "OpenRCX and KLayout OpenLane compatibility configuration present."

# ============================================================
# Pinned reference OpenLane
# ============================================================

[[ -d "$REF_OPENLANE/.git" ]] \
    || fail "Reference OpenLane installation missing: $REF_OPENLANE"

ACTUAL_REF_COMMIT="$(
    git -C "$REF_OPENLANE" rev-parse HEAD
)"

[[ "$ACTUAL_REF_COMMIT" == "$REF_COMMIT" ]] \
    || fail "Wrong reference OpenLane commit. Expected $REF_COMMIT, got $ACTUAL_REF_COMMIT"

[[ -f "$REF_OPENLANE/designs/gcd_scl_ref/config.tcl" ]] \
    || fail "gcd_scl_ref design is missing from reference OpenLane."

grep -q \
    'SCL_DRT_SINGLE_PROCESS' \
    "$REF_OPENLANE/scripts/openroad/droute.tcl" \
    || fail "SCL detailed-routing compatibility patch missing."

grep -q \
    'SCL_SKIP_GRT_STA' \
    "$REF_OPENLANE/scripts/tcl_commands/routing.tcl" \
    || fail "SCL post-GRT STA compatibility patch missing."

docker image inspect "$REF_IMAGE" >/dev/null 2>&1 \
    || fail "Reference OpenLane Docker image is missing: $REF_IMAGE"

ok "Pinned OpenLane reference installation and routing patches present."

# ============================================================
# Summary
# ============================================================

echo
echo "OpenROAD: $(openroad -version 2>&1 | head -n 1)"
echo "Yosys:    $(yosys -V 2>&1 | head -n 1)"
echo "KLayout:  $(klayout -v 2>&1 | head -n 1)"
echo "Python:   $(python3 --version 2>&1)"

echo
echo "Reference OpenLane: $ACTUAL_REF_COMMIT"
echo "Reference PDK:      $RAW_PDK"
echo "my_dtech SHA256:    $RECORDED_MY_DTECH_SHA256"
echo "Raw LEF macros:     $RAW_MACRO_COUNT"
echo "Compat LEF macros:  $COMPAT_MACRO_COUNT"

echo
echo "[OK] Environment and PDK checks passed."
