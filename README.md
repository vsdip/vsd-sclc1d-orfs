# VSD SCL C1D 1.2 µm RTL-to-GDS Reference Flow

This repository provides a reproducible GitHub Codespaces RTL-to-GDS flow for the **SCL C1D 1.2 µm digital PDK**.

Validated flow:

**RTL → Synthesis → Floorplan → Placement → CTS → Routing → OpenRCX → STA → KLayout GDS**

The SCL PDK is not stored in this repository.

---

## 1. Create a Codespace

Open:

https://github.com/vsdip/vsd-sclc1d-orfs

Select:

**Code → Codespaces → Create codespace on main**

Wait for Codespace initialization to complete.

---

## 2. Download / upload the SCL PDK

Place the approved SCL C1D 1.2 µm PDK ZIP inside the Codespace.

For example:

```bash
cd /workspaces/vsd-sclc1d-orfs
ls -lh *.zip
cd /workspaces/vsd-sclc1d-orfs

make install-pdk \
PDK_ZIP="/workspaces/vsd-sclc1d-orfs/SCL_PDK.zip"


