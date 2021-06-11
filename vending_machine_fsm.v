`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2021 09:02:57 PM
// Design Name: 
// Module Name: vending_machine_fsm
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


module vending_machine_fsm(
    input clk,
    input reset_n,
    input [3:0]x,   // 5, 10, 25, item_taken
    //input c5, c10, c25, item_taken,
    output r5, r10, r20, dispense
    );
    reg [3:0] state_reg, state_next;
    localparam s0 = 0;
    localparam s1 = 1;
    localparam s2 = 2;
    localparam s3 = 3;
    localparam s4 = 4;
    localparam s5 = 5;
    localparam s6 = 6;
    localparam s7 = 7;
    localparam s8 = 8;
    localparam s9 = 9;
    
    always @(posedge clk, negedge reset_n)
    begin
        if(~reset_n)
            state_reg <= 0;
        else
            state_reg <= state_next;
    end
    
    always @(*)
    begin
        state_next = state_reg;
        case(state_reg)
            s0: if(x == 4'b1000)        // insert 5
                    state_next = s1;
                else if(x == 4'b0100)   // insert 10
                    state_next = s2;
                else if(x == 4'b0010)   // insert 25
                    state_next = s5;
                else
                    state_next = s0;
            s1: if(x == 4'b1000)        // 5
                    state_next = s2;
                else if(x == 4'b0100)   // 10
                    state_next = s3;
                else if(x == 4'b0010)   // 25
                    state_next = s6;
                else 
                    state_next = s1;
            s2: if(x == 4'b1000)        // 5
                    state_next = s3;
                else if(x == 4'b0100)   // 10
                    state_next = s4;
                else if(x == 4'b0010)   // 25
                    state_next = s7;
                else
                    state_next = s2;
            s3: if(x == 4'b1000)        // 5
                    state_next = s4;        
                else if(x == 4'b0100)   // 10
                    state_next = s5;
                else if(x == 4'b0010)   // 25
                    state_next = s8;
                else
                    state_next = s3;
            s4: if(x == 4'b1000)        // 5
                    state_next = s5;
                else if(x == 4'b0100)   // 10
                    state_next = s6;
                else if(x == 4'b0010)   // 25
                    state_next = s9;
                else
                    state_next = s4;
            s5: if(x == 4'b0001)        // take item, no change
                    state_next = s0;
                else
                    state_next = s5;
            s6: if(x == 4'b0001)        // take item, change: 5
                    state_next = s0;
                else
                    state_next = s6;
            s7: if(x == 4'b0001)        // take item, change: 10
                    state_next = s0;
                else
                    state_next = s7;
            s8: if(x == 4'b0001)        // take item, change: 15
                    state_next = s0;
                else
                    state_next = s8;
            s9: if(x == 4'b0001)        // take item, change: 20
                    state_next = s0;
                else
                    state_next = s9;
            default: state_next = state_reg;
        endcase
    end
    
    assign r5 = (state_reg == s6) | (state_reg == s8);
    assign r10 = (state_reg == s7) | (state_reg == s8);
    //assign r15 = (state_reg == s8);
    assign r20 = (state_reg == s9);
    assign dispense = (state_reg == s5) | (state_reg == s6) | (state_reg == s7) | (state_reg == s8) | (state_reg == s9);
endmodule
