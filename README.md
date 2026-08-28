Copy the entire block below directly into `README.md` in the GitHub GUI.

````markdown
# VSD SCL C1D 1.2 µm RTL-to-GDS Reference Flow

A reproducible **RTL-to-GDS digital design flow** for the **SCL C1D 1.2 µm CMOS PDK**, running entirely in **GitHub Codespaces** using open-source tools.

### Validated reference flow

**RTL → Synthesis → Floorplan → Placement → CTS → Routing → OpenRCX → Post-Route STA → KLayout GDS**

> **For users:** use the `main` branch.  
> **For development/experiments:** use the `sclc1d-reference-openlane` branch.

---

<details open>
<summary><b>1. Create a GitHub Codespace</b></summary>

<br>

Open:

https://github.com/vsdip/vsd-sclc1d-orfs

Select:

**Code → Codespaces → Create codespace on main**

Wait until the Codespace initialization completes.

The environment automatically prepares:

- OpenROAD
- Yosys
- KLayout
- noVNC desktop
- pinned OpenLane reference installation
- SCL compatibility infrastructure

The SCL PDK itself is **not included in this repository**.

</details>

---

<details>
<summary><b>2. Download / Upload the SCL C1D PDK</b></summary>

<br>

Obtain the approved **SCL C1D 1.2 µm digital PDK ZIP** separately.

Upload or download the ZIP into the Codespace.

For example:

```bash
cd /workspaces/vsd-sclc1d-orfs
ls -lh *.zip
```

Example:

```text
SCL_1.2um_PDK.zip
```

The exact filename may be different.

</details>

---

<details>
<summary><b>3. Install the PDK</b></summary>

<br>

From the repository root:

```bash
cd /workspaces/vsd-sclc1d-orfs
```

Install the PDK:

```bash
make install-pdk \
PDK_ZIP="/workspaces/vsd-sclc1d-orfs/SCL_1.2um_PDK.zip"
```

Replace the ZIP path with the actual PDK path.

The installer performs the required local setup, including:

- PDK checksum verification
- SCL PDK installation
- standard-cell views installation
- OpenRCX setup
- KLayout setup
- creation of the OpenLane compatibility LEF
- installation of the SCL OpenLane compatibility configuration

The original SCL PDK files remain local to the Codespace.

The SCL PDK and generated compatibility files are **not committed to GitHub**.

</details>

---

<details>
<summary><b>4. Verify the Installation</b></summary>

<br>

Run:

```bash
cd /workspaces/vsd-sclc1d-orfs
make doctor
```

The environment should report successful checks for the PDK and reference OpenLane installation.

The final line should be:

```text
[OK] Environment and PDK checks passed.
```

Do not continue if `make doctor` reports an error.

</details>

---

<details>
<summary><b>5. Launch the Pinned OpenLane Docker Environment</b></summary>

<br>

Move to the reference OpenLane installation:

```bash
cd /workspaces/OpenLane-scl-ref
```

Set the tested OpenLane Docker image:

```bash
export OPENLANE_IMAGE_NAME=ghcr.io/the-openroad-project/openlane:ff5509f65b17bfa4068d5336495ab1718987ff69
```

Launch OpenLane:

```bash
make mount \
PDK_ROOT=/workspaces/vsd-sclc1d-orfs/pdks/sclc1d/current \
PDK=sclc1d
```

A successful launch should show:

```text
OpenLane Container (ff5509f):/openlane$
```

The reference OpenLane commit is:

```text
ff5509f65b17bfa4068d5336495ab1718987ff69
```

</details>

---

<details>
<summary><b>6. Start OpenLane Interactive Mode</b></summary>

<br>

Inside the OpenLane Docker container:

```bash
./flow.tcl -interactive
```

At the OpenLane `%` prompt:

```tcl
package require openlane
```

Prepare the reference GCD design:

```tcl
prep -design gcd_scl_ref -tag ROUTE_CLEAN
```

The run directory will be:

```text
/openlane/designs/gcd_scl_ref/runs/ROUTE_CLEAN
```

You may use another run tag if required.

For example:

```tcl
prep -design gcd_scl_ref -tag MY_RUN
```

Use the same tag later when locating or viewing the final GDS.

</details>

---

<details>
<summary><b>7. Run Synthesis</b></summary>

<br>

At the OpenLane `%` prompt:

```tcl
run_synthesis
```

This performs:

- RTL synthesis
- technology mapping
- reference Liberty integration
- synthesis STA

Wait for the command to return to the `%` prompt before continuing.

</details>

---

<details>
<summary><b>8. Run Floorplanning and PDN</b></summary>

<br>

Run:

```tcl
run_floorplan
```

The reference flow includes:

- fixed reference die/core dimensions
- SCL `CORE` placement site
- SCL alternate-row placement architecture
- I/O placement
- power distribution network generation

A validated reference run uses:

```text
Die  : 0 0 4000 4000 µm
Core : 320 292.2 3680 3701.2 µm
```

and keeps:

```text
35 placement rows
```

after SCL alternate-row filtering.

</details>

---

<details>
<summary><b>9. Run Placement</b></summary>

<br>

Run:

```tcl
run_place
```

This executes:

- global placement
- placement STA
- detailed placement
- detailed-placement STA

The reference configuration intentionally disables incompatible placement/resizer optimizations for this SCL/OpenROAD combination.

</details>

---

<details>
<summary><b>10. Run Clock Tree Synthesis</b></summary>

<br>

Run:

```tcl
run_cts
```

This performs:

- clock tree synthesis
- CTS STA

The validated reference flow uses the SCL clock-buffer configuration provided by the compatibility layer.

</details>

---

<details>
<summary><b>11. Run Global + Detailed Routing</b></summary>

<br>

Run:

```tcl
run_routing
```

The SCL C1D technology uses only:

```text
metal1
metal2
```

The reference environment contains compatibility fixes for the pinned OpenROAD version to support this two-metal routing architecture.

During a successful run you should see:

```text
[INFO]: SCL C1D: skipping incompatible post-global-route estimated STA.
```

followed by detailed routing.

The important success message is:

```text
[INFO]: No DRC violations after detailed routing.
```

The validated GCD reference run completed TritonRoute with:

```text
Detailed routing : PASS
DRT violations   : 0
```

A wire-length check is also executed automatically after detailed routing.

</details>

---

<details>
<summary><b>12. Run OpenRCX Parasitic Extraction and Post-Route STA</b></summary>

<br>

After routing completes, run:

```tcl
run_parasitics_sta
```

The reference SCL configuration automatically supplies:

- OpenRCX extractor
- SCL OpenRCX rules
- metal1 RC
- metal2 RC
- via1 resistance
- signal wire RC layer
- clock wire RC layer

A successful run performs:

```text
SPEF Extraction
Multi-Corner STA
Single-Corner Post-Route STA
```

The generated nominal SPEF is stored under the run directory.

</details>

---

<details>
<summary><b>13. Generate the Final GDS with KLayout</b></summary>

<br>

Run:

```tcl
run_klayout
```

KLayout streams the routed design and SCL standard-cell GDS into the final layout.

Verify the resulting GDS:

```tcl
puts "CURRENT_GDS = $::env(CURRENT_GDS)"
```

Then:

```tcl
puts [exec ls -lh $::env(CURRENT_GDS)]
```

For the `ROUTE_CLEAN` run, the final GDS is:

```text
/openlane/designs/gcd_scl_ref/runs/ROUTE_CLEAN/results/signoff/gcd.gds
```

KLayout also generates:

```text
/openlane/designs/gcd_scl_ref/runs/ROUTE_CLEAN/results/signoff/gcd.klayout.gds
```

The canonical final output is:

```text
gcd.gds
```

</details>

---

<details>
<summary><b>14. Locate the GDS from the Normal Codespaces Terminal</b></summary>

<br>

The OpenLane Docker directory:

```text
/openlane
```

is mounted from:

```text
/workspaces/OpenLane-scl-ref
```

Therefore the same final GDS is available outside Docker at:

```text
/workspaces/OpenLane-scl-ref/designs/gcd_scl_ref/runs/ROUTE_CLEAN/results/signoff/gcd.gds
```

Open a **new normal Codespaces terminal** and verify:

```bash
ls -lh \
/workspaces/OpenLane-scl-ref/designs/gcd_scl_ref/runs/ROUTE_CLEAN/results/signoff/gcd.gds
```

</details>

---

<details>
<summary><b>15. Open the Final GDS in KLayout GUI</b></summary>

<br>

### Important

Use the **KLayout installed in the Codespaces host environment** for graphical viewing.

Do **not** use:

```tcl
open_in_klayout
```

from inside the pinned OpenLane Docker image.

The pinned OpenLane image contains an older KLayout build that does not render reliably through the Codespaces noVNC desktop.

Open a **new normal Codespaces terminal**.

Set the display:

```bash
export DISPLAY=:1
```

Launch KLayout:

```bash
/usr/bin/klayout \
  -nn /workspaces/vsd-sclc1d-orfs/pdks/sclc1d/current/sclc1d/libs.tech/klayout/tech/scl_c1d.lyt \
  -l /workspaces/vsd-sclc1d-orfs/pdks/sclc1d/current/sclc1d/libs.tech/klayout/tech/scl_c1d.lyp \
  /workspaces/OpenLane-scl-ref/designs/gcd_scl_ref/runs/ROUTE_CLEAN/results/signoff/gcd.gds &
```

Then in VS Code:

1. Open the **Ports** tab.
2. Find the forwarded **noVNC Desktop** on port `6080`.
3. Click **Open in Browser**.
4. Connect to the desktop.

KLayout should appear with the final `gcd.gds` loaded.

</details>

---

<details>
<summary><b>16. Complete Command Sequence — Quick Reference</b></summary>

<br>

### Codespaces terminal

```bash
cd /workspaces/vsd-sclc1d-orfs

make install-pdk \
PDK_ZIP="/workspaces/vsd-sclc1d-orfs/SCL_1.2um_PDK.zip"

make doctor
```

Launch OpenLane:

```bash
cd /workspaces/OpenLane-scl-ref

export OPENLANE_IMAGE_NAME=ghcr.io/the-openroad-project/openlane:ff5509f65b17bfa4068d5336495ab1718987ff69

make mount \
PDK_ROOT=/workspaces/vsd-sclc1d-orfs/pdks/sclc1d/current \
PDK=sclc1d
```

### Inside OpenLane Docker

```bash
./flow.tcl -interactive
```

### At the OpenLane `%` prompt

```tcl
package require openlane

prep -design gcd_scl_ref -tag ROUTE_CLEAN

run_synthesis

run_floorplan

run_place

run_cts

run_routing

run_parasitics_sta

run_klayout
```

Check final GDS:

```tcl
puts "CURRENT_GDS = $::env(CURRENT_GDS)"
puts [exec ls -lh $::env(CURRENT_GDS)]
```

### Open GDS from normal Codespaces terminal

```bash
export DISPLAY=:1

/usr/bin/klayout \
  -nn /workspaces/vsd-sclc1d-orfs/pdks/sclc1d/current/sclc1d/libs.tech/klayout/tech/scl_c1d.lyt \
  -l /workspaces/vsd-sclc1d-orfs/pdks/sclc1d/current/sclc1d/libs.tech/klayout/tech/scl_c1d.lyp \
  /workspaces/OpenLane-scl-ref/designs/gcd_scl_ref/runs/ROUTE_CLEAN/results/signoff/gcd.gds &
```

Open port `6080` from the VS Code **Ports** tab to access the noVNC desktop.

</details>

---

<details>
<summary><b>17. What Has Been Validated</b></summary>

<br>

The reference `gcd_scl_ref` flow has been validated through:

| Stage | Status |
|---|---|
| Synthesis | ✅ PASS |
| Synthesis STA | ✅ PASS |
| Floorplan | ✅ PASS |
| SCL alternate-row setup | ✅ PASS |
| I/O placement | ✅ PASS |
| PDN generation | ✅ PASS |
| Global placement | ✅ PASS |
| Detailed placement | ✅ PASS |
| Placement STA | ✅ PASS |
| CTS | ✅ PASS |
| CTS STA | ✅ PASS |
| Global routing | ✅ PASS |
| Detailed routing | ✅ PASS |
| TritonRoute internal DRC | ✅ 0 violations |
| Wire-length check | ✅ PASS |
| OpenRCX SPEF extraction | ✅ PASS |
| Post-route STA | ✅ PASS |
| KLayout GDS stream-out | ✅ PASS |
| Final `gcd.gds` generation | ✅ PASS |
| KLayout GUI through noVNC | ✅ PASS |

</details>

---

<details>
<summary><b>18. Current Signoff Limitations</b></summary>

<br>

The current reference flow intentionally does **not** claim full foundry signoff.

### Magic

The supplied SCL PDK package currently does not contain the OpenLane-required:

```text
libs.tech/magic
```

integration.

Therefore Magic GDS/DRC is not part of the validated reference path.

### Netgen LVS

The supplied package currently does not contain:

```text
libs.tech/netgen
```

integration.

Therefore Netgen LVS is not yet part of the validated reference path.

### IR-Drop Signoff

OpenROAD PDN/IR-drop analysis has been successfully executed using the configured SCL RC values.

However, accurate IR-drop analysis requires validated physical supply-source locations using:

```text
VSRC_LOC_FILES
```

Until those supply locations are qualified, IR-drop numerical results should not be considered signoff-quality.

### DRC terminology

The routing result:

```text
No DRC violations after detailed routing.
```

means **TritonRoute internal routing DRC = 0**.

It should not be interpreted as complete foundry signoff DRC.

</details>

---

<details>
<summary><b>19. PDK Handling</b></summary>

<br>

The SCL PDK is deliberately not stored in this GitHub repository.

The repository contains only:

- flow configuration
- compatibility scripts
- reference design
- installation logic
- OpenLane patches
- tests and environment checks

The user-supplied PDK remains local to the Codespace.

The original foundry LEF is preserved.

Where tool compatibility adjustments are required, the installation process generates a separate local compatibility LEF under the PDK's tool-specific `libs.tech/openlane` area.

</details>

---

<details>
<summary><b>20. Branch Policy</b></summary>

<br>

### User / stable branch

```text
main
```

Users should always create Codespaces from `main`.

### Experimental branch

```text
sclc1d-reference-openlane
```

Use this branch for:

- new PDK experiments
- OpenLane compatibility work
- routing experiments
- DRC/LVS integration
- IR-drop qualification
- tool-version experiments

Validated changes should only be merged into `main` after reproduction on a fresh Codespace.

</details>

---

## Reference Toolchain

The OpenLane reference environment is intentionally pinned for reproducibility.

```text
OpenLane:
ff5509f65b17bfa4068d5336495ab1718987ff69

OpenROAD:
41a51eaf4ca2171c92ff38afb91eb37bbd3f36da
```

The Codespaces host provides the newer KLayout GUI used to view the final GDS.

---

## VSD

**VLSI System Design (VSD)**  
Open-source semiconductor design, education and hardware ecosystem.

**VSD — Open to Innovate.**
````
