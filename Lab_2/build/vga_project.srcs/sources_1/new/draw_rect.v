`timescale 1ns / 1ps

module draw_rect(
    input wire pclk,
    input wire rst,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [3:0] r_in,
    input wire [3:0] g_in,
    input wire [3:0] b_in,
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [3:0] r_out,
    output reg [3:0] g_out,
    output reg [3:0] b_out

    );
    
    localparam POS_X = 100;
    localparam POS_Y = 100;
    localparam WIDTH = 300;
    localparam HEIGHT = 300;
    localparam COLOR = 12'ha_b_c;
    
    
    always @(posedge pclk)
    begin
        if(rst)
        begin
            vcount_out <= 0;
            hcount_out <= 0;
            hsync_out <= 0;
            vsync_out <= 0;
            hblnk_out <= 0;
            vblnk_out <= 0;
        end
        else
        begin
            hsync_out <= hsync_in;
            vsync_out <= vsync_in;
            hblnk_out <= hblnk_in;
            vblnk_out <= vblnk_in;
            hcount_out <= hcount_in;
            vcount_out <= vcount_in;
            
            if (vblnk_in || hblnk_in)
                {r_out,g_out,b_out} <= 12'h0_0_0;
            else if(( vcount_in >= POS_X && vcount_in <= (WIDTH - 1) ) && (hcount_in >= POS_Y && hcount_in <= (HEIGHT - 1) ) )
                {r_out,g_out,b_out} <= COLOR;
            else
            begin
                 r_out <= r_in;
                 g_out <= g_in;
                 b_out <= b_in;
            end
        end    
    end
           
    
    
endmodule
