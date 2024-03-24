module qsn_merge_len5 (
	output wire [4:0] sw_out,

	input wire [3:0] left_in,
	input wire [4:0] right_in,
	input wire [3:0] sel
);

	assign sw_out[0] = (sel[0] == 1'b0) ? right_in[4] : left_in[0];
	assign sw_out[1] = (sel[1] == 1'b0) ? right_in[3] : left_in[1];
	assign sw_out[2] = (sel[2] == 1'b0) ? right_in[2] : left_in[2];
	assign sw_out[3] = (sel[3] == 1'b0) ? right_in[1] : left_in[3];
	assign sw_out[4] = right_in[0];
endmodule