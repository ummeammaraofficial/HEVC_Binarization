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
    parameter N             = 8;     
    parameter bins_width    = 16;  
    
    // Testbench variables
    logic                       clk;
    logic                       rst_n;
    logic                       start;
    logic [N-1:0]               N_i;
    logic [3:0]                 K;
    logic                       done;
    logic [bins_width-1:0]      bin_string;
    logic [bins_width-1:0]      bin_len;
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Instantiate DUT
    Kth_order_EGK #(
        .N(N),
        .bins_width(bins_width)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .K(K),
        .N_i(N_i),
        .done(done),
        .bin_string(bin_string),
        .bin_len(bin_len)
    );
    
    initial begin

        clk = 0;
        rst_n = 0;
        start = 0;
        N_i = 0;
        K= 0;
        
        #20;
        rst_n = 1;
        #20;
        
        
        // Test values from 0 to 4
        for (int i = 0; i <= 6; i++) begin
           #10 start = 1;
           K = 1;
           N_i = i;
           #30 start = 0;
            wait(done);
        end
            
         
        #20;
        $finish;
    end

    
endmodule
