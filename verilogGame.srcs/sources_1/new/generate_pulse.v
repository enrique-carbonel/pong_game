`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 06:39:28 PM
// Design Name: 
// Module Name: generate_pulse
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


module generate_pulse
    #( parameter COUNT = 10**2)             
    (
    input clock,
    input resetn,
    input E,
    input sclr,
    output [$clog2(COUNT):0] q,
    output z
    );
    
    localparam nbits = $clog2(COUNT);
    
    
    reg [nbits:0] Qt;
    
    always@(posedge(clock) or negedge resetn)
    begin
        if (resetn == 1'b0) begin
            Qt <= 0;
        end else begin
            if (E == 1'b1) begin
                if (sclr == 1'b1) begin
                    Qt <= 0;
                end else begin
                    if (Qt == COUNT - 1) begin
                        Qt <= 0;
                    end else begin
                        Qt <= Qt + 1;
                    end
                end
            end
        end           
    end
    
    assign z = (Qt == COUNT -1) ? 1'b1: 1'b0;
    assign q = Qt;
    
endmodule
