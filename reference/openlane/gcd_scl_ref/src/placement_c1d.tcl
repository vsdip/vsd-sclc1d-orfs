# Save this as designs/counter_SCL180/src/placement_simple.tcl

read_liberty /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lib/nldm_tt_27_1p5.lib

read_lef /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lef/tech_c1d.lef
read_lef /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lef/core_c1d.lef
read_lef /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lef/io_c1d.lef
read_lef /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lef/corner_c1d.lef

read_def "/home/scl/EDA/OpenLane/designs/qa_check/runs/RUN/results/floorplan/shift_reg_pdn.def"

#make_placement_blockage -boundary {2237.5 993.7 2240.1 4022.4} -type soft 
# Direct placement without any variable dependencies
#set_placement_padding -global -left 2 -right 2
global_placement -density 0.2  

detailed_placement 


check_placement -verbose
#set ::env(FP_FILL_CELL) "FILLER1 FILLER2 FILLER3 FILLER4 FILLER5"
#filler_placement -prefix FILLER [list "FILLER1" "FILLER2" "FILLER3" "FILLER4" "FILLER5"]

write_def "/home/scl/EDA/OpenLane/designs/qa_check/runs/RUN/results/placement/shift_reg_pl.def"

puts "Success: Manual placement reached."

write_db /home/scl/EDA/OpenLane/designs/qa_check/runs/RUN/results/placement/shift_reg_plcts.odb

#/home/scl/EDA/openlane/OpenLane/OpenLane/designs/counter_SCL180/runs/RUN_NEW_ALIGNED/results/placement/counter_power.def
#/home/scl/EDA/openlane/OpenLane/OpenLane/designs/counter_SCL180/runs/RUN_NEW_ALIGNED/results/placement/counter_plpdn2.def
