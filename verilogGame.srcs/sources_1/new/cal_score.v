`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 06:39:28 PM
// Design Name: 
// Module Name: cal_score
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


module cal_score(
    input clock,
    input resetn,
    input up_score,
    input incd,
    output [7:0] score,
    output [3:0] difficulty
    );
    
    
    generate_pulse #(.COUNT(15)) gp7
      ( .clock(clock),
        .resetn(resetn),
        .E(incd),
        .sclr(1'b0),
        .q(difficulty)
      );  
      
      
      generate_pulse #(.COUNT(255)) gp8
      ( .clock(clock),
        .resetn(resetn),
        .E(up_score),
        .sclr(1'b0),
        .q(score)
      );  
      
      
      
endmodule
