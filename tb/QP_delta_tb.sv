`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2025 04:23:26 PM
// Design Name: 
// Module Name: QP_delta_tb
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



module QP_delta_tb;

    // Parameters
    parameter int BIN_WIDTH = 16;
    parameter int VALUE_WIDTH = 16;
    parameter int K = 0;

    // Signals
    logic clk, rst, start;
    logic [VALUE_WIDTH-1:0] Cu_qp_delta_abs;
    logic done;
    logic [BIN_WIDTH-1:0] bin_string;
    logic [BIN_WIDTH-1:0] bin_length;

    // DUT Instance
    QP_delta #(
        .BIN_WIDTH(BIN_WIDTH),
        .VALUE_WIDTH(VALUE_WIDTH),
        .K(K)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .Cu_qp_delta_abs(Cu_qp_delta_abs),
        .done(done),
        .bin_string(bin_string),
        .bin_length(bin_length)
    );

    // Clock generation (100MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        rst = 0;
        start = 0;
        Cu_qp_delta_abs = 0;

        // Reset
        #20;
        rst = 1;

        // -------- TEST CASE 1 --------
        #10;
        Cu_qp_delta_abs = 3;   // smaller than 5 ? only prefix
        start = 1;
        #10 start = 0;

        wait(done);
        #5;

        // -------- TEST CASE 2 --------
        #20;
        Cu_qp_delta_abs = 8;   // prefix=5 + suffix EGK
        start = 1;
        #10 start = 0;

        wait(done);
        #5;

        // -------- TEST CASE 3 --------
        #20;
        Cu_qp_delta_abs = 1;
        start = 1;
        #10 start = 0;

        wait(done);
        #5;

        #20;
        $finish;
    end

endmodule
