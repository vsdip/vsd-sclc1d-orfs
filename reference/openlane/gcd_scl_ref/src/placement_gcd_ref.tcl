puts "=== SCL GCD REFERENCE PLACEMENT ==="

set PDK_DIR [file join $::env(PDK_ROOT) sclc1d digital_c1d]

set FLOORPLAN_DIR "/openlane/designs/gcd_scl_ref/runs/REF/results/floorplan"
set PLACE_DIR "/openlane/designs/gcd_scl_ref/runs/REF/results/placement"

file mkdir $PLACE_DIR

read_liberty [file join $PDK_DIR lib nldm_tt_27_1p5.lib]

read_lef [file join $PDK_DIR lef tech_c1d.lef]
read_lef [file join $PDK_DIR lef core_c1d.lef]
read_lef [file join $PDK_DIR lef io_c1d.lef]
read_lef [file join $PDK_DIR lef corner_c1d.lef]

read_def $FLOORPLAN_DIR/gcd_pdn.def

puts "Starting global placement..."

set gp_start [clock milliseconds]

global_placement -density 0.2

set gp_end [clock milliseconds]

puts "GLOBAL_PLACEMENT_MS=[expr {$gp_end - $gp_start}]"

puts "Starting detailed placement..."

set dp_start [clock milliseconds]

detailed_placement

set dp_end [clock milliseconds]

puts "DETAILED_PLACEMENT_MS=[expr {$dp_end - $dp_start}]"

check_placement -verbose

write_def $PLACE_DIR/gcd_pl.def
write_db  $PLACE_DIR/gcd_pl.odb

puts "Success: GCD reference placement complete."
