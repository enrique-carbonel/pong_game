`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 06:39:28 PM
// Design Name: 
// Module Name: draw_bar
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


module draw_bar
    #(parameter WIDTH = 10)
    (
    input [9:0] h_start,
    input [8:0] v_start,
    input [9:0] h_count,
    input [8:0] v_count,
    input [8:0] length,
    output reg draw
    );
    
    
    localparam [9:0] wid = WIDTH;
    wire [9:0] hor;
    wire [8:0] ver;
    wire [9:0] hs;
    wire [8:0] vs;
    wire [9:0] hc;
    wire [8:0] vc;
    
    assign hor = h_start + wid;
    assign ver = v_start + length;
    assign hc = h_count;
    assign vc = v_count;
    assign hs = h_start;
    assign vs = v_start;
    
    always@(hs,vs,hc,vc,hor)
    begin
        if(hc >= hs && hc <= hor) begin
            if(vc >= vs && vc <= ver) begin
                draw <= 1'b1;
            end else begin
                draw <= 1'b0;
            end
        end else begin
            draw <= 1'b0;
        end
    end
            
    
    
endmodule
