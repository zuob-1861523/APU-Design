`timescale 1ns / 1ps

module testbench();

    parameter ClockDelay = 50;
    
    // up stream i/o
    logic rd_en1;
    logic [7:0] rd_addr1;
    logic [127:0] rd_data1;
    
    logic rd_en2;
    logic [7:0] rd_addr2;
    logic [127:0] rd_data2;
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


    simpleAPU dut (.rd_en1,.rd_addr1,.rd_data1,.rd_en2,.rd_addr2,.rd_data2,
                    .rd_EvTID_ready,.rd_EvTID_DONE,.wr_EvTID_DONE,.wr_en,.wr_addr,.wr_data,
                    .clk,.reset
                    );

	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
    
    initial begin
		reset <=1; rd_data1 <= 'x; rd_data2 <= 'x; rd_EvTID_ready <= 0; repeat(3) @(posedge clk);
		reset <=0; rd_data1 <= 'x; rd_data2 <= 'x; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data1 <= 5; rd_data2 <= 5; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data1 <= 128'd311982733492; rd_data2 <= 10; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data1 <= 128'd12;           rd_data2 <= 128'd534534536; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data1 <= 128'd19123113823733492; rd_data2 <= 100; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data1 <= 128'd232; rd_data2 <= 128'd1023423342; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data1 <= 128'd978273492; rd_data2 <= 128'd3823733492; rd_EvTID_ready <= 1; @(posedge clk);
        reset <=0; rd_data1 <= 'x; rd_data2 <= 'x; rd_EvTID_ready <= 1; @(posedge clk);
        reset <=0; rd_data1 <= 'x; rd_data2 <= 'x; rd_EvTID_ready <= 1; @(posedge clk);
        reset <=0; rd_data1 <= 5; rd_data2 <= 5; rd_EvTID_ready <= 1; @(posedge clk);
        reset <=0; rd_data1 <= 1; rd_data2 <= 128'd97896867198273492; rd_EvTID_ready <= 1; @(posedge clk);
        reset <=0; rd_data1 <= 2; rd_data2 <= 10; rd_EvTID_ready <= 1; @(posedge clk);
        reset <=0; rd_data1 <= 3; rd_data2 <= 128'd234236867198273492; rd_EvTID_ready <= 1; @(posedge clk);
        reset <=0; rd_data1 <= 128'd999867198273492; rd_data2 <= 10; rd_EvTID_ready <= 1; @(posedge clk);
        reset <=0; rd_data1 <= 5; rd_data2 <= 128'd2342596867198273492; rd_EvTID_ready <= 1; @(posedge clk);
        reset <=0; rd_data1 <= 'x; rd_data2 <= 'x; rd_EvTID_ready <= 1; @(posedge clk);
		reset <=0; rd_data1 <= 'x; rd_data2 <= 'x; rd_EvTID_ready <= 0; repeat(15) @(posedge clk);
		$stop;
	end
    

endmodule
