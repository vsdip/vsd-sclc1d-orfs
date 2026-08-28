# ============================================================
# VSD - SCL C1D OpenLane 1.0.x compatibility
# ============================================================

set sclc1d_lib_root \
    "$::env(PDK_ROOT)/sclc1d/libs.ref/digital_c1d"

# ------------------------------------------------------------
# LEF
# ------------------------------------------------------------

set ::env(TECH_LEF) \
    "$sclc1d_lib_root/lef/tech_c1d.lef"

set ::env(CELLS_LEF) \
    "$sclc1d_lib_root/lef/core_c1d.lef"


# ------------------------------------------------------------
# Liberty
# ------------------------------------------------------------

set sclc1d_core_lib \
    "$sclc1d_lib_root/lib/nldm_tt_27_1p5.lib"

set ::env(LIB_SYNTH)          $sclc1d_core_lib
set ::env(LIB_SYNTH_COMPLETE) $sclc1d_core_lib
set ::env(LIB_TYPICAL)        $sclc1d_core_lib
set ::env(LIB_FASTEST)        $sclc1d_core_lib
set ::env(LIB_SLOWEST)        $sclc1d_core_lib


# ------------------------------------------------------------
# DEF / placement site
# ------------------------------------------------------------

set ::env(DEF_UNITS_PER_MICRON) 1000

set ::env(PLACE_SITE)        "CORE"
set ::env(PLACE_SITE_WIDTH)  0.01
set ::env(PLACE_SITE_HEIGHT) 48.7


# ------------------------------------------------------------
# Power
# ------------------------------------------------------------

set ::env(VDD_PIN) "VDD"
set ::env(GND_PIN) "VSS"

set ::env(STD_CELL_POWER_PINS)  "VDD"
set ::env(STD_CELL_GROUND_PINS) "VSS"


# ------------------------------------------------------------
# Cell exclusion lists
# ------------------------------------------------------------

set ::env(NO_SYNTH_CELL_LIST) \
    "$::env(PDK_ROOT)/sclc1d/libs.tech/openlane/digital_c1d/no_synth.cells"

set ::env(DRC_EXCLUDE_CELL_LIST) \
    "$::env(PDK_ROOT)/sclc1d/libs.tech/openlane/digital_c1d/drc_exclude.cells"


# ------------------------------------------------------------
# Synthesis
# ------------------------------------------------------------

set ::env(SYNTH_DRIVING_CELL) "INVR01"
set ::env(SYNTH_DRIVING_CELL_PIN) "OUT1"

set ::env(SYNTH_CLK_DRIVING_CELL) "INVR01"
set ::env(SYNTH_CLK_DRIVING_CELL_PIN) "OUT1"

set ::env(SYNTH_MIN_BUF_PORT) "DELBUF IN1 OUT1"

set ::env(SYNTH_TIEHI_PORT) "VDDCON TIEHI"
set ::env(SYNTH_TIELO_PORT) "VSSCON TIELO"

set ::env(OUTPUT_CAP_LOAD) 49.5
set ::env(MAX_FANOUT_CONSTRAINT) 16
set ::env(MAX_TRANSITION_CONSTRAINT) 2.5

# SCL Liberty / ABC compatibility
set ::env(SYNTH_STRATEGY) "AREA 0"
set ::env(SYNTH_BUFFERING) 0
set ::env(SYNTH_SIZING) 0


# ------------------------------------------------------------
# CTS
# ------------------------------------------------------------

set ::env(CTS_ROOT_BUFFER) "INVR01"
set ::env(CTS_CLK_BUFFER_LIST) "INVR01"

set ::env(CTS_MAX_CAP) 0.806


# ------------------------------------------------------------
# SCL physical tie cells
#
# VDDCON/VSSCON exist in Liberty but there are no corresponding
# physical LEF masters.
# ------------------------------------------------------------

set ::env(SCL_SKIP_TIE_INSERTION) 1


# ------------------------------------------------------------
# Routing
# ------------------------------------------------------------

set ::env(RT_MIN_LAYER) "metal1"
set ::env(RT_MAX_LAYER) "metal2"

set ::env(RT_CLOCK_MIN_LAYER) "metal1"
set ::env(RT_CLOCK_MAX_LAYER) "metal2"

set ::env(FP_IO_HLAYER) "metal1"
set ::env(FP_IO_VLAYER) "metal2"

set ::env(GRT_LAYER_ADJUSTMENTS) "0.0,0.5"


# ------------------------------------------------------------
# PDN
# ------------------------------------------------------------

set ::env(FP_PDN_RAIL_LAYER)       "metal1"
set ::env(FP_PDN_HORIZONTAL_LAYER) "metal1"
set ::env(FP_PDN_VERTICAL_LAYER)   "metal2"

set ::env(FP_PDN_CFG) \
    "$::env(DESIGN_DIR)/src/pdn_scl_openlane.tcl"

set ::env(FP_PDN_AUTO_ADJUST) 0


# ------------------------------------------------------------
# SCL placement architecture
# ------------------------------------------------------------

set ::env(SCL_DELETE_ALTERNATE_ROWS) 1
