// instruction memory

module imem
#(parameter
    DATA_WIDTH = 16,
    ADDR_WIDTH = 8
)
(
    input  wire                  clk,
    input  wire [ADDR_WIDTH-1:0] ra, // read address
//  input  wire [ADDR_WIDTH-1:0] wa,  // write address
//  input  wire                  wen, // write enable
//  input  wire [DATA_WIDTH-1:0]   wd,  // write data
    output wire [DATA_WIDTH-1:0] rd  // read data
);

reg [DATA_WIDTH-1:0] ram[0:2**ADDR_WIDTH-1];

initial $readmemh("imem.dat",ram);

//always @(posedge clk)
//  if(wen)
//      ram[wa] <= wd;


assign rd = ram[ra];

endmodule