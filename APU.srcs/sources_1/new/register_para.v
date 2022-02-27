`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zhixing Jiang, Bowen Zuo
// Create Date: 2022/02/20 15:38:13
// Description: a register.
//////////////////////////////////////////////////////////////////////////////////
module register_para #(parameter WIDTH = 128) (DataOut, DataIn, WriteEn, clk, reset);	
	output logic [WIDTH-1:0] DataOut;
	input  logic clk, WriteEn, reset;
	input  logic [WIDTH-1:0] DataIn;
	logic        [WIDTH-1:0] muxOut;
	
	
	Mux2_1 #(WIDTH) mx (.in0(DataOut), .in1(DataIn), .sel(WriteEn), .out(muxOut));
	
	always_ff @ (posedge clk) begin
	   if(reset)
	       DataOut <= 0;
	   else
	       DataOut <= muxOut;
    end

endmodule 

