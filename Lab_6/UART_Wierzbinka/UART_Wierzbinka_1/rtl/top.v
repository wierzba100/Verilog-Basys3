`timescale 1ns / 1ps

module top(
    input wire clk,
    input wire reset,
    input wire rx,
    input wire loopback_enable,
    output reg tx,
    output reg rx_monitor,
    output reg tx_monitor
    );
    
    wire rd_uart, wr_uart, tx_full, rx_empty;
    wire [7:0] w_data,r_data,led_temp;
    wire tx_temp;
    
    uart u_uart (
        //input
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .rd_uart(rd_uart),
        .wr_uart(wr_uart),
        .w_data(w_data),
        //output
        .tx(tx_temp),
        .tx_full(tx_full),
        .rx_empty(rx_empty),
        .r_data(r_data)
    );
    
    always@(posedge clk)
    begin
        rx_monitor <= rx;
        tx_monitor <= tx;
    end
    
    always@*
    begin
        if(loopback_enable == 1)
            tx = rx;
        else
            tx = 0;
    end
    
endmodule