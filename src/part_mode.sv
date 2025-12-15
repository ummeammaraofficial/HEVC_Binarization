`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2025 04:30:39 PM
// Design Name: 
// Module Name: part_mode
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



module part_mode #(
    parameter MAX_BIN = 4
)(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start,

    input  logic [7:0]          cu_size,       
    input  logic [7:0]          min_cu_size,    
    input  logic [2:0]          part_mode,  
    input  logic                amp_enable,
    input  logic                pred_mode,      // 0 = Intra, 1 = Inter

    output logic [MAX_BIN-1:0]  bin_string,
    output logic [2:0]          bin_length,
    output logic                done
);

    // Part mode localparams
    localparam PART_2Nx2N  = 0; 
    localparam PART_Nx2N   = 1; 
    localparam PART_2NxN   = 2;
    localparam PART_NxN    = 3; 
    localparam PART_2NxnU  = 4; 
    localparam PART_2NxnD  = 5; 
    localparam PART_nLx2N  = 6; 
    localparam PART_nRx2N  = 7;


    logic [MAX_BIN-1:0] bin_c;
    logic [2:0]         len_c;


    always_comb begin
        bin_c = '0;
        len_c = 0;

        if (pred_mode == 0) begin
            // INTRA MODE
            if (cu_size == min_cu_size) begin
                case (part_mode)
                    PART_2Nx2N: bin_c = 1; 
                    PART_NxN:   bin_c = 0; 
                endcase
                len_c = 1;
            end else begin
                bin_c = 0;
                len_c = 0;
            end
        end else begin
            // INTER MODE
            if (cu_size == min_cu_size && cu_size == 8) begin
                // CU=8x8
                case (part_mode)
                    PART_2Nx2N: bin_c = 2'b10;
                    PART_Nx2N:  bin_c = 2'b01;   
                    PART_2NxN:  bin_c = 2'b00;
                    PART_NxN:   bin_c = 2'b00;
                endcase
                len_c = 2;
            end else if (!amp_enable & cu_size > min_cu_size) begin
                // CU > min, AMP disabled
                case (part_mode)
                    PART_2Nx2N: bin_c = 2'b10;
                    PART_Nx2N:  bin_c = 2'b01;
                    PART_2NxN:  bin_c = 2'b00;
                    default:    bin_c = 2'b00;
                endcase
                len_c = 2;
            end else if(cu_size == min_cu_size & cu_size > 8) begin
                   case (part_mode)
                    PART_2Nx2N: bin_c = 2'b10;
                    PART_Nx2N:  bin_c = 2'b01;
                    default:    bin_c = 2'b00;
                endcase
                len_c = 2;
            end else if(cu_size == min_cu_size & cu_size > 8) begin
                   case (part_mode)
                    PART_2NxN: bin_c = 2'b001;
                    PART_NxN:  bin_c = 2'b000;
                    default:    bin_c = 2'b000;
                endcase
                len_c = 3;
            end else if(amp_enable == 1 & cu_size > min_cu_size)begin
                // CU > min, AMP enabled
                case (part_mode)
                    PART_2Nx2N: bin_c = 4'b1000;
                    PART_Nx2N:  bin_c = 4'b0110;
                    PART_2NxN:  bin_c = 4'b0010;
                    PART_2NxnU: bin_c = 4'b0100;
                    PART_2NxnD: bin_c = 4'b0101;
                    PART_nLx2N: bin_c = 4'b0000;
                    PART_nRx2N: bin_c = 4'b0001;
                    default:    bin_c = 0;
                endcase
                len_c = 4;
            end
        end
    end

  
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)begin
            bin_string = 0;
            bin_length = 0;
            done = 0;
        end else if(start) begin
            bin_string = bin_c;
            bin_length = len_c;
            done = 1;
       end
  end
    
endmodule



