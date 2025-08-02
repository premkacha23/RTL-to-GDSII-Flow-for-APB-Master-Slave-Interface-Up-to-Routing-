create_clock -name clk -period 2.0 [get_ports clk]

set_input_delay 1.2 -clock clk [get_ports {reset_n transfer read_write wr_addr[7] wr_addr[6] wr_addr[5] wr_addr[4] wr_addr[3] wr_addr[2] wr_addr[1] wr_addr[0] wr_data[7] wr_data[6] wr_data[5] wr_data[4] wr_data[3] wr_data[2] wr_data[1] wr_data[0] rd_addr[7] rd_addr[6] rd_addr[5] rd_addr[4] rd_addr[3] rd_addr[2] rd_addr[1] rd_addr[0]}]

set_output_delay 0.8 -clock clk [get_ports { rd_data[7] rd_data[6] rd_data[5] rd_data[4] rd_data[3] rd_data[2] rd_data[1] rd_data[0] done}]

set_clock_uncertainty -setup 0.3 [get_clocks clk]

set_clock_uncertainty -hold  0.3 [get_clocks clk]
