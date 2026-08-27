#!/usr/bin/env bash
set -euo pipefail

echo "================================================"
echo " Installing SCL reference toolchain"
echo "================================================"

OPENLANE_COMMIT="ff5509f65b17bfa4068d5336495ab1718987ff69"
OPENROAD_COMMIT="41a51eaf4ca2171c92ff38afb91eb37bbd3f36da"
YOSYS_COMMIT="1979e0b1f2482dbf0562f5116ab444280a377773"

OPENLANE_DIR="/workspaces/OpenLane-scl-ref"
YOSYS_DIR="/workspaces/yosys-0.9"

OPENLANE_IMAGE="ghcr.io/the-openroad-project/openlane:${OPENLANE_COMMIT}-amd64"

echo
echo "=== Installing build dependencies ==="

sudo apt-get update

sudo apt-get install -y \
    build-essential \
    clang \
    bison \
    flex \
    gawk \
    libreadline-dev \
    tcl-dev \
    libffi-dev \
    pkg-config \
    zlib1g-dev

#
# GCC 9
#
if ! command -v gcc-9 >/dev/null 2>&1; then
    echo
    echo "=== Installing GCC 9 ==="

    sudo apt-get install -y software-properties-common

    sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
    sudo apt-get update

    sudo apt-get install -y gcc-9 g++-9
fi

echo
echo "GCC:"
gcc-9 --version | head -1

echo "G++:"
g++-9 --version | head -1


#
# OpenLane reference source
#
echo
echo "=== Installing OpenLane ff5509f ==="

if [ ! -d "$OPENLANE_DIR/.git" ]; then
    git clone \
        https://github.com/The-OpenROAD-Project/OpenLane.git \
        "$OPENLANE_DIR"
fi

cd "$OPENLANE_DIR"

git fetch --all --tags
git checkout --detach "$OPENLANE_COMMIT"
git submodule update --init --recursive

echo "OpenLane commit:"
git rev-parse HEAD


#
# Exact OpenLane Docker image
#
echo
echo "=== Pulling reference OpenLane image ==="

docker pull "$OPENLANE_IMAGE"

echo
echo "Reference OpenROAD:"
docker run --rm \
    "$OPENLANE_IMAGE" \
    openroad -version

echo
echo "Reference container Yosys:"
docker run --rm \
    "$OPENLANE_IMAGE" \
    yosys -V


#
# Yosys 0.9
#
echo
echo "=== Installing Yosys 0.9 ==="

if [ ! -d "$YOSYS_DIR/.git" ]; then
    git clone \
        --recursive \
        https://github.com/YosysHQ/yosys.git \
        "$YOSYS_DIR"
fi

cd "$YOSYS_DIR"

git fetch --all --tags
git checkout "$YOSYS_COMMIT"
git submodule update --init --recursive

#
# Old Yosys 0.9 needs an explicit C++ <limits> include
# with current system headers. This does not alter synthesis logic.
#
if ! grep -q '#include <limits>' passes/sat/freduce.cc; then
    sed -i \
      '/#include <algorithm>/a #include <limits>' \
      passes/sat/freduce.cc
fi

make config-gcc

#
# Build Yosys itself first.
#
make -j"$(nproc)" \
    CXX=gcc-9 \
    LD=gcc-9 || true

#
# Build the exact ABC revision expected by Yosys 0.9.
#
make -C abc DEP= clean

make -C abc -j"$(nproc)" \
    CC=gcc-9 \
    CXX=gcc-9 \
    LD=gcc-9 \
    ABC_USE_LIBSTDCXX=1 \
    ARCHFLAGS="-DABC_USE_STDINT_H" \
    PROG=abc-3709744

#
# Complete Yosys build.
#
make -j"$(nproc)" \
    CXX=gcc-9 \
    LD=gcc-9

echo
echo "=== Tool versions ==="

"$YOSYS_DIR/yosys" -V
"$YOSYS_DIR/yosys-abc" -c "version"

echo
echo "OpenLane:"
cd "$OPENLANE_DIR"
git rev-parse --short HEAD

echo
echo "OpenROAD inside reference container:"
docker run --rm \
    "$OPENLANE_IMAGE" \
    openroad -version

echo
echo "================================================"
echo " SCL reference toolchain ready"
echo "================================================"
