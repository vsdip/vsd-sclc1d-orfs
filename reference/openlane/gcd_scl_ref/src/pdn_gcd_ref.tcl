puts "=== SCL GCD REFERENCE PDN ==="

set PDK_DIR [file join $::env(PDK_ROOT) sclc1d digital_c1d]

set FLOORPLAN_DIR "/openlane/designs/gcd_scl_ref/runs/REF/results/floorplan"

read_liberty [file join $PDK_DIR lib nldm_tt_27_1p5.lib]

read_lef [file join $PDK_DIR lef tech_c1d.lef]
read_lef [file join $PDK_DIR lef core_c1d.lef]
read_lef [file join $PDK_DIR lef io_c1d.lef]
read_lef [file join $PDK_DIR lef corner_c1d.lef]

read_def $FLOORPLAN_DIR/gcd_fp.def

add_global_connection \
    -net VDD \
    -pin_pattern VDD \
    -power

add_global_connection \
    -net VSS \
    -pin_pattern VSS \
    -ground

global_connect

set_voltage_domain \
    -name CORE \
    -power VDD \
    -ground VSS

define_pdn_grid \
    -name "Core_1" \
    -voltage_domain CORE \
    -pins "metal2"

set_pdnsim_net_voltage -net VDD -voltage 5.0
set_pdnsim_net_voltage -net VSS -voltage 0.0

add_pdn_stripe \
    -grid "Core_1" \
    -layer metal1 \
    -width 9.0 \
    -followpins \
    -extend_to_core_ring

add_pdn_connect \
    -grid "Core_1" \
    -layers {"metal1" "metal2"}

add_pdn_ring \
    -grid "Core_1" \
    -layer {"metal1" "metal2"} \
    -widths "3 3" \
    -spacings "3 3" \
    -core_offsets "30 30"

pdngen

write_def $FLOORPLAN_DIR/gcd_pdn.def

puts "Success: GCD reference PDN complete."
