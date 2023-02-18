
module micro
#(parameter
    WIDTH          = 16, // datapath width
    IRAM_ADDR_BITS = 8   // instruction RAM address size
)
(
    input  wire                        clk,
    input  wire                        reset,
//wire [IRAM_ADDR_BITS-1:0] iram_wa,
//wire      iram_wen,
//wire [WIDTH-1:0]   iram_din,
    input  wire                        PCenable,  // program counter enable
    input  wire                        extCtl,    // external program control signal (e.g. button)
    input  wire [3:0]                  monRFSrc,  // select register for monitoring
    output wire [WIDTH-1:0]            monRFData, // contents of monitored register
    output wire [WIDTH-1:0]            monInstr,
    output wire [2*IRAM_ADDR_BITS-1:0] monPC
);
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Control signals - inputs
wire [3:0]                ALUFlags;

//------------------------------------------------------------------------------
// Control signals - outputs
wire                      PCSrc;           // PC counter source select
wire [1:0]                ALUControl;
wire [1:0]                RegFileControl;

//------------------------------------------------------------------------------
// local wires - Datapath

wire [WIDTH-1:0]          Instr;
wire [WIDTH-1:0]          ALU_a;
wire [WIDTH-1:0]          ALU_b;
wire [WIDTH-1:0]          ALUResult;
wire [WIDTH-1:0]          RF_wd3;
wire [WIDTH/2-1:0]        RF_wd3a, RF_wd3b;

wire [IRAM_ADDR_BITS-1:0] PC;
wire [IRAM_ADDR_BITS-1:0] PCNext;

//------------------------------------------------------------------------------
// monitoring outputs
assign monPC    = {PC, PCNext};
assign monInstr = Instr;

//------------------------------------------------------------------------------
// Program counter
flopenr #(
    .WIDTH(IRAM_ADDR_BITS)
) u_PC (
    .clk (clk),
    .reset(reset),
    .en (PCenable),
    .d (PCNext),
    .q (PC)
);

//------------------------------------------------------------------------------
// Instruction RAM

imem #(
    .DATA_WIDTH(WIDTH),
    .ADDR_WIDTH(IRAM_ADDR_BITS)
) u_imem (
    .clk(clk),
    .ra (PC),   //read address
// .wa (iram_wa), //write address
// .wen(iram_wen), //write enable
// .wd (iram_din), //write data
    .rd (Instr) //read data
);

//------------------------------------------------------------------------------
// register file

regfile #(
    .WIDTH(WIDTH)
) u_regfile (
    .clk (clk),
    .ra1 (Instr[3:0]),       //read address #1
    .ra2 (Instr[7:4]),       //read address #2
    .wa3 (Instr[11:8]),      //write address #3
    .we3 (RegFileControl),   //write enable
    .wd3 (RF_wd3),           //input data
    .monitor_sel (monRFSrc), //select the register for monitoring
    .rd1 (ALU_a),            //read data 1
    .rd2 (ALU_b),            //read data 2
    .monitor_data(monRFData) //the contents of the monitored register
);

//------------------------------------------------------------------------------
// ALU

alu #(
    .WIDTH(WIDTH)
) u_alu (
    .a(ALU_a),
    .b(ALU_b),
    .ALUControl(ALUControl),
    .Result (ALUResult),
    .ALUFlags (ALUFlags)
);

//------------------------------------------------------------------------------
// PC counter increment

wire [IRAM_ADDR_BITS-1:0] PCPlus1;
wire [IRAM_ADDR_BITS-1:0] PCPlus1PlusI;

adder #(
    .WIDTH(IRAM_ADDR_BITS)
) u_pcadd1 (
    .a(PC),
    .b(8'b1),
    .y(PCPlus1)
);
//------------------------------------------------------------------------------
adder #(
    .WIDTH(IRAM_ADDR_BITS)
) u_pcaddz (
    .a(PC),
    .b(Instr[7:0]),
    .y(PCPlus1PlusI)
);

// PC counter mux

mux2 #(
    .WIDTH(IRAM_ADDR_BITS)
) u_pcmux (
    .d0(PCPlus1),
    .d1(PCPlus1PlusI),
    .s (PCSrc),
    .y (PCNext)
);

//------------------------------------------------------------------------------
// regfile w3 mux #1

mux2 #(
    .WIDTH(WIDTH/2)
) u_rfmux1 (
    .d0( 8'b0 ),
    .d1( Instr[7:0] ),
    .s (RegFileControl[0]),
    .y (RF_wd3a)
);

//------------------------------------------------------------------------------
// regfile w3 mux #2

mux2 #(
    .WIDTH(WIDTH/2)
) u_rfmux2 (
    .d0( Instr[7:0] ),
    .d1( 8'b0 ),
    .s (RegFileControl[0]),
    .y (RF_wd3b)
);
//------------------------------------------------------------------------------
// regfile w3 mux #3

mux2 #(
    .WIDTH(WIDTH)
) u_rfmux3 (
    .d0(ALUResult),
    .d1( {RF_wd3b, RF_wd3a} ),
    .s (RegFileControl[1]),
    .y (RF_wd3)
);

//------------------------------------------------------------------------------
// control unit
control_unit u_control_unit (
    .clk(clk),
    .reset(reset),
    .en(PCenable),
    .ALUFlags (ALUFlags),
    .extCtl (extCtl),
    .OPcode(Instr[15:12]),
    .PCSrc (PCSrc),
    .ALUControl (ALUControl),
    .RegFileControl(RegFileControl)
);

endmodule
