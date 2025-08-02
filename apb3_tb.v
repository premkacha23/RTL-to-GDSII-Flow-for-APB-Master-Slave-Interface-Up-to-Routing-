`timescale 1ns/1ns

module apb3_tb;

  reg clk;
  reg reset_n;
  reg transfer;
  reg read_write;
  reg [7:0] wr_addr;
  reg [7:0] wr_data;
  reg [7:0] rd_addr;
  wire [7:0] rd_data;
  wire done;

  // DUT instantiation (Top Module)
  apb3 dut (
    .clk(clk),
    .reset_n(reset_n),
    .transfer(transfer),
    .read_write(read_write),
    .wr_addr(wr_addr),
    .wr_data(wr_data),
    .rd_addr(rd_addr),
    .rd_data(rd_data),
    .done(done)
  );

  // Clock Generation: 10ns period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  integer i;

  // Test Sequence
  initial begin
    $dumpfile("apb3.vcd");
    $dumpvars(0, apb3_tb);

    // Initialize signals
    reset_n = 0;
    transfer = 0;
    read_write = 0;
    wr_addr = 0;
    wr_data = 0;
    rd_addr = 0;
    
    // Reset sequence
    @(posedge clk);
    reset_n = 1;
    @(posedge clk);

    // --------------------------
    // WRITE TEST (4 locations)
    // --------------------------
    $display("Starting write test...");
    for (i = 0; i < 4; i = i + 1) begin
      @(posedge clk);
      wr_addr = i;
      wr_data = 8'hA0 + i;
      read_write = 0; // write operation
      transfer = 1;
      
      // Wait for transfer completion
      wait(done == 1);
      transfer = 0;
      
      $display("Write completed: Addr=%0d, Data=0x%0h", wr_addr, wr_data);
      @(posedge clk);
    end

    // --------------------------
    // READ TEST (verify writes)
    // --------------------------
    $display("\nStarting read test...");
    for (i = 0; i < 4; i = i + 1) begin
      @(posedge clk);
      rd_addr = i;
      read_write = 1; // read operation
      transfer = 1;
      
      // Wait for transfer completion and check data immediately
      wait(done == 1);
      if (rd_data !== (8'hA0 + i)) begin
        $display("ERROR: Addr=%0d, Read=0x%0h, Expected=0x%0h", 
                rd_addr, rd_data, 8'hA0 + i);
      end
      else begin
        $display("Read PASS: Addr=%0d, Data=0x%0h", rd_addr, rd_data);
      end
      transfer = 0;
      @(posedge clk);
    end
end
endmodule