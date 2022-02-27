`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zhixing Jiang, Bowen Zuo
// Create Date: 2022/02/20 15:38:13
// Description: a D_ff
//////////////////////////////////////////////////////////////////////////////////
module D_FF (q, d, reset, clk);
	output logic q;
	input logic d, reset, clk; 
	
	always_ff @(posedge clk) begin 
		if (reset) 
			q <= 0; // On reset, set to 0 
		else 
			q <= d; // Otherwise out = d
		end
endmodule 
