

module flopenr #(parameter WIDTH = 8)
(
	input  wire             clk,	// posedge clock
	input  wire             reset,  // async reset active low
	input  wire             en,
	input  wire [WIDTH-1:0] d,
	output reg  [WIDTH-1:0] q
);

always @(posedge clk, posedge reset)
	if (reset)
		q <= 0;
	else
		if (en)
			q <= d;
endmodule