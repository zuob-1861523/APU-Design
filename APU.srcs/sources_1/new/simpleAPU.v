`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UW
// Engineer: Zhixing Jiang, Bowen Zuo
// Create Date: 2022/02/20 15:38:13
// Module Name: simpleAPU
// Project Name: simpleAPU
// Target Devices: VCU118
// Description: a simple APU testing i/o interface.
//////////////////////////////////////////////////////////////////////////////////
module simpleAPU(
    // up stream i/o
    output logic rd_en,
    output logic [7:0] rd_addr,
    input logic [127:0] rd_data,
    // event id i/o
    input logic rd_EvTID_ready,
    output logic rd_EvTID_DONE,
    output logic wr_EvTID_DONE,
    // down stream i/o
    output logic wr_en,
    output logic [7:0] wr_addr,
    output logic [127:0] wr_data,
    
    input logic clk,
    input logic reset
    );

    logic [127:0] toppointer_out;
    logic [127:0] rd_data_out,calc_result, reg1out, reg2out, reg3out;
    logic delay;
    logic data_sel, top_WriteEn;
 
    assign delay = 0;
        
    algo_signal_ctrl #(8, 8, 3) 
ctrol_sigs (.clk, .reset, .rd_EvTID_ready, .topp(toppointer_out[9:0]),
    .delay, .rd_en, .rd_addr, .rd_EvTID_DONE, .wr_en, .wr_addr, .wr_EvTID_DONE,
 .data_sel, .top_WriteEn
); 
    
    register_para #(128) toppointer (.DataOut(toppointer_out), .DataIn(rd_data_out), .WriteEn(top_WriteEn), .clk, .reset);
      
    Mux2_1 #(128) data_input (.in0(0), .in1(rd_data), .sel(data_sel), .out(rd_data_out));  // select receive data from memory or not
    
    // Algrithm start
    register_para #(128) register1 (.DataOut(reg1out), .DataIn(rd_data_out), .WriteEn(~delay), .clk(clk), .reset(reset));
    register_para #(128) register2 (.DataOut(reg2out), .DataIn(reg1out), .WriteEn(1'b1), .clk(clk), .reset(reset));
    register_para #(128) register3 (.DataOut(reg3out), .DataIn(reg2out), .WriteEn(1'b1), .clk(clk), .reset(reset));
    calculation calc (.data3(reg3out), .data2(reg2out), .data1(reg1out), .result(calc_result));
    // algorithm end
    
    Mux2_1 #(128) data_out (.in0(calc_result), .in1(toppointer_out), .sel(top_WriteEn), .out(wr_data));  // select the sum or data from addr0
    
endmodule



