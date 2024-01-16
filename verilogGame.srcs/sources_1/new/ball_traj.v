`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 06:39:28 PM
// Design Name: 
// Module Name: ball_traj
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


module ball_traj
    #(parameter RADIUS = 10,
      parameter WIDTH = 10)
    (
    input clock,
    input reset,
    input en,
    input [8:0] vcount,
    input [9:0] hcount,
    output [8:0] v_center,
    output [9:0] h_center,
    input [8:0] vs1,
    input [9:0] hs1,
    input [8:0] vs2,
    input [9:0] hs2,
    input [3:0] difficulty,
    output lost,
    input [8:0] length
    );
    
    
    reg h_dir;
    reg v_dir;
    reg hin;
    wire vin;
    reg en_h;
    wire en_v;
    
    reg [9:0] h_cen;
    reg [8:0] v_cen;
    
    wire [9:0] h_cent;
    wire [8:0] v_cent;
    reg lost_in;
    wire [8:0] vc;
    wire [9:0] hc;
    
    assign lost = lost_in;
    
    assign vc = vcount;
    assign hc = hcount;
    assign h_cent = (h_dir) ? h_cen + difficulty : h_cen - difficulty;
    assign v_cent = (v_dir) ? v_cen + difficulty : v_cen - difficulty;
    
    assign h_center = h_cen;
    assign v_center = v_cen;
    
    always@(negedge clock or negedge reset)
    begin
        if(reset == 1'b0) begin
            h_dir <= 1'b1;
            v_dir <= 1'b0;
        end else begin
            if(en_h == 1'b1)
                h_dir <= hin;
            else if(en_v == 1'b1)
                v_dir <= vin;
        end
    end  
    
    assign en_v = (v_cen < RADIUS || v_cen >480-RADIUS)? 1'b1 : 1'b0;
    assign vin = (v_cen > 480-RADIUS)? 1'b0 :
                 (v_cen < RADIUS)?     1'b1 :
                                       1'b0;
                                       
    always@(h_cen, v_cen,hs1, vs1,hs2,vs2,length)
    begin
        if(h_cen < (hs1+RADIUS+WIDTH)) begin
            if(v_cen>vs1 && v_cen<(vs1+length)) begin
                en_h <= 1'b1;
                hin <= 1'b1;
                lost_in <= 1'b0;
            end else begin
                en_h <= 1'b0;
                hin <= 1'b0;
                lost_in <= 1'b1;
            end
        end else if(h_cen > (hs2 - RADIUS)) begin
            if(v_cen > vs2 && v_cen < (vs2 + length)) begin
                en_h <= 1'b1;
                hin <= 1'b0;
                lost_in <= 1'b0;
            end else begin
                en_h <= 1'b0;
                hin <= 1'b0;
                lost_in <= 1'b1;
            end
        end else begin
            en_h <= 1'b0;
            hin <= 1'b0;
            lost_in <= 1'b0;
        end
   end
    
    
   always@(posedge clock or negedge reset)
   begin
    if(reset == 1'b0) begin
        h_cen <= 10'b0101000000;
        v_cen <= 9'b011110000;
    end else begin
        if(vc == 490 && hc == 640) begin
            if(lost_in == 1'b0 && en == 1'b1) begin
                h_cen <= h_cent;
                v_cen <= v_cent;
            end
        end
    end
   end
   
    
endmodule
