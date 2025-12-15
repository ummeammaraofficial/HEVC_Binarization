`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2025 11:29:24 AM
// Design Name: 
// Module Name: unary_binary_code
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



module unary_binary_code #(
    parameter BIN_WIDTH      = 16,     
    parameter VALUE_WIDTH    = 8,      
    parameter CMAX_WIDTH     = 3       
)(
    input  logic                     clk,
    input  logic                     rst_n,
    input  logic                     start_i,
    input  logic [VALUE_WIDTH-1:0]   Value_i,
    input  logic [CMAX_WIDTH-1:0]    cMax,
    input  logic                     sel,         // 0=TRU, 1=Unary
    output logic [BIN_WIDTH-1:0]     bin_o,
    output logic                     Done_o,
    output logic [BIN_WIDTH-1:0]     Bin_length_o
);

    logic [VALUE_WIDTH:0] counter, max_count;
    logic [BIN_WIDTH-1:0] bin;
    logic [BIN_WIDTH-1:0] bin_length_reg;
    logic done;

    always_comb begin
        if (sel == 1) begin // Unary mode
            max_count = Value_i;
            bin_length_reg = Value_i + 1;
        end else begin // TRU mode
            if (Value_i < cMax) begin
                max_count = Value_i;
                bin_length_reg = Value_i + 1;
            end else begin
                max_count = cMax - 1; // No trailing zero
                bin_length_reg = cMax;
            end
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            bin     <= 0;
            done    <= 0;
        end else if (start_i) begin
            counter <= 0;
            bin     <= 0;
            done    <= 0;
        end else if (!done) begin
            if (counter <= max_count) begin
               if (sel == 1) begin 
                bin <= {bin[BIN_WIDTH-2:0], (counter < max_count) ? 1'b1 : 1'b0};
             end else begin // TRU mode
                if (Value_i < cMax) begin
                   // Value_i ones followed by zero
                   bin <= {bin[BIN_WIDTH-2:0], (counter < max_count) ? 1'b1 : 1'b0};
             
            end else begin
                bin <= {bin[BIN_WIDTH-2:0],1'b1};
            end
            end
           counter <= counter + 1;
          end
            if (counter >= max_count) begin
                done <= 1'b1;
            end
        end
    end

    // Output assignments
    assign bin_o = bin;
    assign Done_o = done;
    assign Bin_length_o = bin_length_reg;

endmodule
