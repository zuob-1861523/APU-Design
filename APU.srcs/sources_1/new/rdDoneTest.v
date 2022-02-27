`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zhixing Jiang, Bowen Zuo
// Create Date: 2022/02/20 15:38:13
// Description: read done test
//////////////////////////////////////////////////////////////////////////////////
module rdDoneTest(
    output logic done,
    input logic done_previous,
    input logic [7:0] addr,
    input logic [9:0] toppointer,
    input logic clk, 
    input logic reset
    );
    
    logic [7:0] top;
    assign top = toppointer[7:0];
    
    always_comb
        if (addr == top & top != 0 & done_previous != 1)  // done can only true for one cycle
			done = 1'b1;
        else 
            done = 1'b0;
            
endmodule
