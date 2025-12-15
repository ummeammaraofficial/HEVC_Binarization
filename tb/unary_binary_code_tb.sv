`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2025 02:26:46 PM
// Design Name: 
// Module Name: unary_binary_code_tb
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


module unary_binary_code_tb();

    // Parameters
    localparam BIN_WIDTH   = 16;
    localparam VALUE_WIDTH = 8;
    localparam CMAX_WIDTH  = 3;

    // DUT signals
    logic clk;
    logic rst_n;
    logic start_i;
    logic [VALUE_WIDTH-1:0] Value_i;
    logic [CMAX_WIDTH-1:0]  cMax;
    logic sel;  // 0 = TRU, 1 = Unary
    logic [BIN_WIDTH-1:0] bin_o;
    logic Done_o;
    logic [BIN_WIDTH-1:0] Bin_length_o;

    // Instantiate DUT (Device Under Test)
    unary_binary_code #(
        .BIN_WIDTH(BIN_WIDTH),
        .VALUE_WIDTH(VALUE_WIDTH),
        .CMAX_WIDTH(CMAX_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start_i(start_i),
        .Value_i(Value_i),
        .cMax(cMax),
        .sel(sel),
        .bin_o(bin_o),
        .Done_o(Done_o),
        .Bin_length_o(Bin_length_o)
    );

    // Clock generation (100MHz)
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        // Initialize
        clk     = 0;
        rst_n   = 0;
        start_i = 0;
        Value_i = 0;
        cMax    = 3;
        sel     = 0;

        // Reset
        #10;
        rst_n = 1;

        // ---- Test 1: Unary Encoding ----
        sel = 0;          // Unary
        Value_i = 2;      // Value = 3 ? expect 111
        start_i = 1; #30; start_i = 0;
        wait (Done_o);

        // ---- Test 2: TRU Encoding (Value < cMax) ----
        sel = 0;          // TRU
        Value_i = 3;      // Value=2, cMax=3 ? expect 110
        start_i = 1; #30; start_i = 0;
        wait (Done_o);
        
        // ---- Test 3: TRU Encoding (Value == cMax) ----
        sel = 1;
        Value_i = 7;      // Value=cMax=3 ? expect 111
        start_i = 1; #30; start_i = 0;
        wait (Done_o);

        // Done
        #20;
        $finish;
    end

endmodule
