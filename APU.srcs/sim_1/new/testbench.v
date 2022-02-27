`timescale 1ns / 1ps

module testbench();

    parameter ClockDelay = 50;
    
	// up stream i/o
    logic rd_en;
    logic [7:0] rd_addr;
    logic [127:0] rd_data;
    // event id i/o
    logic rd_EvTID_ready;
    logic rd_EvTID_DONE;
    logic wr_EvTID_DONE;
    // down stream i/o
    logic wr_en;
    logic [7:0] wr_addr;
    logic [127:0] wr_data;
    
    logic clk;
    logic reset;

	simpleAPU dut (
	.rd_en,.rd_addr,.rd_data,
	.rd_EvTID_ready,.rd_EvTID_DONE,.wr_EvTID_DONE,
	.wr_en,.wr_addr,.wr_data,
	.clk,.reset);

	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
    
    initial begin
		reset <=1; rd_data <= 'x; rd_EvTID_ready <= 0; repeat(3) @(posedge clk);
		reset <=0; rd_data <= 'x; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 5; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 1; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 2; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 3; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 4; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 5; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 'x; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 'x; rd_EvTID_ready <= 0; @(posedge clk);
		reset <=0; rd_data <= 5; rd_EvTID_ready <= 0; @(posedge clk);
		reset <=0; rd_data <= 1; rd_EvTID_ready <= 0; @(posedge clk);
		reset <=0; rd_data <= 2; rd_EvTID_ready <= 0; @(posedge clk);
		reset <=0; rd_data <= 3; rd_EvTID_ready <= 0; @(posedge clk);
		reset <=0; rd_data <= 4; rd_EvTID_ready <= 0; @(posedge clk);
		reset <=0; rd_data <= 5; rd_EvTID_ready <= 0; @(posedge clk);
		reset <=0; rd_data <= 'x; rd_EvTID_ready <= 0; @(posedge clk);
		reset <=0; rd_data <= 'x; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 5; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 1; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 2; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 3; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 4; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 5; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 'x; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 'x; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 7; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 1; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 2; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 3; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 4; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 5; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 6; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 7; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 'x; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data <= 'x; rd_EvTID_ready <= 0; @(posedge clk);
		reset <=0; rd_data <= 'x; rd_EvTID_ready <= 0; @(posedge clk);
		reset <=0; rd_data <= 'x; rd_EvTID_ready <= 0; repeat(3) @(posedge clk);
		$stop;
	end
    

endmodule
