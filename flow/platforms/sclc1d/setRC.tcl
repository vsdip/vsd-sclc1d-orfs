# First-order RC from tech_c1d.lef.
# R/um = sheet resistance / nominal width.
# C/um = area capacitance * width + 2 * edge capacitance.
set_layer_rc -layer metal1 -resistance 2.083333e-2 -capacitance 2.648e-4
set_layer_rc -layer metal2 -resistance 1.200000e-2 -capacitance 2.390e-4
set_layer_rc -via via1 -resistance 1.700000e-1

set_wire_rc -signal -layer metal1
set_wire_rc -clock -layer metal2

