`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.02.2026 03:21:44
// Design Name: 
// Module Name: Datapath_Unit
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


module Datapath_Unit#(
    parameter word_size = 8,
              size_bit_count=3,
              all_ones = {(word_size+1){1'b1}} //9 bits ones        
    )(output Serial_out,
             BC_lt_BCmax,
      input [word_size-1:0] Data_Bus,
      input Load_XMT_DR,
      input Load_XMT_shftreg,
      input start,
      input shift,
      input clear,
      input Clock,
      input rst_b
      );
      
      reg [word_size:0] XMT_datareg;  //Data register of Transmitter
      reg [word_size+1:0] XMT_shftreg; //Shift register of Transmitter
      reg [size_bit_count:0] bit_count;
      
      assign Serial_out = XMT_shftreg[0];
      assign BC_lt_BCmax = (bit_count < word_size + 1);
      
      always @(posedge Clock, negedge rst_b) 
        if(rst_b ==0) begin
            XMT_shftreg <= all_ones;
            bit_count <= 0;
        end
        else begin
            if(Load_XMT_DR == 1'b1) begin
                XMT_datareg <= Data_Bus;
            end
            
            if(Load_XMT_shftreg == 1'b1) begin
                XMT_shftreg <= {XMT_datareg,1'b1};
            end
            
            if(start==1'b1) begin
                XMT_shftreg[0] <= 1'b0;
            end
            
            if(clear == 1'b1) begin
                bit_count <= 1'b0;
            end
            
            if(shift == 1'b1) begin
                XMT_shftreg <= {1'b1,XMT_shftreg[word_size:1]};
            end
        end
endmodule
