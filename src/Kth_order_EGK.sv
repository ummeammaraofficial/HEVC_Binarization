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
    parameter N = 8,     
    parameter bins_width = 16     
)(
    input  logic                        clk,
    input  logic                        rst_n,
    input  logic                        start,
    input  logic [3:0]                  K,
    input  logic [N-1:0]                N_i,
    output logic                        done,
    output logic [bins_width-1:0]       bin_string,
    output logic [bins_width - 1:0]     bin_len
);

    localparam K_INT_BITS =  ($clog2(N) > 0) ? $clog2(N) : 1;

     typedef enum logic [1:0] {
        IDLE     = 2'b00,
        PREFIX   = 2'b01,
        SUFFIX   = 2'b10,
        FINISH   = 2'b11
    } state_t;
    
    state_t                      state, next_state;
    logic [N-1:0]                absV;                    
    logic [K_INT_BITS-1:0]       k;                    
    logic [K_INT_BITS-1:0]       bit_cnt;
    logic [bins_width-1:0]       shift_reg;       
    logic [bins_width-1:0]       length_reg;
    logic                        sign_bit;


        // Absolute value
    assign sign_bit = N_i[N-1];
    
    // FSM sequential logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end
    
    // FSM combinational logic
    always_comb begin
        next_state = state;
        
        case (state)
            IDLE: begin
                if (start) next_state = PREFIX;
            end
            
            PREFIX: begin
                if (absV < (N'(1) << k_reg[K_INT_BITS-1:0])) 
                    next_state = SUFFIX;
            end
            
            SUFFIX: begin
                if (bit_cnt == 0) 
                    next_state = FINISH;
            end
            
            FINISH: begin
                next_state = IDLE;
            end
            
            default: next_state = IDLE;
        endcase
    end
    
    // Datapath
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            absV        <= '0;
            k_reg       <= '0;
            bit_cnt     <= '0;
            shift_reg   <= '0;
            length_reg  <= '0;
            done        <= 1'b0;
        end else begin
            done <= 1'b0;  
            
            case (state)
                IDLE: begin
                    if (start) begin
                        absV <= sign_bit ? (~N_i + 1'b1) : N_i;
                        k_reg <= {1'b0, K[K_INT_BITS-1:0]};
                        shift_reg <= '0;
                        length_reg <= '0;
                        done <= 1'b0;
                    end
                end
                
                PREFIX: begin
                    if (absV >= (N'(1) << k_reg[K_INT_BITS-1:0])) begin
                        // Output '1', subtract, increment k
                        shift_reg <= (shift_reg << 1) | 1'b1;
                        absV <= absV - (N'(1) << k_reg[K_INT_BITS-1:0]);
                        k_reg <= k_reg + 1'b1;
                        length_reg <= length_reg + 1'b1;
                    end else begin
                        // Output '0', move to suffix
                        shift_reg <= (shift_reg << 1);
                        bit_cnt <= k_reg[K_INT_BITS-1:0];
                        length_reg <= length_reg + 1'b1;
                    end
                end
                
                SUFFIX: begin
                    if (bit_cnt > 0) begin
                        shift_reg <= (shift_reg << 1) | absV[bit_cnt-1];
                        length_reg <= length_reg + 1'b1;
                        bit_cnt <= bit_cnt - 1'b1;
                    end
                end
                
                FINISH: begin
                    done <= 1'b1;
                end
                
                default: ;
            endcase
        end
    end

    assign bin_string = shift_reg;
    assign bin_len    = done_o;

endmodule
