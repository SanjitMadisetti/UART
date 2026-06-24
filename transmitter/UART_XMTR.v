`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.02.2026 03:38:59
// Design Name: 
// Module Name: UART_XMTR
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


module UART_XMTR#(parameter word_size = 8)(
    output Serial_out,
    input [word_size-1:0] Data_Bus,
    input Load_XMT_datareg, Byte_ready, T_byte, Clock, rst_b);
    
    Control_Unit M0(Load_XMT_DR,Load_XMT_shftreg,start,shift,clear,Load_XMT_datareg,Byte_ready,T_byte,BC_lt_BCmax,Clock,rst_b);
    
    Datapath_Unit M1(Serial_out,BC_lt_BCmax,Data_Bus,Load_XMT_DR,Load_XMT_shftreg,start,shift,clear,Clock,rst_b);
endmodule

