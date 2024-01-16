`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 06:39:28 PM
// Design Name: 
// Module Name: draw_ball
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


module draw_ball
    #(parameter RADIUS = 30)
    (
    input [9:0] h_center,
    input [8:0] v_center,
    input [9:0] h_count,
    input [8:0] v_count,
    output draw
    );
    
    
    localparam [19:0] radsq = RADIUS*RADIUS;
    wire [9:0] h_diff;
    wire [8:0] v_diff;
    wire [9:0] h_diffc;
    wire [9:0] v_diffc;
    wire [19:0] boundary;
    
    assign h_diff = (h_count > h_center) ? h_count - h_center : h_center-h_count;
    assign v_diff = (v_count > v_center) ? v_count - v_center : v_center-v_count;
    
    assign h_diffc = h_diff;
    assign v_diffc = {1'b0, v_diff};
    
    assign boundary = (h_diffc * h_diffc) + (v_diffc * v_diffc);
    assign draw = (boundary <= radsq) ? 1'b1 : 1'b0;
       
    
endmodule
