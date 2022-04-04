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
    
    logic [7:0] mem_addr_in, addr_update, new_addr;
    logic [7:0] addr_d1, addr_d2, addr_d3;      // addr_d1 also is the current data addr  // d1, d2, d3 means delay 1 cycle, 2 cycles, or 3 cycles
    logic [127:0] toppointer;
    logic [127:0] rd_data_out,calc_result, reg1out, reg2out, reg3out;
    logic rd_ready, rd_done, rd_EvTID_done_d1, rd_EvTID_done_d2, rd_EvTID_done_d3;  // d1, d2, d3 means delay 1 cycle, 2 cycles, or 3 cycles
    logic rd_en_to_wr_en, rd_en_to_wr_en_d1, rd_en_to_wr_en_d2, rd_en_to_wr_en_d3;  // d1, d2, d3 means delay 1 cycle, 2 cycles, or 3 cycles
    logic addr_reset, addr_sel;
    
    assign rd_ready = rd_EvTID_ready&~rd_EvTID_done_d1;  // rewrite rd_EvTID_ready because rd_EvTID_ready should be off in the last cycle (the new event is not updated yet)
    assign addr_reset = rd_EvTID_DONE|~rd_ready|reset;
    assign rd_en = rd_ready;                        // in this simple apu rd_en == rd_ready, because there is no delay slot needed during the calculation. 
    assign rd_en_to_wr_en = rd_en&~rd_EvTID_DONE;   // this signal will be delayed to become the wr_en signal, the length of wr_en is one cycle shorter than rd_en
    assign addr_update = rd_addr + 1;
    assign addr_sel = ~(rd_done| rd_EvTID_done_d1 | ~rd_ready);  // select the address update, 
    assign rd_done = (rd_addr == toppointer[7:0] & toppointer[7:0] != 0 & rd_EvTID_DONE != 1); // rd_EvTID_DONE != 1 because done can only true for 1 cycle,  toppointer[7:0] != 0 because toppointer need to have a valid data
    
    // delay the control signals from read to become write
    always_ff @(posedge clk) begin 
		if (reset) begin 
			addr_d1 <= 0;    
			addr_d2 <= 0; 
			addr_d3 <= 0;
			wr_addr <= 0;
            
			rd_en_to_wr_en_d1 <= 0;
			rd_en_to_wr_en_d2 <= 0;
			rd_en_to_wr_en_d3 <= 0;
			wr_en <= 0;
            
			rd_EvTID_DONE <= 0;
			rd_EvTID_done_d1 <= 0;
			rd_EvTID_done_d2 <= 0;
			rd_EvTID_done_d3 <= 0;
			wr_EvTID_DONE <= 0;
		end else begin
			addr_d1 <= rd_addr;
			addr_d2 <= addr_d1; 
			addr_d3 <= addr_d2;
			wr_addr <= addr_d3;
			
			rd_en_to_wr_en_d1 <= rd_en_to_wr_en;
			rd_en_to_wr_en_d2 <= rd_en_to_wr_en_d1;
			rd_en_to_wr_en_d3 <= rd_en_to_wr_en_d2;
			wr_en <= rd_en_to_wr_en_d3;
			
			rd_EvTID_DONE <= rd_done;
			rd_EvTID_done_d1 <= rd_EvTID_DONE;
			rd_EvTID_done_d2 <= rd_EvTID_done_d1;
			rd_EvTID_done_d3 <= rd_EvTID_done_d2;
			wr_EvTID_DONE <= rd_EvTID_done_d3;
		end
	end
	
	always_ff @(posedge clk) begin
		// address update
		if (addr_reset) 
			rd_addr <= 0;
		else
			rd_addr <= new_addr;
		//  toppointer update  
		if (reset) 
			toppointer <= 0;
		else if (addr_d1==0)
			toppointer <= rd_data_out;
		else
			toppointer <= toppointer;
	end
    
	always_comb begin
		// address +1 or stay the same
		if (addr_sel)
			new_addr = addr_update;
		else
			new_addr = rd_addr;
		// select receive data from memory or not
		if (rd_en_to_wr_en_d1)  // rd_en_to_wr_en_d1 can be used as a control signal here
			rd_data_out = rd_data;
		else
			rd_data_out = 0;
		// select output data
		if (wr_addr==0)
			wr_data = toppointer;
		else
			wr_data = calc_result;
	end 
    
	// algorithm starts, 3 stages pipeline
	always_ff @(posedge clk) begin
		if (reset) begin 
			reg1out <= 0;
			reg2out <= 0;
			reg3out <= 0;
		end else begin
			reg1out <= rd_data_out;
			reg2out <= reg1out;
			reg3out <= reg2out;
		end
	end
	
	assign calc_result = reg1out + reg2out + reg3out;
	// algorithm ends
endmodule



