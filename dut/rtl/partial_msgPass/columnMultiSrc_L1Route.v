/**
* Created date: 16 October, 2022
* Developer: Bo-Yu Tseng
* Email: tsengs0@gmail.com
* Module name: columnVNU_L1Route

* # I/F
* 1) Output:

* 2) Input:
* 
* # Param
* 
* # Description
* To perform the (base matrix) column-wise 1st-level circular shifting opertion for passing VNU outgoing messages or channel messages
* # Dependencies
* 	1) devine.vh -> quantisatin bit with of messages
**/
`include "define.vh"

module columnMultiSrc_L1Route #(
	parameter QUAN_SIZE = 4,
	parameter STRIDE_UNIT_SIZE = 15,
	parameter STRIDE_WIDTH = 3,
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
	`ifdef DECODER_4bit
		output wire [STRIDE_UNIT_SIZE-1:0] stride0_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride1_out_bit3_o,
		output wire [STRIDE_UNIT_SIZE-1:0] stride2_out_bit3_o,
	`endif
	
	//--------------
	// Input ports
	//--------------
	// Stride unit 0
	// From channel messages
	input wire [STRIDE_UNIT_SIZE-1:0] stride0_in0_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride0_in0_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride0_in0_bit2_i,
	// From VNUs
	input wire [STRIDE_UNIT_SIZE-1:0] stride0_in1_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride0_in1_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride0_in1_bit2_i,

	// Stride unit 1
	// From channel messages
	input wire [STRIDE_UNIT_SIZE-1:0] stride1_in0_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride1_in0_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride1_in0_bit2_i,
	// From VNUs
	input wire [STRIDE_UNIT_SIZE-1:0] stride1_in1_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride1_in1_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride1_in1_bit2_i,

	// Stride unit 2
	// From channel messages
	input wire [STRIDE_UNIT_SIZE-1:0] stride2_in0_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride2_in0_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride2_in0_bit2_i,
	// From VNUs
	input wire [STRIDE_UNIT_SIZE-1:0] stride2_in1_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride2_in1_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] stride2_in1_bit2_i,
	`ifdef DECODER_4bit
		input wire [STRIDE_UNIT_SIZE-1:0] stride0_in0_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride0_in1_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride1_in0_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride1_in1_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride2_in0_bit3_i,
		input wire [STRIDE_UNIT_SIZE-1:0] stride2_in1_bit3_i,
	`endif

	// selector of permutatoin input source
	input wire [BITWIDTH_SHIFT_FACTOR-1:0] shift_factor,
	input wire sw_in_src,
	input wire sys_clk,
	input wire rstn
);

localparam LEFT_SEL_WIDTH = $clog2(STRIDE_UNIT_SIZE);
localparam RIGHT_SEL_WIDTH = $clog2(STRIDE_UNIT_SIZE);

//--------------------------
// Net and reg declarations
//--------------------------
wire [STRIDE_UNIT_SIZE-1:0] shared_sw_in_bit [0:STRIDE_WIDTH-1][0:QUAN_SIZE-1];
wire [STRIDE_UNIT_SIZE-1:0] sw_out_bit [0:STRIDE_WIDTH-1][0:QUAN_SIZE-1];

genvar stride_unit_id;
generate 
	for(stride_unit_id=0; stride_unit_id<STRIDE_WIDTH; stride_unit_id=stride_unit_id+1) begin : strideBs_group_inst
		wire [LEFT_SEL_WIDTH-1:0]  left_sel;
		wire [RIGHT_SEL_WIDTH-1:0]  right_sel;
		wire [STRIDE_UNIT_SIZE-2:0] merge_sel;
		qsn_top_len15 vnu_qsn_top_len15_u0 (
			.sw_out_bit0 (sw_out_bit[stride_unit_id][0]),
			.sw_out_bit1 (sw_out_bit[stride_unit_id][1]),	
			.sw_out_bit2 (sw_out_bit[stride_unit_id][2]),
		`ifdef DECODER_4bit	
			.sw_out_bit3 (sw_out_bit[stride_unit_id][3]),
		`endif

			.sys_clk     (sys_clk),
			.rstn		 (rstn),

			.sw_in_bit0  (shared_sw_in_bit[stride_unit_id][0]),
			.sw_in_bit1  (shared_sw_in_bit[stride_unit_id][1]),
			.sw_in_bit2  (shared_sw_in_bit[stride_unit_id][2]),
			`ifdef DECODER_4bit
				.sw_in_bit3  (shared_sw_in_bit[stride_unit_id][3]),
			`endif

			.left_sel    (left_sel),
			.right_sel   (right_sel),
			.merge_sel   (merge_sel)
		);
		
		qsn_controller_len15 #(
			.PERMUTATION_LENGTH(STRIDE_UNIT_SIZE)
		) vnu_qsn_controller_len15_u0 (
			.left_sel     (left_sel ),
			.right_sel    (right_sel),
			.merge_sel    (merge_sel),
			.shift_factor (shift_factor) // offset shift factor of submatrix_1
			//.rstn         (rstn),
			//.sys_clk      (sys_clk)
		);
	end
endgenerate

// Stride unit 0
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) strideUnit0_shared_sw_in_u0 (.sw_out(shared_sw_in_bit[/*strideUnit_0*/0][0]), .sw_in_0(stride0_in0_bit0_i[`STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride0_in1_bit0_i[`STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) strideUnit0_shared_sw_in_u1 (.sw_out(shared_sw_in_bit[/*strideUnit_0*/0][1]), .sw_in_0(stride0_in0_bit1_i[`STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride0_in1_bit1_i[`STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) strideUnit0_shared_sw_in_u2 (.sw_out(shared_sw_in_bit[/*strideUnit_0*/0][2]), .sw_in_0(stride0_in0_bit2_i[`STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride0_in1_bit2_i[`STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
`ifdef DECODER_4bit
	scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) strideUnit0_shared_sw_in_u3 (.sw_out(shared_sw_in_bit[/*strideUnit_0*/0][3]), .sw_in_0(stride0_in0_bit3_i[`STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride0_in1_bit3_i[`STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
`endif
assign stride0_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_0*/0][0];
assign stride0_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_0*/0][1];
assign stride0_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_0*/0][2];
`ifdef DECODER_4bit
	assign stride0_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_0*/0][3];
`endif
// Stride unit 1
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) strideUnit1_shared_sw_in_u0 (.sw_out(shared_sw_in_bit[/*strideUnit_1*/1][0]), .sw_in_0(stride1_in0_bit0_i[`STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride1_in1_bit0_i[`STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) strideUnit1_shared_sw_in_u1 (.sw_out(shared_sw_in_bit[/*strideUnit_1*/1][1]), .sw_in_0(stride1_in0_bit1_i[`STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride1_in1_bit1_i[`STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) strideUnit1_shared_sw_in_u2 (.sw_out(shared_sw_in_bit[/*strideUnit_1*/1][2]), .sw_in_0(stride1_in0_bit2_i[`STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride1_in1_bit2_i[`STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
`ifdef DECODER_4bit
	scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) strideUnit1_shared_sw_in_u3 (.sw_out(shared_sw_in_bit[/*strideUnit_1*/1][3]), .sw_in_0(stride1_in0_bit3_i[`STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride1_in1_bit3_i[`STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
`endif
assign stride1_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_1*/1][0];
assign stride1_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_1*/1][1];
assign stride1_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_1*/1][2];
`ifdef DECODER_4bit
	assign stride1_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_1*/1][3];
`endif
// Stride unit 2
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) strideUnit2_shared_sw_in_u0 (.sw_out(shared_sw_in_bit[/*strideUnit_2*/2][0]), .sw_in_0(stride2_in0_bit0_i[`STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride2_in1_bit0_i[`STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) strideUnit2_shared_sw_in_u1 (.sw_out(shared_sw_in_bit[/*strideUnit_2*/2][1]), .sw_in_0(stride2_in0_bit1_i[`STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride2_in1_bit1_i[`STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) strideUnit2_shared_sw_in_u2 (.sw_out(shared_sw_in_bit[/*strideUnit_2*/2][2]), .sw_in_0(stride2_in0_bit2_i[`STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride2_in1_bit2_i[`STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
`ifdef DECODER_4bit
	scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) strideUnit2_shared_sw_in_u3 (.sw_out(shared_sw_in_bit[/*strideUnit_2*/2][3]), .sw_in_0(stride2_in0_bit3_i[`STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride2_in1_bit3_i[`STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));
`endif
assign stride2_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_2*/2][0];
assign stride2_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_2*/2][1];
assign stride2_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_2*/2][2];
`ifdef DECODER_4bit
assign stride2_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_2*/2][3];
`endif
endmodule
