module decode (
    input  wire [3:0] OPcode,
    input  wire       en,
    
    /* [0] - update Carry and Overflow flags; 
     * [1] - update Neg and  Zero flags;
     *  ADD, SUB - update all flags; 
     * AND, OR - update only Neg and Zero
     *  */
    output reg  [1:0] UpdateFlags,
     
    output reg  [1:0] ALUControl,
    output reg  [1:0] RegFileControl
);


//------------------------------------------------------------------------------
// put your code here

localparam  ADD = 3'b000,
            SUB = 3'b001,
            AND = 3'b010,
            OR =  3'b011,
            LDA = 3'b100,
            LDB = 3'b101,
            NOP = 3'b111;

//------------------------------------------------------------------------------
always @*
    if(!en)
        RegFileControl = 2'b00;
    else
        if(OPcode[3]) // branch
            RegFileControl = 2'b00;
        else begin    // execute
            case(OPcode[2:0])
                ADD: begin RegFileControl = 2'b01; ALUControl = 2'b00  ; UpdateFlags = 2'b11;end
                SUB: begin RegFileControl = 2'b01; ALUControl = 2'b01  ; UpdateFlags = 2'b11; end
                AND:begin RegFileControl = 2'b01; ALUControl = 2'b10   ; UpdateFlags = 2'b10;end
                OR: begin RegFileControl = 2'b01; ALUControl = 2'b11   ; UpdateFlags = 2'b10;end
                LDA: RegFileControl               = 2'b11;
                LDB: RegFileControl               = 2'b10;
                NOP: RegFileControl               = 2'b00;
                default: RegFileControl           = 2'b00;
            endcase
        end

endmodule
