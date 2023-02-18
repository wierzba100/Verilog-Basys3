`timescale 1ns / 1ps


module draw_rect_ctl_test;

  reg clk;
  reg rst;
  wire mouse_left;
  wire [11:0] mouse_xpos, mouse_ypos;
  wire [11:0] xpos, ypos;

draw_rect_ctl_tb u_draw_rect_ctl_tb (
    .clk(clk),
    .rst(rst),
    .mouse_left(mouse_left),
    .mouse_xpos(mouse_xpos),
    .mouse_ypos(mouse_ypos)
);

draw_rect_ctl u_draw_rect_ctl (
    .clk(clk),
    .rst(rst),
    .mouse_left(mouse_left),
    .mouse_xpos(mouse_xpos),
    .mouse_ypos(mouse_ypos),
    .xpos(xpos),
    .ypos(ypos)
);



always
begin
    clk = 1'b0;
    #12;
    clk = 1'b1;
    #12;
end

initial
begin
  rst = 0;
  #100 rst = 1;
  #110 rst = 0;
end

initial
begin
    $display("Simulation started");
    $stop;
end

endmodule