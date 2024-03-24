module qsn_merge_len17 (
	output wire [16:0] sw_out,

	input wire [15:0] left_in,
	input wire [16:0] right_in,
	input wire [15:0] sel
);

	assign sw_out[0] = (sel[0] == 1'b0) ? right_in[16] : left_in[0];
	assign sw_out[1] = (sel[1] == 1'b0) ? right_in[15] : left_in[1];
	assign sw_out[2] = (sel[2] == 1'b0) ? right_in[14] : left_in[2];
	assign sw_out[3] = (sel[3] == 1'b0) ? right_in[13] : left_in[3];
	assign sw_out[4] = (sel[4] == 1'b0) ? right_in[12] : left_in[4];
	assign sw_out[5] = (sel[5] == 1'b0) ? right_in[11] : left_in[5];
	assign sw_out[6] = (sel[6] == 1'b0) ? right_in[10] : left_in[6];
	assign sw_out[7] = (sel[7] == 1'b0) ? right_in[9] : left_in[7];
	assign sw_out[8] = (sel[8] == 1'b0) ? right_in[8] : left_in[8];
	assign sw_out[9] = (sel[9] == 1'b0) ? right_in[7] : left_in[9];
	assign sw_out[10] = (sel[10] == 1'b0) ? right_in[6] : left_in[10];
	assign sw_out[11] = (sel[11] == 1'b0) ? right_in[5] : left_in[11];
	assign sw_out[12] = (sel[12] == 1'b0) ? right_in[4] : left_in[12];
	assign sw_out[13] = (sel[13] == 1'b0) ? right_in[3] : left_in[13];
	assign sw_out[14] = (sel[14] == 1'b0) ? right_in[2] : left_in[14];
	assign sw_out[15] = (sel[15] == 1'b0) ? right_in[1] : left_in[15];
	assign sw_out[16] = right_in[0];
endmodule