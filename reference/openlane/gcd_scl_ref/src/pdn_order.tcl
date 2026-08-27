read_liberty /home/scl/my_dtech/sclc1d/digital_c1d/lib/nldm_tt_27_1p5_pad.lib
read_lef /home/scl/my_dtech/sclc1d/digital_c1d/lef/tech2.lef
read_lef /home/scl/my_dtech/sclc1d/digital_c1d/lef/ref1.lef
read_lef /home/scl/my_dtech/sclc1d/digital_c1d/lef/io.lef
read_lef /home/scl/my_dtech/sclc1d/digital_c1d/lef/corner.lef

read_def /home/scl/EDA/openlane/OpenLane/OpenLane/designs/check_stdcells/runs/RUN_check/results/floorplan/RO.def

make_io_sites \
-horizontal_site IO \
-vertical_site IO \
-corner_site corner \
-offset 0
# ── 6. Place Corner Cells (always before pads) ────────────
place_corners  PadLessCorner_New 
# ── 7. Place IO Pads ──────────────────────────────────────
# SOUTH — Inputs
place_pad  U_PAD1 -row IO_SOUTH -location 1200 
place_pad  U_PAD2 -row IO_SOUTH -location 1800 
#place_pad -master PVDD01 -row IO_SOUTH -location 2500 pad_vdd_s 
#place_pad -master PVSS01 -row IO_SOUTH -location 3000 pad_vss_s 
# NORTH — Outputs
#place_pad pad_out_0 -row IO_NORTH -location 1000 
#place_pad pad_out_1 -row IO_NORTH -location 2000  
#place_pad pad_out_2 -row IO_NORTH -location 2500 
#place_pad pad_out_3 -row IO_NORTH -location 1500
#place_pad -master PVDD01 -row IO_NORTH -location 3500 pad_vdd_n 
#place_pad -master PVSS01 -row IO_NORTH -location 3000 pad_vss_n 
# WEST — Power/Ground
#place_pad -master PVDD01 -row IO_WEST -location 1800 pad_vdd_w 
#place_pad -master PVSS01 -row IO_WEST -location 2800 pad_vss_w 
#place_pad -master PVDD01 -row IO_EAST -location 900 pad_vdd_e 
#place_pad -master PVSS01 -row IO_EAST -location 1500 pad_vss_e 


# ── 9. Connect Pad Ring ───────────────────────────────────
connect_by_abutment


write_def /home/scl/EDA/openlane/OpenLane/OpenLane/designs/check_stdcells/runs/RUN_check/results/floorplan/RO_io.def
