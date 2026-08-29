#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARCHIVE="${1:-}"

PDK_RELEASE="OS_C1D_SCL_PDK_31-07-2026"
EXPECTED_MY_DTECH_SHA256="14ce5806614bb31fbeb36f35da0d2fbccf3b1988ef1d2ffdfa66bb0ab4ecb8b1"

usage()
{
    echo "Usage: $0 /path/to/SCL_PDK.zip"
    echo
    echo "Accepted inputs:"
    echo "  1. SCL outer package containing C1D_OSPDK_KIT_Digital/my_dtech.zip"
    echo "  2. my_dtech.zip directly"
}

if [[ -z "$ARCHIVE" || ! -f "$ARCHIVE" ]]; then
    usage
    exit 1
fi

for tool in unzip sha256sum find install python3; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "[ERROR] Missing required tool: $tool"
        exit 1
    fi
done

ARCHIVE="$(readlink -f "$ARCHIVE")"
ARCHIVE_SHA256="$(sha256sum "$ARCHIVE" | awk '{print $1}')"

PDK_INSTALL_DIR="$REPO_ROOT/pdks/sclc1d/$PDK_RELEASE"
PLATFORM_DIR="$REPO_ROOT/flow/platforms/sclc1d"
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

# ------------------------------------------------------------
# Locate the authoritative digital payload: my_dtech.zip
# ------------------------------------------------------------

if unzip -Z1 "$ARCHIVE" | grep -qE '(^|/)open_pdks/sclc1d/'; then
    INNER_ARCHIVE="$ARCHIVE"
    PACKAGE_KIND="direct-my_dtech"
else
    mkdir -p "$TEMP_DIR/outer"
    unzip -q "$ARCHIVE" -d "$TEMP_DIR/outer"

    mapfile -t INNER_CANDIDATES < <(
        find "$TEMP_DIR/outer" -type f -name 'my_dtech.zip' -print
    )

    if [[ "${#INNER_CANDIDATES[@]}" -eq 0 ]]; then
        echo "[ERROR] my_dtech.zip was not found inside: $ARCHIVE"
        exit 1
    fi

    if [[ "${#INNER_CANDIDATES[@]}" -ne 1 ]]; then
        echo "[ERROR] Expected exactly one my_dtech.zip, found ${#INNER_CANDIDATES[@]}."
        printf '  %s\n' "${INNER_CANDIDATES[@]}"
        exit 1
    fi

    INNER_ARCHIVE="${INNER_CANDIDATES[0]}"
    PACKAGE_KIND="outer-package"
fi

MY_DTECH_SHA256="$(sha256sum "$INNER_ARCHIVE" | awk '{print $1}')"

echo "[INFO] Input package SHA256 : $ARCHIVE_SHA256"
echo "[INFO] my_dtech.zip SHA256  : $MY_DTECH_SHA256"

if [[ "$MY_DTECH_SHA256" != "$EXPECTED_MY_DTECH_SHA256" ]]; then
    echo "[ERROR] my_dtech.zip checksum does not match the validated SCL release."
    echo "Expected: $EXPECTED_MY_DTECH_SHA256"
    echo "Actual:   $MY_DTECH_SHA256"
    echo
    echo "Set ALLOW_UNTESTED_PDK=1 only for intentional PDK experiments."

    if [[ "${ALLOW_UNTESTED_PDK:-0}" != "1" ]]; then
        exit 1
    fi

    echo "[WARNING] Continuing with an unvalidated PDK payload."
fi

# ------------------------------------------------------------
# Deterministic extraction of the complete my_dtech payload
# ------------------------------------------------------------

rm -rf "$PDK_INSTALL_DIR"
mkdir -p "$PDK_INSTALL_DIR"

unzip -q "$INNER_ARCHIVE" -d "$PDK_INSTALL_DIR"

mapfile -t PDK_CANDIDATES < <(
    find "$PDK_INSTALL_DIR" -type d \
        -path '*/open_pdks/sclc1d' -print
)

if [[ "${#PDK_CANDIDATES[@]}" -eq 0 ]]; then
    echo "[ERROR] open_pdks/sclc1d was not found after extraction."
    exit 1
fi

if [[ "${#PDK_CANDIDATES[@]}" -ne 1 ]]; then
    echo "[ERROR] Expected exactly one open_pdks/sclc1d directory, found ${#PDK_CANDIDATES[@]}."
    printf '  %s\n' "${PDK_CANDIDATES[@]}"
    exit 1
fi

PDK_SOURCE="${PDK_CANDIDATES[0]}"
RAW_PDK_ROOT="$(dirname "$PDK_SOURCE")"

# ------------------------------------------------------------
# Helpers for the normalized ORFS platform mirror
# ------------------------------------------------------------

copy_file()
{
    local source_path="$1"
    local destination_path="$2"

    if [[ ! -f "$PDK_SOURCE/$source_path" ]]; then
        echo "[ERROR] Missing PDK file: $source_path"
        exit 1
    fi

    mkdir -p "$(dirname "$PLATFORM_DIR/$destination_path")"

    install -m 0644 \
        "$PDK_SOURCE/$source_path" \
        "$PLATFORM_DIR/$destination_path"
}

copy_dir()
{
    local source_path="$1"
    local destination_path="$2"

    if [[ ! -d "$PDK_SOURCE/$source_path" ]]; then
        echo "[ERROR] Missing PDK directory: $source_path"
        exit 1
    fi

    rm -rf "$PLATFORM_DIR/$destination_path"
    mkdir -p "$PLATFORM_DIR/$destination_path"

    cp -a \
        "$PDK_SOURCE/$source_path/." \
        "$PLATFORM_DIR/$destination_path/"
}

# ------------------------------------------------------------
# Mirror implementation/signoff assets used by this repository
# ------------------------------------------------------------

# LEF
copy_file digital_c1d/lef/tech_c1d.lef   lef/tech_c1d.lef
copy_file digital_c1d/lef/core_c1d.lef   lef/core_c1d.lef
copy_file digital_c1d/lef/io_c1d.lef     lef/io_c1d.lef
copy_file digital_c1d/lef/corner_c1d.lef lef/corner_c1d.lef

# Core Liberty
copy_file digital_c1d/lib/nldm_tt_27_1p5.lib    lib/nldm_tt_27_1p5.lib
copy_file digital_c1d/lib/nldm_ss_125_2p45.lib  lib/nldm_ss_125_2p45.lib
copy_file digital_c1d/lib/nldm_ff_m25_1p55.lib  lib/nldm_ff_m25_1p55.lib

# I/O pad Liberty
copy_file digital_c1d/lib/scl1u_pads_typ.lib lib/scl1u_pads_typ.lib
copy_file digital_c1d/lib/scl1u_pads_min.lib lib/scl1u_pads_min.lib
copy_file digital_c1d/lib/scl1u_pads_max.lib lib/scl1u_pads_max.lib

# GDS
copy_file digital_c1d/gds/core_c1d.gds gds/core_c1d.gds
copy_file digital_c1d/gds/io_c1d.gds   gds/io_c1d.gds
copy_file digital_c1d/gds/scl_drc.txt  gds/scl_drc.txt

# Simulation
copy_file digital_c1d/verilog/c1d.v verilog/c1d.v

# CDL / LVS support
copy_file digital_c1d/cdl/core_iolib_c1d.cdl \
    cdl/core_iolib_c1d.cdl

copy_file digital_c1d/cdl/res_model.subckt \
    cdl/res_model.subckt

# ------------------------------------------------------------
# KLayout technology + physical verification
# ------------------------------------------------------------

copy_file libs.tech/klayout/klayoutrc \
    klayout/klayoutrc

copy_file libs.tech/klayout/source_klayout \
    klayout/source_klayout

copy_file libs.tech/klayout/sh_py_script \
    klayout/sh_py_script

copy_file libs.tech/klayout/verilog2spice.py \
    klayout/verilog2spice.py

copy_file libs.tech/klayout/tech/scl_c1d.lyt \
    scl_c1d.lyt

copy_file libs.tech/klayout/tech/scl_c1d.lyp \
    scl_c1d.lyp

copy_file libs.tech/klayout/tech/scl_c1d.map \
    scl_c1d.map

copy_dir libs.tech/klayout/tech/drc drc
copy_dir libs.tech/klayout/tech/lvs lvs

# ------------------------------------------------------------
# OpenRCX
# ------------------------------------------------------------

copy_file \
    libs.tech/openrcx/scl_c1d.rcx.lib \
    rcx/scl_c1d.rcx.lib

# ------------------------------------------------------------
# Preserve original SCL reference Tcl scripts
# ------------------------------------------------------------

copy_dir scripts_template scripts_template

# ------------------------------------------------------------
# ORFS-specific local KLayout adjustment
#
# Only the LOCAL platform copy is adjusted.
# Raw SCL source data remains untouched.
# ------------------------------------------------------------

if ! grep -q '<lef-files' "$PLATFORM_DIR/scl_c1d.lyt"; then
    sed -i \
        '/<map-file\/>/a\   <lef-files\/>' \
        "$PLATFORM_DIR/scl_c1d.lyt"
fi

# ------------------------------------------------------------
# Record provenance and immutable raw reference hashes
# ------------------------------------------------------------

RAW_CORE_LEF="$PDK_SOURCE/libs.ref/digital_c1d/lef/core_c1d.lef"
RAW_TECH_LEF="$PDK_SOURCE/libs.ref/digital_c1d/lef/tech_c1d.lef"
RAW_RCX="$PDK_SOURCE/libs.tech/openrcx/scl_c1d.rcx.lib"

CORE_LEF_SHA256="$(
    sha256sum "$RAW_CORE_LEF" | awk '{print $1}'
)"

TECH_LEF_SHA256="$(
    sha256sum "$RAW_TECH_LEF" | awk '{print $1}'
)"

RCX_SHA256="$(
    sha256sum "$RAW_RCX" | awk '{print $1}'
)"

{
    echo "PDK_RELEASE=$PDK_RELEASE"
    echo "PACKAGE_KIND=$PACKAGE_KIND"
    echo "ARCHIVE_SHA256=$ARCHIVE_SHA256"
    echo "MY_DTECH_SHA256=$MY_DTECH_SHA256"
    echo "CORE_LEF_SHA256=$CORE_LEF_SHA256"
    echo "TECH_LEF_SHA256=$TECH_LEF_SHA256"
    echo "RCX_SHA256=$RCX_SHA256"
    echo "PDK_SOURCE=$PDK_SOURCE"
} > "$PLATFORM_DIR/.pdk-version"

# ------------------------------------------------------------
# Stable raw PDK root for the reference OpenLane flow
# ------------------------------------------------------------

mkdir -p "$REPO_ROOT/pdks/sclc1d"

ln -sfn \
    "$RAW_PDK_ROOT" \
    "$REPO_ROOT/pdks/sclc1d/current"

# ------------------------------------------------------------
# Install VSD's OpenLane compatibility layer
#
# This generates tool-specific compatibility data under
# libs.tech/openlane and preserves the original SCL reference LEF.
# ------------------------------------------------------------

"$REPO_ROOT/scripts/configure-reference-pdk.sh" \
    "$RAW_PDK_ROOT"

echo
echo "[OK] SCL C1D PDK installed."
echo "Release:          $PDK_RELEASE"
echo "Package kind:     $PACKAGE_KIND"
echo "my_dtech SHA256:  $MY_DTECH_SHA256"
echo "Platform mirror:  $PLATFORM_DIR"
echo "Reference PDK:    $REPO_ROOT/pdks/sclc1d/current"
