`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2026 18:22:25
// Design Name: 
// Module Name: UART_RCVR
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


module UART_RCVR#(parameter word_size = 8, half_word = word_size/2)
(
    output [word_size-1:0] RCV_datareg,
    output read_not_ready_out,
    Error1, Error2,
    input Serial_in,
    read_not_ready_in,
    Sample_clk,
    rst_b
    );
    
    Control_Unit M0(
    read_not_ready_out,
    Error1, Error2,
    clr_Sample_counter,
    inc_Sample_counter,
    clr_Bit_counter,
    inc_Bit_counter,
    shift,
    load,
    read_not_ready_in,
    Ser_in_0,
    SC_eq_3,
    SC_lt_7,
    BC_eq_8,
    Sample_clk,
    rst_b
    );
    
    Datapath_Unit M1(
    RCV_datareg,
    Ser_in_0,
    SC_eq_3,
    SC_lt_7,
    BC_eq_8,
    Serial_in,
    clr_Sample_counter,
    inc_Sample_counter,
    clr_Bit_counter,
    inc_Bit_counter,
    shift,
    load,
    Sample_clk,
    rst_b
    );
    
    
endmodule
