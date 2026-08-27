
## ----------------------------------------------------------------------------
# OpenROAD Routing Script for SCL 1200nm
# ----------------------------------------------------------------------------

# Read design files
# Update these paths to your actual SCL120 .lib and .lef locations

read_liberty /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lib/nldm_tt_27_1p5.lib

read_lef /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lef/tech_c1d.lef
read_lef /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lef/core_c1d.lef
read_lef /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lef/io_c1d.lef
read_lef /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lef/corner_c1d.lef

# Update path to your SCL1200 placement DEF
#read_def "/home/scl/EDA/OpenLane/designs/qa_check/runs/RUN/results/placement/shift_reg_pl.def"

# Update path to your SCL1200 CTS DEF
read_def "/home/scl/EDA/OpenLane/designs/qa_check/runs/RUN/results/cts/Shift_reg_post_plcts.def"

# ----------------------------------------------------------------------------
# Track definitions (Based on LEF: metal1 Pitch 4.0, metal2 Pitch 4.2)
# ----------------------------------------------------------------------------
# Syntax: make_tracks <layer> -x_offset <off> -x_pitch <pit> -y_offset <off> -y_pitch <pit>
make_tracks metal1 -x_offset 0.0 -x_pitch 4.0 -y_offset 0.0 -y_pitch 4.0
make_tracks metal2 -x_offset 0.0 -x_pitch 4.2 -y_offset 0.0 -y_pitch 4.2

# ----------------------------------------------------------------------------
# Pin Placement
# Using metal1 (Horizontal) and metal2 (Vertical) as per LEF directions
# ----------------------------------------------------------------------------
place_pins -hor_layers {metal1} -ver_layers {metal2}

# ----------------------------------------------------------------------------
# Routing layer settings
# ----------------------------------------------------------------------------
set_global_routing_layer_adjustment metal1 0
set_global_routing_layer_adjustment metal2 0

# Restricted to the 2 layers defined in your Tech LEF
set_routing_layers -signal metal1-metal2 -clock metal1-metal2

#set_net_routing_rule -net one_ -type special
# ----------------------------------------------------------------------------
# Global routing
# ----------------------------------------------------------------------------
global_route -allow_congestion -verbose
#----------------------------------------------------------------------------

#read_guides /home/scl/EDA/openlane/OpenLane/OpenLane/route.guide
# Detailed routing
# ----------------------------------------------------------------------------
detailed_route \
    -top_routing_layer metal2 \
    -via_in_pin_bottom_layer metal1 \
    -via_in_pin_top_layer metal2 \
    -verbose 1
write_def "/home/scl/EDA/OpenLane/designs/qa_check/runs/RUN/results/routing/shift_reg_rt.def"
write_verilog -include_pwr_gnd "/home/scl/EDA/OpenLane/designs/qa_check/runs/RUN/results/routing/shift_reg_rt_pwr.v"
write_verilog -remove_cells {FILLER1 FILLER2 FILLER3 FILLER4 FILLER5} /home/scl/EDA/OpenLane/designs/qa_check/runs/RUN/results/routing/shift_reg_rt_sim.v


