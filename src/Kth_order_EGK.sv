`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2025 11:05:53 AM
// Design Name: 
// Module Name: Kth_order_EGK
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


module Kth_order_EGK #(
    parameter SYMBOL_BITS = 8,     
    parameter MAX_BITS    = 16     
)(
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic                   start,
    input  logic [3:0]             K,
    input  logic [SYMBOL_BITS-1:0] symbolVal,
    output logic                   done,
    output logic [MAX_BITS-1:0]    code,
    output logic [MAX_BITS - 1:0]             code_len
);

    localparam ABS_BITS = SYMBOL_BITS;                    // Absolute value bit width
    localparam K_INT_BITS = $clog2(SYMBOL_BITS) + 1;      // Internal k register bit width
    
    // Internal registers
    logic [ABS_BITS-1:0]     absV;                    
    logic [K_INT_BITS-1:0]   k;                    
    logic [K_INT_BITS-1:0]   suffix_cnt;              
    logic [MAX_BITS-1:0]     shift_reg;       
    logic                    prefix_done;
    logic                    running;
    logic done_o;


    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            absV        <= '0;
            k           <= K_INT_BITS'(K);    
            suffix_cnt  <= '0;
            shift_reg   <= '0;
            code_len    <= '0;
            prefix_done <= 1'b0;
            running     <= 1'b0;
            done_o        <= 1'b0;
        end else begin
            done_o <= 1'b0; // default

            if(start) begin
                absV        <= symbolVal[SYMBOL_BITS-1] ? (~symbolVal + 1) : symbolVal; // 2's complement abs
                k           <= K_INT_BITS'(K);  
                suffix_cnt  <= '0;
                shift_reg   <= '0;
                code_len    <= '0;
                prefix_done <= 1'b0;
                running     <= 1'b1;
            end else if(running) begin
                if(!prefix_done) begin
                    // PREFIX stage
                    if(absV >= (ABS_BITS'(1) << k)) begin
                        shift_reg <= (shift_reg << 1) | 1'b1;  // push 1
                        absV      <= absV - (ABS_BITS'(1) << k);
                        if (k < K_INT_BITS'(SYMBOL_BITS))
                                k <= k + 1; 
                        code_len  <= code_len + 8'd1;
                    end else begin
                        shift_reg   <= (shift_reg << 1);       // push 0
                        code_len    <= code_len + 8'd1;
                        suffix_cnt  <= k;                 
                        prefix_done <= 1'b1;
                    end
                end else begin
                    // SUFFIX stage
                    if(suffix_cnt > 0) begin
                        shift_reg  <= (shift_reg << 1) | ((absV >> (suffix_cnt - K_INT_BITS'(1))) & 1);
                        suffix_cnt <= suffix_cnt - K_INT_BITS'(1);
                        code_len   <= code_len + 8'd1;
                    end else begin
                        running <= 1'b0;
                        done_o    <= 1'b1;
                    end
                end
            end
        end
    end

    assign code = shift_reg;
    assign done = done_o;

endmodule
