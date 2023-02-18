`timescale 1ns / 1ps

module clock_delay(
    input wire clk,
    input wire rst,
    input wire [11:0] xpos_in,
    input wire [11:0] ypos_in,
    output reg [11:0] xpos_out,
    output reg [11:0] ypos_out
    );
    
    always@(posedge clk)
    begin
        if(rst)
        begin
            xpos_out <= 0;
            ypos_out <= 0;
        end
        else
        begin
            xpos_out <= xpos_in;
            ypos_out <= ypos_in;
        end
    end
    
endmodule
