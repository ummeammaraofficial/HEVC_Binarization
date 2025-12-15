`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 10:49:30 AM
// Design Name: 
// Module Name: KTR_tb
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



module KTR_tb;

    parameter int BIN_WIDTH   = 16;
    parameter int VALUE_WIDTH = 8;

    logic clk;
    logic rst_n;
    logic start_i;
    logic [BIN_WIDTH-1:0] K;
    logic [BIN_WIDTH-1:0] cMax;
    logic [VALUE_WIDTH-1:0] N_i;
    logic [BIN_WIDTH-1:0]   bin_o;
    logic done_o;
    logic  [BIN_WIDTH-1:0] bin_length_o;


    KTR_Binary_Code #(
        .BIN_WIDTH(BIN_WIDTH),
        .VALUE_WIDTH(VALUE_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start_i(start_i),
        .N_i(N_i),
        .bin_o(bin_o),
        .done_o(done_o),
        .bin_length_o(bin_length_o),
        .K(K),
        .cMax
    );

    always #5 clk = ~clk;


    initial begin
        clk     = 0;
        rst_n   = 0;
        start_i = 0;
        N_i     = 0;
        K       = 0;
        cMax = 0;

        #10 rst_n = 1;
        
        for (int n = 0; n <= 12; n++) begin
            #10 start_i = 1;
            N_i = n;
            K       = 1;
             cMax = 8;
            #30 start_i = 0;
            wait(done_o);
        end

       
        #20;
        $finish;
    end

endmodule
