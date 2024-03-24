module qsn_top_len51 (
	output reg [50:0] sw_out_bit0,
	output reg [50:0] sw_out_bit1,
	output reg [50:0] sw_out_bit2,

	input wire sys_clk,
	input wire rstn,
	input wire [50:0] sw_in_bit0,
	input wire [50:0] sw_in_bit1,
	input wire [50:0] sw_in_bit2,
	input wire [5:0] left_sel,
	input wire [5:0] right_sel,
	input wire [49:0] merge_sel
);

	wire [50:0] sw_in_reg[0:2];
	wire [50:0] sw_out_reg[0:2];
	reg [49:0] merge_sel_reg0;
	always @(posedge sys_clk) begin if(!rstn) merge_sel_reg0 <= 0; else merge_sel_reg0 <= merge_sel; end

	genvar i;
	generate
		for(i=0;i<3;i=i+1) begin : bs_bitwidth_inst
		// Instantiation of Left Shift Network
		wire [49:0] left_sw_out;
		qsn_left_len51 qsn_left_len51_u0 (
			.sw_out (left_sw_out[49:0]),

			.sys_clk (sys_clk),
			.rstn (rstn),
			.sw_in (sw_in_reg[i]),
			.sel (left_sel[5:0])
		);
		// Instantiation of Right Shift Network
		wire [51:0] right_sw_out;
		qsn_right_len51 qsn_right_len51_u0 (
			.sw_out (right_sw_out[50:0]),

			.sys_clk (sys_clk),
			.rstn (rstn),
			.sw_in (sw_in_reg[i]),
			.sel (right_sel[5:0])
		);
		// Instantiation of Merge Network
		qsn_merge_len51 qsn_merge_len51_u0 (
			.sw_out (sw_out_reg[i]),

			.left_in (left_sw_out[49:0]),
			.right_in (right_sw_out[50:0]),
			.sel (merge_sel_reg0[49:0])
		);
		end
	endgenerate

	assign sw_in_reg[0] = sw_in_bit0[50:0];
	assign sw_in_reg[1] = sw_in_bit1[50:0];
	assign sw_in_reg[2] = sw_in_bit2[50:0];
	always @(posedge sys_clk) begin if(!rstn) sw_out_bit0[50:0] <= 0; else sw_out_bit0[50:0] <= sw_out_reg[0]; end
	always @(posedge sys_clk) begin if(!rstn) sw_out_bit1[50:0] <= 0; else sw_out_bit1[50:0] <= sw_out_reg[1]; end
	always @(posedge sys_clk) begin if(!rstn) sw_out_bit2[50:0] <= 0; else sw_out_bit2[50:0] <= sw_out_reg[2]; end
endmodule