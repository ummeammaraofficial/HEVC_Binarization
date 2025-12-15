`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2025 10:16:44 AM
// Design Name: 
// Module Name: inta_chroma_pred_mode_tb
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


module inta_chroma_pred_mode_tb;
    logic clk;
    logic rst_n;
    logic        valid_in;
    logic [2:0]  chroma_intra_mode;
    logic        valid_out;
    logic [2:0]  bin_value;
    logic [1:0]  num_bins;

    intra_chroma_pred_mode dut (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .chroma_intra_mode(chroma_intra_mode),
        .valid_out(valid_out),
        .bin_value(bin_value),
        .num_bins(num_bins)
    );

    localparam DM_CHROMA_IDX = 3'd4;
    localparam INTRA_PLANAR = 3'd0;
    localparam INTRA_ANG26  = 3'd1;
    localparam INTRA_ANG10  = 3'd2;
    localparam INTRA_DC     = 3'd3;

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        valid_in = 0;
        chroma_intra_mode = 0;

        // reset
        #20;
        rst_n = 1;

        // -------------------------------
        // Case 1: Derived Mode
        // -------------------------------
        @(posedge clk);
        valid_in = 1;
        chroma_intra_mode = DM_CHROMA_IDX;

        @(posedge clk);
        valid_in = 0;

        // -------------------------------
        // Case 2: Explicit PLANAR
        // -------------------------------
        @(posedge clk);
        valid_in = 1;
        chroma_intra_mode = INTRA_PLANAR;

        @(posedge clk);
        valid_in = 0;

        // -------------------------------
        // Case 3: Explicit ANGULAR 26
        // -------------------------------
        @(posedge clk);
        valid_in = 1;
        chroma_intra_mode = INTRA_ANG26;

        @(posedge clk);
        valid_in = 0;

        // -------------------------------
        // Case 4: Explicit ANGULAR 10
        // -------------------------------
        @(posedge clk);
        valid_in = 1;
        chroma_intra_mode = INTRA_ANG10;

        @(posedge clk);
        valid_in = 0;

        // -------------------------------
        // Case 5: Explicit DC
        // -------------------------------
        @(posedge clk);
        valid_in = 1;
        chroma_intra_mode = INTRA_DC;

        @(posedge clk);
        valid_in = 0;

        // finish
        #20;
        $finish;
    end

endmodule
