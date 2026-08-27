# SCL 1.2 µm Open-Source Digital Design Flow

This repository provides a reproducible digital RTL-to-GDSII design environment for the
**SCL C1D 1.2 µm CMOS PDK** using open-source semiconductor design tools.

The environment is designed to run directly in **GitHub Codespaces**.

---

## 1. Create a GitHub Codespace

Open this repository:

https://github.com/vsdip/vsd-sclc1d-orfs

Select:

**Code → Codespaces → Create codespace**

Wait until the Codespace setup completes.

---

## 2. Download the SCL 1.2 µm PDK

The SCL PDK is not stored in this repository.

Obtain the approved SCL 1.2 µm digital PDK package separately and upload the ZIP file
into the repository root inside the Codespace.

Example:

```text
vsd-sclc1d-orfs/
├── SCL 1.2 µm PDK.zip
├── Makefile
├── flow/
├── scripts/
└── ...
