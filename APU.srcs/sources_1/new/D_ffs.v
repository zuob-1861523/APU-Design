`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zhixing Jiang, Bowen Zuo
// Create Date: 2022/02/20 15:38:13
// Description: D_FFs in series.
//////////////////////////////////////////////////////////////////////////////////
module D_ffs #(parameter NUM = 4) (q, d, reset, clk);
	output logic q;
	input logic d, reset, clk; 
	
	logic [NUM:0] d_in;
	assign d_in[0] = d;
	
	genvar i;
	generate
		for(i = 0; i < NUM; i=i+1) begin
			D_FF regis (.q(d_in[i+1]), .d(d_in[i]), .reset(reset), .clk(clk));
		end
	endgenerate
	
	assign q = d_in[NUM];
	
endmodule 