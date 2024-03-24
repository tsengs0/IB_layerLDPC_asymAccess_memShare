module lowend_partial_msgPass_wrapper #(
	parameter QUAN_SIZE = 3,
	parameter ROW_SPLIT_FACTOR = 5, // Ns=	parameter CHECK_PARALLELISM = 51,
	parameter STRIDE_UNIT_SIZE = 51,
	parameter STRIDE_WIDTH = 5,
	parameter LAYER_NUM = 3,
	// Parameters of extrinsic RAMs
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b,
	parameter MEM_DEVICE_NUM = 28,
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 12,
	parameter ADDR_WIDTH = $clog2(DEPTH),
	// Parameter of page alignment
	parameter MAX_MEMSHARE_INSTANCES = 3
) (
/*====== Stride unit 0 =================================================== */
	// The memory Dout port to variable/check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2node_stride0_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2node_stride0_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2node_stride0_bit2_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2rowOffset_stride0_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2rowOffset_stride0_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2rowOffset_stride0_bit2_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mux2ctrl_stride0_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mux2ctrl_stride0_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mux2ctrl_stride0_bit2_o,
	// The varible/check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride0_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride0_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride0_bit2_i,
	// The 2nd variable extrinsic messages as row address of the sebsequent IB-LUT 
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride0_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride0_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride0_bit2_i,
	// The channel message input
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride0_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride0_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride0_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] shift2node_stride0_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride0_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride0_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride0_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride0_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride0_bit3_i,
`endif
/*====== Stride unit 1 =================================================== */
	// The memory Dout port to variable/check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2node_stride1_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2node_stride1_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2node_stride1_bit2_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2rowOffset_stride1_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2rowOffset_stride1_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2rowOffset_stride1_bit2_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mux2ctrl_stride1_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mux2ctrl_stride1_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mux2ctrl_stride1_bit2_o,
	// The varible/check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride1_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride1_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride1_bit2_i,
	// The 2nd variable extrinsic messages as row address of the sebsequent IB-LUT 
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride1_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride1_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride1_bit2_i,
	// The channel message input
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride1_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride1_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride1_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] shift2node_stride1_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride1_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride1_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride1_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride1_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride1_bit3_i,
`endif
/*====== Stride unit 2 =================================================== */
	// The memory Dout port to variable/check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2node_stride2_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2node_stride2_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2node_stride2_bit2_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2rowOffset_stride2_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2rowOffset_stride2_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2rowOffset_stride2_bit2_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mux2ctrl_stride2_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mux2ctrl_stride2_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mux2ctrl_stride2_bit2_o,
	// The varible/check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride2_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride2_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride2_bit2_i,
	// The 2nd variable extrinsic messages as row address of the sebsequent IB-LUT 
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride2_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride2_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride2_bit2_i,
	// The channel message input
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride2_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride2_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride2_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] shift2node_stride2_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride2_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride2_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride2_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride2_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride2_bit3_i,
`endif
/*====== Stride unit 3 =================================================== */
	// The memory Dout port to variable/check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2node_stride3_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2node_stride3_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2node_stride3_bit2_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2rowOffset_stride3_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2rowOffset_stride3_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2rowOffset_stride3_bit2_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mux2ctrl_stride3_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mux2ctrl_stride3_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mux2ctrl_stride3_bit2_o,
	// The varible/check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride3_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride3_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride3_bit2_i,
	// The 2nd variable extrinsic messages as row address of the sebsequent IB-LUT 
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride3_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride3_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride3_bit2_i,
	// The channel message input
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride3_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride3_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride3_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] shift2node_stride3_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride3_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride3_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride3_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride3_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride3_bit3_i,
`endif
/*====== Stride unit 4 =================================================== */
	// The memory Dout port to variable/check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2node_stride4_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2node_stride4_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2node_stride4_bit2_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2rowOffset_stride4_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2rowOffset_stride4_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  shift2rowOffset_stride4_bit2_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mux2ctrl_stride4_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mux2ctrl_stride4_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mux2ctrl_stride4_bit2_o,
	// The varible/check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride4_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride4_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride4_bit2_i,
	// The 2nd variable extrinsic messages as row address of the sebsequent IB-LUT 
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride4_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride4_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride4_bit2_i,
	// The channel message input
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride4_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride4_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride4_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] shift2node_stride4_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride4_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride4_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2shift_stride4_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  mem2mux_stride4_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  chRAM2mux_stride4_bit3_i,
`endif
//----------------------------------------------------------------------//
	// The following nets for level-2 message passing are reused across all strides*/
	// The level-1 message passing
	input wire mux2shiftCtrl_sel_i, //! input source selector for subsequent input source of "shift control encoder"
	input wire [STRIDE_WIDTH-1:0] L1_nodeBsShift_factor_bit0_i,
	input wire [STRIDE_WIDTH-1:0] L1_nodeBsShift_factor_bit1_i,
	input wire [STRIDE_WIDTH-1:0] L1_nodeBsShift_factor_bit2_i,
	input wire [STRIDE_WIDTH-1:0] L1_nodeBsShift_factor_bit3_i,
	input wire [STRIDE_WIDTH-1:0] L1_nodeBsShift_factor_bit4_i,
	input wire [STRIDE_WIDTH-1:0] L1_nodeBsShift_factor_bit5_i,
	// The level-1 page alignment (circular shifter) for aligning variable/check node incoming messages
	input wire [STRIDE_UNIT_SIZE-1:0] L2_nodePaShift_factor_bit0_i, // shifter factor[bit_0]
	input wire [STRIDE_UNIT_SIZE-1:0] L2_nodePaShift_factor_bit1_i, // shifter factor[bit_1]
	input wire [STRIDE_UNIT_SIZE-1:0] L2_nodePaShift_factor_bit2_i, // shifter factor[bit_2]
	// The level-2 page alignment (bus combiner) for aligning variable/check node incoming messages
	input wire [STRIDE_UNIT_SIZE-1:0] L2_nodePaLoad_factor_bit0_i, // shifter factor[bit_0]
	input wire [STRIDE_UNIT_SIZE-1:0] L2_nodePaLoad_factor_bit1_i, // shifter factor[bit_1]
	input wire [STRIDE_UNIT_SIZE-1:0] L2_nodePaLoad_factor_bit2_i, // shifter factor[bit_2]
	input wire [STRIDE_UNIT_SIZE-1:0] L2_nodePaLoad_factor_bit3_i, // shifter factor[bit_3]
	input wire [STRIDE_UNIT_SIZE-1:0] L2_nodePaLoad_factor_bit4_i, // shifter factor[bit_4]
	// Layer status control
	input wire isMsgPass_i, //! Current L2PA usage is for V2C/C2V permutation
//----------------------------------------------------------------------//
	input wire [ADDR_WIDTH-1:0] cnu_sync_addr_i,
	input wire [ADDR_WIDTH-1:0] vnu_sync_addr_i,
	input wire [LAYER_NUM-1:0] cnu_layer_status_i,
	input wire [LAYER_NUM-1:0] vnu_layer_status_i,
	input wire [ROW_SPLIT_FACTOR-1:0] cnu_sub_row_status_i,
	input wire [ROW_SPLIT_FACTOR-1:0] vnu_sub_row_status_i,
	input wire [1:0] last_row_chunk_i, // [0]: check, [1]: variable
	input wire [1:0] we, // [0]: check, [1]: variable
	input wire sys_clk,
	input wire rstn
);

//-----------------------------------------------------------------------------//
// Message passing for check node messages
//-----------------------------------------------------------------------------//
//--------------------------
// Net and reg declarations
//--------------------------
// Stride group 0 - 4
localparam L1BS_SHIFT_CTRL_WIDTH = $clog2(STRIDE_UNIT_SIZE);
wire [L1BS_SHIFT_CTRL_WIDTH-1:0] L1_nodeBsShift_factor_stride [0:STRIDE_WIDTH-1];
assign L1_nodeBsShift_factor_stride[0] = {L1_nodeBsShift_factor_bit5_i[0], L1_nodeBsShift_factor_bit4_i[0], L1_nodeBsShift_factor_bit3_i[0], L1_nodeBsShift_factor_bit2_i[0],L1_nodeBsShift_factor_bit1_i[0],L1_nodeBsShift_factor_bit0_i[0]};
assign L1_nodeBsShift_factor_stride[1] = {L1_nodeBsShift_factor_bit5_i[1], L1_nodeBsShift_factor_bit4_i[1], L1_nodeBsShift_factor_bit3_i[1], L1_nodeBsShift_factor_bit2_i[1],L1_nodeBsShift_factor_bit1_i[1],L1_nodeBsShift_factor_bit0_i[1]};
assign L1_nodeBsShift_factor_stride[2] = {L1_nodeBsShift_factor_bit5_i[2], L1_nodeBsShift_factor_bit4_i[2], L1_nodeBsShift_factor_bit3_i[2], L1_nodeBsShift_factor_bit2_i[2],L1_nodeBsShift_factor_bit1_i[2],L1_nodeBsShift_factor_bit0_i[2]};
assign L1_nodeBsShift_factor_stride[3] = {L1_nodeBsShift_factor_bit5_i[3], L1_nodeBsShift_factor_bit4_i[3], L1_nodeBsShift_factor_bit3_i[3], L1_nodeBsShift_factor_bit2_i[3],L1_nodeBsShift_factor_bit1_i[3],L1_nodeBsShift_factor_bit0_i[3]};
assign L1_nodeBsShift_factor_stride[4] = {L1_nodeBsShift_factor_bit5_i[4], L1_nodeBsShift_factor_bit4_i[4], L1_nodeBsShift_factor_bit3_i[4], L1_nodeBsShift_factor_bit2_i[4],L1_nodeBsShift_factor_bit1_i[4],L1_nodeBsShift_factor_bit0_i[4]};
// s2n: shift-to-node
wire [STRIDE_UNIT_SIZE-1:0] l1bsOut_Stride0_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 0
wire [STRIDE_UNIT_SIZE-1:0] l1bsOut_Stride1_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 1
wire [STRIDE_UNIT_SIZE-1:0] l1bsOut_Stride2_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 2
wire [STRIDE_UNIT_SIZE-1:0] l1bsOut_Stride3_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 3
wire [STRIDE_UNIT_SIZE-1:0] l1bsOut_Stride4_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 4

columnSingleSrc_L1Route #(
	.QUAN_SIZE(QUAN_SIZE),
	.STRIDE_UNIT_SIZE(STRIDE_UNIT_SIZE),
	.STRIDE_WIDTH(STRIDE_WIDTH),
	.BITWIDTH_SHIFT_FACTOR($clog2(STRIDE_UNIT_SIZE-1))
) L1BS (
	.stride0_out_bit0_o (l1bsOut_Stride0_bit[0]), // to CNUs of stride unit 0
	.stride0_out_bit1_o (l1bsOut_Stride0_bit[1]), // to CNUs of stride unit 0
	.stride0_out_bit2_o (l1bsOut_Stride0_bit[2]), // to CNUs of stride unit 0
	.stride1_out_bit0_o (l1bsOut_Stride1_bit[0]), // to CNUs of stride unit 1
	.stride1_out_bit1_o (l1bsOut_Stride1_bit[1]), // to CNUs of stride unit 1
	.stride1_out_bit2_o (l1bsOut_Stride1_bit[2]), // to CNUs of stride unit 1
	.stride2_out_bit0_o (l1bsOut_Stride2_bit[0]), // to CNUs of stride unit 2
	.stride2_out_bit1_o (l1bsOut_Stride2_bit[1]), // to CNUs of stride unit 2
	.stride2_out_bit2_o (l1bsOut_Stride2_bit[2]), // to CNUs of stride unit 2
	.stride3_out_bit0_o (l1bsOut_Stride3_bit[0]), // to CNUs of stride unit 3
	.stride3_out_bit1_o (l1bsOut_Stride3_bit[1]), // to CNUs of stride unit 3
	.stride3_out_bit2_o (l1bsOut_Stride3_bit[2]), // to CNUs of stride unit 3
	.stride4_out_bit0_o (l1bsOut_Stride4_bit[0]), // to CNUs of stride unit 4
	.stride4_out_bit1_o (l1bsOut_Stride4_bit[1]), // to CNUs of stride unit 4
	.stride4_out_bit2_o (l1bsOut_Stride4_bit[2]), // to CNUs of stride unit 4
	`ifdef DECODER_4bit
		.stride0_out_bit3_o (l1bsOut_Stride0_bit[3]),
		.stride1_out_bit3_o (l1bsOut_Stride1_bit[3]),
		.stride2_out_bit3_o (l1bsOut_Stride2_bit[3]),
		.stride3_out_bit3_o (l1bsOut_Stride3_bit[3]),
		.stride4_out_bit3_o (l1bsOut_Stride4_bit[3]),
	`endif

	.stride0_bit0_i (mem2shift_stride0_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 0
	.stride0_bit1_i (mem2shift_stride0_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 0
	.stride0_bit2_i (mem2shift_stride0_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 0
	.stride1_bit0_i (mem2shift_stride1_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 1
	.stride1_bit1_i (mem2shift_stride1_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 1
	.stride1_bit2_i (mem2shift_stride1_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 1
	.stride2_bit0_i (mem2shift_stride2_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 2
	.stride2_bit1_i (mem2shift_stride2_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 2
	.stride2_bit2_i (mem2shift_stride2_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 2
	.stride3_bit0_i (mem2shift_stride3_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 3
	.stride3_bit1_i (mem2shift_stride3_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 3
	.stride3_bit2_i (mem2shift_stride3_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 3
	.stride4_bit0_i (mem2shift_stride4_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 4
	.stride4_bit1_i (mem2shift_stride4_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 4
	.stride4_bit2_i (mem2shift_stride4_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 4
	`ifdef DECODER_4bit
		.stride0_bit3_i (mem2shift_stride0_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride1_bit3_i (mem2shift_stride1_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride2_bit3_i (mem2shift_stride2_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride3_bit3_i (mem2shift_stride3_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride4_bit3_i (mem2shift_stride4_bit3_i[STRIDE_UNIT_SIZE-1:0]),
	`endif
	.stride0_shift_factor_i (L1_nodeBsShift_factor_stride[0]),
	.stride1_shift_factor_i (L1_nodeBsShift_factor_stride[1]),
	.stride2_shift_factor_i (L1_nodeBsShift_factor_stride[2]),
	.stride3_shift_factor_i (L1_nodeBsShift_factor_stride[3]),
	.stride4_shift_factor_i (L1_nodeBsShift_factor_stride[4]),
	.sys_clk             (sys_clk),
	.rstn                (rstn)
);
//------------------------------------------------------------------------------
// Glue logic of multiplexing between two input sources to barrel shifters
//------------------------------------------------------------------------------
// Stride group 0
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride0_shiftCtrlMUX_bit0 (.sw_out(mux2ctrl_stride0_bit0_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride0_bit0_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride0_bit0_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride0_shiftCtrlMUX_bit1 (.sw_out(mux2ctrl_stride0_bit1_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride0_bit1_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride0_bit1_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride0_shiftCtrlMUX_bit2 (.sw_out(mux2ctrl_stride0_bit2_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride0_bit2_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride0_bit2_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
// Stride group 1
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride1_shiftCtrlMUX_bit0 (.sw_out(mux2ctrl_stride1_bit0_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride1_bit0_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride1_bit0_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride1_shiftCtrlMUX_bit1 (.sw_out(mux2ctrl_stride1_bit1_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride1_bit1_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride1_bit1_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride1_shiftCtrlMUX_bit2 (.sw_out(mux2ctrl_stride1_bit2_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride1_bit2_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride1_bit2_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
// Stride group 2
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride2_shiftCtrlMUX_bit0 (.sw_out(mux2ctrl_stride2_bit0_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride2_bit0_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride2_bit0_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride2_shiftCtrlMUX_bit1 (.sw_out(mux2ctrl_stride2_bit1_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride2_bit1_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride2_bit1_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride2_shiftCtrlMUX_bit2 (.sw_out(mux2ctrl_stride2_bit2_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride2_bit2_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride2_bit2_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
// Stride group 3
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride3_shiftCtrlMUX_bit0 (.sw_out(mux2ctrl_stride3_bit0_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride3_bit0_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride3_bit0_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride3_shiftCtrlMUX_bit1 (.sw_out(mux2ctrl_stride3_bit1_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride3_bit1_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride3_bit1_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride3_shiftCtrlMUX_bit2 (.sw_out(mux2ctrl_stride3_bit2_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride3_bit2_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride3_bit2_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
// Stride group 4
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride4_shiftCtrlMUX_bit0 (.sw_out(mux2ctrl_stride4_bit0_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride4_bit0_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride4_bit0_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride4_shiftCtrlMUX_bit1 (.sw_out(mux2ctrl_stride4_bit1_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride4_bit1_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride4_bit1_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride4_shiftCtrlMUX_bit2 (.sw_out(mux2ctrl_stride4_bit2_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride4_bit2_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride4_bit2_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
`ifdef DECODER_4bit
	scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride0_shiftCtrlMUX_bit3 (.sw_out(mux2ctrl_stride0_bit3_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride0_bit3_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride0_bit3_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
	scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride1_shiftCtrlMUX_bit3 (.sw_out(mux2ctrl_stride1_bit3_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride1_bit3_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride1_bit3_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
	scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride2_shiftCtrlMUX_bit3 (.sw_out(mux2ctrl_stride2_bit3_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride2_bit3_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride2_bit3_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
	scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride3_shiftCtrlMUX_bit3 (.sw_out(mux2ctrl_stride3_bit3_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride3_bit3_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride3_bit3_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
	scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) stride4_shiftCtrlMUX_bit3 (.sw_out(mux2ctrl_stride4_bit3_o[STRIDE_UNIT_SIZE-1:0]),.sw_in_0(chRAM2mux_stride4_bit3_i[STRIDE_UNIT_SIZE-1:0]),.sw_in_1(mem2mux_stride4_bit3_i[STRIDE_UNIT_SIZE-1:0]), .in_src(mux2shiftCtrl_sel_i));
`endif
//--------------------------------------------------------------------------
generate
	genvar strideUnit_id;
	for(strideUnit_id=0; strideUnit_id<STRIDE_UNIT_SIZE; strideUnit_id=strideUnit_id+1) begin : columnVNU_L2Route_inst
		msgPass2pageAlignIF #(
			.SHIFT_LENGTH        (STRIDE_WIDTH       ),
			.QUAN_SIZE           (QUAN_SIZE          ),
			.L2PA_ENABLE         (1                  ),
			MAX_MEMSHARE_INSTANCES (MAX_MEMSHARE_INSTANCES)
		) L1L2PA (
			.msgPass2paOut_bit0_o ({shift2node_stride4_bit0_o[strideUnit_id], shift2node_stride3_bit0_o[strideUnit_id], shift2node_stride2_bit0_o[strideUnit_id], shift2node_stride1_bit0_o[strideUnit_id], shift2node_stride0_bit0_o[strideUnit_id]}),
			.msgPass2paOut_bit1_o ({shift2node_stride4_bit1_o[strideUnit_id], shift2node_stride3_bit1_o[strideUnit_id], shift2node_stride2_bit1_o[strideUnit_id], shift2node_stride1_bit1_o[strideUnit_id], shift2node_stride0_bit1_o[strideUnit_id]}),
			.msgPass2paOut_bit2_o ({shift2node_stride4_bit2_o[strideUnit_id], shift2node_stride3_bit2_o[strideUnit_id], shift2node_stride2_bit2_o[strideUnit_id], shift2node_stride1_bit2_o[strideUnit_id], shift2node_stride0_bit2_o[strideUnit_id]}),

			.swIn_bit0_i      ({l1bsOut_Stride4_bit[0][strideUnit_id], l1bsOut_Stride3_bit[0][strideUnit_id], l1bsOut_Stride2_bit[0][strideUnit_id], l1bsOut_Stride1_bit[0][strideUnit_id], l1bsOut_Stride0_bit[0][strideUnit_id]}),
			.swIn_bit1_i      ({l1bsOut_Stride4_bit[1][strideUnit_id], l1bsOut_Stride3_bit[1][strideUnit_id], l1bsOut_Stride2_bit[1][strideUnit_id], l1bsOut_Stride1_bit[1][strideUnit_id], l1bsOut_Stride0_bit[1][strideUnit_id]}),
			.swIn_bit2_i      ({l1bsOut_Stride4_bit[2][strideUnit_id], l1bsOut_Stride3_bit[2][strideUnit_id], l1bsOut_Stride2_bit[2][strideUnit_id], l1bsOut_Stride1_bit[2][strideUnit_id], l1bsOut_Stride0_bit[2][strideUnit_id]}),

		`ifdef DECODER_4bit
			.msgPass2paOut_bit3_o ({shift2node_stride4_bit3_o[strideUnit_id], shift2node_stride3_bit3_o[strideUnit_id], shift2node_stride2_bit3_o[strideUnit_id], shift2node_stride1_bit3_o[strideUnit_id], shift2node_stride0_bit3_o[strideUnit_id]}),
			.swIn_bit3_i      ({l1bsOut_Stride4_bit[3][strideUnit_id], l1bsOut_Stride3_bit[3][strideUnit_id], l1bsOut_Stride2_bit[3][strideUnit_id], l1bsOut_Stride1_bit[3][strideUnit_id], l1bsOut_Stride0_bit[3][strideUnit_id]}),
		`endif
			.L1_paShift_factor_i ({L2_nodePaShift_factor_bit2_i[strideUnit_id], L2_nodePaShift_factor_bit1_i[strideUnit_id], L2_nodePaShift_factor_bit0_i[strideUnit_id]}),
			.L2_paLoad_factor_i  ({L2_nodePaLoad_factor_bit4_i[strideUnit_id], L2_nodePaLoad_factor_bit3_i[strideUnit_id], L2_nodePaLoad_factor_bit2_i[strideUnit_id], L2_nodePaLoad_factor_bit1_i[strideUnit_id], L2_nodePaLoad_factor_bit0_i[strideUnit_id]}),
			.isMsgPass_i (isMsgPass_i),
			.sys_clk                   (sys_clk),
			.rstn                      (rstn)
		);

		msgPass2pageAlignIF #(
			.SHIFT_LENGTH        (STRIDE_WIDTH       ),
			.QUAN_SIZE           (QUAN_SIZE          ),
			.L2PA_ENABLE         (0                  )
		) L1L2PA_rowAddrOffset (
			.msgPass2paOut_bit0_o ({shift2rowOffset_stride4_bit0_o[strideUnit_id], shift2rowOffset_stride3_bit0_o[strideUnit_id], shift2rowOffset_stride2_bit0_o[strideUnit_id], shift2rowOffset_stride1_bit0_o[strideUnit_id] ,shift2rowOffset_stride0_bit0_o[strideUnit_id]}),
			.msgPass2paOut_bit1_o ({shift2rowOffset_stride4_bit1_o[strideUnit_id], shift2rowOffset_stride3_bit1_o[strideUnit_id], shift2rowOffset_stride2_bit1_o[strideUnit_id], shift2rowOffset_stride1_bit1_o[strideUnit_id] ,shift2rowOffset_stride0_bit1_o[strideUnit_id]}),
			.msgPass2paOut_bit2_o ({shift2rowOffset_stride4_bit2_o[strideUnit_id], shift2rowOffset_stride3_bit2_o[strideUnit_id], shift2rowOffset_stride2_bit2_o[strideUnit_id], shift2rowOffset_stride1_bit2_o[strideUnit_id] ,shift2rowOffset_stride0_bit2_o[strideUnit_id]}),

			.swIn_bit0_i ({mux2ctrl_stride4_bit0_o[strideUnit_id], mux2ctrl_stride3_bit0_o[strideUnit_id], mux2ctrl_stride2_bit0_o[strideUnit_id], mux2ctrl_stride1_bit0_o[strideUnit_id], mux2ctrl_stride0_bit0_o[strideUnit_id]}),
			.swIn_bit1_i ({mux2ctrl_stride4_bit1_o[strideUnit_id], mux2ctrl_stride3_bit1_o[strideUnit_id], mux2ctrl_stride2_bit1_o[strideUnit_id], mux2ctrl_stride1_bit1_o[strideUnit_id], mux2ctrl_stride0_bit1_o[strideUnit_id]}),
			.swIn_bit2_i ({mux2ctrl_stride4_bit2_o[strideUnit_id], mux2ctrl_stride3_bit2_o[strideUnit_id], mux2ctrl_stride2_bit2_o[strideUnit_id], mux2ctrl_stride1_bit2_o[strideUnit_id], mux2ctrl_stride0_bit2_o[strideUnit_id]}),
		`ifdef DECODER_4bit
			.msgPass2paOut_bit3_o ({shift2rowOffset_stride4_bit3_o[strideUnit_id], shift2rowOffset_stride3_bit3_o[strideUnit_id], shift2rowOffset_stride2_bit3_o[strideUnit_id], shift2rowOffset_stride1_bit3_o[strideUnit_id] ,shift2rowOffset_stride0_bit3_o[strideUnit_id]}),
			.swIn_bit3_i ({mux2ctrl_stride4_bit3_o[strideUnit_id], mux2ctrl_stride3_bit3_o[strideUnit_id], mux2ctrl_stride2_bit3_o[strideUnit_id], mux2ctrl_stride1_bit3_o[strideUnit_id], mux2ctrl_stride0_bit3_o[strideUnit_id]}),
		`endif
			.L1_paShift_factor_i ({L2_nodePaShift_factor_bit2_i[strideUnit_id], L2_nodePaShift_factor_bit1_i[strideUnit_id], L2_nodePaShift_factor_bit0_i[strideUnit_id]}),
			.L2_paLoad_factor_i  ({L2_nodePaLoad_factor_bit4_i[strideUnit_id], L2_nodePaLoad_factor_bit3_i[strideUnit_id], L2_nodePaLoad_factor_bit2_i[strideUnit_id], L2_nodePaLoad_factor_bit1_i[strideUnit_id], L2_nodePaLoad_factor_bit0_i[strideUnit_id]}),
			.isMsgPass_i (isMsgPass_i),
			.sys_clk                   (sys_clk),
			.rstn                      (rstn)
		);
	end
endgenerate
endmodule