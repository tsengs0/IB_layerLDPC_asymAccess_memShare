module qsn_merge_len3 (
	output wire [2:0] sw_out,

	input wire [1:0] left_in,
	input wire [2:0] right_in,
	input wire [1:0] sel
);

	assign sw_out[0] = (sel[0] == 1'b0) ? right_in[2] : left_in[0];
	assign sw_out[1] = (sel[1] == 1'b0) ? right_in[1] : left_in[1];
	assign sw_out[2] = right_in[0];
endmodule