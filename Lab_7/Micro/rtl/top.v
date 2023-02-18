module top
(
    input wire clk,
    input wire reset,
    input wire [1:0] btn,
    input wire [5:0] sw,
    input wire rx,
    output wire [3:0] an,
    output wire [7:0] sseg,
    output wire tx
);

wire [15:0] monRFData, monInstr, monPC;
wire extCtl, PCenable;
reg [3:0] hex0, hex1, hex2, hex3;
wire [7:0] rec_data;

micro u_micro (
    //input
    .clk(clk),
    .reset(reset),
    .PCenable(PCenable),
    .extCtl(extCtl),
    .monRFSrc(sw[3:0]),
    .iram_wa(rec_data),
    .iram_wen(PCenable),
    .iram_din(),
    //output
    .monRFData(monRFData),
    .monInstr(monInstr),
    .monPC(monPC)
);

debounce u_debounce_btn0 (
    //input
    .clk(clk),
    .reset(reset),
    .sw(btn[0]),
    //output
    .db_level(),
    .db_tick(PCenable)
);

debounce u_debounce_btn1 (
    //input
    .clk(clk),
    .reset(reset),
    .sw(btn[1]),
    //output
    .db_level(extCtl),
    .db_tick()
);

disp_hex_mux u_disp_hex_mux (
    //input
    .clk(clk),
    .reset(reset),
    .hex0(hex0),
    .hex1(hex1),
    .hex2(hex2),
    .hex3(hex3),
    .dp_in(4'b1111),
    //output
    .an(an),
    .sseg(sseg)
);

uart u_uart
(
    //input
    .clk(clk),
    .reset(reset),
    .rd_uart(1'b1),
    .wr_uart(PCenable),
    .rx(rx),
    .w_data(),
    //output
    .tx_full(),
    .rx_empty(),
    .r_data(rec_data),
    .tx(tx)
);

always@*
begin
    if(sw[5:4] == 2'b00)
    begin
        hex0 = monInstr[3:0];
        hex1 = monInstr[7:4];
        hex2 = monInstr[11:8];
        hex3 = monInstr[15:12];
    end
    else if(sw[5:4] == 2'b01)
    begin
        hex0 = monPC[3:0];
        hex1 = monPC[7:4];
        hex2 = monPC[11:8];
        hex3 = monPC[15:12];
    end
    else
    begin
        hex0 = monRFData[3:0];
        hex1 = monRFData[7:4];
        hex2 = monRFData[11:8];
        hex3 = monRFData[15:12];
    end
end


endmodule
