module qsn_left_len3 (
	output wire [1:0] sw_out,

	input wire [2:0] sw_in,
	input wire [1:0] sel,
	input wire sys_clk,
	input wire rstn
);

	// Multiplexer Stage 1
	wire [0:0] mux_stage_1;
	assign mux_stage_1[0] = (sel[1] == 1'b1) ? sw_in[2] : sw_in[0];

	// Multiplexer Stage 0
	wire [1:0] mux_stage_0;
	assign mux_stage_0[0] = (sel[0] == 1'b1) ? sw_in[1] : mux_stage_1[0];
	assign mux_stage_0[1] = (sel[0] == 1'b1) ? sw_in[2] : sw_in[1];

	assign sw_out[1:0] = mux_stage_0[1:0];
endmodule