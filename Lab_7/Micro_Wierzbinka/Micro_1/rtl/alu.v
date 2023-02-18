
module alu #(parameter WIDTH = 16)
(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire [1:0]       ALUControl,
    output reg  [WIDTH-1:0] Result,
    output wire [3:0]       ALUFlags
);

wire             neg, zero, carry, overflow;
wire [WIDTH-1:0] condinvb;
wire [WIDTH:0]   sum;

assign condinvb = ALUControl[0] ? ~b : b;
assign sum      = a + condinvb + ALUControl[0];

always @*
    casex (ALUControl[1:0])
        2'b0?: Result = sum;
        2'b10: Result = a & b;
        2'b11: Result = a | b;
    endcase

assign neg      = Result[WIDTH-1];
assign zero     = (Result == {WIDTH{1'b0}});
assign carry    = (ALUControl[1] == 1'b0) & sum[WIDTH];
assign overflow = (ALUControl[1] == 1'b0) & ~(a[WIDTH-1] ^ b[WIDTH-1] ^ ALUControl[0]) & (a[WIDTH-1] ^ sum[WIDTH-1]);
assign ALUFlags = {neg, zero, carry, overflow};

endmodule
