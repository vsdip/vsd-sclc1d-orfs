# ============================================================
# SCL C1D PDN configuration for OpenLane 1.0.2 / OpenROAD
#
# Derived from the supplied SCL pdn_c1d.tcl.
#
# IMPORTANT:
# - Do not read LEF/Liberty/DEF here: OpenLane already loaded them.
# - Do not call pdngen here: OpenLane scripts/openroad/pdn.tcl
#   calls pdngen after sourcing FP_PDN_CFG.
# ============================================================

source $::env(SCRIPTS_DIR)/openroad/common/set_global_connections.tcl
set_global_connections

set_voltage_domain \
    -name CORE \
    -power $::env(VDD_NET) \
    -ground $::env(GND_NET)

# SCL reference grid
define_pdn_grid \
    -name "Core_1" \
    -voltage_domain CORE \
    -pins "metal2"

# SCL standard-cell followpin rail
add_pdn_stripe \
    -grid "Core_1" \
    -layer metal1 \
    -width 9.0 \
    -followpins \
    -extend_to_core_ring

# Connect metal1 rails to metal2
add_pdn_connect \
    -grid "Core_1" \
    -layers {"metal1" "metal2"}

# SCL reference core ring
add_pdn_ring \
    -grid "Core_1" \
    -layer {"metal1" "metal2"} \
    -widths "3 3" \
    -spacings "3 3" \
    -core_offsets "30 30"

