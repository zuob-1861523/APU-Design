`timescale 1ns / 1ps
module full_adder (Sum, Co, A, B, Ci);
	output logic Sum, Co;
	input logic A, B, Ci;
	logic D, E, F, G;
	
	xor xorgate0 (D, A, B);
	xor xorgate1 (Sum, D, Ci);

	and gate0 (E, A ,B);
	and gate1 (F, A ,Ci);
	and gate2 (G, B ,Ci);
	or  outputgate (Co, E, F, G);
endmodule
