// File: vga_example.v
// This is the top level design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_example (
  input wire clk,
  input wire rst,
  output reg vs,
  output reg hs,
  output reg [3:0] r,
  output reg [3:0] g,
  output reg [3:0] b,
  output wire pclk_mirror,
  inout ps2_clk,
  inout ps2_data
  );

  // Converts 100 MHz clk into 40 MHz pclk.
  // This uses a vendor specific primitive
  // called MMCME2, for frequency synthesis.

  wire clk_in;
  wire locked;
  wire clk_fb;
  wire clk_ss;
  wire clk_out;
  wire clk_100Mhz;
  wire clk_40Mhz;

  (* KEEP = "TRUE" *) 
  (* ASYNC_REG = "TRUE" *)
  reg [7:0] safe_start = 0;
/*
  IBUF clk_ibuf (.I(clk),.O(clk_in));

  MMCME2_BASE #(
    .CLKIN1_PERIOD(10.000),
    .CLKFBOUT_MULT_F(10.000),
    .CLKOUT0_DIVIDE_F(25.000))
  clk_in_mmcme2 (
    .CLKIN1(clk_in),
    .CLKOUT0(clk_out),
    .CLKOUT0B(),
    .CLKOUT1(),
    .CLKOUT1B(),
    .CLKOUT2(),
    .CLKOUT2B(),
    .CLKOUT3(),
    .CLKOUT3B(),
    .CLKOUT4(),
    .CLKOUT5(),
    .CLKOUT6(),
    .CLKFBOUT(clkfb),
    .CLKFBOUTB(),
    .CLKFBIN(clkfb),
    .LOCKED(locked),
    .PWRDWN(1'b0),
    .RST(1'b0)
  );

  BUFH clk_out_bufh (.I(clk_out),.O(clk_ss));
  always @(posedge clk_ss) safe_start<= {safe_start[6:0],locked};

  BUFGCE clk_out_bufgce (.I(clk_out),.CE(safe_start[7]),.O(pclk));

  // Mirrors pclk on a pin for use by the testbench;
  // not functionally required for this design to work.
*/
  ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(clk_40Mhz),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
  );

  // Instantiate the vga_timing module, which is
  // the module you are designing for this lab.  
  wire [10:0] vcount_out [3:0], hcount_out [3:0];
  wire [4:0] hsync_out, vsync_out;
  wire [3:0] hblnk_out, vblnk_out, char_line;
  wire [11:0] xpos[2:0],ypos[2:0];
  wire [11:0] rgb_image,rgb_out[4:1];
  wire [7:0] char_pixels, char_xy;
  wire [6:0] char_code;
  wire [10:0] addr;
  wire [11:0] address;
  wire rst_delay;
  wire left;
  
  clk_wiz_0 clk_wiz_0 (
  // Clock out ports  
    .clk_100Mhz(clk_100Mhz),
    .clk_40Mhz(clk_40Mhz),
    // Status and control signals               
    .reset(rst),
    .locked(locked),
   // Clock in ports
    .clk(clk)
  );
  
  reset_delay u_reset_delay (
    //input
    .locked(locked),
    .clk(clk_40Mhz),
    //output
    .rst_out(rst_delay)
  );
  
  vga_timing my_timing (
    //input
    .clk_in(clk_40Mhz),
    .rst(rst_delay),
    //output
    .vcount(vcount_out [0]),
    .vsync(vsync_out [0]),
    .vblnk(vblnk_out [0]),
    .hcount(hcount_out [0]),
    .hsync(hsync_out [0]),
    .hblnk(hblnk_out [0])
  );
  
  draw_background u_draw_background (
    //input
    .clk_in(clk_40Mhz),
    .rst(rst_delay),
    .hcount_in(hcount_out [0]),
    .hsync_in(hsync_out [0]),
    .hblnk_in(hblnk_out [0]),
    .vcount_in(vcount_out [0]),
    .vsync_in(vsync_out [0]),
    .vblnk_in(vblnk_out [0]),
    //output
    .hcount_out(hcount_out [1]),
    .hsync_out(hsync_out [1]),
    .hblnk_out(hblnk_out [1]),
    .vcount_out(vcount_out [1]),
    .vsync_out(vsync_out [1]),
    .vblnk_out(vblnk_out [1]),
    .rgb_out(rgb_out[1])
  );
  
draw_rect u_draw_rect (
    //input
    .clk_in(clk_40Mhz),
    .rst(rst_delay),
    .hcount_in(hcount_out[1]),
    .hsync_in(hsync_out[1]),
    .hblnk_in(hblnk_out[1]),
    .vcount_in(vcount_out[1]),
    .vsync_in(vsync_out[1]),
    .vblnk_in(vblnk_out[1]),
    .rgb_in(rgb_out[1]),
    .xpos(xpos[2]),
    .ypos(ypos[2]),
    .rgb_pixel(rgb_image),
    //output
    .hcount_out(hcount_out[2]),
    .hsync_out(hsync_out[2]),
    .hblnk_out(hblnk_out[2]),
    .vcount_out(vcount_out[2]),
    .vsync_out(vsync_out[2]),
    .vblnk_out(vblnk_out[2]),
    .rgb_out(rgb_out[2]),
    .pixel_addr(address)
  );

draw_rect_ctl u_draw_rect_ctl (
    .clk(clk_40Mhz),
    .rst(rst_delay),
    .mouse_left(left),
    .mouse_xpos(xpos[1]),
    .mouse_ypos(ypos[1]),
    .xpos(xpos[2]),
    .ypos(ypos[2])
);

draw_rect_char
#(
    .XPOS(100),
    .YPOS(100),
    .FONT_COLOR(12'hf_0_0)
)
u_draw_rect_char
(
    //input
    .clk_in(clk_40Mhz),
    .rst(rst_delay),
    .hcount_in(hcount_out[2]),
    .hsync_in(hsync_out[2]),
    .hblnk_in(hblnk_out[2]),
    .vcount_in(vcount_out[2]),
    .vsync_in(vsync_out[2]),
    .vblnk_in(vblnk_out[2]),
    .rgb_in(rgb_out[2]),
    .char_pixels(char_pixels),
    //output
    .hcount_out(hcount_out[3]),
    .hsync_out(hsync_out[3]),
    .hblnk_out(hblnk_out[3]),
    .vcount_out(vcount_out[3]),
    .vsync_out(vsync_out[3]),
    .vblnk_out(vblnk_out[3]),
    .rgb_out(rgb_out[3]),
    .char_xy(char_xy),
    .char_line(char_line)
);

font_rom u_font_rom (
    //input
    .clk(clk_40Mhz),
    .addr({char_code,char_line}),
    //output
    .char_line_pixels(char_pixels)
);

char_rom_16x16 u_char_rom_16x16 (
    //input
    .char_xy(char_xy),
    //output
    .char_code(char_code)
);

MouseCtl u_MouseCtl (
    //input
    .clk(clk_100Mhz),
    .rst(rst_delay),
    //inout
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    //output
    .xpos(xpos[0]),
    .ypos(ypos[0]),
    .left(left)
);

clock_delay u_clock_delay (
    //input
    .clk(clk_40Mhz),
    .xpos_in(xpos[0]),
    .ypos_in(ypos[0]),
    //output
    .xpos_out(xpos[1]),
    .ypos_out(ypos[1])
);

MouseDisplay u_MouseDisplay (
    //input
    .pixel_clk(clk_40Mhz),
    .xpos(xpos[0]),
    .ypos(ypos[0]),
    .hcount({1'b0,hcount_out[3]}),
    .vcount({1'b0,vcount_out[3]}),
    .blank(vblnk_out[3] || hblnk_out[3]),
    .rgb_in(rgb_out[3]),
    .vs_in(vsync_out[3]),
    .hs_in(hsync_out[3]),
    //output
    .rgb_out(rgb_out[4]),
    .vs_out(vsync_out[4]),
    .hs_out(hsync_out[4])
);

image_rom u_image_rom (
    //input
    .clk(clk_40Mhz),
    .rst(rst_delay),
    .address(address),
    //output
    .rgb(rgb_image)
);

always @(posedge clk_40Mhz)
  begin
    vs <= vsync_out [4];
    hs <= hsync_out [4];
    {r,g,b} <= rgb_out [4];
  end


endmodule
