`timescale 1ns / 1ps

module draw_rect_ctl(
    input wire clk,
    input wire rst,
    input wire mouse_left,
    input wire [11:0] mouse_xpos,
    input wire [11:0] mouse_ypos,
    output reg [11:0] xpos,
    output reg [11:0] ypos
    );

localparam HEIGHT = 64;
localparam WIDTH = 48;

reg mode_clicked, mode_move,mode_clicked_nxt, mode_move_nxt;
reg [11:0] ypos_nxt,xpos_nxt;
reg [23:0] speed, speed_nxt;
integer acceleration, acceleration_nxt;

always @*
begin
    acceleration_nxt = acceleration;
    speed_nxt = speed;
    xpos_nxt = xpos;
    ypos_nxt = ypos;
    mode_clicked_nxt = mode_clicked;
    mode_move_nxt = mode_move;
    
    if(mouse_left == 1)
    begin
        mode_clicked_nxt = 1;
    end
    else
        mode_clicked_nxt = mode_clicked;
    
    if(mode_clicked == 1)
    begin
        if(ypos < 599 - HEIGHT  && mode_move == 0)
            ypos_nxt = ypos + speed[23];
        else
            mode_move_nxt = 1;
        
        if(ypos > 0 && mode_move_nxt == 1)
            ypos_nxt = ypos - speed[23];
        else
            mode_move_nxt = 0;
        
        speed_nxt = speed + acceleration;
        xpos_nxt = xpos;
        
        if(speed[23] == 1)
        begin
            speed_nxt = 0;
            if(mode_move == 0)
                acceleration_nxt = acceleration + 1;
            else
                if(acceleration > 1)
                    acceleration_nxt = acceleration - 1;
                else
                    mode_move_nxt = 0;
        end
    end
    else
    begin
        xpos_nxt = mouse_xpos;
        ypos_nxt = mouse_ypos;
    end
end

always@(posedge clk)
begin
    if(rst)
    begin
        xpos <= 0;
        ypos <= 0;
        speed <= 0;
        acceleration <= 1;
        mode_move <= 0;
        mode_clicked <= 0;
    end
    else
    begin
        xpos <= xpos_nxt;
        ypos <= ypos_nxt;
        speed <= speed_nxt;
        acceleration <= acceleration_nxt;
        mode_move <= mode_move_nxt;
        mode_clicked <= mode_clicked_nxt;
    end
end



endmodule
