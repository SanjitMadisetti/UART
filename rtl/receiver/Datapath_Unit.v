`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2026 18:13:59
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


module Datapath_Unit#(parameter word_size = 8, half_word = word_size/2, Num_counter_bits = 4)(
    output reg [word_size-1:0] RCV_datareg,
    output Ser_in_0,
    SC_eq_3,
    SC_lt_7,
    BC_eq_8,
    input Serial_in,
    clr_Sample_counter,
    inc_Sample_counter,
    clr_Bit_counter,
    inc_Bit_counter,
    shift,
    load,
    Sample_clk,
    rst_b
);

    reg [word_size-1:0] RCV_shftreg;
    reg [Num_counter_bits-1:0] Sample_counter;
    reg [Num_counter_bits:0] Bit_counter;
    
    assign Ser_in_0 = (Serial_in == 1'b0);
    assign BC_eq_8 = (Bit_counter == word_size);
    assign SC_lt_7 = (Sample_counter < word_size - 1);
    assign SC_eq_3 = (Sample_counter == half_word-1);
    
    always @(posedge Sample_clk) begin
        if(rst_b == 1'b0) begin //synchronous rst_b
            Sample_counter <= 0; 
            Bit_counter <= 0;
            RCV_datareg <= 0;
            RCV_shftreg <= 0;
        end
        
        else begin
            if(clr_Sample_counter == 1) Sample_counter <= 0;
            else if(inc_Sample_counter == 1) Sample_counter <= Sample_counter + 1;
            
            if(clr_Bit_counter == 1) Bit_counter <= 0;
            else if(inc_Bit_counter == 1) Bit_counter <= Bit_counter + 1;
            
            if(shift == 1) RCV_shftreg <= {Serial_in,RCV_shftreg[word_size-1:1]};
            if(load == 1) RCV_datareg <= RCV_shftreg;
        end
    end
    
endmodule
