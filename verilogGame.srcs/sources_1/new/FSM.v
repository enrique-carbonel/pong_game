`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 06:39:28 PM
// Design Name: 
// Module Name: FSM
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


module FSM(
    input clock,
    input reset,
    input lost,
    output reg incd,
    output reg up_score,
    output reg gs,
    output reg [3:0] done,
    input start
    );
    
    
    localparam [1:0] game_start = 2'b00,
                     play       = 2'b01,
                     inc_diff   = 2'b10,
                     lose       = 2'b11;
                     
    reg [1:0] state_reg;
    wire inc;
    
    
    generate_pulse #(.COUNT((10**9)/4)) gp4
      ( .clock(clock),
        .resetn(reset),
        .E(1'b1),
        .sclr(1'b0),
        .z(inc)
      );
    
    
    always@(posedge clock)
    begin
        if(reset == 1'b0) begin
            state_reg <= game_start;
        end else begin
            case(state_reg)
                game_start: begin if(start == 1'b1) state_reg <= inc_diff; else state_reg <= game_start; end
                play: begin if(lost == 1'b1) state_reg <= lose; else if(inc == 1'b1) state_reg <= inc_diff; else state_reg <= play; end
                inc_diff: begin state_reg <= play; end
                lose: begin if(start == 1'b0) state_reg <= game_start; else state_reg <= lose; end
            endcase
        end
    end
    
    always@(state_reg)
    begin
        up_score <= 1'b0;
        incd <= 1'b0;
        done <= 4'b0000;
        gs <= 1'b0;
        case(state_reg)
            game_start: begin
                done <= 4'b0000;
                gs <= 1'b0;
                end
            play: begin
                gs <= 1'b1;
                done <= 4'b0101;
                end
            inc_diff: begin
                up_score <= 1'b1;
                incd <= 1'b1;
                done <= 4'b0101;
                gs <= 1'b1;
                end
            lose: begin
                gs <= 1'b0;
                done <= 4'b1111;
                end
       endcase
   end
       
                     
endmodule
