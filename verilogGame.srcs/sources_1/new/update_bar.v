`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 06:39:28 PM
// Design Name: 
// Module Name: update_bar
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


module update_bar(
    input klu,
    input kld,
    input kru,
    input krd,
    input en,
    input clock,
    input reset,
    output [8:0] vs1,
    output [8:0] vs2
    );
    
    
    
    wire check;
    wire [8:0] vs1_in;
    wire [8:0] vs2_in;
    
    
    reg [8:0] vs1_reg;
    reg [8:0] vs2_reg;
    
    generate_pulse #(.COUNT(10**6)) gp5
      ( .clock(clock),
        .resetn(reset),
        .E(1'b1),
        .sclr(1'b0),
        .z(check)
      );
      
    assign vs1_in  = (klu == 1'b0 && kld == 1'b1) ? vs1_reg + 10 :
                     (kld == 1'b0 && klu == 1'b1) ? vs1_reg - 10 : 
                                                    vs1_reg;
                                                    
    assign vs2_in  = (kru == 1'b0 && krd == 1'b1) ? vs2_reg + 10 :
                     (krd == 1'b0 && kru == 1'b1) ? vs2_reg - 10 : 
                                                    vs2_reg;
                                                    
    assign vs1 = vs1_reg;
    assign vs2 = vs2_reg;
    
    always@(posedge clock or negedge reset)
    begin
        if(reset == 1'b0) begin
            vs1_reg <= 0;
            vs2_reg <= 0;
        end else begin
            if(check == 1'b1 && en <= 1'b1) begin
                if(vs1_in < 366 && vs1_in >= 0)
                    vs1_reg <= vs1_in;
                if(vs2_in < 366 && vs2_in >= 0)
                    vs2_reg <= vs2_in;
            end
        end
    end
                
    
endmodule
