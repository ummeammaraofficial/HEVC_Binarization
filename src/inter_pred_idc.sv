`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2025 03:05:13 PM
// Design Name: 
// Module Name: inter_pred_idc
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


module inter_pred_idc(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start,
    input  logic [1:0]  inter_pred_idc,   // 0:L0, 1:L1, 2:BI
    input  logic [3:0]  nPbW,
    input  logic [3:0]  nPbH,

    output logic        bin_valid,
    output logic        bin_value,
    output logic        done,
    output logic [1:0] num_bins
);

    logic        active;
    logic        small_block;
    logic [1:0]  bin_cnt;

    assign small_block = ((nPbW + nPbH) == 12);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            active     <= 1'b0;
            bin_cnt    <= 2'd0;
            bin_valid  <= 1'b0;
            num_bins   <= 2'd0;
            bin_value  <= 1'b0;
            done       <= 1'b0;
        end
        else begin
            bin_valid <= 1'b0;
            done      <= 1'b0;

            if (start && !active) begin
                active  <= 1'b1;
                bin_cnt <= 2'd0;

                if (small_block)
                    num_bins  <= 2'd1;
                else if (inter_pred_idc == 2)
                    num_bins <= 2'd1;
                else
                    num_bins <= 2'd2;
            end

            else if (active) begin
                bin_valid <= 1'b1;

                if (bin_cnt == 0) begin
                    if (small_block)
                        bin_value <= inter_pred_idc[0];       // L0/L1
                    else
                        bin_value <= (inter_pred_idc == 2);   // BI?
               
                end else begin
                    bin_value <= inter_pred_idc[0];
                end

                bin_cnt <= bin_cnt + 1'b1;

                if (bin_cnt + 1 == num_bins) begin
                    active <= 1'b0;
                    done   <= 1'b1;
                end
            end
        end
    end

endmodule