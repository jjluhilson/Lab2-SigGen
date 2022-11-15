module sinegen #(
    parameter   A_WIDTH = 8,
                D_WIDTH = 8
)(
  // interface signals  
  input  logic               clk,      // clock 
  input  logic               rst,      // reset 
  input  logic               en,       // enable
  input  logic [D_WIDTH-1:0] incr,     // increment for addr counter
  input  logic [D_WIDTH-1:0] offset,   // offset
  output logic [D_WIDTH-1:0] dout1,    // output data
  output logic [D_WIDTH-1:0] dout2     // output data
);

  wire  [A_WIDTH-1:0]        address1;   // interconnect wire
  wire  [A_WIDTH-1:0]        address2;   // interconnect wire

counter myCounter (
  .clk (clk),
  .rst (rst),
  .en (en),
  .incr (incr),
  .offset (offset),
  .count1 (address1),
  .count2 (address2)
);

rom sineRom (
  .clk (clk),
  .addr1 (address1),
  .addr2 (address2),
  .dout1 (dout1),
  .dout2 (dout2)
);

endmodule
