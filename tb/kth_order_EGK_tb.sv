`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2025 11:18:59 AM
// Design Name: 
// Module Name: kth_order_EGK_tb
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




module Kth_order_EGK_tb;
    
    // Parameters
    parameter SYMBOL_BITS = 16;
    parameter MAX_BITS = 16;
    
    // Testbench variables
    logic                   clk;
    logic                   rst_n;
    logic                   start;
    logic [SYMBOL_BITS-1:0] symbolVal;
    logic [3:0]             K;
    logic                   done;
    logic [MAX_BITS-1:0]    code;
    logic [7:0]             code_len;
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Instantiate DUT
    Kth_order_EGK #(
        .SYMBOL_BITS(SYMBOL_BITS),
        .MAX_BITS(MAX_BITS)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .K(K),
        .symbolVal(symbolVal),
        .done(done),
        .code(code),
        .code_len(code_len)
    );
    
    initial begin

        clk = 0;
        rst_n = 0;
        start = 0;
        symbolVal = 0;
        K= 0;
        
        #20;
        rst_n = 1;
        #20;
        
        
        // Test values from 0 to 4
        for (int i = -3; i <= 6; i++) begin
           #10 start = 1;
           K = 1;
            symbolVal = i;
           #30 start = 0;
            wait(done);
        end
            
         
        #20;
        $finish;
    end

    
endmodule
