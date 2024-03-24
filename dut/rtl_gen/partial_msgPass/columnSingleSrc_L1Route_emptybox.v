/**
* Created date:
* Developer: Bo-Yu Tseng
* Email: tsengs0@gmail.com
* Module name: columnSingleSrc_L1Route_emptybox

* # I/F
* 1) Output:

* 2) Input:
*
* # Param
*
* # Description
* To perform the (base matrix) column-wise 1st-level circular shifting opertion for passing CNU outgoing messages
* # Dependencies
*   1) devine.vh -> quantisatin bit with of messages
**/
`include "define.vh"
module columnSingleSrc_L1Route_emptybox #(
	parameter QUAN_SIZE = 4,
	parameter STRIDE_UNIT_SIZE = 15,
	parameter STRIDE_WIDTH = 17,
	parameter BITWIDTH_SHIFT_FACTOR = $clog2(STRIDE_UNIT_SIZE-1)
) (
	//--------------
	// Output ports
	//--------------
	// Stride unit 0
	output wire [STRIDE_UNIT_SIZE-1:0] stride0_out_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride0_out_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride0_out_bit2_o,
	// Stride unit 1
	output wire [STRIDE_UNIT_SIZE-1:0] stride1_out_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride1_out_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride1_out_bit2_o,
	// Stride unit 2
	output wire [STRIDE_UNIT_SIZE-1:0] stride2_out_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride2_out_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride2_out_bit2_o,
	// Stride unit 3
	output wire [STRIDE_UNIT_SIZE-1:0] stride3_out_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride3_out_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride3_out_bit2_o,
	// Stride unit 4
	output wire [STRIDE_UNIT_SIZE-1:0] stride4_out_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride4_out_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride4_out_bit2_o,
	// Stride unit 5
	output wire [STRIDE_UNIT_SIZE-1:0] stride5_out_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride5_out_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride5_out_bit2_o,
	// Stride unit 6
	output wire [STRIDE_UNIT_SIZE-1:0] stride6_out_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride6_out_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride6_out_bit2_o,
	// Stride unit 7
	output wire [STRIDE_UNIT_SIZE-1:0] stride7_out_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride7_out_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride7_out_bit2_o,
	// Stride unit 8
	output wire [STRIDE_UNIT_SIZE-1:0] stride8_out_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride8_out_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride8_out_bit2_o,
	// Stride unit 9
	output wire [STRIDE_UNIT_SIZE-1:0] stride9_out_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride9_out_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride9_out_bit2_o,
	// Stride unit 10
	output wire [STRIDE_UNIT_SIZE-1:0] stride10_out_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride10_out_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride10_out_bit2_o,
	// Stride unit 11
	output wire [STRIDE_UNIT_SIZE-1:0] stride11_out_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride11_out_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride11_out_bit2_o,
	// Stride unit 12
	output wire [STRIDE_UNIT_SIZE-1:0] stride12_out_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride12_out_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride12_out_bit2_o,
	// Stride unit 13
	output wire [STRIDE_UNIT_SIZE-1:0] stride13_out_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride13_out_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride13_out_bit2_o,
	// Stride unit 14
	output wire [STRIDE_UNIT_SIZE-1:0] stride14_out_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride14_out_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride14_out_bit2_o,
	// Stride unit 15
	output wire [STRIDE_UNIT_SIZE-1:0] stride15_out_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride15_out_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride15_out_bit2_o,
	// Stride unit 16
	output wire [STRIDE_UNIT_SIZE-1:0] stride16_out_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride16_out_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] stride16_out_bit2_o,
	`ifdef DECODER_4bit
		output wire [STRIDE_UNIT_SIZE-1:0] stride0_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride1_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride2_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride3_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride4_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride5_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride6_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride7_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride8_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride9_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride10_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride11_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride12_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride13_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride14_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride15_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride16_out_bit3_o,
	`endif
	//--------------
	// Input ports
	//--------------
	input wire [STRIDE_UNIT_SIZE-1:0] stride0_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride0_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride0_bit2_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride1_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride1_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride1_bit2_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride2_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride2_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride2_bit2_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride3_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride3_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride3_bit2_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride4_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride4_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride4_bit2_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride5_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride5_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride5_bit2_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride6_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride6_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride6_bit2_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride7_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride7_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride7_bit2_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride8_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride8_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride8_bit2_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride9_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride9_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride9_bit2_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride10_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride10_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride10_bit2_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride11_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride11_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride11_bit2_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride12_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride12_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride12_bit2_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride13_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride13_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride13_bit2_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride14_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride14_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride14_bit2_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride15_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride15_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride15_bit2_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride16_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride16_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride16_bit2_i,
	`ifdef DECODER_4bit
		input wire [STRIDE_UNIT_SIZE-1:0] stride0_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride1_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride2_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride3_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride4_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride5_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride6_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride7_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride8_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride9_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride10_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride11_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride12_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride13_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride14_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride15_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride16_bit3_i,
	`endif
	// selector of permutatoin input source
	input wire [BITWIDTH_SHIFT_FACTOR-1:0] shift_factor,
	input wire sys_clk,
	input wire rstn
);

// Nets as output sources from circular shifters
assign stride0_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride0_bit0_i[STRIDE_UNIT_SIZE-1:0];
assign stride0_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride0_bit1_i[STRIDE_UNIT_SIZE-1:0];
assign stride0_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride0_bit2_i[STRIDE_UNIT_SIZE-1:0];
`ifdef DECODER_4bit assign stride0_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride0_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif
assign stride1_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride1_bit0_i[STRIDE_UNIT_SIZE-1:0];
assign stride1_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride1_bit1_i[STRIDE_UNIT_SIZE-1:0];
assign stride1_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride1_bit2_i[STRIDE_UNIT_SIZE-1:0];
`ifdef DECODER_4bit assign stride1_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride1_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif
assign stride2_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride2_bit0_i[STRIDE_UNIT_SIZE-1:0];
assign stride2_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride2_bit1_i[STRIDE_UNIT_SIZE-1:0];
assign stride2_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride2_bit2_i[STRIDE_UNIT_SIZE-1:0];
`ifdef DECODER_4bit assign stride2_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride2_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif
assign stride3_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride3_bit0_i[STRIDE_UNIT_SIZE-1:0];
assign stride3_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride3_bit1_i[STRIDE_UNIT_SIZE-1:0];
assign stride3_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride3_bit2_i[STRIDE_UNIT_SIZE-1:0];
`ifdef DECODER_4bit assign stride3_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride3_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif
assign stride4_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride4_bit0_i[STRIDE_UNIT_SIZE-1:0];
assign stride4_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride4_bit1_i[STRIDE_UNIT_SIZE-1:0];
assign stride4_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride4_bit2_i[STRIDE_UNIT_SIZE-1:0];
`ifdef DECODER_4bit assign stride4_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride4_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif
assign stride5_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride5_bit0_i[STRIDE_UNIT_SIZE-1:0];
assign stride5_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride5_bit1_i[STRIDE_UNIT_SIZE-1:0];
assign stride5_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride5_bit2_i[STRIDE_UNIT_SIZE-1:0];
`ifdef DECODER_4bit assign stride5_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride5_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif
assign stride6_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride6_bit0_i[STRIDE_UNIT_SIZE-1:0];
assign stride6_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride6_bit1_i[STRIDE_UNIT_SIZE-1:0];
assign stride6_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride6_bit2_i[STRIDE_UNIT_SIZE-1:0];
`ifdef DECODER_4bit assign stride6_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride6_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif
assign stride7_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride7_bit0_i[STRIDE_UNIT_SIZE-1:0];
assign stride7_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride7_bit1_i[STRIDE_UNIT_SIZE-1:0];
assign stride7_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride7_bit2_i[STRIDE_UNIT_SIZE-1:0];
`ifdef DECODER_4bit assign stride7_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride7_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif
assign stride8_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride8_bit0_i[STRIDE_UNIT_SIZE-1:0];
assign stride8_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride8_bit1_i[STRIDE_UNIT_SIZE-1:0];
assign stride8_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride8_bit2_i[STRIDE_UNIT_SIZE-1:0];
`ifdef DECODER_4bit assign stride8_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride8_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif
assign stride9_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride9_bit0_i[STRIDE_UNIT_SIZE-1:0];
assign stride9_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride9_bit1_i[STRIDE_UNIT_SIZE-1:0];
assign stride9_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride9_bit2_i[STRIDE_UNIT_SIZE-1:0];
`ifdef DECODER_4bit assign stride9_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride9_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif
assign stride10_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride10_bit0_i[STRIDE_UNIT_SIZE-1:0];
assign stride10_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride10_bit1_i[STRIDE_UNIT_SIZE-1:0];
assign stride10_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride10_bit2_i[STRIDE_UNIT_SIZE-1:0];
`ifdef DECODER_4bit assign stride10_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride10_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif
assign stride11_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride11_bit0_i[STRIDE_UNIT_SIZE-1:0];
assign stride11_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride11_bit1_i[STRIDE_UNIT_SIZE-1:0];
assign stride11_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride11_bit2_i[STRIDE_UNIT_SIZE-1:0];
`ifdef DECODER_4bit assign stride11_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride11_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif
assign stride12_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride12_bit0_i[STRIDE_UNIT_SIZE-1:0];
assign stride12_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride12_bit1_i[STRIDE_UNIT_SIZE-1:0];
assign stride12_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride12_bit2_i[STRIDE_UNIT_SIZE-1:0];
`ifdef DECODER_4bit assign stride12_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride12_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif
assign stride13_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride13_bit0_i[STRIDE_UNIT_SIZE-1:0];
assign stride13_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride13_bit1_i[STRIDE_UNIT_SIZE-1:0];
assign stride13_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride13_bit2_i[STRIDE_UNIT_SIZE-1:0];
`ifdef DECODER_4bit assign stride13_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride13_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif
assign stride14_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride14_bit0_i[STRIDE_UNIT_SIZE-1:0];
assign stride14_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride14_bit1_i[STRIDE_UNIT_SIZE-1:0];
assign stride14_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride14_bit2_i[STRIDE_UNIT_SIZE-1:0];
`ifdef DECODER_4bit assign stride14_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride14_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif
assign stride15_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride15_bit0_i[STRIDE_UNIT_SIZE-1:0];
assign stride15_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride15_bit1_i[STRIDE_UNIT_SIZE-1:0];
assign stride15_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride15_bit2_i[STRIDE_UNIT_SIZE-1:0];
`ifdef DECODER_4bit assign stride15_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride15_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif
assign stride16_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride16_bit0_i[STRIDE_UNIT_SIZE-1:0];
assign stride16_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride16_bit1_i[STRIDE_UNIT_SIZE-1:0];
assign stride16_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride16_bit2_i[STRIDE_UNIT_SIZE-1:0];
`ifdef DECODER_4bit assign stride16_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride16_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif
endmodule