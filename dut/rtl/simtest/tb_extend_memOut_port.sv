
`timescale 1ns/1ps

module tb_extend_memOut_port (); /* this is automatically generated */

	// clock
	logic clk;
	initial begin
		clk = '0;
		forever #(0.5) clk = ~clk;
	end

	// synchronous reset
	logic srstb;
	initial begin
		srstb <= '0;
		repeat(10)@(posedge clk);
		srstb <= '1;
	end

	// (*NOTE*) replace reset, clock, others

	parameter    REAL_PORT_NUM = 1;
	parameter VIRTUAL_PORT_NUM = 2;
	parameter  UNIT_PORT_WIDTH = 4;

	logic [(UNIT_PORT_WIDTH*VIRTUAL_PORT_NUM)-1:0] extend_port_o;
	logic    [(REAL_PORT_NUM*UNIT_PORT_WIDTH)-1:0] real_port_i;
	logic                                          sys_clk;
	logic                                          rstn;

	extend_memOut_port #(
			.REAL_PORT_NUM(REAL_PORT_NUM),
			.VIRTUAL_PORT_NUM(VIRTUAL_PORT_NUM),
			.UNIT_PORT_WIDTH(UNIT_PORT_WIDTH)
		) inst_extend_memOut_port (
			.extend_port_o (extend_port_o),
			.real_port_i   (real_port_i),
			.sys_clk       (sys_clk),
			.rstn          (rstn)
		);

	task init();
		real_port_i <= '0;
		sys_clk     <= '0;
		rstn        <= '0;
	endtask

	task drive(int iter);
		for(int it = 0; it < iter; it++) begin
			real_port_i <= '0;
			sys_clk     <= '0;
			rstn        <= '0;
			@(posedge clk);
		end
	endtask

	initial begin
		// do something

		init();
		repeat(10)@(posedge clk);

		drive(20);

		repeat(10)@(posedge clk);
		$finish;
	end

	// dump wave
	initial begin
		$display("random seed : %0d", $unsigned($get_initial_random_seed()));
		if ( $test$plusargs("fsdb") ) begin
			$fsdbDumpfile("tb_extend_memOut_port.fsdb");
			$fsdbDumpvars(0, "tb_extend_memOut_port", "+mda", "+functions");
		end
	end

endmodule
