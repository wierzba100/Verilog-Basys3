`timescale 1ns / 1ps

module draw_rect_ctl_tb(
    input wire clk,
    input wire rst,
    output reg mouse_left,
    output reg [11:0] mouse_xpos,
    output reg [11:0] mouse_ypos
    );

always @(posedge clk)
begin
    if(rst)
    begin
        mouse_left = 0;
        mouse_xpos = 0;
        mouse_ypos = 0;
    end
    else
    begin
        mouse_left = 1;
        mouse_xpos = 100;
        mouse_ypos = 500;
    end
end

endmodule