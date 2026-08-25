export DESIGN_NAME = gcd
export PLATFORM = sclc1d

export VERILOG_FILES = $(sort $(wildcard ./designs/src/$(DESIGN_NAME)/*.v))
export SDC_FILE = ./designs/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc

# Explicit, relaxed first floorplan. Core width is 800 x 4.2 um.
export DIE_AREA = 0 0 4000 4000
export CORE_AREA = 320 292.2 3680 3701.2
export PLACE_DENSITY = 0.10

# Proof-of-flow settings. Re-enable timing optimization after clean routing.
export ABC_AREA = 1
export GPL_TIMING_DRIVEN = 0
export ENABLE_PLACE_REPAIR_TIMING = 0
export SKIP_CTS_REPAIR_TIMING = 1
export SKIP_INCREMENTAL_REPAIR = 1

