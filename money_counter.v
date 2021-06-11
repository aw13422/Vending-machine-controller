`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2021 04:23:42 PM
// Design Name: 
// Module Name: money_counter
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


module money_counter
    #(parameter BITS = 6)( 
    input clk,
    input reset_n,
    input enable,
    //input up, //when asserted the counter is up counter; otherwise, it is a down counter
    //input load,
    input c5, c10, c25,
    //input [BITS - 1:0] D,
    output [BITS - 1:0] money,
    output [BITS - 1:0] change
    );
    
    reg [BITS - 1:0] money_reg, money_next;
    reg [BITS - 1:0] change_reg, change_next;
    
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
        begin
            money_reg <= 6'b000000;
            change_reg <= 6'b000000;
        end
        else if(enable & money_reg < 5'b11001)
        begin
            money_reg <= money_next;
            change_reg <= change_next;
        end
        else
        begin
            money_reg <= money_reg;
            change_reg <= change_reg;
        end
    end
    
    // Next state logic
    always @(money_reg, c5, c10, c25)
    begin
        money_next = money_reg;
        case({c5, c10, c25})
            3'b100: money_next = money_reg + 4'b0101;
            3'b010: money_next = money_reg + 4'b1010;
            3'b001: money_next = money_reg + 5'b11001;
            default: money_next = money_reg;
        endcase
        
        if(money_next > 5'b11001)
            change_next = money_next - 5'b11001;
        else
            change_next = 6'b000000;
    end
    
    // Output logic
    assign money = money_reg;
    assign change = change_reg;
    
endmodule
