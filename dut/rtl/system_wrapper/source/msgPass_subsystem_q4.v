`timescale 1ns/1ps

/**
* Latest date: 12th July, 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: memShare_control_wrapper
* 
* # I/F
* 1) Output:
*
* 2) Input:
*
* # Param

* # Description
        Register list:
            L1PA_SPR,
            L1PA_PSRA,
            L1PA_START,
            L1PA_END
* # Dependencies
    1) Preprocessor to add any new special function register
        ./memShare_config.vh
*
* # Remark
*	Type-0 Register: 7 bits wide
    Type-0 Register Array: 64 page
    Memory Cell: 64x7bit
*		LUT: 11,214
        Logic LUT: 11,207
        LUTRAM: 7
		FF: 7,654
        I/O: 6,584
        Freq: 400MHz
        WNS: +1.998 ns
        TNS: 0.0 ns
        WHS: +0.093 ns
        THS: 0.0 ns
        WPWS: 0.718 ns
        TPWS: 0.0 ns
**/
`include "define.vh"
`include "memShare_config.vh"

module msgPass_subsystem_q4 #(
    //----------------------------------------------------------
    // L1BS
    //----------------------------------------------------------
    parameter L1BSOUT_EXTRA_DELAY = `L1BSOUT_EXTRA_DELAY, //! Additional delay on L1BS output for timing sync.
    //----------------------------------------------------------
    // memShare_control wrapper
    //----------------------------------------------------------
    // General usages
    parameter MAX_MEMSHARE_INSTANCES = `MAX_MEMSHARE_INSTANCES, //! //! Maximum number of required L1PA shfit patterns to complete an instance of shared memory allocation
    // Access-request generator
    parameter SHARE_GROUP_SIZE = `SHARE_GROUP_SIZE, //! Number of requestors joining a share group (GP1+GP2)
    parameter RQST_ADDR_BITWIDTH = `RQST_ADDR_BITWIDTH, //! Bit width of every requestor's column address
    parameter MODE_BITWIDTH = `RQST_MODE_BITWIDTH, //! Bit width of "mode set signals"
    parameter MEMSHARE_RQSTFLAG_CYCLE = `MEMSHARE_RQSTFLAG_CYCLE,
    // L1PA regFile-mapping unit
    parameter RQST_BITWIDTH = `SHARE_GROUP_SIZE, //! Size of request flag
    parameter REGFILE_PAGE_NUM = `L1PA_REGFILE_PAGE_NUM, //! Number of pages in memShare_regFile
    parameter REGFILE_ADDR_WIDTH = RQST_BITWIDTH,
    parameter L1PA_SHIFT_BITWIDTH = $clog2(RQST_BITWIDTH),
    parameter MEMSHARE_SHIFTDELTA_ALU_CYCLE = `MEMSHARE_SHIFTDELTA_ALU_CYCLE,
    // L1PA register file
    parameter SHIFT_BITWIDTH = `L1PA_SHIFT_BITWIDTH,
    parameter DELTA_BITWIDTH = `L1PA_SHIFT_DELTA_WIDTH,
    parameter SEQ_PTR_BITWIDTH = `L1PA_SEQ_PTR_BITWIDTH, // Bit width of isGtr
    parameter SEQ_SIZE = `L1PA_SEQ_SIZE, //! Maximum size of one L1PA shfit pattern sequence
    parameter TYPE0_ADDR_BITWIDTH = `L1PA_REGFILE_ADDR_WIDTH,
    parameter TYPE0_REG_BITWIDTH = `L1PA_REGFILE_PAGE_WIDTH,
    parameter TYPE0_PAGE_NUM =`L1PA_REGFILE_PAGE_NUM,
    parameter MEMSHARE_REGFILE_RD_CYCLE = `MEMSHARE_REGFILE_RD_CYCLE,
    //----------------------------------------------------------
    // shfit offset generator for L1PA
    //----------------------------------------------------------
    parameter SHIFT_OFFSET_DELAY = `SHIFT_OFFSET_DELAY,
    //----------------------------------------------------------
    // lowend_partial_msgPass_wrapper
    //----------------------------------------------------------
	parameter QUAN_SIZE = 4,
	parameter ROW_SPLIT_FACTOR = 5, // Ns=	parameter CHECK_PARALLELISM = 51,
	parameter ROW_CHUNK_SIZE = 51,
	parameter STRIDE_WIDTH = 5,
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
    //----------------------------------------------------------
    // memShare_control wrapper
    //----------------------------------------------------------
    // Access-request generator
    input wire [ROW_CHUNK_SIZE*RQST_ADDR_BITWIDTH-1:0] mem2memShareCtrl_stride0_i,
    input wire [ROW_CHUNK_SIZE*RQST_ADDR_BITWIDTH-1:0] mem2memShareCtrl_stride1_i,
    input wire [ROW_CHUNK_SIZE*RQST_ADDR_BITWIDTH-1:0] mem2memShareCtrl_stride2_i,
    input wire [ROW_CHUNK_SIZE*RQST_ADDR_BITWIDTH-1:0] mem2memShareCtrl_stride3_i,
    input wire [ROW_CHUNK_SIZE*RQST_ADDR_BITWIDTH-1:0] mem2memShareCtrl_stride4_i,
    input wire [MODE_BITWIDTH-1:0] modeSet_i,
    // L1PA register file
    input wire [TYPE0_ADDR_BITWIDTH-1:0] l1pa_regFile_waddr_i,
    input wire [TYPE0_REG_BITWIDTH-1:0] l1pa_regFile_wdata_i,
    input wire l1pa_regFile_we_i,
    //----------------------------------------------------------
    // lowend_partial_msgPass_wrapper
    //----------------------------------------------------------
    /*====== Stride unit 0 =================================================== */
	// The memory Dout port to variable/check nodes as instrinsic messages
	output wire [ROW_CHUNK_SIZE-1:0]  shift2node_stride0_bit0_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2node_stride0_bit1_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2node_stride0_bit2_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2rowOffset_stride0_bit0_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2rowOffset_stride0_bit1_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2rowOffset_stride0_bit2_o,
	output wire [ROW_CHUNK_SIZE-1:0]  mux2ctrl_stride0_bit0_o,
	output wire [ROW_CHUNK_SIZE-1:0]  mux2ctrl_stride0_bit1_o,
	output wire [ROW_CHUNK_SIZE-1:0]  mux2ctrl_stride0_bit2_o,
	// The varible/check extrinsic message written back onto memory through BS and PA
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride0_bit0_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride0_bit1_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride0_bit2_i,
	// The 2nd variable extrinsic messages as row address of the sebsequent IB-LUT 
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride0_bit0_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride0_bit1_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride0_bit2_i,
	// The channel message input
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride0_bit0_i,
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride0_bit1_i,
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride0_bit2_i,
`ifdef DECODER_4bit
	output wire [ROW_CHUNK_SIZE-1:0] shift2node_stride0_bit3_o,
	output wire [ROW_CHUNK_SIZE-1:0] shift2rowOffset_stride0_bit3_o,
	output wire [ROW_CHUNK_SIZE-1:0] mux2ctrl_stride0_bit3_o,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride0_bit3_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride0_bit3_i,
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride0_bit3_i,
`endif
    /*====== Stride unit 1 =================================================== */
	// The memory Dout port to variable/check nodes as instrinsic messages
	output wire [ROW_CHUNK_SIZE-1:0]  shift2node_stride1_bit0_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2node_stride1_bit1_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2node_stride1_bit2_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2rowOffset_stride1_bit0_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2rowOffset_stride1_bit1_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2rowOffset_stride1_bit2_o,
	output wire [ROW_CHUNK_SIZE-1:0]  mux2ctrl_stride1_bit0_o,
	output wire [ROW_CHUNK_SIZE-1:0]  mux2ctrl_stride1_bit1_o,
	output wire [ROW_CHUNK_SIZE-1:0]  mux2ctrl_stride1_bit2_o,
	// The varible/check extrinsic message written back onto memory through BS and PA
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride1_bit0_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride1_bit1_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride1_bit2_i,
	// The 2nd variable extrinsic messages as row address of the sebsequent IB-LUT 
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride1_bit0_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride1_bit1_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride1_bit2_i,
	// The channel message input
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride1_bit0_i,
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride1_bit1_i,
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride1_bit2_i,
`ifdef DECODER_4bit
	output wire [ROW_CHUNK_SIZE-1:0] shift2node_stride1_bit3_o,
	output wire [ROW_CHUNK_SIZE-1:0] shift2rowOffset_stride1_bit3_o,
	output wire [ROW_CHUNK_SIZE-1:0] mux2ctrl_stride1_bit3_o,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride1_bit3_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride1_bit3_i,
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride1_bit3_i,
`endif
    /*====== Stride unit 2 =================================================== */
	// The memory Dout port to variable/check nodes as instrinsic messages
	output wire [ROW_CHUNK_SIZE-1:0]  shift2node_stride2_bit0_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2node_stride2_bit1_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2node_stride2_bit2_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2rowOffset_stride2_bit0_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2rowOffset_stride2_bit1_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2rowOffset_stride2_bit2_o,
	output wire [ROW_CHUNK_SIZE-1:0]  mux2ctrl_stride2_bit0_o,
	output wire [ROW_CHUNK_SIZE-1:0]  mux2ctrl_stride2_bit1_o,
	output wire [ROW_CHUNK_SIZE-1:0]  mux2ctrl_stride2_bit2_o,
	// The varible/check extrinsic message written back onto memory through BS and PA
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride2_bit0_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride2_bit1_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride2_bit2_i,
	// The 2nd variable extrinsic messages as row address of the sebsequent IB-LUT 
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride2_bit0_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride2_bit1_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride2_bit2_i,
	// The channel message input
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride2_bit0_i,
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride2_bit1_i,
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride2_bit2_i,
`ifdef DECODER_4bit
	output wire [ROW_CHUNK_SIZE-1:0] shift2node_stride2_bit3_o,
	output wire [ROW_CHUNK_SIZE-1:0] shift2rowOffset_stride2_bit3_o,
	output wire [ROW_CHUNK_SIZE-1:0] mux2ctrl_stride2_bit3_o,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride2_bit3_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride2_bit3_i,
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride2_bit3_i,
`endif
    /*====== Stride unit 3 =================================================== */
	// The memory Dout port to variable/check nodes as instrinsic messages
	output wire [ROW_CHUNK_SIZE-1:0]  shift2node_stride3_bit0_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2node_stride3_bit1_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2node_stride3_bit2_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2rowOffset_stride3_bit0_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2rowOffset_stride3_bit1_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2rowOffset_stride3_bit2_o,
	output wire [ROW_CHUNK_SIZE-1:0]  mux2ctrl_stride3_bit0_o,
	output wire [ROW_CHUNK_SIZE-1:0]  mux2ctrl_stride3_bit1_o,
	output wire [ROW_CHUNK_SIZE-1:0]  mux2ctrl_stride3_bit2_o,
	// The varible/check extrinsic message written back onto memory through BS and PA
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride3_bit0_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride3_bit1_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride3_bit2_i,
	// The 2nd variable extrinsic messages as row address of the sebsequent IB-LUT 
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride3_bit0_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride3_bit1_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride3_bit2_i,
	// The channel message input
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride3_bit0_i,
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride3_bit1_i,
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride3_bit2_i,
`ifdef DECODER_4bit
	output wire [ROW_CHUNK_SIZE-1:0] shift2node_stride3_bit3_o,
	output wire [ROW_CHUNK_SIZE-1:0] shift2rowOffset_stride3_bit3_o,
	output wire [ROW_CHUNK_SIZE-1:0] mux2ctrl_stride3_bit3_o,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride3_bit3_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride3_bit3_i,
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride3_bit3_i,
`endif
    /*====== Stride unit 4 =================================================== */
	// The memory Dout port to variable/check nodes as instrinsic messages
	output wire [ROW_CHUNK_SIZE-1:0]  shift2node_stride4_bit0_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2node_stride4_bit1_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2node_stride4_bit2_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2rowOffset_stride4_bit0_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2rowOffset_stride4_bit1_o,
	output wire [ROW_CHUNK_SIZE-1:0]  shift2rowOffset_stride4_bit2_o,
	output wire [ROW_CHUNK_SIZE-1:0]  mux2ctrl_stride4_bit0_o,
	output wire [ROW_CHUNK_SIZE-1:0]  mux2ctrl_stride4_bit1_o,
	output wire [ROW_CHUNK_SIZE-1:0]  mux2ctrl_stride4_bit2_o,
	// The varible/check extrinsic message written back onto memory through BS and PA
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride4_bit0_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride4_bit1_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride4_bit2_i,
	// The 2nd variable extrinsic messages as row address of the sebsequent IB-LUT 
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride4_bit0_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride4_bit1_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride4_bit2_i,
	// The channel message input
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride4_bit0_i,
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride4_bit1_i,
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride4_bit2_i,
`ifdef DECODER_4bit
	output wire [ROW_CHUNK_SIZE-1:0] shift2node_stride4_bit3_o,
	output wire [ROW_CHUNK_SIZE-1:0] shift2rowOffset_stride4_bit3_o,
	output wire [ROW_CHUNK_SIZE-1:0] mux2ctrl_stride4_bit3_o,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2shift_stride4_bit3_i,
	input wire [ROW_CHUNK_SIZE-1:0]  mem2mux_stride4_bit3_i,
	input wire [ROW_CHUNK_SIZE-1:0]  chRAM2mux_stride4_bit3_i,
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
    // L1PA shfit control signal generation
    input wire [ROW_CHUNK_SIZE-1:0] L1_deltaFFrstn_shareGroup,
	// The latest and previous shift offset values from Shift offset generator, used for L1PAs
	output wire [ROW_CHUNK_SIZE-1:0] L2_sOffsetNew_bit0_o, // Current (the latest) shifter offset[bit_0]
	output wire [ROW_CHUNK_SIZE-1:0] L2_sOffsetNew_bit1_o, // Current (the latest) shifter offset[bit_1]
	output wire [ROW_CHUNK_SIZE-1:0] L2_sOffsetNew_bit2_o, // Current (the latest) shifter offset[bit_2]
	input wire  [ROW_CHUNK_SIZE-1:0] L2_sOffsetOld_bit0_i, // shifter offset[bit_0]
	input wire  [ROW_CHUNK_SIZE-1:0] L2_sOffsetOld_bit1_i, // shifter offset[bit_1]
	input wire  [ROW_CHUNK_SIZE-1:0] L2_sOffsetOld_bit2_i, // shifter offset[bit_2]
	input wire is_vnF0_i, // To indicate that if decoder system is in VNU.F0 phase
	input wire is_preV2CPerm_i, // To indicate that if decoder system is in phase of preprocessing V2C permuation
	input wire [$clog2(STRIDE_WIDTH)-1:0] shareGroup_size,
	// The level-2 page alignment (bus combiner) for aligning variable/check node incoming messages
	input wire [ROW_CHUNK_SIZE-1:0] L2_nodePaLoad_factor_bit0_i, // shifter factor[bit_0]
	input wire [ROW_CHUNK_SIZE-1:0] L2_nodePaLoad_factor_bit1_i, // shifter factor[bit_1]
	input wire [ROW_CHUNK_SIZE-1:0] L2_nodePaLoad_factor_bit2_i, // shifter factor[bit_2]
	input wire [ROW_CHUNK_SIZE-1:0] L2_nodePaLoad_factor_bit3_i, // shifter factor[bit_3]
	input wire [ROW_CHUNK_SIZE-1:0] L2_nodePaLoad_factor_bit4_i, // shifter factor[bit_4]
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
    //----------------------------------------------------------
    // Common control
    //----------------------------------------------------------
    input wire rstn,
    input wire sys_clk
);

// To vectorise in/out of memShare_control wrapper
wire [(RQST_ADDR_BITWIDTH*SHARE_GROUP_SIZE)-1:0] rqstAddr_shareGroup [0:ROW_CHUNK_SIZE-1];
wire [L1PA_SHIFT_BITWIDTH-1:0] l1pa_shift_shareGroup [0:ROW_CHUNK_SIZE-1]; //! shift control instructing the L1PA
wire [ROW_CHUNK_SIZE-1:0] l1pa_isGtr_shareGroup; //! 1: currently accessed L1PA_SPR is the last pattern in the chosen L1PA shift sequence
// To Vectorise in/out of lowend_partial_msgPass_wrapper
wire [ROW_CHUNK_SIZE-1:0] L2_nodePaShift_factor_bit0_net; // shifter factor[bit_0]
wire [ROW_CHUNK_SIZE-1:0] L2_nodePaShift_factor_bit1_net; // shifter factor[bit_1]
wire [ROW_CHUNK_SIZE-1:0] L2_nodePaShift_factor_bit2_net; // shifter factor[bit_2]
genvar gp_id; // share group index
generate
	for (gp_id=0; gp_id<ROW_CHUNK_SIZE; gp_id=gp_id+1) begin: memShare_control_stride
        memShare_control_wrapper #(
            .SHARE_GROUP_SIZE(SHARE_GROUP_SIZE),
            .RQST_ADDR_BITWIDTH(RQST_ADDR_BITWIDTH),
            .MODE_BITWIDTH(MODE_BITWIDTH),
            .RQST_BITWIDTH(RQST_BITWIDTH),
            .REGFILE_PAGE_NUM(REGFILE_PAGE_NUM),
            .MAX_MEMSHARE_INSTANCES(MAX_MEMSHARE_INSTANCES),
            .REGFILE_ADDR_WIDTH(REGFILE_ADDR_WIDTH),
            .L1PA_SHIFT_BITWIDTH(L1PA_SHIFT_BITWIDTH),
            .SHIFT_BITWIDTH(SHIFT_BITWIDTH),
            .DELTA_BITWIDTH(DELTA_BITWIDTH),
            .SEQ_PTR_BITWIDTH(SEQ_PTR_BITWIDTH),
            .SEQ_SIZE(SEQ_SIZE),
            .TYPE0_ADDR_BITWIDTH(TYPE0_ADDR_BITWIDTH),
            .TYPE0_REG_BITWIDTH(TYPE0_REG_BITWIDTH),
            .TYPE0_PAGE_NUM(TYPE0_PAGE_NUM),
            .RQST_FLAG_CYCLE      (MEMSHARE_RQSTFLAG_CYCLE),
            .REGFILE_RD_CYCLE     (MEMSHARE_REGFILE_RD_CYCLE),
            .SHIFTDELTA_ALU_CYCLE (MEMSHARE_SHIFTDELTA_ALU_CYCLE)
        ) memShare_control (
            .l1pa_shift_o     (l1pa_shift_shareGroup[gp_id]),
            .isGtr_o          (l1pa_isGtr_shareGroup[gp_id]),

            .rqst_addr_i      (rqstAddr_shareGroup[gp_id]),
            .modeSet_i        (modeSet_i),
            .regType0_waddr_i (l1pa_regFile_waddr_i),
            .regType0_wdata_i (l1pa_regFile_wdata_i),
            .regType0_we_i    (l1pa_regFile_we_i),
            .deltaPipe_rstn   (L1_deltaFFrstn_shareGroup[gp_id]),
            .rstn             (rstn),
            .sys_clk          (sys_clk)
        );
        // To vectorise in/out of memShare_control wrapper
		localparam msb_temp = (gp_id+1)*RQST_ADDR_BITWIDTH-1;
		localparam lsb_temp = gp_id*RQST_ADDR_BITWIDTH;
		assign rqstAddr_shareGroup[gp_id] = {
						mem2memShareCtrl_stride4_i[msb_temp:lsb_temp],
						mem2memShareCtrl_stride3_i[msb_temp:lsb_temp],
						mem2memShareCtrl_stride2_i[msb_temp:lsb_temp],
						mem2memShareCtrl_stride1_i[msb_temp:lsb_temp],
						mem2memShareCtrl_stride0_i[msb_temp:lsb_temp]
		};
        // To Vectorise in/out of lowend_partial_msgPass_wrapper
        assign L2_nodePaShift_factor_bit0_net[gp_id] = l1pa_shift_shareGroup[gp_id][0];
        assign L2_nodePaShift_factor_bit1_net[gp_id] = l1pa_shift_shareGroup[gp_id][1];
        assign L2_nodePaShift_factor_bit2_net[gp_id] = l1pa_shift_shareGroup[gp_id][2];    
	end
endgenerate

lowend_partial_msgPass_wrapper #(
    .QUAN_SIZE(QUAN_SIZE),
    .ROW_SPLIT_FACTOR(ROW_SPLIT_FACTOR),
    .STRIDE_UNIT_SIZE(ROW_CHUNK_SIZE),
    .STRIDE_WIDTH(STRIDE_WIDTH),
    .LAYER_NUM(LAYER_NUM),
    .SHIFT_OFFSET_DELAY(SHIFT_OFFSET_DELAY),
    .RAM_PORTA_RANGE(RAM_PORTA_RANGE),
    .RAM_PORTB_RANGE(RAM_PORTB_RANGE),
    .MEM_DEVICE_NUM(MEM_DEVICE_NUM),
    .DEPTH(DEPTH),
    .DATA_WIDTH(DATA_WIDTH),
    .FRAG_DATA_WIDTH(FRAG_DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .MAX_MEMSHARE_INSTANCES (MAX_MEMSHARE_INSTANCES)
) lowend_partial_msgPass_wrapper (
    .shift2node_stride0_bit0_o      (shift2node_stride0_bit0_o),
    .shift2node_stride0_bit1_o      (shift2node_stride0_bit1_o),
    .shift2node_stride0_bit2_o      (shift2node_stride0_bit2_o),
    .shift2rowOffset_stride0_bit0_o (shift2rowOffset_stride0_bit0_o),
    .shift2rowOffset_stride0_bit1_o (shift2rowOffset_stride0_bit1_o),
    .shift2rowOffset_stride0_bit2_o (shift2rowOffset_stride0_bit2_o),
    .mux2ctrl_stride0_bit0_o        (mux2ctrl_stride0_bit0_o),
    .mux2ctrl_stride0_bit1_o        (mux2ctrl_stride0_bit1_o),
    .mux2ctrl_stride0_bit2_o        (mux2ctrl_stride0_bit2_o),
    .mem2shift_stride0_bit0_i       (mem2shift_stride0_bit0_i),
    .mem2shift_stride0_bit1_i       (mem2shift_stride0_bit1_i),
    .mem2shift_stride0_bit2_i       (mem2shift_stride0_bit2_i),
    .mem2mux_stride0_bit0_i         (mem2mux_stride0_bit0_i),
    .mem2mux_stride0_bit1_i         (mem2mux_stride0_bit1_i),
    .mem2mux_stride0_bit2_i         (mem2mux_stride0_bit2_i),
    .chRAM2mux_stride0_bit0_i       (chRAM2mux_stride0_bit0_i),
    .chRAM2mux_stride0_bit1_i       (chRAM2mux_stride0_bit1_i),
    .chRAM2mux_stride0_bit2_i       (chRAM2mux_stride0_bit2_i),
    .shift2node_stride0_bit3_o      (shift2node_stride0_bit3_o),
    .shift2rowOffset_stride0_bit3_o (shift2rowOffset_stride0_bit3_o),
    .mux2ctrl_stride0_bit3_o        (mux2ctrl_stride0_bit3_o),
    .mem2shift_stride0_bit3_i       (mem2shift_stride0_bit3_i),
    .mem2mux_stride0_bit3_i         (mem2mux_stride0_bit3_i),
    .chRAM2mux_stride0_bit3_i       (chRAM2mux_stride0_bit3_i),
    .shift2node_stride1_bit0_o      (shift2node_stride1_bit0_o),
    .shift2node_stride1_bit1_o      (shift2node_stride1_bit1_o),
    .shift2node_stride1_bit2_o      (shift2node_stride1_bit2_o),
    .shift2rowOffset_stride1_bit0_o (shift2rowOffset_stride1_bit0_o),
    .shift2rowOffset_stride1_bit1_o (shift2rowOffset_stride1_bit1_o),
    .shift2rowOffset_stride1_bit2_o (shift2rowOffset_stride1_bit2_o),
    .mux2ctrl_stride1_bit0_o        (mux2ctrl_stride1_bit0_o),
    .mux2ctrl_stride1_bit1_o        (mux2ctrl_stride1_bit1_o),
    .mux2ctrl_stride1_bit2_o        (mux2ctrl_stride1_bit2_o),
    .mem2shift_stride1_bit0_i       (mem2shift_stride1_bit0_i),
    .mem2shift_stride1_bit1_i       (mem2shift_stride1_bit1_i),
    .mem2shift_stride1_bit2_i       (mem2shift_stride1_bit2_i),
    .mem2mux_stride1_bit0_i         (mem2mux_stride1_bit0_i),
    .mem2mux_stride1_bit1_i         (mem2mux_stride1_bit1_i),
    .mem2mux_stride1_bit2_i         (mem2mux_stride1_bit2_i),
    .chRAM2mux_stride1_bit0_i       (chRAM2mux_stride1_bit0_i),
    .chRAM2mux_stride1_bit1_i       (chRAM2mux_stride1_bit1_i),
    .chRAM2mux_stride1_bit2_i       (chRAM2mux_stride1_bit2_i),
    .shift2node_stride1_bit3_o      (shift2node_stride1_bit3_o),
    .shift2rowOffset_stride1_bit3_o (shift2rowOffset_stride1_bit3_o),
    .mux2ctrl_stride1_bit3_o        (mux2ctrl_stride1_bit3_o),
    .mem2shift_stride1_bit3_i       (mem2shift_stride1_bit3_i),
    .mem2mux_stride1_bit3_i         (mem2mux_stride1_bit3_i),
    .chRAM2mux_stride1_bit3_i       (chRAM2mux_stride1_bit3_i),
    .shift2node_stride2_bit0_o      (shift2node_stride2_bit0_o),
    .shift2node_stride2_bit1_o      (shift2node_stride2_bit1_o),
    .shift2node_stride2_bit2_o      (shift2node_stride2_bit2_o),
    .shift2rowOffset_stride2_bit0_o (shift2rowOffset_stride2_bit0_o),
    .shift2rowOffset_stride2_bit1_o (shift2rowOffset_stride2_bit1_o),
    .shift2rowOffset_stride2_bit2_o (shift2rowOffset_stride2_bit2_o),
    .mux2ctrl_stride2_bit0_o        (mux2ctrl_stride2_bit0_o),
    .mux2ctrl_stride2_bit1_o        (mux2ctrl_stride2_bit1_o),
    .mux2ctrl_stride2_bit2_o        (mux2ctrl_stride2_bit2_o),
    .mem2shift_stride2_bit0_i       (mem2shift_stride2_bit0_i),
    .mem2shift_stride2_bit1_i       (mem2shift_stride2_bit1_i),
    .mem2shift_stride2_bit2_i       (mem2shift_stride2_bit2_i),
    .mem2mux_stride2_bit0_i         (mem2mux_stride2_bit0_i),
    .mem2mux_stride2_bit1_i         (mem2mux_stride2_bit1_i),
    .mem2mux_stride2_bit2_i         (mem2mux_stride2_bit2_i),
    .chRAM2mux_stride2_bit0_i       (chRAM2mux_stride2_bit0_i),
    .chRAM2mux_stride2_bit1_i       (chRAM2mux_stride2_bit1_i),
    .chRAM2mux_stride2_bit2_i       (chRAM2mux_stride2_bit2_i),
    .shift2node_stride2_bit3_o      (shift2node_stride2_bit3_o),
    .shift2rowOffset_stride2_bit3_o (shift2rowOffset_stride2_bit3_o),
    .mux2ctrl_stride2_bit3_o        (mux2ctrl_stride2_bit3_o),
    .mem2shift_stride2_bit3_i       (mem2shift_stride2_bit3_i),
    .mem2mux_stride2_bit3_i         (mem2mux_stride2_bit3_i),
    .chRAM2mux_stride2_bit3_i       (chRAM2mux_stride2_bit3_i),
    .shift2node_stride3_bit0_o      (shift2node_stride3_bit0_o),
    .shift2node_stride3_bit1_o      (shift2node_stride3_bit1_o),
    .shift2node_stride3_bit2_o      (shift2node_stride3_bit2_o),
    .shift2rowOffset_stride3_bit0_o (shift2rowOffset_stride3_bit0_o),
    .shift2rowOffset_stride3_bit1_o (shift2rowOffset_stride3_bit1_o),
    .shift2rowOffset_stride3_bit2_o (shift2rowOffset_stride3_bit2_o),
    .mux2ctrl_stride3_bit0_o        (mux2ctrl_stride3_bit0_o),
    .mux2ctrl_stride3_bit1_o        (mux2ctrl_stride3_bit1_o),
    .mux2ctrl_stride3_bit2_o        (mux2ctrl_stride3_bit2_o),
    .mem2shift_stride3_bit0_i       (mem2shift_stride3_bit0_i),
    .mem2shift_stride3_bit1_i       (mem2shift_stride3_bit1_i),
    .mem2shift_stride3_bit2_i       (mem2shift_stride3_bit2_i),
    .mem2mux_stride3_bit0_i         (mem2mux_stride3_bit0_i),
    .mem2mux_stride3_bit1_i         (mem2mux_stride3_bit1_i),
    .mem2mux_stride3_bit2_i         (mem2mux_stride3_bit2_i),
    .chRAM2mux_stride3_bit0_i       (chRAM2mux_stride3_bit0_i),
    .chRAM2mux_stride3_bit1_i       (chRAM2mux_stride3_bit1_i),
    .chRAM2mux_stride3_bit2_i       (chRAM2mux_stride3_bit2_i),
    .shift2node_stride3_bit3_o      (shift2node_stride3_bit3_o),
    .shift2rowOffset_stride3_bit3_o (shift2rowOffset_stride3_bit3_o),
    .mux2ctrl_stride3_bit3_o        (mux2ctrl_stride3_bit3_o),
    .mem2shift_stride3_bit3_i       (mem2shift_stride3_bit3_i),
    .mem2mux_stride3_bit3_i         (mem2mux_stride3_bit3_i),
    .chRAM2mux_stride3_bit3_i       (chRAM2mux_stride3_bit3_i),
    .shift2node_stride4_bit0_o      (shift2node_stride4_bit0_o),
    .shift2node_stride4_bit1_o      (shift2node_stride4_bit1_o),
    .shift2node_stride4_bit2_o      (shift2node_stride4_bit2_o),
    .shift2rowOffset_stride4_bit0_o (shift2rowOffset_stride4_bit0_o),
    .shift2rowOffset_stride4_bit1_o (shift2rowOffset_stride4_bit1_o),
    .shift2rowOffset_stride4_bit2_o (shift2rowOffset_stride4_bit2_o),
    .mux2ctrl_stride4_bit0_o        (mux2ctrl_stride4_bit0_o),
    .mux2ctrl_stride4_bit1_o        (mux2ctrl_stride4_bit1_o),
    .mux2ctrl_stride4_bit2_o        (mux2ctrl_stride4_bit2_o),
    .mem2shift_stride4_bit0_i       (mem2shift_stride4_bit0_i),
    .mem2shift_stride4_bit1_i       (mem2shift_stride4_bit1_i),
    .mem2shift_stride4_bit2_i       (mem2shift_stride4_bit2_i),
    .mem2mux_stride4_bit0_i         (mem2mux_stride4_bit0_i),
    .mem2mux_stride4_bit1_i         (mem2mux_stride4_bit1_i),
    .mem2mux_stride4_bit2_i         (mem2mux_stride4_bit2_i),
    .chRAM2mux_stride4_bit0_i       (chRAM2mux_stride4_bit0_i),
    .chRAM2mux_stride4_bit1_i       (chRAM2mux_stride4_bit1_i),
    .chRAM2mux_stride4_bit2_i       (chRAM2mux_stride4_bit2_i),
    .shift2node_stride4_bit3_o      (shift2node_stride4_bit3_o),
    .shift2rowOffset_stride4_bit3_o (shift2rowOffset_stride4_bit3_o),
    .mux2ctrl_stride4_bit3_o        (mux2ctrl_stride4_bit3_o),
    .mem2shift_stride4_bit3_i       (mem2shift_stride4_bit3_i),
    .mem2mux_stride4_bit3_i         (mem2mux_stride4_bit3_i),
    .chRAM2mux_stride4_bit3_i       (chRAM2mux_stride4_bit3_i),
    .mux2shiftCtrl_sel_i            (mux2shiftCtrl_sel_i),

    .L1_nodeBsShift_factor_bit0_i   (L1_nodeBsShift_factor_bit0_i),
    .L1_nodeBsShift_factor_bit1_i   (L1_nodeBsShift_factor_bit1_i),
    .L1_nodeBsShift_factor_bit2_i   (L1_nodeBsShift_factor_bit2_i),
    .L1_nodeBsShift_factor_bit3_i   (L1_nodeBsShift_factor_bit3_i),
    .L1_nodeBsShift_factor_bit4_i   (L1_nodeBsShift_factor_bit4_i),
    .L1_nodeBsShift_factor_bit5_i   (L1_nodeBsShift_factor_bit5_i),

    .L2_nodePaShift_factor_bit0_i   (L2_nodePaShift_factor_bit0_net),
    .L2_nodePaShift_factor_bit1_i   (L2_nodePaShift_factor_bit1_net),
    .L2_nodePaShift_factor_bit2_i   (L2_nodePaShift_factor_bit2_net),

    .L2_sOffsetNew_bit0_o           (L2_sOffsetNew_bit0_o),
    .L2_sOffsetNew_bit1_o           (L2_sOffsetNew_bit1_o),
    .L2_sOffsetNew_bit2_o           (L2_sOffsetNew_bit2_o),
    .L2_sOffsetOld_bit0_i           (L2_sOffsetOld_bit0_i),
    .L2_sOffsetOld_bit1_i           (L2_sOffsetOld_bit1_i),
    .L2_sOffsetOld_bit2_i           (L2_sOffsetOld_bit2_i),
    .is_vnF0_i                      (is_vnF0_i),
    .is_preV2CPerm_i                (is_preV2CPerm_i),
    .shareGroup_size                (shareGroup_size),

    .L2_nodePaLoad_factor_bit0_i    (L2_nodePaLoad_factor_bit0_i),
    .L2_nodePaLoad_factor_bit1_i    (L2_nodePaLoad_factor_bit1_i),
    .L2_nodePaLoad_factor_bit2_i    (L2_nodePaLoad_factor_bit2_i),
    .L2_nodePaLoad_factor_bit3_i    (L2_nodePaLoad_factor_bit3_i),
    .L2_nodePaLoad_factor_bit4_i    (L2_nodePaLoad_factor_bit4_i),
    .isMsgPass_i                    (isMsgPass_i),
    .cnu_sync_addr_i                (cnu_sync_addr_i),
    .vnu_sync_addr_i                (vnu_sync_addr_i),
    .cnu_layer_status_i             (cnu_layer_status_i),
    .vnu_layer_status_i             (vnu_layer_status_i),
    .cnu_sub_row_status_i           (cnu_sub_row_status_i),
    .vnu_sub_row_status_i           (vnu_sub_row_status_i),
    .last_row_chunk_i               (last_row_chunk_i),
    .we                             (we),
    .sys_clk                        (sys_clk),
    .rstn                           (rstn)
);
endmodule