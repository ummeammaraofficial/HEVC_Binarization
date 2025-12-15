`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2025 11:58:40 AM
// Design Name: 
// Module Name: QP_delta
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


module QP_delta#(
    parameter int BIN_WIDTH = 16,
    parameter int VALUE_WIDTH = 16,
    parameter int K = 0,
    parameter int cMax = 5
    
    )(
    input  logic                       clk,start,rst,
    input  logic [VALUE_WIDTH - 1: 0]  Cu_qp_delta_abs,
    output logic                       done,
    output logic [BIN_WIDTH - 1:0]     bin_string,
    output logic [BIN_WIDTH - 1:0]     bin_length
    
    );
    
    logic [VALUE_WIDTH - 1: 0]     suffix_value;
    logic [VALUE_WIDTH - 1: 0]     prefix_value;
    logic [BIN_WIDTH - 1:0]        suffix_bins;
    logic [BIN_WIDTH - 1:0]        prefix_bins;
    logic [BIN_WIDTH - 1:0]        suffix_len;
    logic [BIN_WIDTH - 1:0]        prefix_len;
    logic                          suff_done;
    logic                          pref_done;
    logic                          suffix_need;
    logic                          suffix_start;
    logic                          done_reg;
    logic                          prefix_completed;
    logic                          suff_need_prev;
    
    assign prefix_value  = (Cu_qp_delta_abs < 5)? Cu_qp_delta_abs : 5;
    assign suffix_value  = Cu_qp_delta_abs - cMax;
    assign suffix_need   = (prefix_value >= 4);
    
   
      KTR_Binary_Code #(
        .BIN_WIDTH(BIN_WIDTH),
        .VALUE_WIDTH(VALUE_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst),
        .start_i(start),
        .N_i(prefix_value),
        .bin_o(prefix_bins),
        .done_o(pref_done),
        .bin_length_o(prefix_len),
        .K(K),
        .cMax(cMax)
    );
        
     always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            suff_need_prev <= 1'b0;
        end else if (start) begin
            suff_need_prev <= 1'b0;  
        end else begin
            suff_need_prev <= suffix_need;
        end
    end
   
    assign suffix_start = (suffix_need == 1 && suff_need_prev == 0) ? 1'b1 : 1'b0;
    
        always_ff @(posedge clk or negedge rst) begin
            if (!rst) begin
                prefix_completed <= 1'b0;
            end else if (start) begin
                prefix_completed <= 1'b0;
            end else if (pref_done ==1) begin
                prefix_completed <= 1'b1;
                end
              
      end
      
      // Instantiate DUT
    Kth_order_EGK #(
        .SYMBOL_BITS(VALUE_WIDTH),
        .MAX_BITS(BIN_WIDTH)
    ) uut (
        .clk(clk),
        .rst_n(rst),
        .start(start),
        .K(K),
        .symbolVal(suffix_value),
        .done(suff_done),
        .code(suffix_bins),
        .code_len(suffix_len)
    ); 
    
    
       always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        done_reg <= 1'b0;
    end else if (start) begin
        done_reg <= 1'b0;  
    end else begin

        if ((suffix_need && prefix_completed && suff_done) || 
            (!suffix_need && pref_done)) begin
            done_reg <= 1'b1;
        end
    end 
end

    always_comb begin
     if(suffix_need == 1) begin
         bin_string = suffix_bins | (prefix_bins << suffix_len);
         bin_length = prefix_len + suffix_len;
   end else  if(suffix_need == 0) begin
         bin_string =  prefix_bins ;
         bin_length = prefix_len;
  end
  end
  
  assign done = done_reg;

endmodule