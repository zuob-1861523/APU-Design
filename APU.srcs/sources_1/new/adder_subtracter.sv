`timescale 1ns / 1ps
module adder_subtracter #(parameter WIDTH = 128) (Sum, last_Co, OF, A, B, s0);	
	output logic [WIDTH-1:0] Sum;
	output logic last_Co, OF;	// OF stand for overflow
	input  logic [WIDTH-1:0] A, B;
	input  logic s0;
	logic [WIDTH-1:0] Bn, muxOut, Co;
	
	genvar i, j;
	generate
		for(i = 0; i < WIDTH; i++) begin : each_invert
			not invertgate (Bn[i], B[i]);
		end
	endgenerate
	
	// edge case, adder/subtracter at position 0
	Mux2_1 #(1) m1 (.out(muxOut[0]), .in0(B[0]), .in1(Bn[0]), .sel(s0));
	full_adder f1 (.Sum(Sum[0]), .Co(Co[0]), .A(A[0]), .B(muxOut[0]), .Ci(s0));
	
	generate
		for(j = 1; j < WIDTH; j++) begin : each_adder
			Mux2_1 #(1) m (.out(muxOut[j]), .in0(B[j]), .in1(Bn[j]), .sel(s0));
			full_adder fA (.Sum(Sum[j]), .Co(Co[j]), .A(A[j]), .B(muxOut[j]), .Ci(Co[j-1]));
		end
	endgenerate
	
	xor check_OF (OF, Co[WIDTH-1], Co[WIDTH-2]);	//check overflow
	assign last_Co = Co[WIDTH-1];	// output last carry out
	
endmodule

//(in0, in1, sel, out)