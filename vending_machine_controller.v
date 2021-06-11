`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2021 09:02:37 PM
// Design Name: 
// Module Name: vending_machine_controller
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


module vending_machine_controller(
    input clk,
    //input reset_n,
    input c5, c10, c25, item_taken,
    //output r5, r10, r20, dispense,
    //input reset_n,
    output [6:0]sseg,
    output [0:7]AN,
    output DP,
    output r5, r10, r20,
    output rgb_red, rgb_green, rgb_blue
    );
    wire c5_pedge, c10_pedge, c25_pedge, item_taken_pedge;
    wire [5:0]money_bin, change_bin;
    wire [11:0]money_bcd, change_bcd;
    wire counter_en;
    wire counter_reset;
    wire dispense;
    //assign h = dispense;
    
//    assign c5_pedge = c5;
//    assign c10_pedge = c10;
//    assign c25_pedge = c25;
//    assign item_taken_pedge = item_taken;
    button B0(      
        .clk(clk),
        .reset_n(1),
        .noisy(c5),
        .debounced(),
        .p_edge(c5_pedge),
        .n_edge(),
        ._edge()
    );
    button B1(      
        .clk(clk),
        .reset_n(1),
        .noisy(c10),
        .debounced(),
        .p_edge(c10_pedge),
        .n_edge(),
        ._edge()
    );
    button B2(      
        .clk(clk),
        .reset_n(1),
        .noisy(c25),
        .debounced(),
        .p_edge(c25_pedge),
        .n_edge(),
        ._edge()
    );
    button B3(      
        .clk(clk),
        .reset_n(1),
        .noisy(item_taken),
        .debounced(item_taken_pedge),
        .p_edge(),
        .n_edge(),
        ._edge()
    );
    vending_machine_fsm VMF0(
        .clk(clk),
        .reset_n(1), // 1
        .x({c5_pedge, c10_pedge, c25_pedge, item_taken_pedge}),
        .r5(r5),
        .r10(r10),
        //.r15(r15),
        .r20(r20),
        .dispense(dispense)
    );
    assign counter_en = (c5_pedge | c10_pedge | c25_pedge);
    assign counter_reset = ~(item_taken_pedge & dispense);      //resets if counter_reset = 0
    money_counter MC0(
        .clk(clk),
        .reset_n(counter_reset),   //need 0 to reset (counter_reset)
        .enable(counter_en),
        .c5(c5_pedge),
        .c10(c10_pedge),
        .c25(c25_pedge),
        .money(money_bin),          // 6 bits
        .change(change_bin)         // 6 bits
    );
    bin2bcd B2B0(
        .bin({2'b00, money_bin}),   // 8 bits
        .bcd(money_bcd)             // 12 bits
    );
    bin2bcd B2B1(
        .bin({2'b00, change_bin}),  // 8 bits
        .bcd(change_bcd)            // 12 bits
    );
    sseg_driver SSD0(
        .clk(clk),
        //.reset_n(1), //delete
        .I7({1'b1, money_bcd[3:0], 1'b1}),
        .I6({1'b1, money_bcd[7:4], 1'b1}),
        .I5({1'b1, money_bcd[11:8], 1'b1}),
        .I4(6'b000001),
        .I3({1'b1, change_bcd[3:0], 1'b1}),
        .I2({1'b1, change_bcd[7:4], 1'b1}),
        .I1({1'b1, change_bcd[11:8], 1'b1}),
        .I0(6'b000001),
        .AN(AN),
        .sseg(sseg),
        .DP(DP)
    );
    rgb_driver RGB0(
        .clk(clk),
        .reset_n(1), // 1
        .red_duty({9{~dispense}}),
        .green_duty({9{dispense}}),
        .blue_duty(9'b0_0000_0000),
        .red_LED(rgb_red),
        .green_LED(rgb_green),
        .blue_LED(rgb_blue)
    );
    
endmodule
