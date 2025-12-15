`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2025 10:33:53 AM
// Design Name: 
// Module Name: CALR_tb
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


module CALR_tb;
    parameter int BIN_WIDTH = 16;
    parameter int VALUE_WIDTH = 16;
    
    logic                     clk,rst,start;
    logic [VALUE_WIDTH - 1:0] CALR;
    logic [3:0]               cRiceParam;
    logic [BIN_WIDTH - 1 :0]  bin_string;
    logic [BIN_WIDTH - 1:0]   bin_length;
    logic                     done;
 
 CALR#( 
    .BIN_WIDTH(BIN_WIDTH),
    .VALUE_WIDTH(VALUE_WIDTH)
  ) dut(
     .clk,
     .rst,
     .start,
     .CALR,          
     .cRiceParam,    
     .bin_string,
     .bin_length,
     .done  
   
   );
   
   always #5 clk = ~clk;
   
   initial begin
      
        clk = 0;
        rst = 0;
        start = 0;
        CALR = 0;
        cRiceParam= 0;
        
        #20;
        rst = 1;
        #20;
        
   
        for (int i = 0; i <= 77; i++) begin
           #10 start = 1;
           cRiceParam = 0;
            CALR = i;
           #30 start = 0;
            wait(done);
        end
            
         #20;
         rst = 0;
         #20;
         rst = 1;
        #20;
        #20;
        $finish;
  
   end
   
   endmodule 