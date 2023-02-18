module branch_ctl (
    input  wire [3:0] OPcode,
    input  wire       in0,
    input  wire       in1,
    output reg        branchCtl
);

localparam 
NOP = 3'b000, // never branch
B0  = 3'b001, // branch if input 0 is true
B1  = 3'b010, // branch if input 1 is true
BA  = 3'b011, // branch any; if either of inputs is true
BR  = 3'b100, // always branch
BN0 = 3'b101, // branch if not input 0
BN1 = 3'b110, // branch if not input 1
BNA = 3'b111  // branch if both inputs are false
;

always @*
    if(!OPcode[3]) // this is not branch instruction
        branchCtl = 1'b0;
    else
        case(OPcode[2:0])
            NOP: branchCtl = 1'b0;
            B0: branchCtl  = in0;
            B1: branchCtl  = in1;
            BA: branchCtl  = in0 | in1;
            BR: branchCtl  = 1'b1;
            BN0: branchCtl = ~in0;
            BN1: branchCtl = ~in1;
            BNA: branchCtl = ~(in0 | in1);
        endcase

endmodule
