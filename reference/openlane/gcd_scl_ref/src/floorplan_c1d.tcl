# OpenROAD Script to bypass the tie-cell crash

read_liberty /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lib/nldm_tt_27_1p5.lib

read_lef /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lef/tech_c1d.lef
read_lef /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lef/core_c1d.lef
read_lef /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lef/io_c1d.lef
read_lef /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lef/corner_c1d.lef
read_verilog /home/scl/EDA/OpenLane/designs/qa_check/src/sr_syn.v
link_design shift_register_256


# Read SDC if it exists  -does not exist in shift register case.
if { [file exists /home/scl/EDA/openlane/OpenLane/OpenLane/designs/check_stdcells/src/counter_pad.sdc] } {
    read_sdc /home/scl/EDA/openlane/OpenLane/OpenLane/designs/check_stdcells/src/counter_pad.sdc
}

# The manual command that worked in your terminal
# Using 'eval' ensures the list from DIE_AREA is parsed correctly
initialize_floorplan -site $::env(PLACE_SITE) -die_area "$::env(DIE_AREA)" -core_area "$::env(CORE_AREA)"

# ---------------------------------------------------------
set block [[ord::get_db_block] getRows]
set count 0
foreach row $block {
    if { [expr $count % 2] != 0 } {
        # Delete every odd-numbered row to create a 1-row gap
        odb::dbRow_destroy $row
    }
    incr count
}
puts "Custom Row Modification: Removed alternating rows to prevent overlaps."
# ---------------------------------------------------------

# 4. Save the result
set output_def "/home/scl/EDA/OpenLane/designs/qa_check/runs/RUN/results/floorplan/shift_reg_fp.def"
write_def $output_def
#/home/scl/EDA/openlane/OpenLane/OpenLane/designs/counter_SCL180/runs/RUN_NEW_ALIGNED/results/floorplan/counter_fp_pdn.def
#puts "Custom Floorplan: Successfully bypassed the crashing tie-cell insertion."
# Save the result so the next step (Placement) can find it
# Replace the failing line with this:
#write_def "/home/scl/EDA/openlane/OpenLane/OpenLane/designs/counter_SCL180/runs/RUN_NEW_ALIGNED/results/floorplan/cntpdn.def"

puts "Success: Floorplan saved to results folder."
 #/home/scl/EDA/openlane/OpenLane/OpenLane/designs/counter_SCL180/runs/RUN_NEW_ALIGNED/results/floorplan/counter_pdn.def

