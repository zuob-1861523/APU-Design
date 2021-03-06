`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UW
// Engineer: Ethan, Bowen
// 
// Create Date: 2022/03/22 17:00:23
// Design Name: IFO_adaptor
// Module Name: FIFO_rd_adaptor

// Target Devices: VCU118

// Additional Comments: convert signal from bram to fifo
// 
//////////////////////////////////////////////////////////////////////////////////
module FIFO_rd_adaptor(
    // up stream i/o
    output logic rd_en,
    output logic [7:0] rd_addr,
    input logic [127:0] rd_data,
    
    // event id i/o
    input logic rd_EvTID_ready,
    output logic rd_EvTID_DONE,
    
    // down stream i/o
    input logic FIFO_rd_en,
    output logic [127:0] FIFO_data,
    output logic empty,
    
    input logic clk,
    input logic reset
    );
    
    logic ready, rd_done_d1, FIFO_rd_en_d1;
    logic [127:0] top;
    
    assign ready = rd_EvTID_ready&~rd_EvTID_DONE&~rd_done_d1; // modify the rd_EvTID_ready signial, that after rd_done, ready turn off for 1 cycle.
    assign empty = ~ready;
    enum {not_ready, read1, read2, read3} ps, ns;   //FSM,  read1: save top, read2:normal read state, read3: sent rd_done

    always_comb begin
        case (ps)
            not_ready:  if(ready&FIFO_rd_en)   	ns = read1;
                        else                  	ns = not_ready;
            read1:      ns = read2;
            read2:      if(FIFO_rd_en&(top[7:0]==rd_addr))  	ns = read3;     
                        else           				ns = read2;
            read3:      ns = not_ready;
        endcase
        
        if (FIFO_rd_en_d1)  FIFO_data = rd_data;
        else                FIFO_data = 'x;
        if (ps==not_ready)  rd_en = FIFO_rd_en;
        else                rd_en = 1; 
        if (ps==read3)  rd_EvTID_DONE = 1;
        else            rd_EvTID_DONE = 0;
    end
    
    always_ff @(posedge clk) begin
        if(reset) begin
            ps <= not_ready;
            rd_done_d1 <= 0;
            FIFO_rd_en_d1 <= 0;
        end else begin
            ps <= ns;
            rd_done_d1 <= rd_EvTID_DONE;
            FIFO_rd_en_d1 <= FIFO_rd_en;
        end
            
        if(ps == read1)     top <= rd_data;
        else                top <= top;

        if((ns==read1)|(ns==read2)&FIFO_rd_en)          rd_addr <= rd_addr+1;
        else if ((ns==read3)|(ns==read2)&~FIFO_rd_en)   rd_addr <= rd_addr;
        else                                            rd_addr <= 0;
    end
    
    // assertions
    always_comb begin
        if (ps==read3) assert (rd_en == 1);
        if (rd_done_d1==1) assert (rd_en == 0);
        if (rd_en==0) assert ((rd_data == 0)|(rd_data == 'x));
        if ((ps==read1)|(ps==read2)) assert ( top[7:0] > rd_addr);
    end
    
endmodule

