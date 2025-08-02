######## DEFINING REQUIRED INPUTS IN THIS AREA #######

#reading input files

#lib files
read_liberty /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_slow.lib
read_liberty /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_fast.lib
read_liberty /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_lvt.lib
read_liberty /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_typ.lib
read_liberty /home/codewolf/open_road/OpenROAD/test/Nangate45/fake_macros.lib
#lef files
read_lef /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_tech.lef
read_lef /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_stdcell.lef
read_lef /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_lvt.lef
read_lef /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45.lef
read_lef /home/codewolf/open_road/OpenROAD/test/Nangate45/fake_macros.lef

puts "read verilog"
#Synthesized verilog file
read_verilog /home/codewolf/apb_synth_f.v


link_design apb

#sdc file
read_sdc /home/codewolf/apb.sdc
puts "done sdc"


#### FLOORPLAN  #######
puts "sourcing floorplan script"
initialize_floorplan -die_area "0 0 38 38" -core_area "0 0 38 38" -site FreePDK45_38x28_10R_NP_162NW_34O

#metal tracks
puts "creating tracks"
make_tracks metal1 -x_offset 0.000 -x_pitch 0.19 -y_offset 0.000 -y_pitch 0.14
make_tracks metal2 -x_offset 0.000 -x_pitch 0.19 -y_offset 0.000 -y_pitch  0.14
make_tracks metal3 -x_offset 0.000 -x_pitch 0.19 -y_offset 0.000 -y_pitch  0.14
make_tracks metal4 -x_offset 0.000 -x_pitch 0.28 -y_offset 0.000 -y_pitch  0.28
make_tracks metal5 -x_offset 0.000 -x_pitch 0.28 -y_offset 0.000 -y_pitch  0.28
make_tracks metal6 -x_offset 0.000 -x_pitch 0.28 -y_offset 0.000 -y_pitch  0.28
make_tracks metal7 -x_offset 0.000 -x_pitch 0.8 -y_offset 0.000 -y_pitch  0.8
make_tracks metal8 -x_offset 0.000 -x_pitch 0.8 -y_offset 0.000 -y_pitch  0.8
make_tracks metal9 -x_offset 0.000 -x_pitch 1.6 -y_offset 0.000 -y_pitch  1.6
make_tracks metal10 -x_offset 0.000 -x_pitch 1.6 -y_offset 0.000 -y_pitch 1.6
puts "creating powerplan"
#power planing
#pin placement
place_pins -random -hor_layers metal3 -ver_layers metal4
puts "pin placement done"
#endcap and well tap cell placemen
puts "endcap cell placed"
report_cell_usage
puts "cell usage done"


add_global_connection -defer_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDD$} -power
add_global_connection -defer_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDDPE$}
add_global_connection -defer_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDDCE$}
add_global_connection -defer_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSS$} -ground
add_global_connection -defer_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSSE$}

global_connect

set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}

define_pdn_grid -name {grid} -voltage_domains {CORE}

add_pdn_stripe -grid {grid} -layer {metal1} -width 0.07 -pitch 1.4  -offset 0 -followpins
add_pdn_stripe -grid {grid} -layer {metal2} -width 0.14 -pitch 3.8  -offset 0 

add_pdn_stripe -grid {grid} -layer {metal3} -width 0.14 -pitch 5.6 -offset 0 -extend_to_boundary
add_pdn_stripe -grid {grid} -layer {metal4} -width 0.14 -pitch 5.6 -offset 0 -extend_to_boundary
add_pdn_stripe -grid {grid} -layer {metal5} -width 0.14 -pitch 5.6 -offset 0 -extend_to_boundary
add_pdn_stripe -grid {grid} -layer {metal6} -width 0.14 -pitch 5.6 -offset 0 -extend_to_boundary
add_pdn_stripe -grid {grid} -layer {metal7} -width 0.4  -pitch 8  -offset 0 -extend_to_boundary
add_pdn_stripe -grid {grid} -layer {metal8} -width 0.4  -pitch 8  -offset 0 -extend_to_boundary
add_pdn_stripe -grid {grid} -layer {metal9} -width 0.8  -pitch 16  -offset 0 -extend_to_boundary
add_pdn_stripe -grid {grid} -layer {metal10} -width 0.8  -pitch 16  -offset 0 -extend_to_boundary

add_pdn_connect -grid {grid} -layers {metal1 metal2}
add_pdn_connect -grid {grid} -layers {metal2 metal3}
add_pdn_connect -grid {grid} -layers {metal3 metal4}
add_pdn_connect -grid {grid} -layers {metal4 metal5}
add_pdn_connect -grid {grid} -layers {metal5 metal6}
add_pdn_connect -grid {grid} -layers {metal6 metal7}
add_pdn_connect -grid {grid} -layers {metal7 metal8}
add_pdn_connect -grid {grid} -layers {metal8 metal9}
add_pdn_connect -grid {grid} -layers {metal9 metal10}

pdngen
tapcell -tapcell_master TAPCELL_X1 -distance 12  -endcap_master TAPCELL_X1

#check_power_grid -net VDD
#check_power_grid -net VSS

report_power 
puts "power checking done"
report_timing_histogram 
puts "timing_histogram done"
write_db results/floor.odb
write_verilog floorplan.v
report_clock_skew
return
exit
