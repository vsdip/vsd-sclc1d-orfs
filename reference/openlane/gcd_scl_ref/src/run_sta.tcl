# Load the liberty files
read_liberty /home/scl/my_dtech/Open_Source_SCL_1.2micron_PDK_digital/open_source_scl_c1d/open_pdks/sclc1d/digital_c1d/lib/nldm_tt_27_1p5.lib

# Read the gate-level netlist (the .v file used to generate your DEF)
read_verilog /home/scl/EDA/OpenLane/designs/qa_check/runs/RUN/results/routing/shift_reg_rt_sim.v

# Set the top module name
link_design shift_register_256



# Read the parasitics you just generated
read_spef /home/scl/EDA/OpenLane/designs/qa_check/runs/RUN/results/spef/shift_reg_rt.spef



create_clock -name CLK -period 2 [get_ports clk]

# Generate reports
report_checks -path_delay min_max -format full_clock_expanded > timing_report.txt
report_tns > tns_report.txt
report_wns > wns_report.txt

write_sdf /home/scl/EDA/OpenLane/designs/qa_check/runs/RUN/results/sta/shift_reg_rt.sdf
