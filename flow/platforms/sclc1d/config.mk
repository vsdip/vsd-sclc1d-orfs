# SCL C1D 1.2 um, 5 V, two-metal core-only ORFS platform.

export PROCESS = 1200

# Technology and cell views
export TECH_LEF = $(PLATFORM_DIR)/lef/tech_c1d.lef
export SC_LEF = $(PLATFORM_DIR)/lef/core_c1d.lef
export LIB_FILES = $(PLATFORM_DIR)/lib/nldm_tt_27_1p5.lib $(ADDITIONAL_LIBS)
# dfflibmap does not recognize the FF description in the supplied Liberty.
# Map the positive-edge internal Yosys flop explicitly to DFFL11 instead.
export DFF_MAP_FILE = $(PLATFORM_DIR)/dff_map.v
export LATCH_MAP_FILE = $(PLATFORM_DIR)/latch_map.v
export GDS_FILES = $(PLATFORM_DIR)/gds/core_c1d.gds $(ADDITIONAL_GDS)

# Avoid nonstandard or multi-output cells during generic optimization.
export DONT_USE_CELLS += TBUF01 TINV01 PDDR02 PDDR04 DEC24H DEC24L CDRI02
export DONT_USE_CELLS += DFCL11 DFFL11 DFPC11 DFPR11 LTCH11 LTCL11 LTPC11 LTPR11

# Keep filler insertion disabled during first platform bring-up.
# After validating the 0.01 um LEF site definition, test:
export FILL_CELLS = FILLER1 FILLER2 FILLER3 FILLER4 FILLER5

# Yosys and ABC
export TIEHI_CELL_AND_PORT = VDDCON TIEHI
export TIELO_CELL_AND_PORT = VSSCON TIELO
export MIN_BUF_CELL_AND_PORTS = DELBUF IN1 OUT1
export ABC_DRIVER_CELL = DELBUF
export ABC_LOAD_IN_FF = 5
export MATCH_CELL_FOOTPRINT = 0

# Floorplan and PDN
export PLACE_SITE = CORE
export IO_PLACER_H = metal1
export IO_PLACER_V = metal2
export PDN_TCL = $(PLATFORM_DIR)/pdn.tcl
export MAKE_TRACKS = $(PLATFORM_DIR)/make_tracks.tcl

# CTS: restrict inference to non-inverting buffers.
export CTS_BUF_LIST = DELBUF

# Routing
export MIN_ROUTING_LAYER = metal1
export MIN_CLK_ROUTING_LAYER = metal1
export MAX_ROUTING_LAYER = metal2
export VIA_IN_PIN_MIN_LAYER = metal1
export VIA_IN_PIN_MAX_LAYER = metal2
export FASTROUTE_TCL = $(PLATFORM_DIR)/fastroute.tcl

# Parasitics
export LAYER_PARASITICS_FILE = $(PLATFORM_DIR)/setRC.tcl
export RCX_RULES = $(PLATFORM_DIR)/rcx/scl_c1d.rcx.lib

# 5 V power grid
export PWR_NETS_VOLTAGES = VDD 5.0
export GND_NETS_VOLTAGES = VSS 0.0
export IR_DROP_LAYER = metal1

# KLayout stream-out. The DRC/LVS decks are installed beside the platform for
# manual validation after the first route; current ORFS does not standardize
# platform variables for those two deck paths.
export KLAYOUT_TECH_FILE = $(PLATFORM_DIR)/scl_c1d.lyt
export CDL_FILE = $(PLATFORM_DIR)/cdl/core_iolib_c1d.cdl

export USE_FILL = 0
# Cells with grouped related_pin timing arcs unsupported by ABC SCL
export DONT_USE_CELLS += ADOR16 AND201 AND301 AND401 AND501 AND601 AND701 AND801 AOI401
export DONT_USE_CELLS += NND300 NND301 NND401 NND501 NND601 NND701
export DONT_USE_CELLS += NOR200 NOR201 NOR300 NOR301 NOR401 NOR501 NOR601 NOR701 NOR801
export DONT_USE_CELLS += OR2101 OR3101 OR4101 OR5101 OR7101 OR8101
export DONT_USE_CELLS += XNR201 MX4122 MX2101 MX201B


export SKIP_ANTENNA_REPAIR = 1
export SKIP_ANTENNA_REPAIR_POST_DRT = 1

