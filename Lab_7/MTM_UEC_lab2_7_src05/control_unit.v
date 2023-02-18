module control_unit (
    input  wire       clk,
    input  wire       reset,
    input  wire       en,            // module enable

    input  wire [3:0] ALUFlags,      // {neg, zero, carry, overflow};
    input  wire       extCtl,        // external input signal
    input  wire [3:0] OPcode,

    output wire       PCSrc,         // PC counter source select
    output wire [1:0] ALUControl,
    output wire [1:0] RegFileControl
);

//------------------------------------------------------------------------------
// local wires - Control
wire [3:0] Flags;
wire [1:0] UpdateFlags;

//------------------------------------------------------------------------------
// FLAGS (status register)

flopenr #( .WIDTH(1) ) u_flag_neg (
    .clk (clk),
    .reset(reset),
    .d (ALUFlags[3]),
    .en(UpdateFlags[1] & en),
    .q (Flags[3])
);

flopenr #( .WIDTH(1) ) u_flag_zero (
    .clk (clk),
    .reset(reset),
    .d (ALUFlags[2]),
    .en(UpdateFlags[1] & en),
    .q (Flags[2])
);

flopenr #( .WIDTH(1) ) u_flag_carry (
    .clk (clk),
    .reset(reset),
    .d (ALUFlags[1]),
    .en(UpdateFlags[0] & en),
    .q (Flags[1])
);

flopenr #( .WIDTH(1) ) u_flag_overflow (
    .clk (clk),
    .reset(reset),
    .d (ALUFlags[0]),
    .en(UpdateFlags[0] & en),
    .q (Flags[0])
);

//------------------------------------------------------------------------------
// register for external signal
flopenr #( .WIDTH(1) ) u_flopr (
    .clk(clk),
    .reset(reset),
    .en(en),
    .d(extCtl),
    .q(extCtlReg)
);

//------------------------------------------------------------------------------
// branch control

branch_ctl u_branch_ctl (
    .OPcode (OPcode),
    .in0(extCtlReg), // external control input
    .in1(Flags[2]),  // ALU zero
    .branchCtl(PCSrc)
);

//------------------------------------------------------------------------------
// instruction decoder
decode u_decode (
    .OPcode(OPcode),
    .en(en),
    .UpdateFlags(UpdateFlags),
    .ALUControl(ALUControl),
    .RegFileControl(RegFileControl)
);

//------------------------------------------------------------------------------

endmodule
