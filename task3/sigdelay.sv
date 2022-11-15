module sigdelay #(
    parameter   A_WIDTH = 9,
                D_WIDTH = 8
)(
  // interface signals  
  input  logic               clk,             // clock 
  input  logic               rst,             // reset 
  input  logic               wr,              // write enable
  input  logic               rd,              // read enable
  input  logic [A_WIDTH-1:0] offset,          // offset
  input  logic [D_WIDTH-1:0] mic_signal,      // mic_signal
  output logic [D_WIDTH-1:0] delayed_signal   // delayed_signal
);

  wire  [A_WIDTH-1:0]        address1;    // interconnect wire
  wire  [A_WIDTH-1:0]        address2;    // interconnect wire

counter myCounter (
  .clk (clk),
  .rst (rst),
  .offset (offset),
  .count1 (address1),
  .count2 (address2)
);

ram myRam (
  .clk (clk),
  .din (mic_signal),
  .wr_en (wr),
  .rd_en (rd),
  .wr_addr (address1),
  .rd_addr (address2),
  .dout (delayed_signal)
);

endmodule
