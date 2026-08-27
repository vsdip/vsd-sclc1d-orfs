# Process node
set ::env(PROCESS) C1D
set ::env(DEF_UNITS_PER_MICRON) 1000

set ::env(SYNTH_DRIVING_CELL) inv0d1
set ::env(SYNTH_DRIVING_CELL_PIN) A


set ::env(OUTPUT_CAP_LOAD) 10.0
set ::env(QUIT_ON_LINTER_ERRORS) 0

set ::env(CLOCK_PERIOD) 10.0
set ::env(MAX_FANOUT_CONSTRAINT) 10
set ::env(CLOCK_PORT) "CLK"
set ::env(CLOCK_NET) "CLK"

#set ::env(SYNTH_TIEHI_PORT) ""
#unset -nocomplain ::env(SYNTH_TIEHI_PORT)
#unset -nocomplain ::env(SYNTH_TIELO_PORT)
#unset -nocomplain ::env(SYNTH_TIELO_PORT)
set ::env(SYNTH_TIEHI_PORT) "bufbd1 I"
set ::env(SYNTH_TIELO_PORT) "bufbd1 I"
set ::env(TIEHI_CELL) "VDDCON TIEEHI"
set ::env(TIELO_CELL) "VSSCON TIELO"
set ::env(SYNTH_USE_TIE_CELLS) 1
#set ::env(SYNTH_TIEHI_PORT) "1'b1"
#set ::env(SYNTH_TIELO_PORT) "1'b0"
set ::env(SYNTH_NO_HILOMAP) 1
set ::env(SYNTH_USE_PG_PINS_DEFINES) 1
set ::env(SYNTH_STRATEGY) "AREA 0"
set ::env(SYNTH_CONSTANTS_TO_PORTS) 1
set ::env(SYNTH_FLAT_TOP) 1
#set ::env(SYNTH_TIEHI_PORT) "LOGIC1 Y"
#set ::env(SYNTH_TIELO_PORT) "LOGIC0 Y"
set ::env(SYNTH_MIN_BUF_CELL) bufbd1
set ::env(SYNTH_MIN_BUF_PORT) "bufbd1 I Z"
set ::env(VDD_NET) "VDD"
set ::env(GND_NET) "VSS"
 #check_power_grid -net $::env(VDD_NETS)
 #check_power_grid -net $::env(GND_NETS)
# --- Match the LEF geometry exactly ---
set ::env(PLACE_SITE) "CORE"
set ::env(PLACE_SITE_WIDTH) 0.1
set ::env(PLACE_SITE_HEIGHT) 48.7
set ::env(FP_CORE_CANVAS_OFFSET) "0.000"
set ::env(PWL_CUSTOM_FLOORPLAN_SCRIPT) "$::env(DESIGN_DIR)/src/floorplan_c1d.tcl"
# Disable timing-driven placement (SDC issues can crash OpenROAD)
set ::env(FP_IC_EFFORT) 0
set ::env(FP_PDN_CONNECT_IO_PADS) 1
set ::env(FP_PDN_CORE_RING) 1
set ::env(FP_PDN_ENABLE_RAILS) 1

set ::env(RUN_FILL_INSERTION) 1
set ::env(FP_FILL_CELL) "FILLER1 FILLER2 FILLER3 FILLER4 FILLER5"
# IO Placement: Use a different mode to avoid boundary math errors
set ::env(FP_IO_MODE) 1
set ::env(FP_IO_HLAYER) "metal1"
set ::env(FP_IO_VLAYER) "metal2"
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 0
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) 0
set ::env(FP_TAP_HORIZONTAL_HALO) 10
set ::env(FP_TAP_VERTICAL_HALO) 10
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 22000 22000"
set ::env(CORE_AREA) "1000 1000 21000 21000"
set ::env(FP_IO_VTRACKS_PITCH) 4.2
set ::env(FP_IO_HTRACKS_PITCH) 4.0
set ::env(FP_IO_VOFFSET) 3.0
set ::env(FP_IO_HOFFSET) 2.0
# Increase the margin (sometimes Segfaults happen because the die is too tight)
#set ::env(FP_CORE_UTIL) 20
#set ::env(FP_SIZING) relative

# Force the core to snap to the manufacturing grid (0.005 from your grep)
#set ::env(FP_CORE_CANVAS_OFFSET) "0.005"
set ::env(FP_TAPS_INSERTION) 0
set ::env(RUN_TAP_DECAP_INSERTION) 0
#set ::env(FP_SIZING) relative
#set ::env(FP_CORE_UTIL) 30
set ::env(FP_PDN_ENABLE) 1
set ::env(FP_PDN_AUTO_SHUTDOWN) 1
set ::env(FP_TIEHI_CELL_AND_PORT) "TIEHI"
set ::env(FP_TIELO_CELL_AND_PORT) "TIELO"
set ::env(RUN_CTS) 0
set ::env(RUN_POST_CTS_STA) 0
set ::env(RUN_PRE_CTS_STA) 0
set ::env(SYNTH_FLAT_TOP) 1
set ::env(DISABLE_RESIZER_TIMING_DRIVEN) 1
set ::env(RUN_SIMPLE_STA) 0

# Global Placement Cell Padding
#set ::env(GPL_CELL_PADDING) 0
# Core Utilization (percentage of the area occupied by cells)
#set ::env(FP_CORE_UTIL) 50
# Diode Padding (usually needed by the same calculation script)
set ::env(DIODE_PADDING) 2


if { ![info exist ::env(STD_CELL_LIBRARY)] } {
	set ::env(STD_CELL_LIBRARY) digital_c1d
}
if { ![info exist ::env(STD_CELL_LIBRARY_OPT)] } {
	set ::env(STD_CELL_LIBRARY_OPT) digital_c1d
}

# Placement site for core cells
# This can be found in the technology lef
set ::env(VDD_PIN) "VDD"
set ::env(GND_PIN) "VSS"

set ::env(VDD_PIN_VOLTAGE) "5.00"
set ::env(GND_PIN_VOLTAGE) "0.00"
set ::env(FP_PDN_ENABLE_GLOBAL_CONNECTIONS) 1
set ::env(STD_CELL_POWER_PINS) "VDD"
set ::env(STD_CELL_GROUND_PINS) "VSS"

set ::env(BASE_SDC_FILE) "$::env(DESIGN_DIR)/src/counter.sdc"
# --- Placement site info ---
set ::env(PLACE_SITE) "CORE"
set ::env(PLACE_SITE_WIDTH) 0.1
set ::env(PLACE_SITE_HEIGHT) 48.7


set pdk_root"/home/scl/usr/digital_verification_01062026/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d"

# 1. Liberty Files (Timing)
set ::env(LIB_SYNTH) "$pdk_path/digital_c1d/lib/scl1u_pads_typ.lib"
set ::env(LIB_FASTEST) "$pdk_path/digital_c1d/lib/scl1u_pads_typ.lib"
set ::env(LIB_SLOWEST) "$pdk_path/digital_c1d/lib/scl1u_pads_typ.lib"
set ::env(LIB_TYPICAL) "$pdk_path/digital_c1d/lib/scl1u_pads_typ.lib"
# 2. LEF Files (Physical)
set ::env(CELLS_LEF)  "$pdk_path/digital_c1d/lef/core_c1d.lef"
set ::env(TECH_LEF)  "$pdk_path/digital_c1d/lef/tech_c1d.lef"
set ::env(EXTRA_LEF)  "$pdk_path/digital_c1d/lef/io_c1d.lef"
set ::env(EXTRA_LEF)  "$pdk_path/digital_c1d/lef/corner.lef"
# 3. GDS File (For final stream-out)
# Even though OpenLane merges this later, we define it to help the back-end tools
#set ::env(GDS_FILES) "$pdk_path/gds/scl18fs120.gds"


puts $::env(PDK_ROOT)
puts $::env(PDK)
puts $::env(STD_CELL_LIBRARY)


# Technology LEF
set ::env(TECH_LEF) "$pdk_path/digital_c1d/lef/tech_c1d.lef"
set ::env(TECH_LEF_MIN) "$pdk_path/digital_c1d/lef/tech_c1d.lef"
set ::env(TECH_LEF_MAX) "$pdk_path/digital_c1d/lef/tech_c1d.lef"
set ::env(CELLS_LEF) [glob "$pdk_path/digital_c1d/lef/core_c1d.lef"]
#set ::env(GDS_FILES) [glob "$pdk_path/gds/scl18fs120.gds"]
#set ::env(STD_CELL_LIBRARY_CDL)	"$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY)/cdl/$::env(STD_CELL_LIBRARY).cdl"

#set ::env(GPIO_PADS_LEF) "\
	#$::env(PDK_ROOT)/$::env(PDK)/libs.ref/sky130_fd_io/lef/sky130_fd_io.lef\
	#$::env(PDK_ROOT)/$::env(PDK)/libs.ref/sky130_fd_io/lef/sky130_ef_io.lef\

#"
# sky130_fd_io.v is not parsable by yosys, so it cannot be included it here just yet...
#set ::env(GPIO_PADS_VERILOG) "\
	#$::env(PDK_ROOT)/$::env(PDK)/libs.ref/sky130_fd_io/verilog/sky130_ef_io.v
#"

#set ::env(GPIO_PADS_PREFIX) "sky130_fd_io sky130_ef_io"

# Optimization library
set ::env(TECH_LEF_OPT) "$pdk_path/digital_c1d/lef/tech_c1d.lef"
set ::env(CELLS_LEF_OPT) [glob "$pdk_path/digital_c1d/lef/core_c1d.lef"]
#set ::env(GDS_FILES_OPT) [glob "$pdk_path/gds/scl18fs120.gds"]
#set ::env(STD_CELL_LIBRARY_OPT_CDL)	"$::env(PDK_ROOT)/$::env(PDK)/libs.ref/$::env(STD_CELL_LIBRARY_OPT)/cdl/$::env(STD_CELL_LIBRARY_OPT).cdl"


# Optimization library slowest corner
#set tmp $::env(STD_CELL_LIBRARY)
#set ::env(STD_CELL_LIBRARY) $::env(STD_CELL_LIBRARY_OPT)
#source "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/$::env(STD_CELL_LIBRARY_OPT)/config.tcl"
#set ::env(LIB_SLOWEST_OPT) $::env(LIB_SLOWEST)
#set ::env(STD_CELL_LIBRARY) digital_c1d
#source "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/$::env(STD_CELL_LIBRARY)/config.tcl"

#set ::env(GPIO_PADS_LEF_CORE_SIDE) "\
	#$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/custom_cells/lef/sky130_fd_io_core.lef\
	#$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/custom_cells/lef/sky130_ef_io_core.lef\
#"

# magic setup
#set ::env(MAGIC_MAGICRC) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/magic/sky130A.magicrc"
#set ::env(MAGIC_TECH_FILE) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/magic/sky130A.tech"

# Klayout setup
#set ::env(KLAYOUT_TECH) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/klayout/tech/$::env(PDK).lyt"
#set ::env(KLAYOUT_PROPERTIES) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/klayout/tech/$::env(PDK).lyp"
#set ::env(KLAYOUT_DEF_LAYER_MAP) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/klayout/tech/$::env(PDK).map"
#set ::env(KLAYOUT_XOR_IGNORE_LAYERS) "81/14"
#set ::env(KLAYOUT_DRC_OPTIONS) [dict create beol 1 feol 1 floating_metal 0 seal 1 offgrid 1] ; # based on KLAYOUT_DRC_RUNSET options
#set ::env(KLAYOUT_DRC_RUNSET) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/klayout/drc/$::env(PDK)_mr.drc"
#set ::env(KLAYOUT_DRC_TECH) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/klayout/$::env(PDK).lydrc"

# netgen setup
#set ::env(NETGEN_SETUP_FILE) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/netgen/sky130A_setup.tcl"
# CTS luts

#set ::env(FP_TAPCELL_DIST) 13

# Tracks info
#set ::env(TRACKS_INFO_FILE) "/home/scl/my_dtech/scl180/libs.tech/openlane/scl18fs120/tracks.info"

# Latch mapping
#set ::env(SYNTH_LATCH_MAP) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/$::env(STD_CELL_LIBRARY)/latch_map.v"

# Tri-state buffer mapping
#set ::env(TRISTATE_BUFFER_MAP) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/$::env(STD_CELL_LIBRARY)/tribuff_map.v"

# Full adder mapping
#set ::env(FULL_ADDER_MAP) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/$::env(STD_CELL_LIBRARY)/fa_map.v"

# Ripple carry adder mapping
#set ::env(RIPPLE_CARRY_ADDER_MAP) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/$::env(STD_CELL_LIBRARY)/rca_map.v"

# Carry select adder mapping
#set ::env(CARRY_SELECT_ADDER_MAP) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/$::env(STD_CELL_LIBRARY)/csa_map.v"

# Default No Synth List
set ::env(NO_SYNTH_CELL_LIST) "inv0d0"
# Default DRC Exclude List
set ::env(DRC_EXCLUDE_CELL_LIST) "inv0d0"

# DRC Exclude List for Optimization library
set ::env(DRC_EXCLUDE_CELL_LIST_OPT) "inv0d0"

# Open-RCX Rules File
#set ::env(RCX_RULES) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/rules.openrcx.$::env(PDK).nom.spef_extractor"
#set ::env(RCX_RULES_MIN) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/rules.openrcx.$::env(PDK).min.spef_extractor"
#set ::env(RCX_RULES_MAX) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/rules.openrcx.$::env(PDK).max.spef_extractor"
#if { [file exists "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/rules.openrcx.$::env(PDK).nom.calibre"] } {
	#set ::env(RCX_RULES) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/rules.openrcx.$::env(PDK).nom.calibre"
	#set ::env(RCX_RULES_MIN) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/rules.openrcx.$::env(PDK).min.calibre"
	#set ::env(RCX_RULES_MAX) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/rules.openrcx.$::env(PDK).max.calibre"
#}

# Extra PDN configs
set ::env(FP_PDN_RAIL_LAYER) metal1
set ::env(FP_PDN_VERTICAL_LAYER) metal2
set ::env(FP_PDN_HORIZONTAL_LAYER) metal1
set ::env(FP_PDN_RAIL_OFFSET) 2
set ::env(FP_PDN_VWIDTH) 1.6
set ::env(FP_PDN_HWIDTH) 20
set ::env(FP_PDN_VSPACING) 1.5
set ::env(FP_PDN_HSPACING) 1.5
set ::env(FP_PDN_VOFFSET) 20
set ::env(FP_PDN_VPITCH) 60
set ::env(FP_PDN_HOFFSET) 20
set ::env(FP_PDN_HPITCH) 60


# Core Ring PDN defaults
set ::env(FP_PDN_CORE_RING_VWIDTH) 9
set ::env(FP_PDN_CORE_RING_HWIDTH) 9
set ::env(FP_PDN_CORE_RING_VSPACING) 2
set ::env(FP_PDN_CORE_RING_HSPACING) 2
set ::env(FP_PDN_CORE_RING_VOFFSET) 2
set ::env(FP_PDN_CORE_RING_HOFFSET) 2

# PDN Macro blockages list
set ::env(MACRO_BLOCKAGES_LAYER) " metal1 metal2"

# Used for parasitics estimation, IR drop analysis, etc
set ::env(DATA_WIRE_RC_LAYER) "metal2"
set ::env(CLOCK_WIRE_RC_LAYER) "metal2"
set ::env(DESIGN_IS_CORE) 0
set ::env(GPIO_PADS_LEF) "$pdk_path/digital_c1d/lef/io_c1d.lef"
# I/O Layer info
#set ::env(FP_IO_HLAYER) "met3"
#set ::env(FP_IO_VLAYER) "met2"
set ::env(GPL_CELL_PADDING) 40
set ::env(DPL_CELL_PADDING) 20
set ::env(PL_TARGET_DENSITY) 0.2
# Routing Layer Info
set ::env(GRT_MARGIN) 4
set ::env(GRT_LAYER_ADJUSTMENTS) "0.0,0.5"
set ::env(TRITONROUTE_REPAIR_PDN_VARS) 0
set ::env(DRT_OPT_ITERS) 400
set ::env(RT_MIN_LAYER) "metal1"
set ::env(RT_MAX_LAYER) "metal2"

set ::env(RT_CLOCK_MIN_LAYER) "metal1"

# CVC
#set ::env(CVC_SCRIPTS_DIR) "$::env(PDK_ROOT)/$::env(PDK)/libs.tech/openlane/cvc"
