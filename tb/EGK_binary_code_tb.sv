`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 11:43:27 AM
// Design Name: 
// Module Name: EGK_binary_code_tb
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


module EGK_binary_code_tb;

    parameter int BIN_WIDTH   = 16;
    parameter int VALUE_WIDTH = 8;
    parameter int K           = 1;

    logic clk;
    logic rst;
    logic start_i;
    logic [VALUE_WIDTH-1:0] N_i;
    logic [BIN_WIDTH-1:0]   code_o;
    logic done_o;
    logic [BIN_WIDTH-1:0]   bin_length_o;

    EGK_binary_code #(
        .BIN_WIDTH(BIN_WIDTH),
        .VALUE_WIDTH(VALUE_WIDTH),
        .K(K)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start_i(start_i),
        .N_i(N_i),
        .code_o(code_o),
        .done_o(done_o),
        .bin_length_o(bin_length_o)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start_i = 0;
        N_i = 0;

        #10 rst = 0;
        #10;

        // ---- Test 1 ----
        N_i = 5;     
        start_i = 1;
        #30 start_i = 0; 
        wait (done_o);
        #2;

        // ---- Test 2 ----
        #10;
        N_i = -3;
        start_i = 1;
        #30 start_i = 0;
        wait (done_o);
        #2;
        
        // ---- Test 3 ----
        #10;
        N_i = -2;
        start_i = 1;
        #30 start_i = 0;
        wait (done_o);
        #2;
        
        #10;
        N_i = -4;
        start_i = 1;
        #30 start_i = 0;
        wait (done_o);
        #2;
        
        #10;
        N_i = 6;
        start_i = 1;
        #30 start_i = 0;
        wait (done_o);
        #2;
        
         #10;
        N_i = 7;
        start_i = 1;
        #30 start_i = 0;
        wait (done_o);
        #2;
        
       #10;
        N_i = 0;
        start_i = 1;
        #30 start_i = 0;
        wait (done_o);
        #2;
        
        
        #10;
        N_i = -1;
        start_i = 1;
        #30 start_i = 0;
        wait (done_o);
        #2;

        #20;
        $finish;
    end

endmodule
