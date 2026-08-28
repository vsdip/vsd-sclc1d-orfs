# ============================================================
# GCD - SCL C1D OpenLane reference configuration
# ============================================================

set ::env(DESIGN_NAME) "gcd"
set ::env(STD_CELL_LIBRARY) "digital_c1d"
set ::env(STD_CELL_LIBRARY_OPT) "digital_c1d"

set ::env(VERILOG_FILES) "\
    $::env(DESIGN_DIR)/src/gcd.v"

# GCD clock
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_NET)  "clk"
set ::env(CLOCK_PERIOD) "100.0"

# Preserve the same geometry used in our successful
# SCL reference experiment.
set ::env(FP_SIZING) "absolute"
set ::env(DIE_AREA)  "0 0 4000 4000"
set ::env(CORE_AREA) "320 292.2 3680 3701.2"

# Defined by SCL technology LEF:
# SITE CORE = 0.01 x 48.700 um
set ::env(PLACE_SITE) "CORE"

# Placement target used in SCL reference script
set ::env(PL_TARGET_DENSITY) "0.20"

# SCL C1D has metal1 + metal2 routing
set ::env(RT_MIN_LAYER) "metal1"
set ::env(RT_MAX_LAYER) "metal2"

set ::env(RT_CLOCK_MIN_LAYER) "metal1"
set ::env(RT_CLOCK_MAX_LAYER) "metal2"

# Enable normal physical-design stages
set ::env(RUN_CTS) 1
set ::env(FP_PDN_ENABLE) 1


# ============================================================
# Validated SCL reference placement settings
# ============================================================

set ::env(GPL_CELL_PADDING) 0
set ::env(DPL_CELL_PADDING) 0

set ::env(PL_TIME_DRIVEN) 0
set ::env(PL_ROUTABILITY_DRIVEN) 0

set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0
set ::env(PL_OPTIMIZE_MIRRORING) 0
