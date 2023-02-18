`timescale 1ns / 1ps

module draw_rect(
    input wire clk_in,
    input wire rst,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] rgb_in,
    input wire [11:0] xpos,
    input wire [11:0] ypos,
    input wire [11:0] rgb_pixel,
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out,
    output reg [11:0] pixel_addr
    );
    
    //localparam POS_X = 100;
    //localparam POS_Y = 100;
    localparam WIDTH = 48;
    localparam HEIGHT = 64;
    localparam COLOR = 12'hf_f_f;
    
    reg[5:0] addry, addrx;
    reg [11:0] rgb_temp_1, rgb_temp_2, rgb_temp_3;
    reg hsync_temp_1, vsync_temp_1, hblnk_temp_1, vblnk_temp_1, hsync_temp_2, vsync_temp_2, hblnk_temp_2, vblnk_temp_2;
    reg [10:0] hcount_temp_1, vcount_temp_1, hcount_temp_2, vcount_temp_2;
    
    always@*
    begin
        if(( hcount_temp_2 >= xpos && hcount_temp_2 <= (xpos+WIDTH - 1)) && (vcount_temp_2 >= ypos && vcount_temp_2 <= (ypos+HEIGHT - 1) ) )
            rgb_temp_1 = rgb_pixel;
        else
            rgb_temp_1 = rgb_temp_3;

        addry[5:0] = vcount_in - ypos;
        addrx[5:0] = hcount_in - xpos;
    end
    
    always @(posedge clk_in)
    if(rst)
    begin
        hcount_temp_1 <= 0;
        hsync_temp_1 <= 0;
        hblnk_temp_1 <= 0;
        vcount_temp_1 <= 0;
        vsync_temp_1 <= 0;
        vblnk_temp_1 <= 0;
        rgb_temp_2 <= 0;
    end
    else
    begin
        hcount_temp_1 <= hcount_in;
        hsync_temp_1 <= hsync_in;
        hblnk_temp_1 <= hblnk_in;
        vcount_temp_1 <= vcount_in;
        vsync_temp_1 <= vsync_in;
        vblnk_temp_1 <= vblnk_in;
        rgb_temp_2 <= rgb_in;
    end
    
    always @(posedge clk_in)
    if(rst)
    begin
        hcount_temp_2 <= 0;
        hsync_temp_2 <= 0;
        hblnk_temp_2 <= 0;
        vcount_temp_2 <= 0;
        vsync_temp_2 <= 0;
        vblnk_temp_2 <= 0;
        rgb_temp_3 <= 0;
    end
    else
    begin
        hcount_temp_2 <= hcount_temp_1;
        hsync_temp_2 <= hsync_temp_1;
        hblnk_temp_2 <= hblnk_temp_1;
        vcount_temp_2 <= vcount_temp_1;
        vsync_temp_2 <= vsync_temp_1;
        vblnk_temp_2 <= vblnk_temp_1;
        rgb_temp_3 <= rgb_temp_2;
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
            pixel_addr <= 0;
        end
        else
        begin
            hsync_out <= hsync_temp_2;
            vsync_out <= vsync_temp_2;
            hblnk_out <= hblnk_temp_2;
            vblnk_out <= vblnk_temp_2;
            hcount_out <= hcount_temp_2;
            vcount_out <= vcount_temp_2;
            pixel_addr <= {addry[5:0], addrx[5:0]};
            rgb_out <= rgb_temp_1;
        end
    end
           
    
    
endmodule
