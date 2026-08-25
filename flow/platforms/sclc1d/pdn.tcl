# Minimal core-only PDN for the two-metal C1D stack.
add_global_connection -net VDD -inst_pattern {.*} -pin_pattern {^VDD$} -power
add_global_connection -net VSS -inst_pattern {.*} -pin_pattern {^VSS$} -ground
global_connect

set_voltage_domain -name CORE -power VDD -ground VSS
define_pdn_grid -name grid -voltage_domains CORE -pins metal2

# The standard-cell VDD/VSS rails are 9 um wide on metal1.
add_pdn_stripe -grid grid -layer metal1 -width 9.0 -followpins

# Sparse vertical straps on metal2. Tune after the first routed result.
add_pdn_stripe -grid grid -layer metal2 -width 2.5 -pitch 420.0 -offset 210.0
add_pdn_connect -grid grid -layers {metal1 metal2}

