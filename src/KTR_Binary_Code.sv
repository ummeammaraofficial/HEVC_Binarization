`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2025 11:53:59 AM
// Design Name: 
// Module Name: KTR_Binary_Code
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
               

module KTR_Binary_Code#(                            
    parameter int BIN_WIDTH = 16,
    parameter int VALUE_WIDTH = 16                                                                                                                       
)(
    input  logic                     clk,
    input  logic                     rst_n,
    input  logic                     start_i,
    input  logic [3:0]     K,   
    input  logic [BIN_WIDTH - 1:0]   cMax,
    input  logic [VALUE_WIDTH-1:0]   N_i,        
    output logic [BIN_WIDTH-1:0]     bin_o,      
    output logic                     done_o,     
    output logic [BIN_WIDTH-1:0]     bin_length_o
);

    logic [VALUE_WIDTH-1:0]  prefix_value;
    logic [VALUE_WIDTH-1:0]  suffix_value;
    logic [BIN_WIDTH-1:0]    prefix_bin;
    logic                    prefix_done;
    logic [BIN_WIDTH-1:0]    suffix_bin;
    logic [BIN_WIDTH-1:0]    prefix_length; 
    logic [BIN_WIDTH-1:0]    total_length;
    logic [BIN_WIDTH-1:0]    shiftdown;
    
    assign shiftdown        = (cMax >> K);                     //shiftdown = (cMax >>k)
    assign prefix_value     = N_i >> K;                        //prefix    = N / (2^k)
    assign suffix_value     = N_i - (prefix_value << K);       //suffix    = N % (2^k)
     
     always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prefix_bin              <= '0;
            prefix_done             <= 1'b0;
            prefix_length           <= '0;
            
        end else if (start_i) begin
            prefix_done <= 1'b1;
            
            if (prefix_value >= shiftdown) begin
                prefix_bin          <= ((1 << prefix_value) - 1);
                prefix_length       <= prefix_value;
                
            end else begin
                    prefix_bin      <= ((1 << prefix_value) - 1) << 1;
                    prefix_length   <= prefix_value + 1;
            end
        end else begin
            prefix_done <= 1'b0;
        end
    end

    // ---------------------------------------------------------
    // Step 3: Binary encoding of suffix log2(shiftup + 1) bits
    // ---------------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            suffix_bin    <= '0;
        else if (start_i)
            suffix_bin    <= suffix_value;

    end

    // ---------------------------------------------------------
    // Step 4: Combine prefix and suffix
    // ---------------------------------------------------------
  always_comb begin
        if (K == 0) begin : NO_SUFFIX
            // k = 0 ? same as truncated unary
             bin_o        = prefix_bin;
             done_o       = prefix_done;
             total_length = prefix_length;
        end
        else begin : HAS_SUFFIX
             bin_o        = suffix_bin | (prefix_bin << K);
             done_o       = prefix_done;
             total_length = prefix_length + K;
            
        end
 end
 
   assign bin_length_o = total_length;
    
  /*  always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
             bin_length_o  <= '0;
        else if (start_i)
              bin_length_o <= total_length;
    end*/

endmodule
