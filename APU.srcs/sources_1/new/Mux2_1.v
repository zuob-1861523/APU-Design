`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zhixing Jiang, Bowen Zuo
// Create Date: 2022/02/20 15:38:13
// Description: a 2_1 mux.
//////////////////////////////////////////////////////////////////////////////////
module Mux2_1 #(parameter DATA_WIDTH = 128) (in0, in1, sel, out);
    input logic sel;
    input logic [DATA_WIDTH-1:0] in0, in1;
    output logic [DATA_WIDTH-1:0] out;

    always_comb begin
        case(sel) 
            1'b0 : out = in0;
            1'b1 : out = in1;
        endcase 
    end
endmodule