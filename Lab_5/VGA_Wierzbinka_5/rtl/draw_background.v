`timescale 1ns / 1ps

module draw_background(
    input wire clk_in,
    input wire rst,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out
    );
    
    reg [11:0] rgb_nxt;
    
    always @*
    begin
    if(rst)
        rgb_nxt = 0;
    else
        // During blanking, make it it black.
        if (vblnk_in || hblnk_in) rgb_nxt = 12'h0_0_0; 
        else
            begin
            // Active display, top edge, make a yellow line.
            if (vcount_in == 0) rgb_nxt = 12'hf_f_0;
            // Active display, bottom edge, make a red line.
            else if (vcount_in == 599) rgb_nxt = 12'hf_0_0;
            // Active display, left edge, make a green line.
            else if (hcount_in == 0) rgb_nxt = 12'h0_f_0;
            // Active display, right edge, make a blue line.
            else if (hcount_in == 799) rgb_nxt = 12'h0_0_f;
            // You will replace this with your own test.
            else if ((hcount_in >= 100  && hcount_in <= 150 ) && (vcount_in >= 100 && vcount_in <= 500))
                rgb_nxt = 12'ha_0_a;
            else if ((hcount_in > 150  && hcount_in <= 300 ) && (vcount_in >= 100 && vcount_in <= 150))
                rgb_nxt = 12'ha_0_a;
            else if ((hcount_in > 150  && hcount_in <= 300 ) && (vcount_in >= 200 && vcount_in <= 250))
                rgb_nxt = 12'ha_0_a;
            else if ((hcount_in >= 400  && hcount_in <= 450 ) && (vcount_in >= 100 && vcount_in <= 500))
                rgb_nxt = 12'ha_0_a;
            else if ((hcount_in >= 650  && hcount_in <= 700 ) && (vcount_in >= 100 && vcount_in <= 500))
                rgb_nxt = 12'ha_0_a;
            else if ((hcount_in >= 650  && hcount_in <= 700 ) && (vcount_in >= 100 && vcount_in <= 500))
                rgb_nxt = 12'ha_0_a;
            else if ((( vcount_in <= -hcount_in + 950 ) && ( vcount_in >= -hcount_in + 925 )) && (hcount_in >= 450 && hcount_in <= 550))
                rgb_nxt = 12'ha_0_a;
            else if ((( vcount_in <= hcount_in - 150 ) && ( vcount_in >= hcount_in - 175 )) && (hcount_in >= 550 && hcount_in <= 650))
                rgb_nxt = 12'ha_0_a;
            // Active display, interior, fill with gray.
            else rgb_nxt = 12'h8_8_8;    
            end
    end
    
    always @(posedge clk_in)
    begin
        if(rst)
        begin
            vcount_out <= 0;
            hcount_out <= 0;
            hsync_out <= 0;
            vsync_out <= 0;
            hblnk_out <= 0;
            vblnk_out <= 0;
            rgb_out <= 0;
        end
        else
        begin
            hsync_out <= hsync_in;
            vsync_out <= vsync_in;
            hblnk_out <= hblnk_in;
            vblnk_out <= vblnk_in;
            hcount_out <= hcount_in;
            vcount_out <= vcount_in;
            rgb_out <= rgb_nxt;
        end
    end
    
    
endmodule

