module counter #( //module name must be same as file name
    parameter WIDTH = 9
)(
    // interface signals
    input logic clk, //clock
    input logic rst, //reset
    input logic [WIDTH-1:0] offset, //offset
    output logic [WIDTH-1:0] count1, //count output
    output logic [WIDTH-1:0] count2 //count output + offset
);

always_ff @ (posedge clk, posedge rst)

    if (rst) count1 <= {WIDTH{1'b0}};
    else  begin
        count1 <= count1 + 1'b1;
    end
    assign count2 = count1 - offset;


endmodule
