module qsn_top_len3 (
	output reg [2:0] sw_out_bit0,
	output reg [2:0] sw_out_bit1,
	output reg [2:0] sw_out_bit2,
	output reg [2:0] sw_out_bit3,

	input wire sys_clk,
	input wire rstn,
	input wire [2:0] sw_in_bit0,
	input wire [2:0] sw_in_bit1,
	input wire [2:0] sw_in_bit2,
	input wire [2:0] sw_in_bit3,
	input wire [1:0] left_sel,
	input wire [1:0] right_sel,
	input wire [1:0] merge_sel
);

	wire [2:0] sw_in_reg[0:3];
	wire [2:0] sw_out_reg[0:3];
	reg [1:0] merge_sel_reg0;
	always @(posedge sys_clk) begin if(!rstn) merge_sel_reg0 <= 0; else merge_sel_reg0 <= merge_sel; end

	genvar i;
	generate
		for(i=0;i<4;i=i+1) begin : bs_bitwidth_inst
		// Instantiation of Left Shift Network
		wire [1:0] left_sw_out;
		qsn_left_len3 qsn_left_len3_u0 (
			.sw_out (left_sw_out[1:0]),

			.sys_clk (sys_clk),
			.rstn (rstn),
			.sw_in (sw_in_reg[i]),
			.sel (left_sel[1:0])
		);
		// Instantiation of Right Shift Network
		wire [3:0] right_sw_out;
		qsn_right_len3 qsn_right_len3_u0 (
			.sw_out (right_sw_out[2:0]),

			.sys_clk (sys_clk),
			.rstn (rstn),
			.sw_in (sw_in_reg[i]),
			.sel (right_sel[1:0])
		);
		// Instantiation of Merge Network
		qsn_merge_len3 qsn_merge_len3_u0 (
			.sw_out (sw_out_reg[i]),

			.left_in (left_sw_out[1:0]),
			.right_in (right_sw_out[2:0]),
			.sel (merge_sel_reg0[1:0])
		);
		end
	endgenerate

	assign sw_in_reg[0] = sw_in_bit0[2:0];
	assign sw_in_reg[1] = sw_in_bit1[2:0];
	assign sw_in_reg[2] = sw_in_bit2[2:0];
	assign sw_in_reg[3] = sw_in_bit3[2:0];
	always @(posedge sys_clk) begin if(!rstn) sw_out_bit0[2:0] <= 0; else sw_out_bit0[2:0] <= sw_out_reg[0]; end
	always @(posedge sys_clk) begin if(!rstn) sw_out_bit1[2:0] <= 0; else sw_out_bit1[2:0] <= sw_out_reg[1]; end
	always @(posedge sys_clk) begin if(!rstn) sw_out_bit2[2:0] <= 0; else sw_out_bit2[2:0] <= sw_out_reg[2]; end
	always @(posedge sys_clk) begin if(!rstn) sw_out_bit3[2:0] <= 0; else sw_out_bit3[2:0] <= sw_out_reg[3]; end
endmodule