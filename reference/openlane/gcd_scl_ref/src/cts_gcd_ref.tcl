puts "=== SCL GCD REFERENCE CTS ==="

set PDK_DIR [file join $::env(PDK_ROOT) sclc1d digital_c1d]

set DESIGN_DIR "/openlane/designs/gcd_scl_ref/src"
set PLACE_DIR  "/openlane/designs/gcd_scl_ref/runs/REF/results/placement"
set CTS_DIR    "/openlane/designs/gcd_scl_ref/runs/REF/results/cts"

file mkdir $CTS_DIR

read_liberty [file join $PDK_DIR lib nldm_tt_27_1p5.lib]

read_db $PLACE_DIR/gcd_pl.odb

read_sdc $DESIGN_DIR/gcd.sdc

puts "Clock before CTS:"
report_clocks

puts "Starting clock tree synthesis..."

set cts_start [clock milliseconds]

clock_tree_synthesis \
    -root_buf INVR01 \
    -buf_list "INVR01" \
    -sink_clustering_enable

repair_clock_nets

puts "Legalizing CTS cells..."

detailed_placement

set_propagated_clock [all_clocks]

set cts_end [clock milliseconds]

puts "CTS_RUNTIME_MS=[expr {$cts_end - $cts_start}]"

check_placement -verbose

write_db  $CTS_DIR/gcd_cts.odb
write_def $CTS_DIR/gcd_cts.def

puts "Success: GCD reference CTS complete."
