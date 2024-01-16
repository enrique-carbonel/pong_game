`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 07:42:43 PM
// Design Name: 
// Module Name: dflipflop
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


module dflipflop(
    input d,
    input clrn,
    input prn,
    input clk,
    input ena,
    output reg q
    );
    
    
  always@(posedge clk)
  begin
    if(clrn == 1'b0) begin
        q <= 1'b0;
    end else if (prn == 1'b0) begin
        q <= 1'b1;
    end else begin
        if(ena == 1'b1) begin
            q <= d;
        end
    end
  end
endmodule
