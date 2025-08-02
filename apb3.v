module apb_master (
    input PCLK,
    input PRESETn,
    input transfer,          // Initiate transfer
    input READ_WRITE,        // 0=write, 1=read
    input [7:0] write_addr,  // Address for write
    input [7:0] write_data,  // Data for write
    input [7:0] read_addr,   // Address for read
    output reg [7:0] read_data, // Read data output
    output reg done,         // Transfer completion indicator

    // APB Interface
    output reg PWRITE,
    output reg PSEL,
    output reg PENABLE,
    output reg [7:0] PADDR,
    output reg [7:0] PWDATA,
    input [7:0] PRDATA,
    input PREADY
);

  // FSM States
  parameter IDLE   = 2'b00,
            SETUP  = 2'b01,
            ACCESS = 2'b10;

  reg [1:0] state, next_state;

  // FSM: State register
  always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn)
      state <= IDLE;
    else
      state <= next_state;
  end

  // FSM: Next state logic
  always @(*) begin
    next_state = state;
    
    case (state)
      IDLE: begin
        if (transfer)
          next_state = SETUP;
      end
      
      SETUP: begin
        next_state = ACCESS;
      end
      
      ACCESS: begin
        if (PREADY)
          next_state = IDLE;
      end
    endcase
  end

  // FSM: Output logic
  always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      PWRITE <= 0;
      PSEL <= 0;
      PENABLE <= 0;
      PADDR <= 8'd0;
      PWDATA <= 8'd0;
      read_data <= 8'd0;
      done <= 0;
    end else begin
    done <= 0;
      case (state)
        IDLE: begin
          PSEL <= 0;
          PENABLE <= 0;
          if (transfer) begin
            PWRITE <= ~READ_WRITE;
          end
        end
        
        SETUP: begin
          PSEL <= 1;
          PENABLE <= 0;
          if (READ_WRITE)
            PADDR <= read_addr;
          else begin
            PADDR <= write_addr;
            PWDATA <= write_data;
          end
        end
        
        ACCESS: begin
          PENABLE <= 1;
          if (PREADY) begin
            done <= 1;
            if (READ_WRITE) begin
              read_data <= PRDATA; 
            end
          end
        end
      endcase
    end
  end
endmodule

module apb_slave (
    input PCLK,
    input PRESETn,
    input PSEL,
    input PENABLE,
    input PWRITE,
    input [7:0] PADDR,
    input [7:0] PWDATA,

    output reg [7:0] PRDATA,
    output reg PREADY
);

  parameter IDLE = 2'b00,
            SETUP = 2'b01,
            ACCESS = 2'b10;

  reg [1:0] state, next_state;
  reg [7:0] mem [0:8];
  

  // FSM: Sequential state update
  always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn)
      state <= IDLE;
    else
      state <= next_state;
  end

  // FSM: Next State Logic (combinational)
  always @(*) begin
    next_state = state;

    case (state)
      IDLE: begin
        if (PSEL && !PENABLE)
          next_state = SETUP;
      end

      SETUP: begin
        if (PSEL && PENABLE)
          next_state = ACCESS;
      end

      ACCESS: begin
        next_state = IDLE;
      end
    endcase
  end

  // Memory behavior & PREADY handling
  always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      PRDATA <= 8'd0;
      PREADY <= 0;
    end else begin
      case (state)
        IDLE: begin
          PREADY <= 0;
        end

        SETUP: begin
          PREADY <= 0;
        end

        ACCESS: begin
          PREADY <= 1;
          if (PWRITE)
            mem[PADDR] <= PWDATA;
          else
            PRDATA <= mem[PADDR];
        end
      endcase
    end
  end

endmodule




module apb3 (
    input wire clk,           
    input wire reset_n,       
    input wire transfer,      
    input wire read_write,    
    input wire [7:0] wr_addr, 
    input wire [7:0] wr_data, 
    input wire [7:0] rd_addr, 
    output wire [7:0] rd_data,
    output wire done          
);

    // APB interface signal
    wire pwrite;
    wire psel;
    wire penable;
    wire [7:0] paddr;
    wire [7:0] pwdata;
    wire [7:0] prdata;
    wire pready;

    // Master instance
    apb_master master (
        .PCLK(clk),
        .PRESETn(reset_n),
        .transfer(transfer),
        .READ_WRITE(read_write),
        .write_addr(wr_addr),
        .write_data(wr_data),
        .read_addr(rd_addr),
        .read_data(rd_data),
        .done(done),
        .PWRITE(pwrite),
        .PSEL(psel),
        .PENABLE(penable),
        .PADDR(paddr),
        .PWDATA(pwdata),
        .PRDATA(prdata),
        .PREADY(pready)
    );

    // Slave instance
    apb_slave slave (
        .PCLK(clk),
        .PRESETn(reset_n),
        .PSEL(psel),
        .PENABLE(penable),
        .PWRITE(pwrite),
        .PADDR(paddr),
        .PWDATA(pwdata),
        .PRDATA(prdata),
        .PREADY(pready)
    );

endmodule