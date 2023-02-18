module micro_test();

localparam WIDTH          = 16;
localparam IRAM_ADDR_BITS = 8;

reg                          clk;
reg                          extCtl;
reg                          reset;
reg                          PCenable;
reg     [3:0]                monRFSrc;

wire    [WIDTH-1:0]          monRFData;
wire    [WIDTH-1:0]          monInstr;
wire    [IRAM_ADDR_BITS-1:0] monPC;
wire    [IRAM_ADDR_BITS-1:0] monPCNext;

event                        check_state;

micro #(
    .WIDTH (WIDTH),
    .IRAM_ADDR_BITS(IRAM_ADDR_BITS)
) u_micro (
    .clk (clk),
    .reset (reset),
    //wire [IRAM_ADDR_BITS-1:0] iram_wa,
    //wire      iram_wen,
    //wire [WIDTH-1:0]   iram_din,
    .PCenable (PCenable),  //program counter enable
    .extCtl (extCtl),      //external program control signal (e.g. button)
    .monRFSrc (monRFSrc),  //select register for monitoring
    .monRFData(monRFData), //contents of monitored register
    .monInstr (monInstr),
    .monPC ( {monPC, monPCNext} )
);

always begin
    #5 clk = 0;
    #5 clk = 1;
end

initial begin
    #5
    forever begin
        #20 PCenable = 1'b1;
        #10 PCenable = 1'b0;
    end
end

initial begin
    extCtl   = 0;
    reset    = 0;
    monRFSrc = 1;

    @(negedge clk) reset = 1;
    @(negedge clk) reset = 0;

    repeat(3*2) @(negedge clk);

    repeat (3) @(negedge clk) extCtl = 1;
    repeat (3) @(negedge clk) extCtl = 0;

    repeat(3*36) @(negedge clk);

    -> check_state;

    repeat(3*4) @(negedge clk);

    $stop;
end

reg                          test_passed;
reg     [15:0]               expected;
reg     [15:0]               rf_expected [15:0];
integer                      i;

always @(check_state)begin

    test_passed     = 1;

    rf_expected[0]  = 1;
    rf_expected[1]  = 0;
    rf_expected[2]  = 3;
    rf_expected[3]  = 5;
    rf_expected[4]  = 8;
    rf_expected[5]  = 13;
    rf_expected[6]  = 21;
    rf_expected[7]  = 34;
    rf_expected[8]  = 0;
    rf_expected[9]  = 89;
    rf_expected[10] = 144;
    rf_expected[11] = 233;
    rf_expected[12] = 377;
    rf_expected[13] = 610;
    rf_expected[14] = 987;
    rf_expected[15] = 377;

    for(i = 0; i < 16; i = i + 1) begin

        monRFSrc = i;
        expected = rf_expected[i];
        #1 if(monRFData !== expected) begin
            test_passed = 0;
            $display("ERROR: Bad register #%0d content: %0d (expected: %0d).",monRFSrc, monRFData, expected);
        end
        else $display("Register #%0d content OK.",monRFSrc);

    end


    if(monPC !== 8'd24) begin
        test_passed = 0;
        $display("ERROR: Bad program counter state: %0d (expected: %0d).", monPC, 8'd24);
    end
    else $display("Program counter state OK.");


    if(monInstr !== 16'hC000) begin
        test_passed = 0;
        $display("ERROR: Bad last instruction: %x (expected: %x).", monInstr, 16'hC000);
    end
    else $display("Last instruction OK.");


    if(test_passed)
        $display("TEST PASSED. GRATULACJE! :)");
    else
        $display("TEST FAILED. :(");

end

endmodule
