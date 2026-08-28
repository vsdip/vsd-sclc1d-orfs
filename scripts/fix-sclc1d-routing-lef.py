#!/usr/bin/env python3

from decimal import Decimal
from pathlib import Path
import re
import shutil
import sys

if len(sys.argv) != 3:
    raise SystemExit(
        "Usage: fix-sclc1d-routing-lef.py SOURCE_LEF OUTPUT_LEF"
    )

src = Path(sys.argv[1])
dst = Path(sys.argv[2])

if not src.is_file():
    raise SystemExit(f"Missing source LEF: {src}")

dst.parent.mkdir(parents=True, exist_ok=True)

# Never modify the foundry LEF.
shutil.copy2(src, dst)

replacements = {
    # DEC24L / VDD
    "RECT 70.862 29.500 74.750 30.283 ;":
        "RECT 70.865 29.500 74.750 30.280 ;",

    "RECT 70.762 29.500 74.750 30.042 ;":
        "RECT 70.765 29.500 74.750 30.040 ;",

    "RECT 70.700 29.500 74.750 29.949 ;":
        "RECT 70.700 29.500 74.750 29.945 ;",

    "RECT 70.600 29.500 74.750 29.799 ;":
        "RECT 70.600 29.500 74.750 29.795 ;",

    # OR2101 / VDD
    "RECT 12.050 28.754 14.950 48.700 ;":
        "RECT 12.050 28.755 14.950 48.700 ;",

    "RECT 11.850 28.954 14.950 48.700 ;":
        "RECT 11.850 28.955 14.950 48.700 ;",

    "RECT 12.104 28.700 14.950 48.700 ;":
        "RECT 12.105 28.700 14.950 48.700 ;",

    "RECT 11.950 28.854 14.950 48.700 ;":
        "RECT 11.950 28.855 14.950 48.700 ;",
}

text = dst.read_text()

for old, new in replacements.items():
    count = text.count(old)

    if count != 1:
        raise SystemExit(
            f"Expected exactly one occurrence, found {count}: {old}"
        )

    text = text.replace(old, new)

dst.write_text(text)

# ------------------------------------------------------------
# Validate all pin geometry against 0.005 um manufacturing grid
# ------------------------------------------------------------

grid = Decimal("0.005")

macro = None
pin = None
violations = []

number_re = re.compile(
    r"[-+]?(?:\d+(?:\.\d*)?|\.\d+)"
)

for lineno, line in enumerate(text.splitlines(), 1):
    s = line.strip()
    low = s.lower()

    if low.startswith("macro "):
        macro = s.split()[1]
        pin = None
        continue

    if macro and low.startswith("pin "):
        pin = s.split()[1]
        continue

    if low.startswith("end "):
        name = s.split()[1]

        if pin is not None and name.lower() == pin.lower():
            pin = None
        elif macro is not None and name.lower() == macro.lower():
            macro = None
            pin = None

        continue

    if macro and pin and (
        low.startswith("rect ")
        or low.startswith("polygon ")
    ):
        values = [
            Decimal(x)
            for x in number_re.findall(s)
        ]

        bad = [
            value
            for value in values
            if value % grid != 0
        ]

        if bad:
            violations.append(
                (lineno, macro, pin, s, bad)
            )

if violations:
    for lineno, macro, pin, shape, bad in violations:
        print(
            f"{lineno}: {macro}/{pin}: "
            f"{shape} OFFGRID={bad}"
        )

    raise SystemExit(
        f"ERROR: {len(violations)} off-grid pin geometries remain."
    )

print("[OK] SCL C1D OpenLane compatibility LEF generated")
print(f"[OK] Patched rectangles: {len(replacements)}")
print("[OK] OFFGRID_PIN_GEOMETRIES=0")
print(f"[OK] Output: {dst}")
