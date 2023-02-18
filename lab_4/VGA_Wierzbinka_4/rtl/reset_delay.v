`timescale 1ns / 1ps


module reset_delay(
    input wire locked,
    input wire clk,
    output wire rst_out
    );
    
    reg[3:0] rst_temp;
    
    always@(posedge clk or negedge locked)
    begin
        if(locked == 0)
        begin
            rst_temp <= 4'b1111;
        end
        else
        begin
            rst_temp <= {rst_temp[3:1],1'b0};
            rst_temp <= rst_temp << 1;
        end
              
    end
    
    assign rst_out = rst_temp[3];
    
endmodule
