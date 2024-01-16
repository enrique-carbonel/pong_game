`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 06:39:28 PM
// Design Name: 
// Module Name: top_pong_game
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


module top_pong_game
    #(parameter nbits = 12)
    (
    input clock,
    input reset,
    output [11:0] RGB,
    output HS,
    output VS,
    output [1:0]vga_clk,
    input start,
    input klu,
    input kld,
    input kru,
    input krd,
    output [6:0] segs,
    output [7:0] AN
    );
    
    wire resetn;
    wire [nbits-1:0] RGB_buf;
    wire vga_tick;
    wire video_on_buf;
    wire [9:0] hcount_buf,vcount_buf;
    wire [nbits-1:0] SW;
    
    wire video_on;
    wire [9:0] hcount, vcount;
    
    wire [9:0] hs1;
    wire [8:0] vs1;
    wire [9:0] hs2;
    wire [8:0] vs2;
    wire [9:0] h_center;
    wire [8:0] v_center;
    
    wire [8:0] len;
    wire lost;
    wire d_ball;
    wire d_bar1;
    wire d_bar2;
    
    wire [7:0] score;
    wire [3:0] diffic;
    wire [3:0] done;
    wire gs;
    wire up_score;
    wire incd;
    
    assign SW = (d_bar1 == 1'b1 || d_bar2 == 1'b1)? 12'b000000001111:
                (d_ball == 1'b1) ?                  12'b111100000000:
                                                    12'b000000000000;
    assign resetn = ~reset;                                              
    assign hs1 = 10'd0;
    assign hs2 = 10'b1001110001;
    assign len = 9'b001110010;
    
    assign vga_clk[1] = lost;
    assign vga_clk[0] = gs;
    assign RGB = (video_on_buf) ? RGB_buf: 12'd0;
    
    vga_display vd1(
        .clock(clock),
        .resetn(resetn),
        .vga_tick(vga_tick),
        .video_on(video_on_buf),
        .hcount(hcount_buf),
        .vcount(vcount_buf),
        .HS(HS),
        .VS(VS)
        );
        
    register #(.N(nbits)) r1(
        .clock(vga_tick),
        .resetn(1'b1),
        .E(video_on_buf),
        .sclr(1'b0),
        .D(SW),
        .Q(RGB_buf)
        );
        
    FSM controller(
        .clock(vga_tick),
        .reset(resetn),
        .lost(lost),
        .incd(incd),
        .up_score(up_score),
        .gs(gs),
        .done(done),
        .start(start)
        );
        
    update_bar ub1(
        .klu(klu),
        .kld(kld),
        .kru(kru),
        .krd(krd),
        .en(gs),
        .clock(vga_tick),
        .reset(resetn),
        .vs1(vs1),
        .vs2(vs2)
        );
        
    ball_traj #(.RADIUS(15),.WIDTH(15)) bt(
        .clock(vga_tick),
        .reset(resetn),
        .en(gs),
        .vcount(vcount[8:0]),
        .hcount(hcount),
        .length(len),
        .v_center(v_center),
        .h_center(h_center),
        .vs1(vs1),
        .hs1(hs1),
        .vs2(vs2),
        .hs2(hs2),
        .difficulty(diffic),
        .lost(lost)
        ); 
        
     draw_ball #(.RADIUS(15)) db(
        .h_center(h_center),
        .v_center(v_center),
        .h_count(hcount),
        .v_count(vcount[8:0]),
        .draw(d_ball)
        );
     
     draw_bar #(.WIDTH(15)) db1(
        .h_start(hs1),
        .v_start(vs1),
        .h_count(hcount),
        .v_count(vcount[8:0]),
        .length(len),
        .draw(d_bar1)
        );       
       
      draw_bar #(.WIDTH(15)) db2(
        .h_start(hs2),
        .v_start(vs2),
        .h_count(hcount),
        .v_count(vcount[8:0]),
        .length(len),
        .draw(d_bar2)
        ); 
        
      sevenseg_display sd1(
        .resetn(resetn),
        .clock(clock),
        .A(score[3:0]),
        .B(score[7:4]),
        .C(4'b0000),
        .D(done),
        .segs(segs),
        .AN(AN)
       );
       
      cal_score(
        .clock(vga_tick),
        .resetn(resetn),
        .up_score(up_score),
        .incd(incd),
        .score(score),
        .difficulty(diffic)
        );
        
       
      assign video_on = video_on_buf;
      assign hcount = hcount_buf;
      assign vcount = vcount_buf;
      

endmodule
