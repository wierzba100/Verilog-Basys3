`timescale 1ns / 1ps

module top(
    //input
    input wire clk,
    input wire reset,
    input wire rx,
    input wire btn,
    //output
    output wire tx,
    output wire [3:0] an,  // enable 1-out-of-4 asserted low
    output wire [7:0] sseg // led segments
    );
    
    wire btn_tick;
    wire [7:0] rec_data, rec_data2;
    
    uart u_uart
    (
        //input
        .clk(clk),
        .reset(reset),
        .rd_uart(1'b1),
        .wr_uart(btn_tick),
        .rx(rx),
        .w_data(),
        //output
        .tx_full(),
        .rx_empty(),
        .r_data(rec_data),
        .r_data2(rec_data2),
        .tx(tx)
    );
    
    debounce btn_db_unit (
        //input
        .clk(clk),
        .reset(reset),
        .sw(btn),
        //output
        .db_level(), 
        .db_tick(btn_tick)
    );
    
    disp_hex_mux u_disp_hex_mux (
        //input
        .clk(clk),
        .reset(reset),
        .hex3(rec_data[7:4]),
        .hex2(rec_data[3:0]),
        .hex1(rec_data2[7:4]),
        .hex0(rec_data2[3:0]),
        .dp_in(4'b1011),
        //output
        .an(an),
        .sseg(sseg)
    );
    
endmodule