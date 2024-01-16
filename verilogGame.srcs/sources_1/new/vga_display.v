`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 06:39:28 PM
// Design Name: 
// Module Name: vga_display
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


module vga_display(
    input clock,
    input resetn,
    output vga_tick,
    output video_on,
    output [9:0] hcount,
    output [9:0] vcount,
    output HS,
    output VS
    );
    
    
    
    localparam HD = 640;
    localparam HF = 16;
    localparam HB = 48;
    localparam HR = 96;
    localparam VD = 480;
    localparam VF = 10;
    localparam VB = 33;
    localparam VR = 2;
    
    localparam state1 = 1'b0;
    localparam state2 = 1'b1;
    
    reg state_reg;
    

    wire [9:0] HC;
    wire [9:0] VC;
    reg E_HC, E_VC, sclr_HC, sclr_VC;
    reg d_VS, d_HS, e_VS, e_HS;
    reg d_video_on, e_video_on;
    reg sclr_vga_tick;
    wire vga_tick_buf;
    
    
    always@(posedge clock or negedge resetn)
    begin
        if(resetn == 1'b0) begin
            state_reg <= state1;
        end else begin
            case(state_reg)
                state1: state_reg <= state2;
                state2: state_reg <= state2;
            endcase
        end
    end
    
    
    always@(state_reg, VC, HC, vga_tick_buf)
    begin
        sclr_vga_tick <= 1'b0;
        sclr_HC <= 1'b0;
        sclr_VC <= 1'b0;
        d_VS <= 1'b0;
        e_VS <= 1'b0;
        d_HS <= 1'b0;
        e_HS <= 1'b0;
        sclr_VC <= 1'b0;
        E_VC <= 1'b0;
        sclr_HC <= 1'b0;
        E_HC <= 1'b0;
        d_video_on <= 1'b0;
        e_video_on <= 1'b0;
        
        case(state_reg)
            state1: begin
                E_HC <= 1'b1;
                sclr_HC <= 1'b1;
                E_VC <= 1'b1;
                sclr_VC <= 1'b1;
                sclr_vga_tick <= 1'b1;
                e_video_on <= 1'b1;
                d_video_on <= 1'b0;
                end
            state2: begin
                if(vga_tick_buf == 1'b1) begin
                    if((HC < HD) && (VC < VD)) begin
                        d_video_on <= 1'b1;
                        e_video_on <= 1'b1;
                    end else begin
                        d_video_on <= 1'b0;
                        e_video_on <= 1'b1;
                    end
                    
                    if(VC >= VD+VF && VC <= VD+VF+VR-1) begin
                        d_VS <= 1'b0;
                        e_VS <= 1'b1;
                    end else begin
                        d_VS <= 1'b1;
                        e_VS <= 1'b1;
                    end
                    
                    if(HC >= HD+HF && HC <= HD+HF+HR-1) begin
                        d_HS <= 1'b0;
                        e_HS <= 1'b1;
                    end else begin
                        d_HS <= 1'b1;
                        e_HS <= 1'b1;
                    end
                    
                    if(HC == HD+HF+HB+HR-1) begin
                        E_HC <= 1'b1;
                        sclr_HC <= 1'b1;
                        if(VC == VD+VF+VB+VR-1) begin
                            E_VC <= 1'b1;
                            sclr_VC <= 1'b1;
                        end else begin
                            E_VC <= 1'b1;
                        end
                    end else begin
                        E_HC <= 1'b1;
                    end
                end
             end
         endcase
      end
      
      
      generate_pulse #(.COUNT(4)) gp1
      ( .clock(clock),
        .resetn(resetn),
        .E(1'b1),
        .sclr(sclr_vga_tick),
        .z(vga_tick_buf)
      );
        
     dflipflop df1(
        .d(d_VS),
        .clrn(resetn),
        .prn(1'b1),
        .clk(clock),
        .ena(e_VS),
        .q(VS)
     );
    
     dflipflop df2(
        .d(d_HS),
        .clrn(resetn),
        .prn(1'b1),
        .clk(clock),
        .ena(e_HS),
        .q(HS)
     );
                    
     dflipflop df3(
        .d(d_video_on),
        .clrn(1'b1),
        .prn(1'b1),
        .clk(clock),
        .ena(e_video_on),
        .q(video_on)
     );
     
     generate_pulse #(.COUNT(HD+HF+HB+HR)) gp2
      ( .clock(clock),
        .resetn(resetn),
        .E(E_HC),
        .sclr(sclr_HC),
        .q(HC)
      );                      
       
     generate_pulse #(.COUNT(VD+VF+VB+VR)) gp3
      ( .clock(clock),
        .resetn(resetn),
        .E(E_VC),
        .sclr(sclr_VC),
        .q(VC)
      );
      
     assign vga_tick = vga_tick_buf;
     assign hcount = HC;
     assign vcount = VC;                 
    
endmodule
