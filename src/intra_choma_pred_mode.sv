`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2025 10:12:08 AM
// Design Name: 
// Module Name: intra_choma_pred_mode
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


module intra_chroma_pred_mode(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        valid_in,
    input  logic [2:0]  chroma_intra_mode,

    output logic        valid_out,
    output logic [2:0]  bin_value,   // up to 3 bins
    output logic [1:0]  num_bins
);

    localparam logic [2:0] DM_CHROMA_IDX = 3'd4;
    localparam logic [2:0] INTRA_PLANAR = 3'd0;
    localparam logic [2:0] INTRA_ANG26  = 3'd1;
    localparam logic [2:0] INTRA_ANG10  = 3'd2;
    localparam logic [2:0] INTRA_DC     = 3'd3;

    logic       is_dm;
    logic [1:0] explicit_idx;
    logic [2:0] chroma_intra_mode_r;
    logic       valid_in_r;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            chroma_intra_mode_r <= 3'd0;
            valid_in_r          <= 1'b0;
        end else begin
            chroma_intra_mode_r <= chroma_intra_mode;
            valid_in_r          <= valid_in;
        end
    end


    always_comb begin
        is_dm        = (chroma_intra_mode_r == DM_CHROMA_IDX);
        explicit_idx = 2'b00;

        case (chroma_intra_mode_r)
            INTRA_PLANAR: explicit_idx = 2'b00;
            INTRA_ANG26:  explicit_idx = 2'b01;
            INTRA_ANG10:  explicit_idx = 2'b10;
            INTRA_DC:     explicit_idx = 2'b11;
            default:      explicit_idx = 2'b00;
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            bin_value <= 3'b000;
            num_bins  <= 2'd0;
        end
        else begin
            valid_out <= valid_in_r;

            if (valid_in_r) begin
                if (is_dm) begin
                    bin_value <= 3'b000;   // only bit[0] is used
                    num_bins  <= 2'd1;
                end
                else begin
                    bin_value <= {1'b1, explicit_idx};
                    num_bins <= 2'd3;
                end
            end
            else begin
                num_bins <= 2'd0;
            end
        end
    end

endmodule