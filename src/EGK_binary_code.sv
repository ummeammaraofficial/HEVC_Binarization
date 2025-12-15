`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2025 12:38:39 PM
// Design Name: 
// Module Name: EGK_binary_cod
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


module EGK_binary_code#(
    parameter int BIN_WIDTH     = 16,
    parameter int VALUE_WIDTH   = 8,
    parameter int K             = 0     // Golomb parameter (K)

)(
    input  logic                        clk,
    input  logic                        rst,
    input  logic                        start_i,
    input  logic [VALUE_WIDTH-1:0]      N_i,
    output logic [BIN_WIDTH - 1:0]      code_o,
    output logic                        done_o,
    output logic [BIN_WIDTH - 1:0]      bin_length_o
);

    logic [BIN_WIDTH-1:0]     lN;
    logic [BIN_WIDTH-1:0]     suffix;
    logic [BIN_WIDTH-1:0]     prefix_len, suffix_len;
   
    always_comb begin
      lN = $clog2((N_i >> K) + 1);
      if ((1 << lN) > N_i+1)begin
         lN = lN - 1;
      end
      prefix_len  = lN + 1;
      suffix_len  = lN + K;

    end
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            done_o        <= 0;
            code_o        <= 0; 
            bin_length_o  <= 0;
            suffix        <= 0;
            
        end else if (start_i) begin
            suffix        <= (N_i + 1) - (1 << lN);
            code_o        <= (1'b1 << suffix_len) | suffix; 
            done_o        <= 1;
            bin_length_o  <= prefix_len + suffix_len;
            
        end else begin
            done_o        <= 0;
            code_o        <= 0; 
            bin_length_o  <= 0;
            suffix        <= 0;
        end
    end

endmodule