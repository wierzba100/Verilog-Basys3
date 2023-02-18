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
  wire [10:0] vcount_in [2:0], hcount_in [2:0], vcount_out [2:0], hcount_out [2:0];
  wire [2:0] vsync_in, hsync_in, hsync_out, vsync_out;
  wire [2:0] vblnk_in, hblnk_in, hblnk_out, vblnk_out;
  wire [3:0] r_in [2:0],g_in [2:0],b_in [2:0], r_out [2:0],g_out [2:0],b_out [2:0];
  wire [11:0] xpos,ypos;
  
  clk_wiz_0 clk_wiz_0 (
  // Clock out ports  
    .clk_100Mhz(clk_100Mhz),
    .clk_40Mhz(clk_40Mhz),
    // Status and control signals               
    .reset(), 
    .locked(locked),
   // Clock in ports
    .clk(clk)
  );
  
  vga_timing my_timing (
    .vcount(vcount_out [0]),
    .vsync(vsync_out [0]),
    .vblnk(vblnk_out [0]),
    .hcount(hcount_out [0]),
    .hsync(hsync_out [0]),
    .hblnk(hblnk_out [0]),
    .clk_in(clk_40Mhz),
    .rst(rst)
  );
  
  draw_background u_draw_background (
    .clk_in(clk_40Mhz),
    .rst(rst),
    .hcount_in(hcount_out [0]),
    .hsync_in(hsync_out [0]),
    .hblnk_in(hblnk_out [0]),
    .vcount_in(vcount_out [0]),
    .vsync_in(vsync_out [0]),
    .vblnk_in(vblnk_out [0]),
    .hcount_out(hcount_out [1]),
    .hsync_out(hsync_out [1]),
    .hblnk_out(hblnk_out [1]),
    .vcount_out(vcount_out [1]),
    .vsync_out(vsync_out [1]),
    .vblnk_out(vblnk_out [1]),
    .r_out(r_out [0]),
    .g_out(g_out [0]),
    .b_out(b_out [0])
  );
  
draw_rect u_draw_rect (
    .clk_in(clk_40Mhz),
    .rst(rst),
    .hcount_in(hcount_out[1]),
    .hsync_in(hsync_out[1]),
    .hblnk_in(hblnk_out[1]),
    .vcount_in(vcount_out[1]),
    .vsync_in(vsync_out[1]),
    .vblnk_in(vblnk_out[1]),
    .hcount_out(hcount_out[2]),
    .hsync_out(hsync_out[2]),
    .hblnk_out(hblnk_out[2]),
    .vcount_out(vcount_out[2]),
    .vsync_out(vsync_out[2]),
    .vblnk_out(vblnk_out[2]),
    .r_in(r_out [0]),
    .g_in(g_out [0]),
    .b_in(b_out [0]),
    .r_out(r_out [1]),
    .g_out(g_out [1]),
    .b_out(b_out [1]),
    .xpos(xpos),
    .ypos(ypos)
  );

MouseCtl u_MouseCtl (
    .clk(clk_100Mhz),
    .rst(rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .xpos(xpos),
    .ypos(ypos)
);

MouseDisplay u_MouseDisplay (
    .pixel_clk(clk_40Mhz),
    .xpos(xpos),
    .ypos(ypos),
    .hcount({1'b0,hcount_out[2]}),
    .vcount({1'b0,vcount_out[2]}),
    .blank(vblnk_out[2] || hblnk_out[2]),
    .red_in(r_out [1]),
    .green_in(g_out [1]),
    .blue_in(b_out [1]),
    .red_out(r_out [2]),
    .green_out(g_out [2]),
    .blue_out(b_out [2])
);

always @(posedge clk_40Mhz)
  begin
    vs <= vsync_out [2];
    hs <= hsync_out [2];
    {r,g,b} <= {r_out[2],g_out[2],b_out[2]};
  end


endmodule
