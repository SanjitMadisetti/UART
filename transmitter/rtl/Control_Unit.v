`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.02.2026 02:50:01
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit#(parameter one_hot_count = 3, //Number of one -hot states
    state_count = one_hot_count, //Number of bits in state register
    size_bit_count = 3, //Size of the bit counter, e.g., 4
    idle = 3'b001, //one-hot state encoding
    waiting = 3'b010,
    sending = 3'b100,
    all_ones = 9'b111111111 //Word + 1 extra bit
    )(
    output reg Load_XMT_DR, //Loads Data_But into XMT_datareg
    output reg Load_XMT_shftreg, //Loads XMT_datareg into XMT_shftreg
    output reg start, //Launches shifting of bits in XMT_shftreg
    output reg shift, //Shifts bits in XMT_shftreg
    output reg clear, //Clears bit_count after last bit is send
    input Load_XMT_datareg, //Asserts Load_XMT_DR in state idle
    input Byte_ready, //Asserts Load_XMT_shftreg in state idle
    input T_byte, //asserts start signal in state waiting
    input BC_lt_BCmax, //Indicates status of bit counter
    input Clock, 
    input rst_b
    );
    
    reg [state_count-1:0] state, next_state; //State machine controller
    
    always @(state,Load_XMT_datareg,Byte_ready,T_byte,BC_lt_BCmax) begin
//        Output_and_next-state
        Load_XMT_DR = 0;
        Load_XMT_shftreg = 0;
        start = 0;
        shift = 0;
        clear = 0;
        next_state = idle;
        
        case(state)
            idle: begin
                if(Load_XMT_datareg == 1'b1) begin
                    Load_XMT_DR = 1;
                    next_state = idle;
                end
                
                else if(Byte_ready == 1'b1) begin
                    Load_XMT_shftreg = 1;
                    next_state = waiting;
                end
            end
            
            waiting: begin
                if(T_byte == 1'b1) begin
                    start = 1;
                    next_state = sending;
                end
                
                else next_state = waiting;
            end
            
            sending: begin
                if(BC_lt_BCmax) begin
                    shift = 1;
                    next_state = sending;
                end
                
                else begin
                    clear = 1;
                    next_state = idle;
                end
            end
            
            default: next_state = idle;
        endcase
    end
    
    always @(posedge Clock, negedge rst_b) begin
        if(rst_b == 1'b0) state <= idle;
        else state <= next_state;
    end
      
endmodule
