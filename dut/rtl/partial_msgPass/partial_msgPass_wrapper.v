`include "define.vh"

//`define MSGPASS_SOL_1
`define MSGPASS_SOL_3

`ifdef MSGPASS_SOL_1
/**
* Created date: 16 October, 2022
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: partial_msgPass_wrapper
* 
* # I/F
* 1) Output:
* 2) Input:
* 
* # Param
* 
* # Description
* 
* # Dependencies
* 	1) devine.vh -> quantisatin bit with of messages
**/
module partial_msgPass_wrapper #(
	parameter QUAN_SIZE = 4,
	parameter ROW_SPLIT_FACTOR = 5, // Ns=5
	parameter CHECK_PARALLELISM = 15,
	parameter STRIDE_UNIT_SIZE = 15,
	parameter STRIDE_WIDTH = 3,
	parameter PAGE_ALIGN_SEL_WIDTH = 2,
	parameter LAYER_NUM = 3,
	// Level-2 message passing, i.e. page alignment
	parameter L1_PA_MUX_SEL_WIDTH = 2,
	// Parameters of extrinsic RAMs
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b, 
	parameter MEM_DEVICE_NUM = 28,
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 12,
	parameter ADDR_WIDTH = $clog2(DEPTH)
) (
/*====== Stride unit 0 =================================================== */
	// The channel messages outputing from the 1st-level circular shifter
	output wire [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride0_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride0_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride0_bit2_o,
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride0_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride0_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride0_bit2_o,
	// The level-1 page alignment outputs for aligning variable node incoming messages
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride0_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride0_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride0_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride0_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride0_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride0_bit2_o,
	// The level-1 page alignment outputs for aligning check node incoming messages
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride0_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride0_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride0_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  ch2bs_stride0_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  ch2bs_stride0_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  ch2bs_stride0_bit2_i,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride0_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride0_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride0_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride0_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride0_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride0_bit2_i,
	// The third input sources of level-1 page alignment for aligning variable node incoming messages
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride0_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride0_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride0_bit2_i,
	// The third input sources of level-1 page alignment for aligning check node incoming messages
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride0_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride0_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride0_bit2_i,
	// The level-1 page alignment mux selectors
	input wire [STRIDE_UNIT_SIZE-1:0] vnuPaMuxSel_stride0_bit0_i, // vnuMux.selector[bit0]
	input wire [STRIDE_UNIT_SIZE-1:0] vnuPaMuxSel_stride0_bit1_i, // vnuMux.selector[bit1]
	input wire [STRIDE_UNIT_SIZE-1:0] cnuPaMuxSel_stride0_bit0_i, // cnuMux.selector[bit0]
	input wire [STRIDE_UNIT_SIZE-1:0] cnuPaMuxSel_stride0_bit1_i, // cnuMux.selector[bit1]

`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride0_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride0_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride0_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride0_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride0_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  ch2bs_stride0_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride0_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride0_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride0_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride0_bit3_i,
`endif

/*====== Stride unit 1 =================================================== */
	// The channel messages outputing from the 1st-level circular shifter
	output wire [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride1_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride1_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride1_bit2_o,
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride1_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride1_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride1_bit2_o,
	// The level-1 page alignment outputs for aligning variable node incoming messages
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride1_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride1_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride1_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride1_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride1_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride1_bit2_o,
	// The level-1 page alignment outputs for aligning check node incoming messages
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride1_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride1_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride1_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  ch2bs_stride1_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  ch2bs_stride1_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  ch2bs_stride1_bit2_i,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride1_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride1_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride1_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride1_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride1_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride1_bit2_i,
	// The third input sources of level-1 page alignment for aligning variable node incoming messages
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride1_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride1_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride1_bit2_i,
	// The third input sources of level-1 page alignment for aligning check node incoming messages
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride1_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride1_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride1_bit2_i,
	// The level-1 page alignment mux selectors
	input wire [STRIDE_UNIT_SIZE-1:0] vnuPaMuxSel_stride1_bit0_i, // vnuMux.selector[bit0]
	input wire [STRIDE_UNIT_SIZE-1:0] vnuPaMuxSel_stride1_bit1_i, // vnuMux.selector[bit1]
	input wire [STRIDE_UNIT_SIZE-1:0] cnuPaMuxSel_stride1_bit0_i, // cnuMux.selector[bit0]
	input wire [STRIDE_UNIT_SIZE-1:0] cnuPaMuxSel_stride1_bit1_i, // cnuMux.selector[bit1]
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride1_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride1_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride1_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride1_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride1_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  ch2bs_stride1_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride1_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride1_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride1_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride1_bit3_i,
`endif
/*====== Stride unit 2 =================================================== */
	// The channel messages outputing from the 1st-level circular shifter
	output wire [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride2_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride2_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride2_bit2_o,
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride2_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride2_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride2_bit2_o,
	// The level-1 page alignment outputs for aligning variable node incoming messages
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride2_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride2_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride2_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride2_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride2_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride2_bit2_o,
	// The level-1 page alignment outputs for aligning check node incoming messages
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride2_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride2_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride2_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  ch2bs_stride2_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  ch2bs_stride2_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  ch2bs_stride2_bit2_i,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride2_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride2_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride2_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride2_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride2_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride2_bit2_i,
	// The third input sources of level-1 page alignment for aligning variable node incoming messages
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride2_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride2_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride2_bit2_i,
	// The third input sources of level-1 page alignment for aligning check node incoming messages
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride2_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride2_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride2_bit2_i,
	// The level-1 page alignment mux selectors
	input wire [STRIDE_UNIT_SIZE-1:0] vnuPaMuxSel_stride2_bit0_i, // vnuMux.selector[bit0]
	input wire [STRIDE_UNIT_SIZE-1:0] vnuPaMuxSel_stride2_bit1_i, // vnuMux.selector[bit1]
	input wire [STRIDE_UNIT_SIZE-1:0] cnuPaMuxSel_stride2_bit0_i, // cnuMux.selector[bit0]
	input wire [STRIDE_UNIT_SIZE-1:0] cnuPaMuxSel_stride2_bit1_i, // cnuMux.selector[bit1]
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride2_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride2_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride2_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride2_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride2_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  ch2bs_stride2_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride2_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride2_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride2_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride2_bit3_i,
`endif
//----------------------------------------------------------------------//
	// The following nets for level-2 message passing are reused across all strides*/
	// The level-1 message passing
	input wire [$clog2(STRIDE_UNIT_SIZE-1)-1:0] L1_vnuBsShift_factor_i,
	input wire [$clog2(STRIDE_UNIT_SIZE-1)-1:0] L1_cnuBsShift_factor_i,
	// The level-1 page alignment (circular shifter) for aligning variable node incoming messages
	input wire [STRIDE_UNIT_SIZE-1:0] L2_vnuPaShift_factor_bit0_i, // shifter factor[bit_0]
	input wire [STRIDE_UNIT_SIZE-1:0] L2_vnuPaShift_factor_bit1_i, // shifter factor[bit_1]
	// The level-1 page alignment (circular shifter) for aligning variable node incoming messages
	input wire [STRIDE_UNIT_SIZE-1:0] L2_cnuPaShift_factor_bit0_i, // shifter factor[bit_0]
	input wire [STRIDE_UNIT_SIZE-1:0] L2_cnuPaShift_factor_bit1_i, // shifter factor[bit_1]
	// The level-2 page alignment (data bus combiiner) for aligning variable node incoming messages
	input wire [STRIDE_UNIT_SIZE-1:0] L2_vnuPaDCombine_patternStride0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L2_vnuPaDCombine_patternStride1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L2_vnuPaDCombine_patternStride2_i,
	// The level-2 page alignment (data bus combiiner) for aligning check node incoming messages
	input wire [STRIDE_UNIT_SIZE-1:0] L2_cnuPaDCombine_patternStride0_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L2_cnuPaDCombine_patternStride1_i,
	input wire [STRIDE_UNIT_SIZE-1:0] L2_cnuPaDCombine_patternStride2_i,
//----------------------------------------------------------------------//
	input wire L1_vnuBs_swInSrc,
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
// Stride unit 0
wire [STRIDE_UNIT_SIZE-1:0] m2cStride0_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU
// Stride unit 1
wire [STRIDE_UNIT_SIZE-1:0] m2cStride1_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU
// Stride unit 2
wire [STRIDE_UNIT_SIZE-1:0] m2cStride2_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU

columnVNU_L1Route #(
	.QUAN_SIZE(QUAN_SIZE),
	.STRIDE_UNIT_SIZE(STRIDE_UNIT_SIZE),
	.STRIDE_WIDTH(STRIDE_WIDTH),
	.BITWIDTH_SHIFT_FACTOR($clog2(STRIDE_UNIT_SIZE-1))
) columnVNU_L1Route (
	.stride0_out_bit0_o (m2cStride0_bit[0]), // to CNUs of stride unit 0
	.stride0_out_bit1_o (m2cStride0_bit[1]), // to CNUs of stride unit 0
	.stride0_out_bit2_o (m2cStride0_bit[2]), // to CNUs of stride unit 0
	.stride1_out_bit0_o (m2cStride1_bit[0]), // to CUNs of stride unit 1
	.stride1_out_bit1_o (m2cStride1_bit[1]), // to CUNs of stride unit 1
	.stride1_out_bit2_o (m2cStride1_bit[2]), // to CUNs of stride unit 1
	.stride2_out_bit0_o (m2cStride2_bit[0]), // to CNUs of stride unit 2
	.stride2_out_bit1_o (m2cStride2_bit[1]), // to CNUs of stride unit 2
	.stride2_out_bit2_o (m2cStride2_bit[2]), // to CNUs of stride unit 2
	`ifdef DECODER_4bit
		.stride0_out_bit3_o (m2cStride0_bit[3]),
		.stride1_out_bit3_o (m2cStride1_bit[3]),
		.stride2_out_bit3_o (m2cStride2_bit[3]),
	`endif
	.stride0_in0_bit0_i (ch2bs_stride0_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from channel MSGs of stride unit 0
	.stride0_in0_bit1_i (ch2bs_stride0_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from channel MSGs of stride unit 0
	.stride0_in0_bit2_i (ch2bs_stride0_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from channel MSGs of stride unit 0
	.stride0_in1_bit0_i (vnu2mem_stride0_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 0
	.stride0_in1_bit1_i (vnu2mem_stride0_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 0
	.stride0_in1_bit2_i (vnu2mem_stride0_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 0
	.stride1_in0_bit0_i (ch2bs_stride1_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from channel MSGs of stride unit 1
	.stride1_in0_bit1_i (ch2bs_stride1_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from channel MSGs of stride unit 1
	.stride1_in0_bit2_i (ch2bs_stride1_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from channel MSGs of stride unit 1
	.stride1_in1_bit0_i (vnu2mem_stride1_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 1
	.stride1_in1_bit1_i (vnu2mem_stride1_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 1
	.stride1_in1_bit2_i (vnu2mem_stride1_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 1
	.stride2_in0_bit0_i (ch2bs_stride2_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from channel MSGs of stride unit 2
	.stride2_in0_bit1_i (ch2bs_stride2_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from channel MSGs of stride unit 2 
	.stride2_in0_bit2_i (ch2bs_stride2_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from channel MSGs of stride unit 2 
	.stride2_in1_bit0_i (vnu2mem_stride2_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 2
	.stride2_in1_bit1_i (vnu2mem_stride2_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 2
	.stride2_in1_bit2_i (vnu2mem_stride2_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 2
	`ifdef DECODER_4bit
		.stride0_in0_bit3_i (ch2bs_stride0_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride0_in1_bit3_i (vnu2mem_stride0_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride1_in0_bit3_i (ch2bs_stride1_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride1_in1_bit3_i (vnu2mem_stride1_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride2_in0_bit3_i (ch2bs_stride2_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride2_in1_bit3_i (vnu2mem_stride2_bit3_i[STRIDE_UNIT_SIZE-1:0]),
	`endif
	.shift_factor        (L1_vnuBsShift_factor_i[$clog2(STRIDE_UNIT_SIZE-1)-1:0]),
	.sw_in_src           (L1_vnuBs_swInSrc),
	.sys_clk             (sys_clk),
	.rstn                (rstn)
);
generate
	genvar strideUnit_id;
	for(strideUnit_id=0; strideUnit_id<STRIDE_UNIT_SIZE; strideUnit_id=strideUnit_id+1) begin : columnVNU_L2Route_inst
		msgPass2pageAlignIF #(
			.SHIFT_LENGTH        (STRIDE_WIDTH       ),
			.QUAN_SIZE           (QUAN_SIZE          ),
			.L1_PA_MUX_SEL_WIDTH (L1_PA_MUX_SEL_WIDTH)
		) columnVNU_L2Route (
			.msgPass2paOut_bit0_o      ({mem2cnu_stride2_bit0_o[strideUnit_id], mem2cnu_stride1_bit0_o[strideUnit_id], mem2cnu_stride0_bit0_o[strideUnit_id]}),
			.msgPass2paOut_bit1_o      ({mem2cnu_stride2_bit1_o[strideUnit_id], mem2cnu_stride1_bit1_o[strideUnit_id], mem2cnu_stride0_bit1_o[strideUnit_id]}),
			.msgPass2paOut_bit2_o      ({mem2cnu_stride2_bit2_o[strideUnit_id], mem2cnu_stride1_bit2_o[strideUnit_id], mem2cnu_stride0_bit2_o[strideUnit_id]}),

			.L1_paOut_bit0_i           ({L1_pa2cnu_stride2_bit0_o[strideUnit_id], L1_pa2cnu_stride1_bit0_o[strideUnit_id], L1_pa2cnu_stride0_bit0_o[strideUnit_id]}),
			.L1_paOut_bit1_i           ({L1_pa2cnu_stride2_bit1_o[strideUnit_id], L1_pa2cnu_stride1_bit1_o[strideUnit_id], L1_pa2cnu_stride0_bit1_o[strideUnit_id]}),
			.L1_paOut_bit2_i           ({L1_pa2cnu_stride2_bit2_o[strideUnit_id], L1_pa2cnu_stride1_bit2_o[strideUnit_id], L1_pa2cnu_stride0_bit2_o[strideUnit_id]}),
		
			.swIn_bit0_i               ({m2cStride2_bit[0][strideUnit_id], m2cStride1_bit[0][strideUnit_id], m2cStride0_bit[0][strideUnit_id]}),
			.swIn_bit1_i               ({m2cStride2_bit[1][strideUnit_id], m2cStride1_bit[1][strideUnit_id], m2cStride0_bit[1][strideUnit_id]}),
			.swIn_bit2_i               ({m2cStride2_bit[2][strideUnit_id], m2cStride1_bit[2][strideUnit_id], m2cStride0_bit[2][strideUnit_id]}),
		
			.memSrcIn_bit0_i           ({L1_mem2pa_cnuStride2_bit0_i[strideUnit_id], L1_mem2pa_cnuStride1_bit0_i[strideUnit_id], L1_mem2pa_cnuStride0_bit0_i[strideUnit_id]}),
			.memSrcIn_bit1_i           ({L1_mem2pa_cnuStride2_bit1_i[strideUnit_id], L1_mem2pa_cnuStride1_bit1_i[strideUnit_id], L1_mem2pa_cnuStride0_bit1_i[strideUnit_id]}),
			.memSrcIn_bit2_i           ({L1_mem2pa_cnuStride2_bit2_i[strideUnit_id], L1_mem2pa_cnuStride1_bit2_i[strideUnit_id], L1_mem2pa_cnuStride0_bit2_i[strideUnit_id]}),
		`ifdef DECODER_4bit	
			.msgPass2paOut_bit3_o      ({mem2cnu_stride2_bit3_o[strideUnit_id], mem2cnu_stride1_bit3_o[strideUnit_id], mem2cnu_stride0_bit3_o[strideUnit_id]}),
			.L1_paOut_bit3_i           ({L1_pa2cnu_stride2_bit3_o[strideUnit_id], L1_pa2cnu_stride1_bit3_o[strideUnit_id], L1_pa2cnu_stride0_bit3_o[strideUnit_id]}),
			.swIn_bit3_i               ({m2cStride2_bit[3][strideUnit_id], m2cStride1_bit[3][strideUnit_id], m2cStride0_bit[3][strideUnit_id]}),
			.memSrcIn_bit3_i           ({L1_mem2pa_cnuStride2_bit3_i[strideUnit_id], L1_mem2pa_cnuStride1_bit3_i[strideUnit_id], L1_mem2pa_cnuStride0_bit3_i[strideUnit_id]}),
		`endif
			.L1_paShift_factor_i ({L2_cnuPaShift_factor_bit1_i[strideUnit_id], L2_cnuPaShift_factor_bit0_i[strideUnit_id]}),
			.L1_paSel_i (
				{
					cnuPaMuxSel_stride2_bit1_i[strideUnit_id], cnuPaMuxSel_stride2_bit0_i[strideUnit_id], 
					cnuPaMuxSel_stride1_bit1_i[strideUnit_id], cnuPaMuxSel_stride1_bit0_i[strideUnit_id], 
					cnuPaMuxSel_stride0_bit1_i[strideUnit_id], cnuPaMuxSel_stride0_bit0_i[strideUnit_id]
				}
			),
			.L2_dataCombiner_pattern_i (
				{
					L2_cnuPaDCombine_patternStride2_i[strideUnit_id], 
					L2_cnuPaDCombine_patternStride1_i[strideUnit_id], 
					L2_cnuPaDCombine_patternStride0_i[strideUnit_id]
				}
			),
			.sys_clk                   (sys_clk),
			.rstn                      (rstn)
		);
	end
endgenerate
//-----------------------------------------------------------------------------//
// Message passing for check node messages
//-----------------------------------------------------------------------------//
// Stride unit 0
wire [STRIDE_UNIT_SIZE-1:0] m2vStride0_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU
// Stride unit 1
wire [STRIDE_UNIT_SIZE-1:0] m2vStride1_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU
// Stride unit 2
wire [STRIDE_UNIT_SIZE-1:0] m2vStride2_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU
columnCNU_L1Route #(
	.QUAN_SIZE(QUAN_SIZE),
	.STRIDE_UNIT_SIZE(STRIDE_UNIT_SIZE),
	.STRIDE_WIDTH(STRIDE_WIDTH),
	.BITWIDTH_SHIFT_FACTOR($clog2(STRIDE_UNIT_SIZE-1))
) columnCNU_L1Route_u0 (
	.stride0_out_bit0_o (m2vStride0_bit[0]), // to VNUs of stride unit 0
	.stride0_out_bit1_o (m2vStride0_bit[1]), // to VNUs of stride unit 0
	.stride0_out_bit2_o (m2vStride0_bit[2]), // to VNUs of stride unit 0
	.stride1_out_bit0_o (m2vStride1_bit[0]), // to VNUs of stride unit 1
	.stride1_out_bit1_o (m2vStride1_bit[1]), // to VNUs of stride unit 1
	.stride1_out_bit2_o (m2vStride1_bit[2]), // to VNUs of stride unit 1
	.stride2_out_bit0_o (m2vStride2_bit[0]), // to VNUs of stride unit 2
	.stride2_out_bit1_o (m2vStride2_bit[1]), // to VNUs of stride unit 2
	.stride2_out_bit2_o (m2vStride2_bit[2]), // to VNUs of stride unit 2
	`ifdef DECODER_4bit
		.stride0_out_bit3_o (m2vStride0_bit[3]),
		.stride1_out_bit3_o (m2vStride1_bit[3]),
		.stride2_out_bit3_o (m2vStride2_bit[3]),
	`endif
	.stride0_bit0_i     (cnu2mem_stride0_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 0
	.stride0_bit1_i     (cnu2mem_stride0_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 0
	.stride0_bit2_i     (cnu2mem_stride0_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 0
	.stride1_bit0_i     (cnu2mem_stride1_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 1
	.stride1_bit1_i     (cnu2mem_stride1_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 1
	.stride1_bit2_i     (cnu2mem_stride1_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 1
	.stride2_bit0_i     (cnu2mem_stride2_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 2
	.stride2_bit1_i     (cnu2mem_stride2_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 2
	.stride2_bit2_i     (cnu2mem_stride2_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 2
	`ifdef DECODER_4bit
		.stride0_bit3_i     (cnu2mem_stride0_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride1_bit3_i     (cnu2mem_stride1_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride2_bit3_i     (cnu2mem_stride2_bit3_i[STRIDE_UNIT_SIZE-1:0]),
	`endif
	.shift_factor        (L1_cnuBsShift_factor_i[$clog2(STRIDE_UNIT_SIZE-1)-1:0]),
	.sys_clk             (sys_clk),
	.rstn                (rstn)
);
generate
	for(strideUnit_id=0; strideUnit_id<STRIDE_UNIT_SIZE; strideUnit_id=strideUnit_id+1) begin : columnCNU_L2Route_inst
		msgPass2pageAlignIF #(
			.SHIFT_LENGTH        (STRIDE_WIDTH       ),
			.QUAN_SIZE           (QUAN_SIZE          ),
			.L1_PA_MUX_SEL_WIDTH (L1_PA_MUX_SEL_WIDTH)
		) columnCNU_L2Route (
			.msgPass2paOut_bit0_o      ({mem2vnu_stride2_bit0_o[strideUnit_id], mem2vnu_stride1_bit0_o[strideUnit_id], mem2vnu_stride0_bit0_o[strideUnit_id]}),
			.msgPass2paOut_bit1_o      ({mem2vnu_stride2_bit1_o[strideUnit_id], mem2vnu_stride1_bit1_o[strideUnit_id], mem2vnu_stride0_bit1_o[strideUnit_id]}),
			.msgPass2paOut_bit2_o      ({mem2vnu_stride2_bit2_o[strideUnit_id], mem2vnu_stride1_bit2_o[strideUnit_id], mem2vnu_stride0_bit2_o[strideUnit_id]}),

			.L1_paOut_bit0_i           ({L1_pa2vnu_stride2_bit0_o[strideUnit_id], L1_pa2vnu_stride1_bit0_o[strideUnit_id], L1_pa2vnu_stride0_bit0_o[strideUnit_id]}),
			.L1_paOut_bit1_i           ({L1_pa2vnu_stride2_bit1_o[strideUnit_id], L1_pa2vnu_stride1_bit1_o[strideUnit_id], L1_pa2vnu_stride0_bit1_o[strideUnit_id]}),
			.L1_paOut_bit2_i           ({L1_pa2vnu_stride2_bit2_o[strideUnit_id], L1_pa2vnu_stride1_bit2_o[strideUnit_id], L1_pa2vnu_stride0_bit2_o[strideUnit_id]}),
		
			.swIn_bit0_i               ({m2vStride2_bit[0][strideUnit_id], m2vStride1_bit[0][strideUnit_id], m2vStride0_bit[0][strideUnit_id]}),
			.swIn_bit1_i               ({m2vStride2_bit[1][strideUnit_id], m2vStride1_bit[1][strideUnit_id], m2vStride0_bit[1][strideUnit_id]}),
			.swIn_bit2_i               ({m2vStride2_bit[2][strideUnit_id], m2vStride1_bit[2][strideUnit_id], m2vStride0_bit[2][strideUnit_id]}),
		
			.memSrcIn_bit0_i           ({L1_mem2pa_vnuStride2_bit0_i[strideUnit_id], L1_mem2pa_vnuStride1_bit0_i[strideUnit_id], L1_mem2pa_vnuStride0_bit0_i[strideUnit_id]}),
			.memSrcIn_bit1_i           ({L1_mem2pa_vnuStride2_bit1_i[strideUnit_id], L1_mem2pa_vnuStride1_bit1_i[strideUnit_id], L1_mem2pa_vnuStride0_bit1_i[strideUnit_id]}),
			.memSrcIn_bit2_i           ({L1_mem2pa_vnuStride2_bit2_i[strideUnit_id], L1_mem2pa_vnuStride1_bit2_i[strideUnit_id], L1_mem2pa_vnuStride0_bit2_i[strideUnit_id]}),
		`ifdef DECODER_4bit	
			.msgPass2paOut_bit3_o      ({mem2vnu_stride2_bit3_o[strideUnit_id], mem2vnu_stride1_bit3_o[strideUnit_id], mem2vnu_stride0_bit3_o[strideUnit_id]}),
			.L1_paOut_bit3_i           ({L1_pa2vnu_stride2_bit3_o[strideUnit_id], L1_pa2vnu_stride1_bit3_o[strideUnit_id], L1_pa2vnu_stride0_bit3_o[strideUnit_id]}),
			.swIn_bit3_i               ({m2vStride2_bit[3][strideUnit_id], m2vStride1_bit[3][strideUnit_id], m2vStride0_bit[3][strideUnit_id]}),
			.memSrcIn_bit3_i           ({L1_mem2pa_vnuStride2_bit3_i[strideUnit_id], L1_mem2pa_vnuStride1_bit3_i[strideUnit_id], L1_mem2pa_vnuStride0_bit3_i[strideUnit_id]}),
		`endif
			.L1_paShift_factor_i ({L2_vnuPaShift_factor_bit1_i[strideUnit_id], L2_vnuPaShift_factor_bit0_i[strideUnit_id]}),
			.L1_paSel_i (
				{
					vnuPaMuxSel_stride2_bit1_i[strideUnit_id], vnuPaMuxSel_stride2_bit0_i[strideUnit_id], 
					vnuPaMuxSel_stride1_bit1_i[strideUnit_id], vnuPaMuxSel_stride1_bit0_i[strideUnit_id], 
					vnuPaMuxSel_stride0_bit1_i[strideUnit_id], vnuPaMuxSel_stride0_bit0_i[strideUnit_id]
				}
			),
			.L2_dataCombiner_pattern_i (
				{
					L2_vnuPaDCombine_patternStride2_i[strideUnit_id], 
					L2_vnuPaDCombine_patternStride1_i[strideUnit_id], 
					L2_vnuPaDCombine_patternStride0_i[strideUnit_id]
				}
			),
			.sys_clk                   (sys_clk),
			.rstn                      (rstn)
		);
	end
endgenerate


// The channel messages outputing from the 1st-level circular shifter
// Bypassing the level-2 page alignment for check intrinsic messages,
// but distinct timing of fetching by channel message RAMs. 
// Stride 0
assign  pa2chRAM_stride0_bit0_o[STRIDE_UNIT_SIZE-1:0] = mem2vnu_stride0_bit0_o;
assign  pa2chRAM_stride0_bit1_o[STRIDE_UNIT_SIZE-1:0] = mem2vnu_stride0_bit1_o;
assign  pa2chRAM_stride0_bit2_o[STRIDE_UNIT_SIZE-1:0] = mem2vnu_stride0_bit2_o;
// Stride 1
assign  pa2chRAM_stride1_bit0_o[STRIDE_UNIT_SIZE-1:0] = mem2vnu_stride1_bit0_o;
assign  pa2chRAM_stride1_bit1_o[STRIDE_UNIT_SIZE-1:0] = mem2vnu_stride1_bit1_o;
assign  pa2chRAM_stride1_bit2_o[STRIDE_UNIT_SIZE-1:0] = mem2vnu_stride1_bit2_o;
// Stride 2
assign  pa2chRAM_stride2_bit0_o[STRIDE_UNIT_SIZE-1:0] = mem2vnu_stride2_bit0_o;
assign  pa2chRAM_stride2_bit1_o[STRIDE_UNIT_SIZE-1:0] = mem2vnu_stride2_bit1_o;
assign  pa2chRAM_stride2_bit2_o[STRIDE_UNIT_SIZE-1:0] = mem2vnu_stride2_bit2_o;

`ifdef  DECODER_4bit
	assign  pa2chRAM_stride0_bit3_o[STRIDE_UNIT_SIZE-1:0] = mem2vnu_stride0_bit3_o; // Stride 0
	assign  pa2chRAM_stride1_bit3_o[STRIDE_UNIT_SIZE-1:0] = mem2vnu_stride1_bit3_o; // Stride 1
	assign  pa2chRAM_stride2_bit3_o[STRIDE_UNIT_SIZE-1:0] = mem2vnu_stride2_bit3_o; // Stride 2
`endif
endmodule
`endif // MSGPASS_SOL_1

`ifdef MSGPASS_SOL_3
/**
* Created date: 26 November, 2022
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: partial_msgPass_wrapper
* 
* # I/F
* 1) Output:
* 2) Input:
* 
* # Param
* 
* # Description
* 
* # Dependencies
* 	1) devine.vh -> quantisatin bit with of messages
**/
module partial_msgPass_wrapper #(
	parameter QUAN_SIZE = 4,
	parameter ROW_SPLIT_FACTOR = 5, // Ns=	parameter CHECK_PARALLELISM = 15,
	parameter STRIDE_UNIT_SIZE = 15,
	parameter STRIDE_WIDTH = 17,
	parameter LAYER_NUM = 3,
	// Parameters of extrinsic RAMs
	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,
	parameter RAM_PORTB_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b,
	parameter MEM_DEVICE_NUM = 28,
	parameter DEPTH = 1024,
	parameter DATA_WIDTH = 36,
	parameter FRAG_DATA_WIDTH = 12,
	parameter ADDR_WIDTH = $clog2(DEPTH)
) (
/*====== Stride unit 0 =================================================== */
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride0_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride0_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride0_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride0_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride0_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride0_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride0_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride0_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride0_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride0_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride0_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride0_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride0_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride0_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride0_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride0_bit3_i,
`endif
/*====== Stride unit 1 =================================================== */
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride1_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride1_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride1_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride1_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride1_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride1_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride1_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride1_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride1_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride1_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride1_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride1_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride1_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride1_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride1_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride1_bit3_i,
`endif
/*====== Stride unit 2 =================================================== */
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride2_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride2_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride2_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride2_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride2_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride2_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride2_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride2_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride2_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride2_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride2_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride2_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride2_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride2_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride2_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride2_bit3_i,
`endif
/*====== Stride unit 3 =================================================== */
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride3_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride3_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride3_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride3_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride3_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride3_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride3_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride3_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride3_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride3_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride3_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride3_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride3_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride3_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride3_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride3_bit3_i,
`endif
/*====== Stride unit 4 =================================================== */
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride4_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride4_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride4_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride4_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride4_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride4_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride4_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride4_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride4_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride4_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride4_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride4_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride4_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride4_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride4_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride4_bit3_i,
`endif
/*====== Stride unit 5 =================================================== */
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride5_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride5_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride5_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride5_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride5_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride5_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride5_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride5_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride5_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride5_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride5_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride5_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride5_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride5_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride5_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride5_bit3_i,
`endif
/*====== Stride unit 6 =================================================== */
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride6_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride6_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride6_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride6_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride6_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride6_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride6_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride6_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride6_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride6_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride6_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride6_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride6_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride6_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride6_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride6_bit3_i,
`endif
/*====== Stride unit 7 =================================================== */
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride7_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride7_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride7_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride7_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride7_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride7_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride7_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride7_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride7_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride7_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride7_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride7_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride7_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride7_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride7_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride7_bit3_i,
`endif
/*====== Stride unit 8 =================================================== */
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride8_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride8_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride8_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride8_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride8_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride8_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride8_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride8_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride8_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride8_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride8_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride8_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride8_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride8_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride8_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride8_bit3_i,
`endif
/*====== Stride unit 9 =================================================== */
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride9_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride9_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride9_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride9_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride9_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride9_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride9_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride9_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride9_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride9_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride9_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride9_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride9_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride9_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride9_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride9_bit3_i,
`endif
/*====== Stride unit 10 =================================================== */
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride10_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride10_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride10_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride10_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride10_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride10_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride10_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride10_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride10_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride10_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride10_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride10_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride10_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride10_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride10_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride10_bit3_i,
`endif
/*====== Stride unit 11 =================================================== */
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride11_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride11_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride11_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride11_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride11_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride11_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride11_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride11_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride11_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride11_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride11_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride11_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride11_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride11_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride11_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride11_bit3_i,
`endif
/*====== Stride unit 12 =================================================== */
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride12_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride12_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride12_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride12_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride12_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride12_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride12_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride12_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride12_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride12_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride12_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride12_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride12_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride12_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride12_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride12_bit3_i,
`endif
/*====== Stride unit 13 =================================================== */
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride13_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride13_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride13_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride13_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride13_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride13_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride13_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride13_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride13_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride13_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride13_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride13_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride13_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride13_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride13_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride13_bit3_i,
`endif
/*====== Stride unit 14 =================================================== */
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride14_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride14_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride14_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride14_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride14_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride14_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride14_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride14_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride14_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride14_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride14_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride14_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride14_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride14_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride14_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride14_bit3_i,
`endif
/*====== Stride unit 15 =================================================== */
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride15_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride15_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride15_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride15_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride15_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride15_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride15_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride15_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride15_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride15_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride15_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride15_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride15_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride15_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride15_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride15_bit3_i,
`endif
/*====== Stride unit 16 =================================================== */
	// The memory Dout port to variable nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride16_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride16_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride16_bit2_o,
	// The memory Dout port to check nodes as instrinsic messages
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride16_bit0_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride16_bit1_o,
	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride16_bit2_o,
	// The varible extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride16_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride16_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride16_bit2_i,
	// The check extrinsic message written back onto memory through BS and PA
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride16_bit0_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride16_bit1_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride16_bit2_i,
`ifdef DECODER_4bit
	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride16_bit3_o,
	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride16_bit3_o,
	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride16_bit3_i,
	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride16_bit3_i,
`endif
//----------------------------------------------------------------------//
	// The following nets for level-2 message passing are reused across all strides*/
	// The level-1 message passing
	input wire [$clog2(STRIDE_UNIT_SIZE-1)-1:0] L1_vnuBsShift_factor_i,
	input wire [$clog2(STRIDE_UNIT_SIZE-1)-1:0] L1_cnuBsShift_factor_i,
	// The level-1 page alignment (circular shifter) for aligning variable node incoming messages
	input wire [STRIDE_UNIT_SIZE-1:0] L2_vnuPaShift_factor_bit0_i, // shifter factor[bit_0]
	input wire [STRIDE_UNIT_SIZE-1:0] L2_vnuPaShift_factor_bit1_i, // shifter factor[bit_1]
	input wire [STRIDE_UNIT_SIZE-1:0] L2_vnuPaShift_factor_bit2_i, // shifter factor[bit_2]
	input wire [STRIDE_UNIT_SIZE-1:0] L2_vnuPaShift_factor_bit3_i, // shifter factor[bit_3]
	input wire [STRIDE_UNIT_SIZE-1:0] L2_vnuPaShift_factor_bit4_i, // shifter factor[bit_4]
	// The level-1 page alignment (circular shifter) for aligning variable node incoming messages
	input wire [STRIDE_UNIT_SIZE-1:0] L2_cnuPaShift_factor_bit0_i, // shifter factor[bit_0]
	input wire [STRIDE_UNIT_SIZE-1:0] L2_cnuPaShift_factor_bit1_i, // shifter factor[bit_1]
	input wire [STRIDE_UNIT_SIZE-1:0] L2_cnuPaShift_factor_bit2_i, // shifter factor[bit_2]
	input wire [STRIDE_UNIT_SIZE-1:0] L2_cnuPaShift_factor_bit3_i, // shifter factor[bit_3]
	input wire [STRIDE_UNIT_SIZE-1:0] L2_cnuPaShift_factor_bit4_i, // shifter factor[bit_4]
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
// Stride unit 0 - 16
wire [STRIDE_UNIT_SIZE-1:0] m2cStride0_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 0
wire [STRIDE_UNIT_SIZE-1:0] m2cStride1_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 1
wire [STRIDE_UNIT_SIZE-1:0] m2cStride2_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 2
wire [STRIDE_UNIT_SIZE-1:0] m2cStride3_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 3
wire [STRIDE_UNIT_SIZE-1:0] m2cStride4_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 4
wire [STRIDE_UNIT_SIZE-1:0] m2cStride5_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 5
wire [STRIDE_UNIT_SIZE-1:0] m2cStride6_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 6
wire [STRIDE_UNIT_SIZE-1:0] m2cStride7_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 7
wire [STRIDE_UNIT_SIZE-1:0] m2cStride8_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 8
wire [STRIDE_UNIT_SIZE-1:0] m2cStride9_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 9
wire [STRIDE_UNIT_SIZE-1:0] m2cStride10_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 10
wire [STRIDE_UNIT_SIZE-1:0] m2cStride11_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 11
wire [STRIDE_UNIT_SIZE-1:0] m2cStride12_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 12
wire [STRIDE_UNIT_SIZE-1:0] m2cStride13_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 13
wire [STRIDE_UNIT_SIZE-1:0] m2cStride14_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 14
wire [STRIDE_UNIT_SIZE-1:0] m2cStride15_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 15
wire [STRIDE_UNIT_SIZE-1:0] m2cStride16_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride 16

//columnSingleSrc_L1Route #(
columnSingleSrc_L1Route_emptybox #(
	.QUAN_SIZE(QUAN_SIZE),
	.STRIDE_UNIT_SIZE(STRIDE_UNIT_SIZE),
	.STRIDE_WIDTH(STRIDE_WIDTH),
	.BITWIDTH_SHIFT_FACTOR($clog2(STRIDE_UNIT_SIZE-1))
) columnVNU_L1Route (
	.stride0_out_bit0_o (m2cStride0_bit[0]), // to CNUs of stride unit 0
	.stride0_out_bit1_o (m2cStride0_bit[1]), // to CNUs of stride unit 0
	.stride0_out_bit2_o (m2cStride0_bit[2]), // to CNUs of stride unit 0
	.stride1_out_bit0_o (m2cStride1_bit[0]), // to CNUs of stride unit 1
	.stride1_out_bit1_o (m2cStride1_bit[1]), // to CNUs of stride unit 1
	.stride1_out_bit2_o (m2cStride1_bit[2]), // to CNUs of stride unit 1
	.stride2_out_bit0_o (m2cStride2_bit[0]), // to CNUs of stride unit 2
	.stride2_out_bit1_o (m2cStride2_bit[1]), // to CNUs of stride unit 2
	.stride2_out_bit2_o (m2cStride2_bit[2]), // to CNUs of stride unit 2
	.stride3_out_bit0_o (m2cStride3_bit[0]), // to CNUs of stride unit 3
	.stride3_out_bit1_o (m2cStride3_bit[1]), // to CNUs of stride unit 3
	.stride3_out_bit2_o (m2cStride3_bit[2]), // to CNUs of stride unit 3
	.stride4_out_bit0_o (m2cStride4_bit[0]), // to CNUs of stride unit 4
	.stride4_out_bit1_o (m2cStride4_bit[1]), // to CNUs of stride unit 4
	.stride4_out_bit2_o (m2cStride4_bit[2]), // to CNUs of stride unit 4
	.stride5_out_bit0_o (m2cStride5_bit[0]), // to CNUs of stride unit 5
	.stride5_out_bit1_o (m2cStride5_bit[1]), // to CNUs of stride unit 5
	.stride5_out_bit2_o (m2cStride5_bit[2]), // to CNUs of stride unit 5
	.stride6_out_bit0_o (m2cStride6_bit[0]), // to CNUs of stride unit 6
	.stride6_out_bit1_o (m2cStride6_bit[1]), // to CNUs of stride unit 6
	.stride6_out_bit2_o (m2cStride6_bit[2]), // to CNUs of stride unit 6
	.stride7_out_bit0_o (m2cStride7_bit[0]), // to CNUs of stride unit 7
	.stride7_out_bit1_o (m2cStride7_bit[1]), // to CNUs of stride unit 7
	.stride7_out_bit2_o (m2cStride7_bit[2]), // to CNUs of stride unit 7
	.stride8_out_bit0_o (m2cStride8_bit[0]), // to CNUs of stride unit 8
	.stride8_out_bit1_o (m2cStride8_bit[1]), // to CNUs of stride unit 8
	.stride8_out_bit2_o (m2cStride8_bit[2]), // to CNUs of stride unit 8
	.stride9_out_bit0_o (m2cStride9_bit[0]), // to CNUs of stride unit 9
	.stride9_out_bit1_o (m2cStride9_bit[1]), // to CNUs of stride unit 9
	.stride9_out_bit2_o (m2cStride9_bit[2]), // to CNUs of stride unit 9
	.stride10_out_bit0_o (m2cStride10_bit[0]), // to CNUs of stride unit 10
	.stride10_out_bit1_o (m2cStride10_bit[1]), // to CNUs of stride unit 10
	.stride10_out_bit2_o (m2cStride10_bit[2]), // to CNUs of stride unit 10
	.stride11_out_bit0_o (m2cStride11_bit[0]), // to CNUs of stride unit 11
	.stride11_out_bit1_o (m2cStride11_bit[1]), // to CNUs of stride unit 11
	.stride11_out_bit2_o (m2cStride11_bit[2]), // to CNUs of stride unit 11
	.stride12_out_bit0_o (m2cStride12_bit[0]), // to CNUs of stride unit 12
	.stride12_out_bit1_o (m2cStride12_bit[1]), // to CNUs of stride unit 12
	.stride12_out_bit2_o (m2cStride12_bit[2]), // to CNUs of stride unit 12
	.stride13_out_bit0_o (m2cStride13_bit[0]), // to CNUs of stride unit 13
	.stride13_out_bit1_o (m2cStride13_bit[1]), // to CNUs of stride unit 13
	.stride13_out_bit2_o (m2cStride13_bit[2]), // to CNUs of stride unit 13
	.stride14_out_bit0_o (m2cStride14_bit[0]), // to CNUs of stride unit 14
	.stride14_out_bit1_o (m2cStride14_bit[1]), // to CNUs of stride unit 14
	.stride14_out_bit2_o (m2cStride14_bit[2]), // to CNUs of stride unit 14
	.stride15_out_bit0_o (m2cStride15_bit[0]), // to CNUs of stride unit 15
	.stride15_out_bit1_o (m2cStride15_bit[1]), // to CNUs of stride unit 15
	.stride15_out_bit2_o (m2cStride15_bit[2]), // to CNUs of stride unit 15
	.stride16_out_bit0_o (m2cStride16_bit[0]), // to CNUs of stride unit 16
	.stride16_out_bit1_o (m2cStride16_bit[1]), // to CNUs of stride unit 16
	.stride16_out_bit2_o (m2cStride16_bit[2]), // to CNUs of stride unit 16
	`ifdef DECODER_4bit
		.stride0_out_bit3_o (m2cStride0_bit[3]),
		.stride1_out_bit3_o (m2cStride1_bit[3]),
		.stride2_out_bit3_o (m2cStride2_bit[3]),
		.stride3_out_bit3_o (m2cStride3_bit[3]),
		.stride4_out_bit3_o (m2cStride4_bit[3]),
		.stride5_out_bit3_o (m2cStride5_bit[3]),
		.stride6_out_bit3_o (m2cStride6_bit[3]),
		.stride7_out_bit3_o (m2cStride7_bit[3]),
		.stride8_out_bit3_o (m2cStride8_bit[3]),
		.stride9_out_bit3_o (m2cStride9_bit[3]),
		.stride10_out_bit3_o (m2cStride10_bit[3]),
		.stride11_out_bit3_o (m2cStride11_bit[3]),
		.stride12_out_bit3_o (m2cStride12_bit[3]),
		.stride13_out_bit3_o (m2cStride13_bit[3]),
		.stride14_out_bit3_o (m2cStride14_bit[3]),
		.stride15_out_bit3_o (m2cStride15_bit[3]),
		.stride16_out_bit3_o (m2cStride16_bit[3]),
	`endif

	.stride0_bit0_i (vnu2mem_stride0_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride0_bit1_i (vnu2mem_stride0_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride0_bit2_i (vnu2mem_stride0_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride1_bit0_i (vnu2mem_stride1_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride1_bit1_i (vnu2mem_stride1_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride1_bit2_i (vnu2mem_stride1_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride2_bit0_i (vnu2mem_stride2_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride2_bit1_i (vnu2mem_stride2_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride2_bit2_i (vnu2mem_stride2_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride3_bit0_i (vnu2mem_stride3_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride3_bit1_i (vnu2mem_stride3_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride3_bit2_i (vnu2mem_stride3_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride4_bit0_i (vnu2mem_stride4_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride4_bit1_i (vnu2mem_stride4_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride4_bit2_i (vnu2mem_stride4_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride5_bit0_i (vnu2mem_stride5_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride5_bit1_i (vnu2mem_stride5_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride5_bit2_i (vnu2mem_stride5_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride6_bit0_i (vnu2mem_stride6_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride6_bit1_i (vnu2mem_stride6_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride6_bit2_i (vnu2mem_stride6_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride7_bit0_i (vnu2mem_stride7_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride7_bit1_i (vnu2mem_stride7_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride7_bit2_i (vnu2mem_stride7_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride8_bit0_i (vnu2mem_stride8_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride8_bit1_i (vnu2mem_stride8_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride8_bit2_i (vnu2mem_stride8_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride9_bit0_i (vnu2mem_stride9_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride9_bit1_i (vnu2mem_stride9_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride9_bit2_i (vnu2mem_stride9_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride10_bit0_i (vnu2mem_stride10_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride10_bit1_i (vnu2mem_stride10_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride10_bit2_i (vnu2mem_stride10_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride11_bit0_i (vnu2mem_stride11_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride11_bit1_i (vnu2mem_stride11_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride11_bit2_i (vnu2mem_stride11_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride12_bit0_i (vnu2mem_stride12_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride12_bit1_i (vnu2mem_stride12_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride12_bit2_i (vnu2mem_stride12_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride13_bit0_i (vnu2mem_stride13_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride13_bit1_i (vnu2mem_stride13_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride13_bit2_i (vnu2mem_stride13_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride14_bit0_i (vnu2mem_stride14_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride14_bit1_i (vnu2mem_stride14_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride14_bit2_i (vnu2mem_stride14_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride15_bit0_i (vnu2mem_stride15_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride15_bit1_i (vnu2mem_stride15_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride15_bit2_i (vnu2mem_stride15_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride16_bit0_i (vnu2mem_stride16_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride16_bit1_i (vnu2mem_stride16_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 	.stride16_bit2_i (vnu2mem_stride16_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit 
	`ifdef DECODER_4bit
		.stride0_bit3_i (vnu2mem_stride0_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride1_bit3_i (vnu2mem_stride1_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride2_bit3_i (vnu2mem_stride2_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride3_bit3_i (vnu2mem_stride3_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride4_bit3_i (vnu2mem_stride4_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride5_bit3_i (vnu2mem_stride5_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride6_bit3_i (vnu2mem_stride6_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride7_bit3_i (vnu2mem_stride7_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride8_bit3_i (vnu2mem_stride8_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride9_bit3_i (vnu2mem_stride9_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride10_bit3_i (vnu2mem_stride10_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride11_bit3_i (vnu2mem_stride11_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride12_bit3_i (vnu2mem_stride12_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride13_bit3_i (vnu2mem_stride13_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride14_bit3_i (vnu2mem_stride14_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride15_bit3_i (vnu2mem_stride15_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride16_bit3_i (vnu2mem_stride16_bit3_i[STRIDE_UNIT_SIZE-1:0]),
	`endif
	.shift_factor        (L1_vnuBsShift_factor_i[$clog2(STRIDE_UNIT_SIZE-1)-1:0]),
	.sys_clk             (sys_clk),
	.rstn                (rstn)
);
generate
	genvar strideUnit_id;
	for(strideUnit_id=0; strideUnit_id<STRIDE_UNIT_SIZE; strideUnit_id=strideUnit_id+1) begin : columnVNU_L2Route_inst
		msgPass2pageAlignIF #(
			.SHIFT_LENGTH        (STRIDE_WIDTH       ),
			.QUAN_SIZE           (QUAN_SIZE          )
		) columnVNU_L2Route (
			.msgPass2paOut_bit0_o      ({mem2cnu_stride16_bit0_o[strideUnit_id], mem2cnu_stride15_bit0_o[strideUnit_id], mem2cnu_stride14_bit0_o[strideUnit_id], mem2cnu_stride13_bit0_o[strideUnit_id], mem2cnu_stride12_bit0_o[strideUnit_id], mem2cnu_stride11_bit0_o[strideUnit_id], mem2cnu_stride10_bit0_o[strideUnit_id], mem2cnu_stride9_bit0_o[strideUnit_id], mem2cnu_stride8_bit0_o[strideUnit_id], mem2cnu_stride7_bit0_o[strideUnit_id], mem2cnu_stride6_bit0_o[strideUnit_id], mem2cnu_stride5_bit0_o[strideUnit_id], mem2cnu_stride4_bit0_o[strideUnit_id], mem2cnu_stride3_bit0_o[strideUnit_id], mem2cnu_stride2_bit0_o[strideUnit_id], mem2cnu_stride1_bit0_o[strideUnit_id], mem2cnu_stride0_bit0_o[strideUnit_id]}),
			.msgPass2paOut_bit1_o      ({mem2cnu_stride16_bit1_o[strideUnit_id], mem2cnu_stride15_bit1_o[strideUnit_id], mem2cnu_stride14_bit1_o[strideUnit_id], mem2cnu_stride13_bit1_o[strideUnit_id], mem2cnu_stride12_bit1_o[strideUnit_id], mem2cnu_stride11_bit1_o[strideUnit_id], mem2cnu_stride10_bit1_o[strideUnit_id], mem2cnu_stride9_bit1_o[strideUnit_id], mem2cnu_stride8_bit1_o[strideUnit_id], mem2cnu_stride7_bit1_o[strideUnit_id], mem2cnu_stride6_bit1_o[strideUnit_id], mem2cnu_stride5_bit1_o[strideUnit_id], mem2cnu_stride4_bit1_o[strideUnit_id], mem2cnu_stride3_bit1_o[strideUnit_id], mem2cnu_stride2_bit1_o[strideUnit_id], mem2cnu_stride1_bit1_o[strideUnit_id], mem2cnu_stride0_bit1_o[strideUnit_id]}),
			.msgPass2paOut_bit2_o      ({mem2cnu_stride16_bit2_o[strideUnit_id], mem2cnu_stride15_bit2_o[strideUnit_id], mem2cnu_stride14_bit2_o[strideUnit_id], mem2cnu_stride13_bit2_o[strideUnit_id], mem2cnu_stride12_bit2_o[strideUnit_id], mem2cnu_stride11_bit2_o[strideUnit_id], mem2cnu_stride10_bit2_o[strideUnit_id], mem2cnu_stride9_bit2_o[strideUnit_id], mem2cnu_stride8_bit2_o[strideUnit_id], mem2cnu_stride7_bit2_o[strideUnit_id], mem2cnu_stride6_bit2_o[strideUnit_id], mem2cnu_stride5_bit2_o[strideUnit_id], mem2cnu_stride4_bit2_o[strideUnit_id], mem2cnu_stride3_bit2_o[strideUnit_id], mem2cnu_stride2_bit2_o[strideUnit_id], mem2cnu_stride1_bit2_o[strideUnit_id], mem2cnu_stride0_bit2_o[strideUnit_id]}),

			.swIn_bit0_i      ({m2cStride16_bit[0][strideUnit_id], m2cStride15_bit[0][strideUnit_id], m2cStride14_bit[0][strideUnit_id], m2cStride13_bit[0][strideUnit_id], m2cStride12_bit[0][strideUnit_id], m2cStride11_bit[0][strideUnit_id], m2cStride10_bit[0][strideUnit_id], m2cStride9_bit[0][strideUnit_id], m2cStride8_bit[0][strideUnit_id], m2cStride7_bit[0][strideUnit_id], m2cStride6_bit[0][strideUnit_id], m2cStride5_bit[0][strideUnit_id], m2cStride4_bit[0][strideUnit_id], m2cStride3_bit[0][strideUnit_id], m2cStride2_bit[0][strideUnit_id], m2cStride1_bit[0][strideUnit_id], m2cStride0_bit[0][strideUnit_id]}),
			.swIn_bit1_i      ({m2cStride16_bit[1][strideUnit_id], m2cStride15_bit[1][strideUnit_id], m2cStride14_bit[1][strideUnit_id], m2cStride13_bit[1][strideUnit_id], m2cStride12_bit[1][strideUnit_id], m2cStride11_bit[1][strideUnit_id], m2cStride10_bit[1][strideUnit_id], m2cStride9_bit[1][strideUnit_id], m2cStride8_bit[1][strideUnit_id], m2cStride7_bit[1][strideUnit_id], m2cStride6_bit[1][strideUnit_id], m2cStride5_bit[1][strideUnit_id], m2cStride4_bit[1][strideUnit_id], m2cStride3_bit[1][strideUnit_id], m2cStride2_bit[1][strideUnit_id], m2cStride1_bit[1][strideUnit_id], m2cStride0_bit[1][strideUnit_id]}),
			.swIn_bit2_i      ({m2cStride16_bit[2][strideUnit_id], m2cStride15_bit[2][strideUnit_id], m2cStride14_bit[2][strideUnit_id], m2cStride13_bit[2][strideUnit_id], m2cStride12_bit[2][strideUnit_id], m2cStride11_bit[2][strideUnit_id], m2cStride10_bit[2][strideUnit_id], m2cStride9_bit[2][strideUnit_id], m2cStride8_bit[2][strideUnit_id], m2cStride7_bit[2][strideUnit_id], m2cStride6_bit[2][strideUnit_id], m2cStride5_bit[2][strideUnit_id], m2cStride4_bit[2][strideUnit_id], m2cStride3_bit[2][strideUnit_id], m2cStride2_bit[2][strideUnit_id], m2cStride1_bit[2][strideUnit_id], m2cStride0_bit[2][strideUnit_id]}),

		`ifdef DECODER_4bit
			.msgPass2paOut_bit3_o      ({mem2cnu_stride16_bit3_o[strideUnit_id], mem2cnu_stride15_bit3_o[strideUnit_id], mem2cnu_stride14_bit3_o[strideUnit_id], mem2cnu_stride13_bit3_o[strideUnit_id], mem2cnu_stride12_bit3_o[strideUnit_id], mem2cnu_stride11_bit3_o[strideUnit_id], mem2cnu_stride10_bit3_o[strideUnit_id], mem2cnu_stride9_bit3_o[strideUnit_id], mem2cnu_stride8_bit3_o[strideUnit_id], mem2cnu_stride7_bit3_o[strideUnit_id], mem2cnu_stride6_bit3_o[strideUnit_id], mem2cnu_stride5_bit3_o[strideUnit_id], mem2cnu_stride4_bit3_o[strideUnit_id], mem2cnu_stride3_bit3_o[strideUnit_id], mem2cnu_stride2_bit3_o[strideUnit_id], mem2cnu_stride1_bit3_o[strideUnit_id], mem2cnu_stride0_bit3_o[strideUnit_id]}),
			.swIn_bit3_i      ({m2cStride16_bit[3][strideUnit_id], m2cStride15_bit[3][strideUnit_id], m2cStride14_bit[3][strideUnit_id], m2cStride13_bit[3][strideUnit_id], m2cStride12_bit[3][strideUnit_id], m2cStride11_bit[3][strideUnit_id], m2cStride10_bit[3][strideUnit_id], m2cStride9_bit[3][strideUnit_id], m2cStride8_bit[3][strideUnit_id], m2cStride7_bit[3][strideUnit_id], m2cStride6_bit[3][strideUnit_id], m2cStride5_bit[3][strideUnit_id], m2cStride4_bit[3][strideUnit_id], m2cStride3_bit[3][strideUnit_id], m2cStride2_bit[3][strideUnit_id], m2cStride1_bit[3][strideUnit_id], m2cStride0_bit[3][strideUnit_id]}),
		`endif
			.L1_paShift_factor_i ({L2_cnuPaShift_factor_bit4_i[strideUnit_id], L2_cnuPaShift_factor_bit3_i[strideUnit_id], L2_cnuPaShift_factor_bit2_i[strideUnit_id], L2_cnuPaShift_factor_bit1_i[strideUnit_id], L2_cnuPaShift_factor_bit0_i[strideUnit_id]}),
			.sys_clk                   (sys_clk),
			.rstn                      (rstn)
		);
	end
endgenerate
//-----------------------------------------------------------------------------//
// Message passing for check node messages
//-----------------------------------------------------------------------------//
// Stride unit 0 - 16
wire [STRIDE_UNIT_SIZE-1:0] m2vStride0_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride 0
wire [STRIDE_UNIT_SIZE-1:0] m2vStride1_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride 1
wire [STRIDE_UNIT_SIZE-1:0] m2vStride2_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride 2
wire [STRIDE_UNIT_SIZE-1:0] m2vStride3_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride 3
wire [STRIDE_UNIT_SIZE-1:0] m2vStride4_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride 4
wire [STRIDE_UNIT_SIZE-1:0] m2vStride5_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride 5
wire [STRIDE_UNIT_SIZE-1:0] m2vStride6_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride 6
wire [STRIDE_UNIT_SIZE-1:0] m2vStride7_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride 7
wire [STRIDE_UNIT_SIZE-1:0] m2vStride8_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride 8
wire [STRIDE_UNIT_SIZE-1:0] m2vStride9_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride 9
wire [STRIDE_UNIT_SIZE-1:0] m2vStride10_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride 10
wire [STRIDE_UNIT_SIZE-1:0] m2vStride11_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride 11
wire [STRIDE_UNIT_SIZE-1:0] m2vStride12_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride 12
wire [STRIDE_UNIT_SIZE-1:0] m2vStride13_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride 13
wire [STRIDE_UNIT_SIZE-1:0] m2vStride14_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride 14
wire [STRIDE_UNIT_SIZE-1:0] m2vStride15_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride 15
wire [STRIDE_UNIT_SIZE-1:0] m2vStride16_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride 16
columnSingleSrc_L1Route #(
	.QUAN_SIZE(QUAN_SIZE),
	.STRIDE_UNIT_SIZE(STRIDE_UNIT_SIZE),
	.STRIDE_WIDTH(STRIDE_WIDTH),
	.BITWIDTH_SHIFT_FACTOR($clog2(STRIDE_UNIT_SIZE-1))
) columnCNU_L1Route_u0 (
	.stride0_out_bit0_o (m2vStride0_bit[0]), // to VNUs of stride unit 0
	.stride0_out_bit1_o (m2vStride0_bit[1]), // to VNUs of stride unit 0
	.stride0_out_bit2_o (m2vStride0_bit[2]), // to VNUs of stride unit 0
	.stride1_out_bit0_o (m2vStride1_bit[0]), // to VNUs of stride unit 1
	.stride1_out_bit1_o (m2vStride1_bit[1]), // to VNUs of stride unit 1
	.stride1_out_bit2_o (m2vStride1_bit[2]), // to VNUs of stride unit 1
	.stride2_out_bit0_o (m2vStride2_bit[0]), // to VNUs of stride unit 2
	.stride2_out_bit1_o (m2vStride2_bit[1]), // to VNUs of stride unit 2
	.stride2_out_bit2_o (m2vStride2_bit[2]), // to VNUs of stride unit 2
	.stride3_out_bit0_o (m2vStride3_bit[0]), // to VNUs of stride unit 3
	.stride3_out_bit1_o (m2vStride3_bit[1]), // to VNUs of stride unit 3
	.stride3_out_bit2_o (m2vStride3_bit[2]), // to VNUs of stride unit 3
	.stride4_out_bit0_o (m2vStride4_bit[0]), // to VNUs of stride unit 4
	.stride4_out_bit1_o (m2vStride4_bit[1]), // to VNUs of stride unit 4
	.stride4_out_bit2_o (m2vStride4_bit[2]), // to VNUs of stride unit 4
	.stride5_out_bit0_o (m2vStride5_bit[0]), // to VNUs of stride unit 5
	.stride5_out_bit1_o (m2vStride5_bit[1]), // to VNUs of stride unit 5
	.stride5_out_bit2_o (m2vStride5_bit[2]), // to VNUs of stride unit 5
	.stride6_out_bit0_o (m2vStride6_bit[0]), // to VNUs of stride unit 6
	.stride6_out_bit1_o (m2vStride6_bit[1]), // to VNUs of stride unit 6
	.stride6_out_bit2_o (m2vStride6_bit[2]), // to VNUs of stride unit 6
	.stride7_out_bit0_o (m2vStride7_bit[0]), // to VNUs of stride unit 7
	.stride7_out_bit1_o (m2vStride7_bit[1]), // to VNUs of stride unit 7
	.stride7_out_bit2_o (m2vStride7_bit[2]), // to VNUs of stride unit 7
	.stride8_out_bit0_o (m2vStride8_bit[0]), // to VNUs of stride unit 8
	.stride8_out_bit1_o (m2vStride8_bit[1]), // to VNUs of stride unit 8
	.stride8_out_bit2_o (m2vStride8_bit[2]), // to VNUs of stride unit 8
	.stride9_out_bit0_o (m2vStride9_bit[0]), // to VNUs of stride unit 9
	.stride9_out_bit1_o (m2vStride9_bit[1]), // to VNUs of stride unit 9
	.stride9_out_bit2_o (m2vStride9_bit[2]), // to VNUs of stride unit 9
	.stride10_out_bit0_o (m2vStride10_bit[0]), // to VNUs of stride unit 10
	.stride10_out_bit1_o (m2vStride10_bit[1]), // to VNUs of stride unit 10
	.stride10_out_bit2_o (m2vStride10_bit[2]), // to VNUs of stride unit 10
	.stride11_out_bit0_o (m2vStride11_bit[0]), // to VNUs of stride unit 11
	.stride11_out_bit1_o (m2vStride11_bit[1]), // to VNUs of stride unit 11
	.stride11_out_bit2_o (m2vStride11_bit[2]), // to VNUs of stride unit 11
	.stride12_out_bit0_o (m2vStride12_bit[0]), // to VNUs of stride unit 12
	.stride12_out_bit1_o (m2vStride12_bit[1]), // to VNUs of stride unit 12
	.stride12_out_bit2_o (m2vStride12_bit[2]), // to VNUs of stride unit 12
	.stride13_out_bit0_o (m2vStride13_bit[0]), // to VNUs of stride unit 13
	.stride13_out_bit1_o (m2vStride13_bit[1]), // to VNUs of stride unit 13
	.stride13_out_bit2_o (m2vStride13_bit[2]), // to VNUs of stride unit 13
	.stride14_out_bit0_o (m2vStride14_bit[0]), // to VNUs of stride unit 14
	.stride14_out_bit1_o (m2vStride14_bit[1]), // to VNUs of stride unit 14
	.stride14_out_bit2_o (m2vStride14_bit[2]), // to VNUs of stride unit 14
	.stride15_out_bit0_o (m2vStride15_bit[0]), // to VNUs of stride unit 15
	.stride15_out_bit1_o (m2vStride15_bit[1]), // to VNUs of stride unit 15
	.stride15_out_bit2_o (m2vStride15_bit[2]), // to VNUs of stride unit 15
	.stride16_out_bit0_o (m2vStride16_bit[0]), // to VNUs of stride unit 16
	.stride16_out_bit1_o (m2vStride16_bit[1]), // to VNUs of stride unit 16
	.stride16_out_bit2_o (m2vStride16_bit[2]), // to VNUs of stride unit 16
	`ifdef DECODER_4bit
		.stride0_out_bit3_o (m2vStride0_bit[3]),
		.stride1_out_bit3_o (m2vStride1_bit[3]),
		.stride2_out_bit3_o (m2vStride2_bit[3]),
		.stride3_out_bit3_o (m2vStride3_bit[3]),
		.stride4_out_bit3_o (m2vStride4_bit[3]),
		.stride5_out_bit3_o (m2vStride5_bit[3]),
		.stride6_out_bit3_o (m2vStride6_bit[3]),
		.stride7_out_bit3_o (m2vStride7_bit[3]),
		.stride8_out_bit3_o (m2vStride8_bit[3]),
		.stride9_out_bit3_o (m2vStride9_bit[3]),
		.stride10_out_bit3_o (m2vStride10_bit[3]),
		.stride11_out_bit3_o (m2vStride11_bit[3]),
		.stride12_out_bit3_o (m2vStride12_bit[3]),
		.stride13_out_bit3_o (m2vStride13_bit[3]),
		.stride14_out_bit3_o (m2vStride14_bit[3]),
		.stride15_out_bit3_o (m2vStride15_bit[3]),
		.stride16_out_bit3_o (m2vStride16_bit[3]),
	`endif
	.stride0_bit0_i     (cnu2mem_stride0_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 0
	.stride0_bit1_i     (cnu2mem_stride0_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 0
	.stride0_bit2_i     (cnu2mem_stride0_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 0
	.stride1_bit0_i     (cnu2mem_stride1_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 1
	.stride1_bit1_i     (cnu2mem_stride1_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 1
	.stride1_bit2_i     (cnu2mem_stride1_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 1
	.stride2_bit0_i     (cnu2mem_stride2_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 2
	.stride2_bit1_i     (cnu2mem_stride2_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 2
	.stride2_bit2_i     (cnu2mem_stride2_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 2
	.stride3_bit0_i     (cnu2mem_stride3_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 3
	.stride3_bit1_i     (cnu2mem_stride3_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 3
	.stride3_bit2_i     (cnu2mem_stride3_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 3
	.stride4_bit0_i     (cnu2mem_stride4_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 4
	.stride4_bit1_i     (cnu2mem_stride4_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 4
	.stride4_bit2_i     (cnu2mem_stride4_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 4
	.stride5_bit0_i     (cnu2mem_stride5_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 5
	.stride5_bit1_i     (cnu2mem_stride5_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 5
	.stride5_bit2_i     (cnu2mem_stride5_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 5
	.stride6_bit0_i     (cnu2mem_stride6_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 6
	.stride6_bit1_i     (cnu2mem_stride6_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 6
	.stride6_bit2_i     (cnu2mem_stride6_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 6
	.stride7_bit0_i     (cnu2mem_stride7_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 7
	.stride7_bit1_i     (cnu2mem_stride7_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 7
	.stride7_bit2_i     (cnu2mem_stride7_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 7
	.stride8_bit0_i     (cnu2mem_stride8_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 8
	.stride8_bit1_i     (cnu2mem_stride8_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 8
	.stride8_bit2_i     (cnu2mem_stride8_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 8
	.stride9_bit0_i     (cnu2mem_stride9_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 9
	.stride9_bit1_i     (cnu2mem_stride9_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 9
	.stride9_bit2_i     (cnu2mem_stride9_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 9
	.stride10_bit0_i     (cnu2mem_stride10_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 10
	.stride10_bit1_i     (cnu2mem_stride10_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 10
	.stride10_bit2_i     (cnu2mem_stride10_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 10
	.stride11_bit0_i     (cnu2mem_stride11_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 11
	.stride11_bit1_i     (cnu2mem_stride11_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 11
	.stride11_bit2_i     (cnu2mem_stride11_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 11
	.stride12_bit0_i     (cnu2mem_stride12_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 12
	.stride12_bit1_i     (cnu2mem_stride12_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 12
	.stride12_bit2_i     (cnu2mem_stride12_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 12
	.stride13_bit0_i     (cnu2mem_stride13_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 13
	.stride13_bit1_i     (cnu2mem_stride13_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 13
	.stride13_bit2_i     (cnu2mem_stride13_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 13
	.stride14_bit0_i     (cnu2mem_stride14_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 14
	.stride14_bit1_i     (cnu2mem_stride14_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 14
	.stride14_bit2_i     (cnu2mem_stride14_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 14
	.stride15_bit0_i     (cnu2mem_stride15_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 15
	.stride15_bit1_i     (cnu2mem_stride15_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 15
	.stride15_bit2_i     (cnu2mem_stride15_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 15
	.stride16_bit0_i     (cnu2mem_stride16_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 16
	.stride16_bit1_i     (cnu2mem_stride16_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 16
	.stride16_bit2_i     (cnu2mem_stride16_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit 16
	`ifdef DECODER_4bit
		.stride0_bit3_i     (cnu2mem_stride0_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride1_bit3_i     (cnu2mem_stride1_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride2_bit3_i     (cnu2mem_stride2_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride3_bit3_i     (cnu2mem_stride3_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride4_bit3_i     (cnu2mem_stride4_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride5_bit3_i     (cnu2mem_stride5_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride6_bit3_i     (cnu2mem_stride6_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride7_bit3_i     (cnu2mem_stride7_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride8_bit3_i     (cnu2mem_stride8_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride9_bit3_i     (cnu2mem_stride9_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride10_bit3_i     (cnu2mem_stride10_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride11_bit3_i     (cnu2mem_stride11_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride12_bit3_i     (cnu2mem_stride12_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride13_bit3_i     (cnu2mem_stride13_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride14_bit3_i     (cnu2mem_stride14_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride15_bit3_i     (cnu2mem_stride15_bit3_i[STRIDE_UNIT_SIZE-1:0]),
		.stride16_bit3_i     (cnu2mem_stride16_bit3_i[STRIDE_UNIT_SIZE-1:0]),
	`endif
	.shift_factor        (L1_cnuBsShift_factor_i[$clog2(STRIDE_UNIT_SIZE-1)-1:0]),
	.sys_clk             (sys_clk),
	.rstn                (rstn)
);
generate
	for(strideUnit_id=0; strideUnit_id<STRIDE_UNIT_SIZE; strideUnit_id=strideUnit_id+1) begin : columnCNU_L2Route_inst
		msgPass2pageAlignIF #(
			.SHIFT_LENGTH        (STRIDE_WIDTH       ),
			.QUAN_SIZE           (QUAN_SIZE          )
		) columnCNU_L2Route (
			.msgPass2paOut_bit0_o      ({mem2vnu_stride16_bit0_o[strideUnit_id], mem2vnu_stride15_bit0_o[strideUnit_id], mem2vnu_stride14_bit0_o[strideUnit_id], mem2vnu_stride13_bit0_o[strideUnit_id], mem2vnu_stride12_bit0_o[strideUnit_id], mem2vnu_stride11_bit0_o[strideUnit_id], mem2vnu_stride10_bit0_o[strideUnit_id], mem2vnu_stride9_bit0_o[strideUnit_id], mem2vnu_stride8_bit0_o[strideUnit_id], mem2vnu_stride7_bit0_o[strideUnit_id], mem2vnu_stride6_bit0_o[strideUnit_id], mem2vnu_stride5_bit0_o[strideUnit_id], mem2vnu_stride4_bit0_o[strideUnit_id], mem2vnu_stride3_bit0_o[strideUnit_id], mem2vnu_stride2_bit0_o[strideUnit_id], mem2vnu_stride1_bit0_o[strideUnit_id], mem2vnu_stride0_bit0_o[strideUnit_id]}),
			.msgPass2paOut_bit1_o      ({mem2vnu_stride16_bit1_o[strideUnit_id], mem2vnu_stride15_bit1_o[strideUnit_id], mem2vnu_stride14_bit1_o[strideUnit_id], mem2vnu_stride13_bit1_o[strideUnit_id], mem2vnu_stride12_bit1_o[strideUnit_id], mem2vnu_stride11_bit1_o[strideUnit_id], mem2vnu_stride10_bit1_o[strideUnit_id], mem2vnu_stride9_bit1_o[strideUnit_id], mem2vnu_stride8_bit1_o[strideUnit_id], mem2vnu_stride7_bit1_o[strideUnit_id], mem2vnu_stride6_bit1_o[strideUnit_id], mem2vnu_stride5_bit1_o[strideUnit_id], mem2vnu_stride4_bit1_o[strideUnit_id], mem2vnu_stride3_bit1_o[strideUnit_id], mem2vnu_stride2_bit1_o[strideUnit_id], mem2vnu_stride1_bit1_o[strideUnit_id], mem2vnu_stride0_bit1_o[strideUnit_id]}),
			.msgPass2paOut_bit2_o      ({mem2vnu_stride16_bit2_o[strideUnit_id], mem2vnu_stride15_bit2_o[strideUnit_id], mem2vnu_stride14_bit2_o[strideUnit_id], mem2vnu_stride13_bit2_o[strideUnit_id], mem2vnu_stride12_bit2_o[strideUnit_id], mem2vnu_stride11_bit2_o[strideUnit_id], mem2vnu_stride10_bit2_o[strideUnit_id], mem2vnu_stride9_bit2_o[strideUnit_id], mem2vnu_stride8_bit2_o[strideUnit_id], mem2vnu_stride7_bit2_o[strideUnit_id], mem2vnu_stride6_bit2_o[strideUnit_id], mem2vnu_stride5_bit2_o[strideUnit_id], mem2vnu_stride4_bit2_o[strideUnit_id], mem2vnu_stride3_bit2_o[strideUnit_id], mem2vnu_stride2_bit2_o[strideUnit_id], mem2vnu_stride1_bit2_o[strideUnit_id], mem2vnu_stride0_bit2_o[strideUnit_id]}),

			.swIn_bit0_i               ({m2vStride16_bit[0][strideUnit_id], m2vStride15_bit[0][strideUnit_id], m2vStride14_bit[0][strideUnit_id], m2vStride13_bit[0][strideUnit_id], m2vStride12_bit[0][strideUnit_id], m2vStride11_bit[0][strideUnit_id], m2vStride10_bit[0][strideUnit_id], m2vStride9_bit[0][strideUnit_id], m2vStride8_bit[0][strideUnit_id], m2vStride7_bit[0][strideUnit_id], m2vStride6_bit[0][strideUnit_id], m2vStride5_bit[0][strideUnit_id], m2vStride4_bit[0][strideUnit_id], m2vStride3_bit[0][strideUnit_id], m2vStride2_bit[0][strideUnit_id], m2vStride1_bit[0][strideUnit_id], m2vStride0_bit[0][strideUnit_id]}),
			.swIn_bit1_i               ({m2vStride16_bit[1][strideUnit_id], m2vStride15_bit[1][strideUnit_id], m2vStride14_bit[1][strideUnit_id], m2vStride13_bit[1][strideUnit_id], m2vStride12_bit[1][strideUnit_id], m2vStride11_bit[1][strideUnit_id], m2vStride10_bit[1][strideUnit_id], m2vStride9_bit[1][strideUnit_id], m2vStride8_bit[1][strideUnit_id], m2vStride7_bit[1][strideUnit_id], m2vStride6_bit[1][strideUnit_id], m2vStride5_bit[1][strideUnit_id], m2vStride4_bit[1][strideUnit_id], m2vStride3_bit[1][strideUnit_id], m2vStride2_bit[1][strideUnit_id], m2vStride1_bit[1][strideUnit_id], m2vStride0_bit[1][strideUnit_id]}),
			.swIn_bit2_i               ({m2vStride16_bit[2][strideUnit_id], m2vStride15_bit[2][strideUnit_id], m2vStride14_bit[2][strideUnit_id], m2vStride13_bit[2][strideUnit_id], m2vStride12_bit[2][strideUnit_id], m2vStride11_bit[2][strideUnit_id], m2vStride10_bit[2][strideUnit_id], m2vStride9_bit[2][strideUnit_id], m2vStride8_bit[2][strideUnit_id], m2vStride7_bit[2][strideUnit_id], m2vStride6_bit[2][strideUnit_id], m2vStride5_bit[2][strideUnit_id], m2vStride4_bit[2][strideUnit_id], m2vStride3_bit[2][strideUnit_id], m2vStride2_bit[2][strideUnit_id], m2vStride1_bit[2][strideUnit_id], m2vStride0_bit[2][strideUnit_id]}),
		`ifdef DECODER_4bit
			.msgPass2paOut_bit3_o      ({mem2vnu_stride16_bit3_o[strideUnit_id], mem2vnu_stride15_bit3_o[strideUnit_id], mem2vnu_stride14_bit3_o[strideUnit_id], mem2vnu_stride13_bit3_o[strideUnit_id], mem2vnu_stride12_bit3_o[strideUnit_id], mem2vnu_stride11_bit3_o[strideUnit_id], mem2vnu_stride10_bit3_o[strideUnit_id], mem2vnu_stride9_bit3_o[strideUnit_id], mem2vnu_stride8_bit3_o[strideUnit_id], mem2vnu_stride7_bit3_o[strideUnit_id], mem2vnu_stride6_bit3_o[strideUnit_id], mem2vnu_stride5_bit3_o[strideUnit_id], mem2vnu_stride4_bit3_o[strideUnit_id], mem2vnu_stride3_bit3_o[strideUnit_id], mem2vnu_stride2_bit3_o[strideUnit_id], mem2vnu_stride1_bit3_o[strideUnit_id], mem2vnu_stride0_bit3_o[strideUnit_id]}),
			.swIn_bit3_i               ({m2vStride16_bit[3][strideUnit_id], m2vStride15_bit[3][strideUnit_id], m2vStride14_bit[3][strideUnit_id], m2vStride13_bit[3][strideUnit_id], m2vStride12_bit[3][strideUnit_id], m2vStride11_bit[3][strideUnit_id], m2vStride10_bit[3][strideUnit_id], m2vStride9_bit[3][strideUnit_id], m2vStride8_bit[3][strideUnit_id], m2vStride7_bit[3][strideUnit_id], m2vStride6_bit[3][strideUnit_id], m2vStride5_bit[3][strideUnit_id], m2vStride4_bit[3][strideUnit_id], m2vStride3_bit[3][strideUnit_id], m2vStride2_bit[3][strideUnit_id], m2vStride1_bit[3][strideUnit_id], m2vStride0_bit[3][strideUnit_id]}),
		`endif
			.L1_paShift_factor_i ({L2_vnuPaShift_factor_bit4_i[strideUnit_id], L2_vnuPaShift_factor_bit3_i[strideUnit_id], L2_vnuPaShift_factor_bit2_i[strideUnit_id], L2_vnuPaShift_factor_bit1_i[strideUnit_id], L2_vnuPaShift_factor_bit0_i[strideUnit_id]}),
			.sys_clk                   (sys_clk),
			.rstn                      (rstn)
		);
	end
endgenerate
endmodule
`endif // MSGPASS_SOL_3
// partial_msgPass_wrapper.pa2chRAM_stride{0,1,2}_bit{0,1,2,3}_o -> ch_msg_ram.v 
// /*--------------------------------------------------------------------------*/ 
// // Multiplexing the sources of Write-Data of Channel Buffer, as follows:
// // 		1) coded_block (from AWGN generator); 
// // 		2) vnu_msg_in (from output of message_pass.PA)
// /*--------------------------------------------------------------------------*/
// assign ch_ram_din[`CH_DATA_WIDTH-1:0] = (ch_ram_init_we == 1'b1) ? ch_msg_genIn[`CH_DATA_WIDTH-1:0] : pa_to_ch_ram[`CH_DATA_WIDTH-1:0];															  
