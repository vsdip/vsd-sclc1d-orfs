#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

OPENLANE_COMMIT="ff5509f65b17bfa4068d5336495ab1718987ff69"
OPENLANE_DIR="/workspaces/OpenLane-scl-ref"
OPENLANE_IMAGE="ghcr.io/the-openroad-project/openlane:${OPENLANE_COMMIT}-amd64"

PATCH_FILE="$REPO_ROOT/reference/patches/openlane-ff5509f-sclc1d.patch"
DESIGN_SRC="$REPO_ROOT/reference/openlane/gcd_scl_ref"
DESIGN_DST="$OPENLANE_DIR/designs/gcd_scl_ref"

echo
echo "================================================"
echo " Preparing SCL C1D reference OpenLane"
echo "================================================"

#
# Clone exact OpenLane source.
#
if [[ ! -d "$OPENLANE_DIR/.git" ]]; then
    echo
    echo "[INFO] Cloning OpenLane..."
    git clone \
        https://github.com/The-OpenROAD-Project/OpenLane.git \
        "$OPENLANE_DIR"
fi

echo
echo "[INFO] Restoring exact OpenLane commit..."

git -C "$OPENLANE_DIR" fetch --all --tags
git -C "$OPENLANE_DIR" reset --hard "$OPENLANE_COMMIT"
git -C "$OPENLANE_DIR" clean -fdx
git -C "$OPENLANE_DIR" submodule update --init --recursive

#
# Apply VSD/SCL OpenLane compatibility patch.
#
echo
echo "[INFO] Applying SCL C1D OpenLane compatibility patch..."

if git -C "$OPENLANE_DIR" apply --check "$PATCH_FILE" >/dev/null 2>&1; then

    git -C "$OPENLANE_DIR" apply "$PATCH_FILE"

elif git -C "$OPENLANE_DIR" apply --reverse --check "$PATCH_FILE" >/dev/null 2>&1; then

    echo "[INFO] OpenLane compatibility patch already applied."

else

    echo "[ERROR] Cannot apply OpenLane compatibility patch."
    exit 1

fi

#
# Install reference design.
#
echo
echo "[INFO] Installing gcd_scl_ref reference design..."

rm -rf "$DESIGN_DST"
cp -a "$DESIGN_SRC" "$DESIGN_DST"

#
# Wait for Docker-in-Docker.
#
echo
echo "[INFO] Waiting for Docker..."

for i in $(seq 1 30); do
    if docker info >/dev/null 2>&1; then
        break
    fi

    sleep 2
done

if ! docker info >/dev/null 2>&1; then
    echo "[ERROR] Docker is not ready."
    exit 1
fi

#
# Pull exact reference OpenLane image.
#
echo
echo "[INFO] Pulling exact OpenLane reference image..."

docker pull "$OPENLANE_IMAGE"

echo
echo "[INFO] OpenLane source:"
git -C "$OPENLANE_DIR" rev-parse HEAD

echo
echo "[INFO] Reference OpenROAD:"
docker run --rm \
    "$OPENLANE_IMAGE" \
    openroad -version

echo
echo "================================================"
echo " SCL reference OpenLane is ready"
echo "================================================"
