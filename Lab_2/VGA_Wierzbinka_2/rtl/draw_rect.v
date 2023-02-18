`timescale 1ns / 1ps

module draw_rect(
    input wire pclk,
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
    
     always @(posedge pclk)
       begin
       // Just pass these through.
           hsync_out <= hsync_in;
           vsync_out <= vsync_in;
           hblnk_out <= hblnk_in;
           vblnk_out <= vblnk_in;
           hcount_out <= hcount_in;
           vcount_out <= vcount_in;
           r_out <= r_in;
           g_out <= g_in;
           b_out <= b_in;
           
           
           if ((hcount_out >= 100  && hcount_out <= 150 ) && (vcount_out >= 100 && vcount_out <= 500))
            {r_out,g_out,b_out} <= 12'ha_0_a;
           else if ((hcount_out > 150  && hcount_out <= 300 ) && (vcount_out >= 100 && vcount_out <= 150))
            {r_out,g_out,b_out} <= 12'ha_0_a;
           else if ((hcount_out > 150  && hcount_out <= 300 ) && (vcount_out >= 200 && vcount_out <= 250))
            {r_out,g_out,b_out} <= 12'ha_0_a;
           else if ((hcount_out >= 400  && hcount_out <= 450 ) && (vcount_out >= 100 && vcount_out <= 500))
            {r_out,g_out,b_out} <= 12'ha_0_a;
           else if ((hcount_out >= 650  && hcount_out <= 700 ) && (vcount_out >= 100 && vcount_out <= 500))
            {r_out,g_out,b_out} <= 12'ha_0_a;
           else if ((hcount_out >= 650  && hcount_out <= 700 ) && (vcount_out >= 100 && vcount_out <= 500))
            {r_out,g_out,b_out} <= 12'ha_0_a;
           else if ((( vcount_out <= -hcount_out + 950 ) && ( vcount_out >= -hcount_out + 925 )) && (hcount_out >= 450 && hcount_out <= 550))
            {r_out,g_out,b_out} <= 12'ha_0_a;
           else if ((( vcount_out <= hcount_out - 150 ) && ( vcount_out >= hcount_out - 175 )) && (hcount_out >= 550 && hcount_out <= 650))
            {r_out,g_out,b_out} <= 12'ha_0_a;
           else
            {r_out,g_out,b_out} <= {r_out,g_out,b_out};
            
          end
           
    
    
endmodule
