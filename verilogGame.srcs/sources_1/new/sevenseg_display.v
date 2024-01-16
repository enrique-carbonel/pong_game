`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 06:39:28 PM
// Design Name: 
// Module Name: sevenseg_display
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


module sevenseg_display(
    input clock,
    input resetn,
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    output [6:0] segs,
    output [7:0] AN
    );
    
    localparam [1:0] S1= 2'b00,
                     S2= 2'b01,
                     S3= 2'b10,
                     S4= 2'b11;
    
    reg [1:0] state_reg;
    reg [1:0] s;
    reg [3:0] omux;
    wire E;
    reg [3:0] ENt;
    wire [6:0] leds; 
    
    
    hex2seven h1(
        .hex(omux),
        .leds(leds)
    );
    
    generate_pulse #(.COUNT(10**5)) gp6
      ( .clock(clock),
        .resetn(resetn),
        .E(1'b1),
        .z(E)
      );
      
    always@(s)
    begin
        case(s)
            2'b00: begin omux <= A; ENt <= 4'b1110; end
            2'b01: begin omux <= B; ENt <= 4'b1111; end
            2'b10: begin omux <= C; ENt <= 4'b1111; end
            2'b11: begin omux <= D; ENt <= 4'b0111; end
        endcase
    end
    
    assign segs = ~(leds); 
    assign AN = {4'b1111, ENt};
    
    always@(posedge clock or negedge resetn)
    begin
        if(resetn == 1'b0) begin
            state_reg <= S1;
        end else begin
            case(state_reg) 
                S1: begin
                    if (E == 1'b1)
                        state_reg <= S2;
                    else
                        state_reg <= S1;
                    end
                S2: begin
                    if (E == 1'b1) 
                        state_reg <= S3;
                    else
                        state_reg <= S2;
                    end
                S3: begin
                    if (E == 1'b1) 
                        state_reg <= S4;
                    else
                        state_reg <= S3;
                    end
                S4: begin
                    if (E == 1'b1) 
                        state_reg <= S1;
                    else
                        state_reg <= S4;
                    end
            endcase
         end
     end
    
    
     always@(state_reg)
     begin
        case(state_reg)
            S1: s <= 2'b00;
            S2: s <= 2'b01;
            S3: s <= 2'b10;
            S4: s <= 2'b11;
        endcase
     end
               
                
           
        
    
    
    
endmodule
