`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zhixing Jiang, Bowen Zuo
// Create Date: 2022/02/20 15:38:13
// Description: registers in series to make delays
//////////////////////////////////////////////////////////////////////////////////
module reg_in_series #(parameter NUM = 4, parameter WIDTH = 8) (q, d, reset, clk);
	output logic [WIDTH-1:0] q;
	input logic [WIDTH-1:0] d;
	input logic reset, clk; 
	
	logic [NUM:0] [WIDTH-1:0] d_in;
	assign d_in[0] = d;
	
	genvar i;
	generate
		for(i = 0; i < NUM; i=i+1) begin
		    register_para #(8) regA (.DataOut(d_in[i+1]), .DataIn(d_in[i]), .WriteEn(1'b1), .clk, .reset);	
		end
	endgenerate
	
	assign q = d_in[NUM];
	
endmodule 