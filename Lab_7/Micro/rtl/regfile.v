//
// The register file consists of sixteen 16-bit registers.

module regfile #(parameter WIDTH = 16)
(
	input  wire               clk,
	input  wire [3:0]         ra1,         // read address #1
	input  wire [3:0]         ra2,         // read address #2
	input  wire [3:0]         wa3,         // write address #3
	input  wire [1:0]         we3,         // write enable for LSB/MSB/both
	input  wire [WIDTH-1:0]   wd3,         // input data
	input  wire [3:0]         monitor_sel, // select the register for monitoring
	output wire [WIDTH-1:0]   rd1,         // read data 1
	output wire [WIDTH-1:0]   rd2,         // read data 2
	output wire [WIDTH-1:0]   monitor_data // the contents of the monitored register
);

reg [WIDTH-1:0] rf[15:0];

always @(posedge clk)
	case ( we3 )
		// write LSB
		2'b11: rf[wa3] <= ( rf[wa3] & { {WIDTH/2{1'b1}}, {WIDTH/2{1'b0}} } )
			| ( wd3 & { {WIDTH/2{1'b0}}, {WIDTH/2{1'b1}} }) ;

		// write MSB
		2'b10: rf[wa3] <= ( rf[wa3] & { {WIDTH/2{1'b0}}, {WIDTH/2{1'b1}} } )
			| ( wd3 & { {WIDTH/2{1'b1}}, {WIDTH/2{1'b0}} }) ;

		// write both bytes;
		2'b01: rf[wa3] <= wd3;
        
        // default not needed in the sequential part
        // 2'b00 - no write
	endcase

assign rd1          =  rf[ra1];
assign rd2          =  rf[ra2];

assign monitor_data = rf[monitor_sel];

endmodule
