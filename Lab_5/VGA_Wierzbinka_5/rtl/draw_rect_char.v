`timescale 1ns / 1ps

module draw_rect_char
#( parameter
        XPOS = 0,
        YPOS = 0,
        FONT_COLOR = 12'hf_f_f
)
(
    //input
    input wire clk_in,
    input wire rst,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] rgb_in,
    input wire [7:0] char_pixels,
    //output
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out,
    output reg[7:0] char_xy,
    output reg[3:0] char_line
    );
    
    reg [11:0] rgb_nxt;
    reg [10:0] char_y,char_x;
    
    always@*
    begin
        char_y = vcount_in -  YPOS;
        char_x = hcount_in -  XPOS;
        
        if ( (vcount_in <= 256 + YPOS) && (vcount_in >= YPOS) && (hcount_in <= 128 + XPOS) && (hcount_in >= XPOS) && (char_pixels[8 - char_x[2:0]]) )
            rgb_nxt = FONT_COLOR;
        else
            rgb_nxt = rgb_in;
    
        char_xy = {char_y[7:4], char_x[6:3]};
        char_line = char_y[3:0];
    end
    
    always@(posedge clk_in)
    if(rst)
    begin
        hcount_out <= 0;
        vcount_out <= 0;
        hsync_out <= 0;
        vsync_out <= 0;
        hblnk_out <= 0;
        vblnk_out <= 0;
        rgb_out <= 0;
    end
    else
    begin
        hcount_out <= hcount_in;
        vcount_out <= vcount_in;
        hsync_out <= hsync_in;
        vsync_out <= vsync_in;
        hblnk_out <= hblnk_in;
        vblnk_out <= vblnk_in;
        rgb_out <= rgb_nxt;
    end

endmodule
