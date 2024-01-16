`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 06:39:28 PM
// Design Name: 
// Module Name: register
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


module register
    #(parameter N = 4)
    (
    input clock,
    input resetn,
    input E,
    input sclr,
    input [N-1:0] D,
    output [N-1:0] Q
    );
    
    
    reg [N-1:0] Qt;
    
    
    always@(posedge clock or negedge resetn)
    begin
        if (resetn == 0) begin
            Qt <= 0;
        end else begin
            if (E == 1'b1) begin
                if (sclr == 1'b1) begin
                    Qt <= 0;
                end else begin
                    Qt <= D;
                end
            end
       end 
    end
    
    assign Q = Qt;
    
    
    
    
endmodule
