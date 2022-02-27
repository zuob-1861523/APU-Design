`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zhixing Jiang, Bowen Zuo
// Create Date: 2022/02/20 15:38:13
//////////////////////////////////////////////////////////////////////////////////
module calculation(
    output logic [127:0] result,
    input logic [127:0] data3,
    input logic [127:0] data2,
    input logic [127:0] data1
    );
    
//    logic [127:0] sum_of_12;
//    logic a, b, c, d;
    
//   adder_subtracter AS1 (.Sum(sum_of_12), .last_Co(a), .OF(b), .A(data1), .B(data2), .s0(1'b0));
//   adder_subtracter AS2 (.Sum(result), .last_Co(c), .OF(d), .A(sum_of_12), .B(data3), .s0(1'b0));

    assign result = data1+data2+data3;
   
endmodule
