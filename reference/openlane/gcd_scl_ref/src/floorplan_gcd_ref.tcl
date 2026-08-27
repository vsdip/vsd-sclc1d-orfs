puts "=== SCL GCD REFERENCE FLOORPLAN ==="

set PDK_DIR [file join $::env(PDK_ROOT) sclc1d digital_c1d]

set DESIGN_DIR "/openlane/designs/gcd_scl_ref/src"
set RESULT_DIR "/openlane/designs/gcd_scl_ref/runs/REF/results/floorplan"

file mkdir $RESULT_DIR

read_liberty [file join $PDK_DIR lib nldm_tt_27_1p5.lib]

read_lef [file join $PDK_DIR lef tech_c1d.lef]
read_lef [file join $PDK_DIR lef core_c1d.lef]
read_lef [file join $PDK_DIR lef io_c1d.lef]
read_lef [file join $PDK_DIR lef corner_c1d.lef]

read_verilog $DESIGN_DIR/gcd_syn.v
link_design gcd

if {[file exists $DESIGN_DIR/gcd.sdc]} {
    puts "Reading GCD SDC"
    read_sdc $DESIGN_DIR/gcd.sdc
}

set ::env(PLACE_SITE) "CORE"
set ::env(DIE_AREA) "0 0 4000 4000"
set ::env(CORE_AREA) "320 292.2 3680 3701.2"

initialize_floorplan \
    -site $::env(PLACE_SITE) \
    -die_area "$::env(DIE_AREA)" \
    -core_area "$::env(CORE_AREA)"

puts "Rows before SCL alternate-row removal: [llength [[ord::get_db_block] getRows]]"

# Preserve the row treatment used by the supplied SCL reference script.
set rows [[ord::get_db_block] getRows]
set count 0

foreach row $rows {
    if {[expr {$count % 2}] != 0} {
        odb::dbRow_destroy $row
    }
    incr count
}

puts "Rows after SCL alternate-row removal: [llength [[ord::get_db_block] getRows]]"

write_def $RESULT_DIR/gcd_fp.def

puts "Success: GCD reference floorplan complete."
