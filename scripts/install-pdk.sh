#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARCHIVE="${1:-}"

PDK_RELEASE="OS_C1D_SCL_PDK_31-07-2026"
EXPECTED_SHA256="722425610949f14ef83a3b1167cdb31ca354e6a43d9e5e40da805ca9559084a4"

if [[ -z "$ARCHIVE" || ! -f "$ARCHIVE" ]]; then
    echo "Usage: $0 /path/to/SCL_1.2um_PDK.zip"
    exit 1
fi

ACTUAL_SHA256="$(sha256sum "$ARCHIVE" | awk '{print $1}')"

if [[ "$ACTUAL_SHA256" != "$EXPECTED_SHA256" ]]; then
    echo "[ERROR] PDK checksum does not match the tested release."
    echo "Expected: $EXPECTED_SHA256"
    echo "Actual:   $ACTUAL_SHA256"
    echo
    echo "Set ALLOW_UNTESTED_PDK=1 only for intentional testing."

    if [[ "${ALLOW_UNTESTED_PDK:-0}" != "1" ]]; then
        exit 1
    fi
fi

PDK_INSTALL_DIR="$REPO_ROOT/pdks/sclc1d/$PDK_RELEASE"
PLATFORM_DIR="$REPO_ROOT/flow/platforms/sclc1d"
TEMP_DIR="$(mktemp -d)"

trap 'rm -rf "$TEMP_DIR"' EXIT

mkdir -p "$PDK_INSTALL_DIR"

if unzip -Z1 "$ARCHIVE" | grep -q 'open_pdks/sclc1d/'; then
    INNER_ARCHIVE="$ARCHIVE"
else
    mkdir -p "$TEMP_DIR/outer"
    unzip -q "$ARCHIVE" -d "$TEMP_DIR/outer"

    INNER_ARCHIVE="$(
        find "$TEMP_DIR/outer" -type f -name 'my_dtech.zip' \
        -print -quit
    )"

    if [[ -z "$INNER_ARCHIVE" ]]; then
        echo "[ERROR] my_dtech.zip was not found inside the PDK archive."
        exit 1
    fi
fi

unzip -q -o "$INNER_ARCHIVE" -d "$PDK_INSTALL_DIR"

PDK_SOURCE="$(
    find "$PDK_INSTALL_DIR" -type d \
    -path '*/open_pdks/sclc1d' -print -quit
)"

if [[ -z "$PDK_SOURCE" ]]; then
    echo "[ERROR] open_pdks/sclc1d was not found after extraction."
    exit 1
fi

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

# LEF
copy_file digital_c1d/lef/tech_c1d.lef lef/tech_c1d.lef
copy_file digital_c1d/lef/core_c1d.lef lef/core_c1d.lef
copy_file digital_c1d/lef/io_c1d.lef lef/io_c1d.lef
copy_file digital_c1d/lef/corner_c1d.lef lef/corner_c1d.lef

# Liberty
copy_file digital_c1d/lib/nldm_tt_27_1p5.lib lib/nldm_tt_27_1p5.lib
copy_file digital_c1d/lib/nldm_ss_125_2p45.lib lib/nldm_ss_125_2p45.lib
copy_file digital_c1d/lib/nldm_ff_m25_1p55.lib lib/nldm_ff_m25_1p55.lib

# GDS and simulation
copy_file digital_c1d/gds/core_c1d.gds gds/core_c1d.gds
copy_file digital_c1d/gds/io_c1d.gds gds/io_c1d.gds
copy_file digital_c1d/verilog/c1d.v verilog/c1d.v
copy_file digital_c1d/cdl/core_iolib_c1d.cdl cdl/core_iolib_c1d.cdl

# KLayout
copy_file libs.tech/klayout/tech/scl_c1d.lyt scl_c1d.lyt
copy_file libs.tech/klayout/tech/scl_c1d.lyp scl_c1d.lyp
copy_file libs.tech/klayout/tech/scl_c1d.map scl_c1d.map

mkdir -p "$PLATFORM_DIR/drc" "$PLATFORM_DIR/lvs" "$PLATFORM_DIR/rcx"

cp -a "$PDK_SOURCE/libs.tech/klayout/tech/drc/." \
      "$PLATFORM_DIR/drc/"

cp -a "$PDK_SOURCE/libs.tech/klayout/tech/lvs/." \
      "$PLATFORM_DIR/lvs/"

copy_file \
    libs.tech/openrcx/scl_c1d.rcx.lib \
    rcx/scl_c1d.rcx.lib

# ORFS KLayout generator requires this placeholder.
if ! grep -q '<lef-files' "$PLATFORM_DIR/scl_c1d.lyt"; then
    sed -i '/<map-file\/>/a\   <lef-files\/>' \
        "$PLATFORM_DIR/scl_c1d.lyt"
fi

{
    echo "PDK_RELEASE=$PDK_RELEASE"
    echo "PDK_SHA256=$ACTUAL_SHA256"
    echo "PDK_SOURCE=$PDK_SOURCE"
} > "$PLATFORM_DIR/.pdk-version"

echo
echo "[OK] SCL C1D PDK installed."
echo "Release: $PDK_RELEASE"
echo "Platform: $PLATFORM_DIR"
