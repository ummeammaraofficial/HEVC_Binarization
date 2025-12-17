`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2025 03:05:44 PM
// Design Name: 
// Module Name: inter_pred_idc_tb
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


module inter_pred_idc_tb;
    logic        clk;
    logic        rst_n;
    logic        start;
    logic [1:0]  inter_pred_idc;
    logic [3:0]  nPbW, nPbH;
    logic        bin_valid;
    logic        bin_value;
    logic        done;
    logic [1:0]  num_bins;

    inter_pred_idc dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .inter_pred_idc(inter_pred_idc),
        .nPbW(nPbW),
        .nPbH(nPbH),
        .bin_valid(bin_valid),
        .bin_value(bin_value),
        .done(done),
        .num_bins(num_bins)
    );

    always #5 clk = ~clk;

    initial begin
        clk  = 0;
        rst_n = 0;
        start = 0;
        inter_pred_idc = 0;
        nPbW = 0;
        nPbH = 0;

        #20;
        rst_n = 1;

        //Normal block, L0 ? 00
        @(negedge clk);
        nPbW = 8; nPbH = 8;          
        inter_pred_idc = 0;          
        start = 1;
        @(negedge clk) start = 0;

        wait(done);
        #20;

        //Normal block, L1 ? 01
        @(negedge clk);
        inter_pred_idc = 1;          
        start = 1;
        @(negedge clk) start = 0;

        wait(done);
        #20;

        //Normal block, BI ? 1
        @(negedge clk);
        inter_pred_idc = 2;          
        start = 1;
        @(negedge clk) start = 0;

        wait(done);
        #20;

        //Small block, L0 ? 0
        @(negedge clk);
        nPbW = 8; nPbH = 4;         
        inter_pred_idc = 0;         
        start = 1;
        @(negedge clk) start = 0;

        wait(done);
        #20;

        //Small block, L1 ? 1
        @(negedge clk);
        inter_pred_idc = 1;         
        start = 1;
        @(negedge clk) start = 0;

        wait(done);
        #20;

        $finish;
    end

endmodule

