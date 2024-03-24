module qsn_right_len5 (
	output wire [4:0] sw_out,

	input wire [4:0] sw_in,
	input wire [2:0] sel
//	,
//	input wire sys_clk,
//	input wire rstn
);

	// Multiplexer Stage 2
	wire [0:0] mux_stage_2;
	assign mux_stage_2[0] = (sel[2] == 1'b1) ? sw_in[0] : sw_in[4];

	// Multiplexer Stage 1
	wire [2:0] mux_stage_1;
	assign mux_stage_1[0] = (sel[1] == 1'b1) ? sw_in[2] : mux_stage_2[0];
	assign mux_stage_1[1] = (sel[1] == 1'b1) ? sw_in[1] : sw_in[3];
	assign mux_stage_1[2] = (sel[1] == 1'b1) ? sw_in[0] : sw_in[2];

	// Multiplexer Stage 0
	wire [3:0] mux_stage_0;
	assign mux_stage_0[0] = (sel[0] == 1'b1) ? mux_stage_1[1] : mux_stage_1[0];
	assign mux_stage_0[1] = (sel[0] == 1'b1) ? mux_stage_1[2] : mux_stage_1[1];
	assign mux_stage_0[2] = (sel[0] == 1'b1) ? sw_in[1] : mux_stage_1[2];
	assign mux_stage_0[3] = (sel[0] == 1'b1) ? sw_in[0] : sw_in[1];

	assign sw_out[4:0] = {sw_in[0], mux_stage_0[3:0]};
endmodule