#### CLOCK TREE SYNTHESIS ###
#lib files
read_liberty /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_slow.lib
read_liberty /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_fast.lib
read_liberty /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_lvt.lib
read_liberty /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_typ.lib

read_db results/place.odb

#lef files
#read_lef /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_tech.lef
#read_lef /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_stdcell.lef
#read_lef /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_lvt.lef


clock_tree_synthesis -clk_nets clk  
detailed_placement
report_cell_usage 

report_cts

report_clock_skew 
#write_db results/g.odb

#report_timing_histogram 
write_verilog cts.v
write_db results/cts.odb
exit
