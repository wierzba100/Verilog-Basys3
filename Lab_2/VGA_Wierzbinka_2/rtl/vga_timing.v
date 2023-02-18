// File: vga_timing.v
// This is the vga timing design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_timing (
  output reg [10:0] vcount,
  output reg vsync,
  output reg vblnk,
  output reg [10:0] hcount,
  output reg hsync,
  output reg hblnk,
  input wire pclk,
  input wire rst
  );
  
  // Describe the actual circuit for the assignment.
  // Video timing controller set for 800x600@60fps
  // using a 40 MHz pixel clock per VESA spec.
  
  localparam HOR_TOTAL_TIME = 1056;
  localparam HOR_BLANK_START = 800;
  localparam HOR_BLANK_STOP = 1056;
  localparam HOR_SYNC_START  = 840;
  localparam HOR_SYNC_STOP  = 968;
  
  localparam VER_TOTAL_TIME = 628;
  localparam VER_BLANK_START = 600;
  localparam VER_BLANK_STOP = 628;
  localparam VER_SYNC_START = 601;
  localparam VER_SYNC_STOP = 605;
  
  reg [10:0] vcount_nxt;
  reg [10:0] hcount_nxt;
  reg hsync_nxt;
  reg vsync_nxt;
  reg hblnk_nxt;
  reg vblnk_nxt;
  
  always@*
  begin
    if(hcount == (HOR_TOTAL_TIME - 1))
        hcount_nxt = 0;
    else
        hcount_nxt = hcount + 1;
    
    if(hcount == (HOR_TOTAL_TIME - 1) && vcount == (VER_TOTAL_TIME - 1))
        vcount_nxt = 0;
    else if(hcount == (HOR_TOTAL_TIME - 1))
        vcount_nxt = vcount + 1;
    else
        vcount_nxt = vcount;
        
    if (hcount >= (HOR_SYNC_START - 1) && hcount <= HOR_SYNC_STOP - 2 )
        hsync_nxt = 1;
    else
        hsync_nxt = 0;
    
    if (vcount >= (VER_SYNC_START - 1) && vcount < (VER_SYNC_STOP -1) && hcount == HOR_TOTAL_TIME - 1) 
        vsync_nxt = 1;
    else if(vcount == (VER_SYNC_STOP - 1) && hcount == HOR_TOTAL_TIME - 1 )
        vsync_nxt = 0;
    else 
        vsync_nxt = vsync;
    
    if(hcount >= (HOR_BLANK_START - 1) && hcount < (HOR_BLANK_STOP - 1 ))
        hblnk_nxt = 1;
    else
        hblnk_nxt = 0;
        
    if (vcount >= (VER_BLANK_START - 1) && vcount < (VER_TOTAL_TIME - 1) && hcount == HOR_TOTAL_TIME - 1) 
        vblnk_nxt = 1;
    else if (vcount == (VER_BLANK_STOP - 1) && hcount == HOR_TOTAL_TIME - 1 )
        vblnk_nxt = 0;
    else 
        vblnk_nxt = vblnk;
     
  end
  
  always @(posedge pclk)
  begin
    if(rst)
    begin
        vcount <= 0;
        hcount <= 0;
        hsync <= 0;
        vsync <= 0;
        hblnk <= 0;
        vblnk <= 0;
    end
    else
    begin
        hcount <= hcount_nxt;
        vcount <= vcount_nxt;
        hsync <= hsync_nxt;
        vsync <= vsync_nxt;
        vblnk <= vblnk_nxt;
        hblnk <= hblnk_nxt;
    end
  end    
   

endmodule