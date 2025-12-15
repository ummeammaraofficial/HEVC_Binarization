`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2025 04:31:08 PM
// Design Name: 
// Module Name: part_mode_tb
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


module part_mode_tb;

    localparam MAX_BIN = 4;
    
    logic clk;
    logic rst_n;
    logic start;
    logic [7:0] cu_size;
    logic [7:0] min_cu_size;
    logic [2:0] part_mode;
    logic amp_enable;
    logic pred_mode;

    logic [MAX_BIN-1:0] bin_string;
    logic [2:0]         bin_length;
    logic                done;

    part_mode #(.MAX_BIN(MAX_BIN)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .cu_size(cu_size),
        .min_cu_size(min_cu_size),
        .part_mode(part_mode),
        .amp_enable(amp_enable),
        .pred_mode(pred_mode),
        .bin_string(bin_string),
        .bin_length(bin_length),
        .done(done)
    );


    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst_n = 0;
        start = 0;
        cu_size = 8;
        min_cu_size = 8;
        amp_enable = 0;
        pred_mode = 0; // Intra
        part_mode = 0;
        #20;
        rst_n = 1;

        // Loop through Intra partition modes
        pred_mode = 0;
      
            part_mode = 0;
            start = 1;
            #10;
            start = 0;
            wait(done);
            #10;
      
         pred_mode = 0;
      
            part_mode = 1;
            start = 1;
            #10;
            start = 0;
            wait(done);
            #10;
        // Loop through Inter partition modes, AMP disabled
        pred_mode = 1;
        amp_enable = 0;
        for (int i = 0; i < 8; i++) begin
            part_mode = i;
            start = 1;
            #10;
            start = 0;
            wait(done);
            #10;
        end

        // Loop through Inter partition modes, AMP enabled
        amp_enable = 1;
        for (int i = 0; i < 8; i++) begin
            part_mode = i;
            start = 1;
            #10;
            start = 0;
            wait(done);
            #10;
        end


        $stop;
    end

endmodule



