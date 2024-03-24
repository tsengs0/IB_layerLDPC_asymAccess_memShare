`timescale 1ns/1ps
/**
* Latest date: 5th July, 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: shift_control_encoder_q3
* 
* # I/F
* 1) Output: (not maintained yet)
        lut_data0_o
        lut_data1_o
        lut_data2_o
        lut_data3_o
        lut_data4_o
* 2) Input: (not maintained yet)
        read_addr0_i
        read_addr1_i
        read_addr2_i
        read_addr3_i
        read_addr4_i
        gp1_write_addr_i
        gp2_write_addr_i
        gp1_lut_in_i
        gp2_lut_in_i
        we_i
        read_clk
        write_clk
        rstn
* # Param (not maintained yet)
    // Basic configuration of memory cells
        QUAN_SIZE
        BANK_INTERLEAVE
        PRELOAD_SET_NUM. The number of preload sets stored in the underlying memory cell
        GP1_RD_ADDR_WIDTH
        GP1_WR_ADDR_WIDTH
        GP1_WR_WIDTH
        GP1_ENTRY_NUM
        GP2_RD_ADDR_WIDTH
        GP2_WR_ADDR_WIDTH
        GP2_WR_WIDTH.
        GP2_ENTRY_NUM.

    // Configuration of shared column
        GROUP_SIZE. Shared group size
        SHARE_COL_CONFIG.'1': shared column
        RD_ADDR4_WIDTH
        RD_ADDR3_WIDTH
        RD_ADDR2_WIDTH
        RD_ADDR1_WIDTH
        RD_ADDR0_WIDTH
* # Description
    For 3-bit qunaitised decoder:
        Shift control encoder for a share group, is to generate the a) shift control signals to L1BS, b) shift control signals to L1PA, c) load_en to L2PA


* # Dependencies
*
* # Remark
		LUT: 32      (PRELOAD_SET_NUM=2); 20 (PRELOAD_SET_NUM=1) 
        Logic LUT: 0 (PRELOAD_SET_NUM=2); 0  (PRELOAD_SET_NUM=1) 
        LUTRAM: 32   (PRELOAD_SET_NUM=2); 20 (PRELOAD_SET_NUM=1) -> it is notable that each of them costs 4 LUTRAMs. 
		FF: 0        (PRELOAD_SET_NUM=2); 0  (PRELOAD_SET_NUM=1) 
        I/O: 50      (PRELOAD_SET_NUM=2); 45 (PRELOAD_SET_NUM=1) 
        Freq: 400MHz
        WNS:  ns
        TNS:  ns
        WHS:  ns
        THS:  ns
        WPWS: ns
        TPWS: ns
**/
module shift_control_encoder_q3 #(
    // Basic configuration of memory cells
    parameter QUAN_SIZE = 3,
    parameter MSG_MAG_WIDTH = QUAN_SIZE-1,
    parameter BANK_INTERLEAVE = 1,
    parameter PRELOAD_SET_NUM = 1, //! The number of preload sets stored in the underlying memory cell
    parameter GP1_RD_ADDR_WIDTH = 4,
    parameter GP1_WR_ADDR_WIDTH = 4,
    parameter GP1_WR_WIDTH = QUAN_SIZE*BANK_INTERLEAVE,
    parameter GP1_ENTRY_NUM = 16,
    parameter GP2_RD_ADDR_WIDTH = 5,
    parameter GP2_WR_ADDR_WIDTH = 5,
    parameter GP2_WR_WIDTH = QUAN_SIZE*BANK_INTERLEAVE,
    parameter GP2_ENTRY_NUM = 32,

    // Configuration of shared column
    parameter GROUP_SIZE = 5, //! Shared group size
    parameter [GROUP_SIZE-1:0] SHARE_COL_CONFIG = 5'b10101, //! '1': shared column
    parameter RD_ADDR4_WIDTH = GP2_RD_ADDR_WIDTH,
    parameter RD_ADDR3_WIDTH = GP1_RD_ADDR_WIDTH,
    parameter RD_ADDR2_WIDTH = GP2_RD_ADDR_WIDTH,
    parameter RD_ADDR1_WIDTH = GP1_RD_ADDR_WIDTH,
    parameter RD_ADDR0_WIDTH = GP1_RD_ADDR_WIDTH,
    // Configuration of access request generator
    parameter ACCESS_RQSTGEN_GP2_MODE_BITWIDTH = 3, //! Bit width of "mode set signals"
    // Configuration of L1PA shift pattern sequence
    parameter [1:0] L1PA_SPR_START_CODE = 2'b10
    // Pipeline configuration
    parameter L1BS_PIPE_STAGE = 2,
    parameter L1PA_PIPE_STAGE = 1,
    parameter L2PA_PIPE_STAGE = 1
) (

    input wire [(MSG_MAG_WIDTH*GROUP_SIZE)-1:0] memShare_colSymAddr_i, //! Aggregation of symmetric col. addreses from all elements of a share group
    input wire [MODE_BITWIDTH-1:0] memShare_modeSet_i, //! config is fixed, hence no need for pipeline propagation
    input wire rstn,
    input wire sys_clk
);

//-----------------------------------------------------------------------------------------
// 1st Phase: Level-1 barrel shifter
//-----------------------------------------------------------------------------------------
reg [(MSG_MAG_WIDTH*GROUP_SIZE)-1:0] shareGroup_colSymAddr_pipe [0:L1BS_PIPE_STAGE-1];

genvar l1bs_pipe_index;
always @(posedge sys_clk) begin if(!rstn) shareGroup_colSymAddr_pipe[0] <= 0; else shareGroup_colSymAddr_pipe[0] <= memShare_colSymAddr_i; end
generate;
    for(l1bs_pipe_index=1; l1bs_pipe_index<L1BS_PIPE_STAGE; l1bs_pipe_index=l1bs_pipe_index+1) begin: l1l2pa_inSrc_pipePropagate
        always @(posedge sys_clk) begin 
            if(!rstn) shareGroup_colSymAddr_pipe[l1bs_pipe_index] <= 0;
            else shareGroup_colSymAddr_pipe[l1bs_pipe_index] <= shareGroup_colSymAddr_pipe[l1bs_pipe_index-1];
        end
    end
endgenerate
//-----------------------------------------------------------------------------------------
// 2nd Phase: Level-1 Page Alignment
//-----------------------------------------------------------------------------------------
wire [SHARED_BANK_NUM-1:0] gp2_rqstFlag_net;
accessRqstGen_2gp #(
    .SHARED_BANK_NUM (GROUP_SIZE), //! Number of requestors joining a share group (GP1+GP2)
    .RQST_ADDR_BITWIDTH (MSG_MAG_WIDTH), //! Bit width of every requestor's column address
    .MODE_BITWIDTH (ACCESS_RQSTGEN_GP2_MODE_BITWIDTH) //! Bit width of "mode set signals"
) access_rqst_gen (
	.share_rqstFlag_o (gp2_rqstFlag_net), //! Request flags to shared group 2 (GP2)
	.rqst_addr_i      (shareGroup_colSymAddr_pipe[L1BS_PIPE_STAGE-1]),
	.modeSet_i        (memShare_modeSet_i)
);

memShare_sched #(
    .SHARED_BANK_NUM (GROUP_SIZE) //! Number of requestors joining a share group (GP1+GP2)
) memShare_sched (
    .rqstFlag_pipe_o (),
    .c2vMEM_wb_waddr_o (),
    .regFile_raddr_o (),

    .rqstFlag_i (),
    .modeSet_i  (),
    .sys_clk    (sys_clk),
    .rstn       (rstn)
);

pageAllign_cycle_stop #(
    .L1PA_CYCLE ()
) pageAllign_cycle_stop (

);
endmodule