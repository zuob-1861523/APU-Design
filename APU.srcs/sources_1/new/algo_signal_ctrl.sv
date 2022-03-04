`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UW
// Engineer: Zhixing Jiang, Bowen Zuo
// Create Date: 2022/03/3 15:38:13
// Description: the contols of a FIFO APU
//////////////////////////////////////////////////////////////////////////////////
module algo_signal_ctrl #(parameter MAX_ADDR_WIDTH = 8,parameter OUT_ADDR_WIDTH = 8, parameter pipe_depth = 1) (
clk, reset, 
rd_EvTID_ready, topp, delay, rd_en, rd_addr, rd_EvTID_DONE, wr_en, wr_addr, wr_EvTID_DONE,  // i/o control
data_sel, top_WriteEn  // internal control
);
    input logic clk, reset;
    input logic rd_EvTID_ready;
    output logic rd_EvTID_DONE, wr_EvTID_DONE;
    input logic [9:0] topp;
    input logic delay;
    output logic rd_en, wr_en;
    output logic [OUT_ADDR_WIDTH-1:0] rd_addr, wr_addr;
    output logic data_sel, top_WriteEn;
    
    logic [7:0] mem_addr_update;
    logic [7:0] next_addr;
    logic [7:0] data_addr;
    logic rd_ready;
    logic mem_addr_reset, rd_done, rd_EvTID_done_previous, addr_sel, rd_en_to_wr;
 
    assign rd_ready = rd_EvTID_ready&~rd_EvTID_done_previous;  // rewrite rd_EvTID_ready because rd_EvTID_ready should be off in the last cycle (the new event is not updated yet)
    assign mem_addr_reset = rd_EvTID_DONE|~rd_ready|reset;  // this three signals can set rd_addr to 0
    assign rd_en = rd_ready & ~delay; 
    assign rd_en_to_wr = rd_en&~rd_EvTID_DONE;  // this signal will be delayed to become the wr_en signal, the length of wr_en is one cycle shorter than rd_en
    assign mem_addr_update = rd_addr + 1;
    assign top_WriteEn = (data_addr == 0);
    assign addr_sel = ~(delay | rd_done| rd_EvTID_done_previous | ~rd_ready);  // select the address update, 
    
    register_para #(8) Mem_addr (.DataOut(rd_addr), .DataIn(next_addr), .WriteEn(1'b1), .clk, .reset(mem_addr_reset));
    Mux2_1 #(8) mem_update (.in0(rd_addr), .in1(mem_addr_update), .sel(addr_sel), .out(next_addr)); // +1 or stay at current addr
    
    D_FF rdone (.q(rd_EvTID_DONE), .d(rd_done), .reset, .clk);
    D_FF rdone1 (.q(rd_EvTID_done_previous), .d(rd_EvTID_DONE), .reset, .clk);  // rd_EvTID_done_previous will be use to add gap in between rd_en for different event
    rdDoneTest read_done_test (.done(rd_done), .done_previous(rd_EvTID_DONE), .addr(rd_addr), .toppointer(topp), .clk, .reset);
    
    always_ff @(posedge clk) begin 
		if (reset) begin 
		    data_addr <= 0; 
            data_sel <= 0;
		end else begin
            data_addr <= rd_addr;    // the current data's addr
            data_sel <= rd_en_to_wr;
		end
	end
    
    // make a 4 cycles delay
    reg_in_series #(pipe_depth+1, OUT_ADDR_WIDTH) write_address (.q(wr_addr), .d(rd_addr), .reset, .clk);
    D_ffs #(pipe_depth+1) write_enable (.q(wr_en), .d(rd_en_to_wr), .reset, .clk);  
    D_ffs #(pipe_depth+1) write_done (.q(wr_EvTID_DONE), .d(rd_EvTID_DONE), .reset, .clk);
    
endmodule