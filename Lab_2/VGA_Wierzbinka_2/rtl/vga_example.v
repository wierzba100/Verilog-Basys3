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
  output wire pclk_mirror
  );

  // Converts 100 MHz clk into 40 MHz pclk.
  // This uses a vendor specific primitive
  // called MMCME2, for frequency synthesis.

  wire clk_in;
  wire locked;
  wire clk_fb;
  wire clk_ss;
  wire clk_out;
  wire pclk;

  (* KEEP = "TRUE" *) 
  (* ASYNC_REG = "TRUE" *)
  reg [7:0] safe_start = 0;

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

  ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(pclk),
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
  
  vga_timing my_timing (
    .vcount(vcount_out [0]),
    .vsync(vsync_out [0]),
    .vblnk(vblnk_out [0]),
    .hcount(hcount_out [0]),
    .hsync(hsync_out [0]),
    .hblnk(hblnk_out [0]),
    .pclk(pclk),
    .rst(rst)
  );
  
  draw_background u_draw_background (
    .pclk(pclk),
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
    .pclk(pclk),
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
    .b_out(b_out [1])
  );

always @(posedge pclk)
  begin
    vs <= vsync_out [2];
    hs <= hsync_out [2];
    {r,g,b} <= {r_out[1],g_out[1],b_out[1]};
  end


  // This is a simple test pattern generator.
 /* 
  always @(posedge pclk)
  begin
    // Just pass these through.
    hs <= hsync;
    vs <= vsync;
    // During blanking, make it it black.
    if (vblnk || hblnk) {r,g,b} <= 12'h0_0_0; 
    else
    begin
      // Active display, top edge, make a yellow line.
      if (vcount == 0) {r,g,b} <= 12'hf_f_0;
      // Active display, bottom edge, make a red line.
      else if (vcount == 599) {r,g,b} <= 12'hf_0_0;
      // Active display, left edge, make a green line.
      else if (hcount == 0) {r,g,b} <= 12'h0_f_0;
      // Active display, right edge, make a blue line.
      else if (hcount == 799) {r,g,b} <= 12'h0_0_f;
      // You will replace this with your own test.
      else if ((hcount >= 100  && hcount <= 150 ) && (vcount >= 100 && vcount <= 500))
        {r,g,b} <= 12'ha_0_a;
      else if ((hcount > 150  && hcount <= 300 ) && (vcount >= 100 && vcount <= 150))
        {r,g,b} <= 12'ha_0_a;
      else if ((hcount > 150  && hcount <= 300 ) && (vcount >= 200 && vcount <= 250))
        {r,g,b} <= 12'ha_0_a;
      else if ((hcount >= 400  && hcount <= 450 ) && (vcount >= 100 && vcount <= 500))
        {r,g,b} <= 12'ha_0_a;
      else if ((hcount >= 650  && hcount <= 700 ) && (vcount >= 100 && vcount <= 500))
        {r,g,b} <= 12'ha_0_a;
      else if ((hcount >= 650  && hcount <= 700 ) && (vcount >= 100 && vcount <= 500))
        {r,g,b} <= 12'ha_0_a;
      else if ((( vcount <= -hcount + 950 ) && ( vcount >= -hcount + 925 )) && (hcount >= 450 && hcount <= 550))
        {r,g,b} <= 12'ha_0_a;
      else if ((( vcount <= hcount - 150 ) && ( vcount >= hcount - 175 )) && (hcount >= 550 && hcount <= 650))
        {r,g,b} <= 12'ha_0_a;
      // Active display, interior, fill with gray.
      else {r,g,b} <= 12'h8_8_8;    
    end
    
    
  end
*/
endmodule
