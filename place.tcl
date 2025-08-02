### PLACEMENT ###
read_db results/floor.odb

#lib files
read_liberty /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_slow.lib
read_liberty /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_fast.lib
read_liberty /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_lvt.lib
read_liberty /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_typ.lib

#lef files
read_lef /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_tech.lef
read_lef /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_stdcell.lef
read_lef /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_lvt.lef




#sdc file
read_sdc /home/codewolf/apb.sdc
puts "done sdc"

global_placement
detailed_placement
check_placement


#write_db results/g.odb
report_cell_usage 

report_timing_histogram 
write_verilog placement.v
write_db results/place.odb
exit


