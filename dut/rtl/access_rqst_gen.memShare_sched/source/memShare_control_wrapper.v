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
*		LUT: 15
        Logic LUT: 11
        LUTRAM: 4
		FF: 17
        I/O: 24
        Freq: 400MHz
        WNS: +1.171 ns
        TNS: 0.0 ns
        WHS: +0.0959 ns
        THS: 0.0 ns
        WPWS: 0.000 ns
        TPWS: 0.0 ns
**/
`include "memShare_config.vh"

module memShare_control_wrapper #(
    // Access-request generator
	parameter SHARE_GROUP_SIZE = `SHARE_GROUP_SIZE, //! Number of requestors joining a share group (GP1+GP2)
	parameter RQST_ADDR_BITWIDTH = `RQST_ADDR_BITWIDTH, //! Bit width of every requestor's column address
	parameter MODE_BITWIDTH = `RQST_MODE_BITWIDTH, //! Bit width of "mode set signals"
    parameter RQST_FLAG_CYCLE = `MEMSHARE_RQSTFLAG_CYCLE,
    // L1PA regFile-mapping unit
    parameter RQST_BITWIDTH = `SHARE_GROUP_SIZE, //! Size of request flag
    parameter REGFILE_PAGE_NUM = `L1PA_REGFILE_PAGE_NUM, //! Number of pages in memShare_regFile
    parameter MAX_MEMSHARE_INSTANCES = `MAX_MEMSHARE_INSTANCES, //! Maximum number of required L1PA shift patterns to complete an instance of shared memory allocation
    parameter REGFILE_ADDR_WIDTH = RQST_BITWIDTH,
    parameter L1PA_SHIFT_BITWIDTH = $clog2(RQST_BITWIDTH),
    parameter REGFILE_RD_CYCLE = `MEMSHARE_REGFILE_RD_CYCLE,
    // L1PA register file
    parameter SHIFT_BITWIDTH = `L1PA_SHIFT_BITWIDTH,
    parameter DELTA_BITWIDTH = `L1PA_SHIFT_DELTA_WIDTH,
    parameter SEQ_PTR_BITWIDTH = `L1PA_SEQ_PTR_BITWIDTH, // Bit width of isGtr
    parameter SEQ_SIZE = `L1PA_SEQ_SIZE, //! Maximum size of one L1PA shift pattern sequence
    parameter TYPE0_ADDR_BITWIDTH = `L1PA_REGFILE_ADDR_WIDTH,
    parameter TYPE0_REG_BITWIDTH = `L1PA_REGFILE_PAGE_WIDTH,
    parameter TYPE0_PAGE_NUM =`L1PA_REGFILE_PAGE_NUM,
    parameter SHIFTDELTA_ALU_CYCLE = `MEMSHARE_SHIFTDELTA_ALU_CYCLE
) (
    //--------------
    // Port 0
   //--------------
    // Access-request generator
    input wire [(RQST_ADDR_BITWIDTH*SHARE_GROUP_SIZE)-1:0] rqst_addr_i,
    input wire [MODE_BITWIDTH-1:0] modeSet_i,
    input wire isColAddr_skid_i, // Selector signal for the skid buffer
    // L1PA regFile-mapping unit
    output wire [L1PA_SHIFT_BITWIDTH-1:0] l1pa_shift_o, //! shift control instructing the L1PA
    output wire isGtr_o, //! 1: currently accessed L1PA_SPR is the last pattern in the chosen L1PA shift sequence
    // L1PA register file
    input wire [TYPE0_ADDR_BITWIDTH-1:0] regType0_waddr_i,
    input wire [TYPE0_REG_BITWIDTH-1:0] regType0_wdata_i,
    input wire regType0_we_i,

    input wire rstn,
    input wire sys_clk  
);

//-----------------------------------
// Pipeline stage 0
// Access-request generator
//-----------------------------------
wire [SHARE_GROUP_SIZE-1:0] share_rqstFlag_net;
wire [SHARE_GROUP_SIZE-1:0] share_rqstFlag_skid;
reg [SHARE_GROUP_SIZE-1:0] share_rqstFlag_pipe0;
`ifdef DECODER_3bit
    accessRqstGen_2gp #(
`endif // DECODER_3bit
`ifdef DECODER_4bit
    accessRqstGen_2gp_q4 #(
`endif // DECODER_4bit
    .SHARED_BANK_NUM (SHARE_GROUP_SIZE), //! Number of requestors joining a share group (GP1+GP2)
    .RQST_ADDR_BITWIDTH (RQST_ADDR_BITWIDTH), //! Bit width of every requestor's column address
    .MODE_BITWIDTH (MODE_BITWIDTH), //! Bit width of "mode set signals"
    .RQST_FLAG_CYCLE (RQST_FLAG_CYCLE)
) accessRqstGen (
	.share_rqstFlag_o (share_rqstFlag_net), //! Request flags to shared group 2

	.rqst_addr_i (rqst_addr_i),
`ifdef DECODER_3bit
	.modeSet_i (3'b011)//(modeSet_i)
`endif // DECODER_3bit
`ifdef DECODER_4bit
	.modeSet_i ({7{1'b0}})//(modeSet_i)
`endif // DECODER_3bit
);

memShare_skidBuffer #(
    .SHARE_GROUP_SIZE (SHARE_GROUP_SIZE)
) (
    share_rqstFlag_o (share_rqstFlag_skid),
    share_rqstFlag_i (share_rqstFlag_net),
    isColAddr_skid_i (isColAddr_skid_i),
    .sys_clk (sys_clk),
    .rstn (rstn)
);
always @(posedge sys_clk) begin if(!rstn) share_rqstFlag_pipe0 <= 0; share_rqstFlag_pipe0 <= share_rqstFlag_skid; end
//-----------------------------------
// Pipeline stage 1.a
// L1PA regFile-mapping unit
//-----------------------------------
wire [L1PA_SHIFT_BITWIDTH-1:0] l1pa_shift_net; //! shift control instructing the L1PA
wire [REGFILE_ADDR_WIDTH-1:0] regFile_raddr_net; //! read address for memShare_regFile
wire isGtr_net; //! 1: currently accessed L1PA_SPR is the last pattern in the chosen L1PA shift sequence
wire [L1PA_SHIFT_BITWIDTH-1:0] l1pa_shift_fb_net;
wire [L1PA_SHIFT_BITWIDTH-1:0] shiftDelta_fb_net;
wire isGtr_fb_net; //! Feedback of "isGreaterThan-0" extracted from LSB of L1PA_SPR
memShare_rfmu #(
    .RQST_BITWIDTH        (RQST_BITWIDTH      ), //! Size of request flag
    .REGFILE_PAGE_NUM     (REGFILE_PAGE_NUM   ), //! Number of pages in memShare_regFile
    .REGFILE_ADDR_WIDTH   (REGFILE_ADDR_WIDTH ),
    .L1PA_SHIFT_BITWIDTH  (L1PA_SHIFT_BITWIDTH),
    .SHIFTDELTA_ALU_CYCLE (SHIFTDELTA_ALU_CYCLE)
) memShare_rfmu (
      // I/F to L1PA
      .l1pa_shift_o (l1pa_shift_net), //! shift control instructing the L1PA
      // I/F to regFile
      .regFile_raddr_o (regFile_raddr_net), //! read address for memShare_regFile
      // I/F to system
     .isGtr_o (isGtr_net), //! 1: currently accessed L1PA_SPR is the last pattern in the chosen L1PA shift sequence

      .rqstFlag_i (share_rqstFlag_pipe0), //! Request flags to shared group 2 (GP2)

      // Feedback signals from memShare_regFile.L1PA_SPR
      .l1pa_shift_fb_i (l1pa_shift_fb_net),
      .shiftDelta_fb_i (shiftDelta_fb_net),
      .isGtr_fb_i (isGtr_fb_net), //! Feedback of "isGreaterThan-0" extracted from LSB of L1PA_SPR
      .rstn (rstn),
      .sys_clk (sys_clk)   
);
//-----------------------------------
// Pipeline stage 1.b
// L1PA register file
//-----------------------------------
wire deltaPipe_rstn;
memShare_delta_reset #(
    .RST_POLARITY (1'b0) // 0: active LOW, 1: active HIGH
) memShare_delta_reset (
    .reset_o (deltaPipe_rstn), // synchrounous reset signal connected to the delta FF
    .isGtr_i (isGtr_fb_net), // isGtr obtainned from RFMU at SHFIT_GEN state
    .sys_clk (sys_clk),
    .rstn (rstn)
);

memShare_regFile_wrapper #(
    .SHIFT_BITWIDTH      (SHIFT_BITWIDTH     ),
    .DELTA_BITWIDTH      (DELTA_BITWIDTH     ),
    .SEQ_PTR_BITWIDTH    (SEQ_PTR_BITWIDTH   ), // Bit width of isGtr
    .SEQ_SIZE            (SEQ_SIZE           ), //! Maximum size of one L1PA shift pattern sequence
    .TYPE0_ADDR_BITWIDTH (TYPE0_ADDR_BITWIDTH), //! page number: 32
    .TYPE0_REG_BITWIDTH  (TYPE0_REG_BITWIDTH ),
    .TYPE0_PAGE_NUM      (TYPE0_PAGE_NUM     ),
    .REGFILE_RD_CYCLE    (REGFILE_RD_CYCLE   )
) memShare_regFile_wrapper (
    // Port 0
    .l1pa_shift_port0_o (l1pa_shift_fb_net),
    .shift_delta_port0_o (shiftDelta_fb_net),
    .isGtr_port0_o (isGtr_fb_net),
    .regType0_raddr_port0_i (regFile_raddr_net),

    .regType0_waddr_i (regType0_waddr_i),
    .regType0_wdata_i (regType0_wdata_i),
    .regType0_we_i (regType0_we_i),
    .sys_clk (sys_clk),
    .rstn (rstn),
    .deltaPipe_rstn (deltaPipe_rstn)
);

//-----------------------------------
// Pipeline stage 2
// Generation of L1PA shift control shift signals
// The corresponding logic is hidden inside the memShare_rfmu
// For ease of debugging for the designer in the futer,
// the assignment of output ports is described herein.
//-----------------------------------
assign l1pa_shift_o = l1pa_shift_net;
assign isGtr_o = isGtr_net;
endmodule