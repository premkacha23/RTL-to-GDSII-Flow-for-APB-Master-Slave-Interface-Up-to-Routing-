#### ROUTING ###
read_db results/cts.odb
#read_liberty /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_slow.lib
#read_liberty /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_fast.lib
#read_liberty /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_lvt.lib
#read_liberty /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_typ.lib

#lef files
#read_lef /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_tech.lef
#read_lef /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_stdcell.lef
#read_lef /home/codewolf/open_road/OpenROAD/test/Nangate45/Nangate45_lvt.lef

#read_verilog /home/codewolf/pipe_example.v
set_global_routing_layer_adjustment metal2 0.5
set_global_routing_layer_adjustment metal3 0.5
set_global_routing_layer_adjustment metal4 0.5

global_route -congestion_report_file greport_file.rpt

detailed_route -droute_end_iter 3 -output_drc output_drc.rpt

report_cell_usage 
#report_timing_histogram 
write_db results/route.odb
exit

