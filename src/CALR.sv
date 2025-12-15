`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2025 11:52:39 AM
// Design Name: 
// Module Name: CALR
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


module CALR#(                         
    parameter int BIN_WIDTH = 16,
    parameter int VALUE_WIDTH = 16
)(
    input logic clk,rst,start,
    input logic [VALUE_WIDTH - 1:0] CALR,
    input logic [3:0] cRiceParam,
    output logic [BIN_WIDTH - 1 :0] bin_string,
    output logic [BIN_WIDTH - 1:0] bin_length,
    output logic done
);

    logic [BIN_WIDTH - 1:0] prefix_val;
    logic [BIN_WIDTH - 1:0] prefix_bins;
    logic [BIN_WIDTH - 1:0] suffix_val;
    logic [BIN_WIDTH - 1:0] suffix_bins;
    logic [BIN_WIDTH - 1:0] cMax;
    logic [BIN_WIDTH - 1:0] prefix_len;
    logic [BIN_WIDTH - 1:0] suffix_len;
    logic                   pref_done;
    logic                   suff_done;
     logic                  suff_need;
    logic suffix_start;
    logic done_reg;
    logic prefix_completed;
   
   
   always_comb begin
         cMax = 4 << cRiceParam;
         prefix_val = (cMax < CALR) ? cMax : CALR; 

     end

   
    KTR_Binary_Code #(
        .BIN_WIDTH(BIN_WIDTH),
        .VALUE_WIDTH(VALUE_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst),
        .start_i(start),
        .N_i(prefix_val),
        .bin_o(prefix_bins),
        .done_o(pref_done),
        .bin_length_o(prefix_len),
        .K(cRiceParam),
        .cMax(cMax)
    );
 
       // wire [BIN_WIDTH - 1:0] mask = prefix_bins & (prefix_bins >> 1) & (prefix_bins >> 2) & (prefix_bins >> 3);
        assign suffix_val = CALR - cMax;
        assign suff_need = (prefix_len >= 4) && 
                   (prefix_bins[prefix_len-1 -: 4] == 4'b1111);
        // Register to detect rising edge of suff_need
        logic suff_need_prev;
        
     always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            suff_need_prev <= 1'b0;
        end else if (start) begin
            suff_need_prev <= 1'b0;  // Reset on new start
        end else begin
            suff_need_prev <= suff_need;
        end
    end
        
        // Generate single-cycle pulse when suff_need becomes 1
        assign suffix_start = (suff_need == 1 && suff_need_prev == 0) ? 1'b1 : 1'b0;
        
        always_ff @(posedge clk or negedge rst) begin
            if (!rst) begin
                prefix_completed <= 1'b0;
            end else if (start) begin
                prefix_completed <= 1'b0;  // Reset on new start
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
        .start(suffix_start),
        .K(cRiceParam+1),
        .symbolVal(suffix_val),
        .done(suff_done),
        .code(suffix_bins),
        .code_len(suffix_len)
    );
     always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        done_reg <= 1'b0;
    end else if (start) begin
        done_reg <= 1'b0;  // Reset on new start
    end else begin
        // Single condition - set done when calculation completes
        if ((suff_need && prefix_completed && suff_done) || 
            (!suff_need && pref_done)) begin
            done_reg <= 1'b1;
        end
    end 
end

    always_comb begin
     if(suff_need == 1) begin
         bin_string = suffix_bins | (prefix_bins << suffix_len);
         bin_length = prefix_len + suffix_len;
   end else  if(suff_need == 0) begin
         bin_string =  prefix_bins ;
         bin_length = prefix_len;
  end
  end
  
  
  assign done = done_reg;


endmodule