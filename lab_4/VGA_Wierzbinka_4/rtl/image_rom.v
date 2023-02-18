// This is the ROM for the 'AGH48x64.png' image.
// The image size is 48 x 64 pixels.
// The input 'address' is a 12-bit number, composed of the concatenated
// 6-bit y and 6-bit x pixel coordinates.
// The output 'rgb' is 12-bit number with concatenated
// red, green and blue color values (4-bit each)
module image_rom (
    input wire clk,
    input wire rst,
    input wire [11:0] address,  // address = {addry[5:0], addrx[5:0]}
    output reg [11:0] rgb
);


reg [11:0] rom [0:4095];

initial $readmemh("D:/Uklady_elektroniki_cyfrowej_2/lab_4/VGA_Wierzbinka_4/rtl/image_rom.data", rom);

always @(posedge clk)
    if(rst)
    begin
        rgb <= 0;
    end
    else
        rgb <= rom[address];

endmodule