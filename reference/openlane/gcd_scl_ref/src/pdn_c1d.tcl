# PDN.tcl # for VDD & VSS straps

read_liberty /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lib/nldm_tt_27_1p5.lib

read_lef /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lef/tech_c1d.lef
read_lef /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lef/core_c1d.lef
read_lef /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lef/io_c1d.lef
read_lef /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lef/corner_c1d.lef

read_def /home/scl/EDA/OpenLane/designs/qa_check/runs/RUN/results/floorplan/shift_reg_fp.def

add_global_connection -net VDD -pin_pattern VDD -power               
                     
add_global_connection -net VSS -pin_pattern VSS -ground
                     
                      
                      
global_connect

set_voltage_domain -name CORE -power VDD -ground VSS
define_pdn_grid -name "Core_1" -voltage_domain CORE -pins "metal2" 
set_pdnsim_net_voltage -net VDD -voltage 5.0
set_pdnsim_net_voltage -net VSS -voltage 0.0
#add_pdn_ring -grid "Core" -layers {"metal1" "metal2"} -widths "7 7" -spacings "5 5" -nets "VSS VDD" -core_offsets "5 5" -connect_to_pads -connect_to_pad_layers {"metal2" "metal1"} 

add_pdn_stripe -grid "Core_1" -layer metal1 -width 9.0 -followpins -extend_to_core_ring 

#add_pdn_stripe -grid "Core_1" -layer metal2 -width 2.5 -pitch 8000 -offset 10 -extend_to_core_ring 

#add_pdn_stripe -grid "Core_1" -layer metal2 -width 2.5 -pitch 10000 -offset 10 -extend_to_core_ring 
add_pdn_connect -grid "Core_1" -layers {"metal1" "metal2"}

#route_manual -layers metal2 -rects {1201 1 4695 83} -net VDD

add_pdn_ring -grid "Core_1" -layer {"metal1" "metal2"} -widths "3 3" -spacings "3 3" -core_offsets "30 30"

#add_pdn_connect -grid "Core_1" -layers {"metal1" "metal2"}  
###################################add_pdn_connect -grid "Core" -layers {"metal1" "metal2"}
#add_pdn_ring -grid std_cell_grid -layers {metal1 metal2} -widths 7.0 -spacings 5.0 -core_offsets 3.0
#add_pdn_ring -grid std_cell_grid -layer {"metal1" "metal2"} -widths "7 7" -spacings "5 5" -core_offsets "3 3" -add_connect -connect_to_pads
#add_pdn_connect -grid std_cell_grid -layers {metal1 metal2}
#add_pdn_connect -grid std_cell_grid -layers {metal1 metal2}

pdngen

# Corrected namespace syntax (no spaces)

write_def /home/scl/EDA/OpenLane/designs/qa_check/runs/RUN/results/floorplan/shift_reg_pdn.def
