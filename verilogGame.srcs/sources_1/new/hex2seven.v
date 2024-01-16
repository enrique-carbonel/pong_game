`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 06:39:28 PM
// Design Name: 
// Module Name: hex2seven
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hex2seven(
    input [3:0] hex,
    output reg [6:0] leds
    );
    
   always@(hex)
   begin
    case(hex)
        4'b0000: leds <= 7'b1111110;
        4'b0001: leds <= 7'b0110000;
        4'b0010: leds <= 7'b1101101;
        4'b0011: leds <= 7'b1111001;
        4'b0100: leds <= 7'b0110011;
        4'b0101: leds <= 7'b1011011;
        4'b0110: leds <= 7'b1011111;
        4'b0111: leds <= 7'b1110000;
        4'b1000: leds <= 7'b1111111;
        4'b1001: leds <= 7'b1111011;
        4'b1010: leds <= 7'b1110111;
        4'b1011: leds <= 7'b0011111;
        4'b1100: leds <= 7'b1001110;
        4'b1101: leds <= 7'b0111101;
        4'b1110: leds <= 7'b1001111;
        4'b1111: leds <= 7'b1000111;
    endcase
  end
endmodule
