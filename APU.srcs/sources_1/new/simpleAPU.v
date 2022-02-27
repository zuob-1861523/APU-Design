`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
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

    logic [7:0] mem_addr_in;
    logic [7:0] mem_addr_update;
    logic [7:0] mux_addr_out;
    logic [7:0] rd_addr_privous1, rd_addr_privous2, rd_addr_privous3;
    logic [9:0] toppointer_out;
    logic [127:0] rd_data_out,calc_result, reg1out, reg2out, reg3out;
    logic delay, notdelay;
    logic isAddr0, mem_addr_reset, rd_done, rd_EvTID_done_previous, mem_addr_sel, rd_en_to_wr, data_mux_sel;
 
    assign delay = 0;
    assign mem_addr_reset = rd_EvTID_DONE|~rd_EvTID_ready|reset;
    assign rd_en = rd_EvTID_ready&~rd_EvTID_done_previous;
    assign rd_en_to_wr = rd_en&~rd_EvTID_DONE;
    //
    assign notdelay = ~delay;
    assign mem_addr_update = rd_addr + 1;
    
    D_FF rdone (.q(rd_EvTID_DONE), .d(rd_done), .reset, .clk);
    D_FF rdone1 (.q(rd_EvTID_done_previous), .d(rd_EvTID_DONE), .reset, .clk);  // rd_EvTID_done_previous will be use to add gap in between rd_en for different event
    
    register_para #(8) Mem_addr (.DataOut(rd_addr), .DataIn(mux_addr_out), .WriteEn(1'b1), .clk(clk), .reset(mem_addr_reset));
    
    Mux2_1 #(8) mem_update (.in0(rd_addr), .in1(mem_addr_update), .sel(mem_addr_sel), .out(mux_addr_out)); // +1 or stay the same
    
    rdDoneTest read_done_test (.done(rd_done), .done_previous(rd_EvTID_DONE), .addr(rd_addr), .toppointer(toppointer_out), .clk(clk), .reset(reset));

    assign mem_addr_sel = ~(delay | rd_done| rd_EvTID_done_previous | ~rd_EvTID_ready);  // select the address update, 
    
    Mux2_1 #(128) data_input (.in0(0), .in1(rd_data), .sel(data_mux_sel), .out(rd_data_out));  // select receive data from memory or not
    
    register_para #(128) register1 (.DataOut(reg1out), .DataIn(rd_data_out), .WriteEn(notdelay), .clk(clk), .reset(reset));
    register_para #(128) register2 (.DataOut(reg2out), .DataIn(reg1out), .WriteEn(1'b1), .clk(clk), .reset(reset));
    register_para #(128) register3 (.DataOut(reg3out), .DataIn(reg2out), .WriteEn(1'b1), .clk(clk), .reset(reset));
    calculation calc (.data3(reg3out), .data2(reg2out), .data1(reg1out), .result(calc_result));
    
    Mux2_1 #(128) data_out (.in0(calc_result), .in1(reg3out), .sel(wr_addr==0), .out(wr_data));  // select the sum or data from addr0
    
    register_para #(10) toppointer (.DataOut(toppointer_out), .DataIn(rd_data_out[9:0]), .WriteEn(rd_addr_privous1==0), .clk(clk), .reset(reset));
    
    always_ff @(posedge clk) begin 
		if (reset) begin 
		    rd_addr_privous1 <= 0;    // the current data addr
            rd_addr_privous2 <= 0; 
            rd_addr_privous3 <= 0;
            data_mux_sel <= 0;
		end else begin
            rd_addr_privous1 <= rd_addr;    // the current data addr
            rd_addr_privous2 <= rd_addr_privous1; 
            rd_addr_privous3 <= rd_addr_privous2;
            wr_addr <= rd_addr_privous3;
            data_mux_sel <= rd_en_to_wr;
		end
	end
    
    // make a 4 cycles delay
    D_ffs write_enable (.q(wr_en), .d(rd_en_to_wr), .reset(reset), .clk(clk));  
    D_ffs write_done (.q(wr_EvTID_DONE), .d(rd_EvTID_DONE), .reset(reset), .clk(clk));
    
    
endmodule



