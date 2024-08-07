`timescale 1ns/1ps
// Project: access_rqst_gen.memShare_sched
// File: memShare_config_pkg.sv
// Package: memShare_config_pkg
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
//
// # Description
// Configuration package to flexibly modify the the design rules, pipeline scheduling 
// strategy, etc. for the SCU.memShare(). Note that the "memShare_config.vh" is the 
// legacy configuration file which is planned to be merged into this package in the future.
//
// # Dependencies
// 	memShare_config.vh
// ----------------------------------------------------------------------------------------
//  # History
//  Date            Revision    Description                 Editor
//  13.April.2024   v0.01       First created               Bo-Yu Tseng
// ----------------------------------------------------------------------------------------
`include "define.vh"

package memShare_config_pkg;

//=====================================================================================================
// Common decoder configuratoin
//=====================================================================================================
`ifdef DECODER_3bit
	localparam QUAN_SIZE = 3;
`elsif DECODER_4bit
	localparam QUAN_SIZE = 4;
`else
	localparam QUAN_SIZE = 4;
`endif
//=====================================================================================================
// SCU.memShare() configuration
//=====================================================================================================
localparam MAX_ALLOC_SEQ_NUM = 2; // maximum number of allocation seuqences for a set of request patterns

// Arrival requestor profiling
localparam ARR_RQST_TRACK_DEPTH = 4; // No specific rule to determine the depth
localparam READ_2SEQ_TRACK_DEPTH = ARR_RQST_TRACK_DEPTH;
localparam MEMSHARE_DRC_NUM = 3; // # of the DRCs in the underlying SCU.memShare()
typedef enum {
    MEMSHARE_DRC1 = 0,
    MEMSHARE_DRC2 = 1,
    MEMSHARE_DRC3 = 2  
} memShare_drc_index;

//=====================================================================================================
// The following parameters are the legacy macros copied from the "memShare_config.vh"
//=====================================================================================================

//-----------------------------------------------------------------------------------------------------
// Shared memory allocation:
// Configuration of access-request generator
//-----------------------------------------------------------------------------------------------------
localparam SHARE_GROUP_SIZE = 5; // Number of requestors joining a share group (GP1+GP2)
localparam bit [SHARE_GROUP_SIZE-1:0] SHARE_COL_CONFIG = 5'b10101; //! '1': shared column
`ifdef DECODER_3bit
    localparam MSGPASS_BUFF_RQST_WIDTH = 3; // Bit width of every requestor's read data from message-pass buffer (before mag. conversion)
    localparam RQST_ADDR_BITWIDTH = 2; // Bit width of every requestor's column address
    localparam RQST_MODE_BITWIDTH = 3; // Bit width of "mode set signals" for sake of reconfigurability
`endif // DECODER_3bit

`ifdef DECODER_4bit
    localparam MSGPASS_BUFF_RQST_WIDTH = 4; // Bit width of every requestor's read data from message-pass buffer (before mag. conversion)
    localparam RQST_ADDR_BITWIDTH = 3; // Bit width of every requestor's column address
    localparam RQST_MODE_BITWIDTH = 7; // Bit width of "mode set signals" for sake of reconfigurability
`endif // DECODER_4bit

typedef enum logic [RQST_ADDR_BITWIDTH-1:0] {
    GP1_BANK0_ADDR = RQST_ADDR_BITWIDTH'(0),
    GP1_BANK1_ADDR = RQST_ADDR_BITWIDTH'(2),
    GP2_BANK0_ADDR = RQST_ADDR_BITWIDTH'(1),
    GP2_BANK1_ADDR = RQST_ADDR_BITWIDTH'(3)
} colBank_addr_gropu_e;
//-----------------------------------------------------------------------------------------------------
// Configuration of the signals associated with the message-passing buffer
//-----------------------------------------------------------------------------------------------------
localparam MSGPASS_RD_ADDR_WIDTH = 5; // tentative
localparam MSGPASS_ADDR_BASE = 100;
localparam MSGPASS_BASEADDR_NUM = 4; // (1) Permuted C2V, driven by L2PA, Lth layer
                                     // (3) Intermediate V2C, driven by VNU.f0, Lth layer
                                     // (4) Intermediate V2C, driven by VNU.f0, (L+1)th layer
                                     // (5) Intermediate V2C, driven by VNU.f0, (L+2)th layer
localparam MSGPASS_BASEADDR_AGG = MSGPASS_RD_ADDR_WIDTH*MSGPASS_BASEADDR_NUM; // aggregation of all base addresses
//-----------------------------------------------------------------------------------------------------
// Configuration of L1BS
//-----------------------------------------------------------------------------------------------------
localparam L1BS_CYCLE = 2; // followed up the autogen of barrel shifter
localparam L1BSOUT_EXTRA_DELAY = 1; // additional dely on L1BS output for timing sync.
//-----------------------------------------------------------------------------------------------------
// Shared memory allocation:
// Configuration of L1PA regFile-mapping unit
//-----------------------------------------------------------------------------------------------------
localparam MAX_MEMSHARE_INSTANCES = 2; // maximum numbe of allocation sequences
//-----------------------------------------------------------------------------------------------------
// Shared memory allocation:
// Configuration of L1PA control register file
//-----------------------------------------------------------------------------------------------------
`ifdef MEMSHARE_REGFILE_SOL4
    localparam L1PA_SHIFT_BITWIDTH = $clog2(SHARE_GROUP_SIZE); // 5 requestors in a share group
    localparam L1PA_SHIFT_DELTA_WIDTH = $clog2(SHARE_GROUP_SIZE);
    localparam L1PA_REGFILE_PAGE_NUM = 32; // Number of pages in memShare_regFile
    localparam L1PA_REGFILE_PAGE_WIDTH = 7;
    localparam L1PA_REGFILE_ADDR_WIDTH = 5;
    localparam MEMSHARE_RQSTFLAG_CYCLE = 1;
    localparam MEMSHARE_REGFILE_RD_CYCLE = 1;
    localparam MEMSHARE_SHIFTDELTA_ALU_CYCLE = 1; 

    // Type-0 register bit segments
    //  _______________________________________________________________________________________________
    // | L1PA pattern[L1PA_SHIFT_BITWIDTH-1:0] | L1PA shfit delta[L1PA_SHIFT_DELTA_WIDTH-1:0] | isGtr  |
    // |_______________________________________|______________________________________________|________|
    localparam L1PA_SHIFT_DELTA_SEGMENT_MSB = L1PA_SHIFT_DELTA_WIDTH;
    localparam L1PA_SHIFT_DELTA_SEGMENT_LSB = 1;
    localparam L1PA_SHIFT_SEGMENT_MSB = (L1PA_SHIFT_BITWIDTH+L1PA_SHIFT_DELTA_WIDTH);
    localparam L1PA_SHIFT_SEGMENT_LSB = (L1PA_SHIFT_DELTA_WIDTH+1);

    localparam L1PA_SEQ_PTR_BITWIDTH = 1; // Bit width of isGtr
    localparam L1PA_SEQ_SIZE = MAX_MEMSHARE_INSTANCES; // Maximum size of one L1PA shfit pattern sequence
`endif // MEMSHARE_REGFILE_SOL4


`ifdef ENABLE_DEPRECATED_DESIGN
    `ifdef L2PA_ENABLE
        localparam L1PA_SPR_BITWIDTH = 2;
        localparam L2PA_LPR_BITWIDTH = 4;

        // Type-0 register bit segments
        //  _____________________________________________________________________________________________
        // | L1PA_isEnd | L2PA_isEnd | L1PA_SPR[L1PA_REG_BITWIDTH-1:0] | L2PA_LPR[L2PA_REG_BITWIDTH-1:0] |
        // |____________|____________|_________________________________|_________________________________|
        localparam TYPE0_REG_BITWIDTH = (2+(L1PA_REG_BITWIDTH+L2PA_REG_BITWIDTH));

        localparam TYPE0_ADDR_BITWIDTH = 6; //! page number: 64
        localparam L1PA_PIPE_NUM = 1;
        localparam L2PA_PIPE_NUM = 2;
    `else //undef L2PA_ENABLE
        localparam GP_ELEMENT_4_ROW_OFFSET_WIDTH = 2;
        localparam GP_ELEMENT_3_ROW_OFFSET_WIDTH = 1;
        localparam GP_ELEMENT_2_ROW_OFFSET_WIDTH = 2;
        localparam GP_ELEMENT_1_ROW_OFFSET_WIDTH = 1;
        localparam GP_ELEMENT_0_ROW_OFFSET_WIDTH = 1;

    // `define L1PA_SPR_BITWIDTH 2 // 4 requestors in ashare group
        localparam L1PA_SPR_BITWIDTH = 3; // 5 requestors in a share group
        localparam L1PA_ENDFLAG_WIDTH = 2;
        localparam GP_ELEMENT_ROW_ADDR_WIDTH = GP_ELEMENT_4_ROW_OFFSET_WIDTH +
                                               GP_ELEMENT_3_ROW_OFFSET_WIDTH +
                                               GP_ELEMENT_2_ROW_OFFSET_WIDTH +
                                               GP_ELEMENT_1_ROW_OFFSET_WIDTH +
                                               GP_ELEMENT_0_ROW_OFFSET_WIDTH;


        // Type-0 register bit segments
        //  __________________________________________________________________________________________________________________________
        // | L1PA_isEnd[L1PA_ENDFLAG_WIDTH-1:0] | L1PA_SPR[L1PA_REG_BITWIDTH-1:0] | Row Address Offset[GP_ELEMENT_ROW_ADDR_WIDTH-1:0] |
        // |____________________________________|_________________________________|___________________________________________________|
        localparam TYPE0_REG_BITWIDTH = (L1PA_ENDFLAG_WIDTH+L1PA_SPR_BITWIDTH+GP_ELEMENT_ROW_ADDR_WIDTH);   
    `endif
`endif // ENABLE_DEPRECATED_DESIGN
//-----------------------------------------------------------------------------------------------------
// Column-bank IB-LUT sharing scheme
//-----------------------------------------------------------------------------------------------------
`ifdef DECODER_3bit
    loclaparam GP1_COL_BANK_NUM = 8; // A total of column banks for the underlying IB-RAM merging 2 decomposition-level IB-LUTs
    localparam GP2_COL_BANK_NUM = 8; // A total of column banks for the underlying IB-RAM merging 2 decomposition-level IB-LUTs
    localparam GP1_COL_SEL_WIDTH = 3;
    localparam GP2_COL_SEL_WIDTH = 3;
    localparam GP1_RAM_ADDR_WIDTH = 6; // ROW_ADDR+COL_BANK_SEL=QUAN_SIZE+3
    localparam GP2_RAM_ADDR_WIDTH = 6; // ROW_ADDR+COL_BANK_SEL=QUAN_SIZE+3
    localparam GP1_VN_LOAD_CYCLE = 64; // (2**QUAN_SIZE)*GP1_COL_BANK_NUM
    localparam GP2_VN_LOAD_CYCLE = 64; // (2**QUAN_SIZE)*GP2_COL_BANK_NUM
`elsif DECODER_4bit
    loclaparam GP1_COL_BANK_NUM = 4; // A total of column banks for the underlying IB-RAM merging 2 decomposition-level IB-LUTs
    localparam GP2_COL_BANK_NUM = 16; // A total of column banks for the underlying IB-RAM merging 2 decomposition-level IB-LUTs
    localparam GP1_COL_SEL_WIDTH = 2;
    localparam GP2_COL_SEL_WIDTH = 4;
    localparam GP1_RAM_ADDR_WIDTH = 6; // ROW_ADDR+COL_BANK_SEL=QUAN_SIZE+2
    localparam GP2_RAM_ADDR_WIDTH = 8; // ROW_ADDR+COL_BANK_SEL=QUAN_SIZE+4
    localparam GP1_VN_LOAD_CYCLE = 64;// (2**QUAN_SIZE)*GP1_COL_BANK_NUM
    localparam GP2_VN_LOAD_CYCLE = 256;// (2**QUAN_SIZE)*GP2_COL_BANK_NUM
`else // 3bit parameters as the default settings
    loclaparam GP1_COL_BANK_NUM = 8; // A total of column banks for the underlying IB-RAM merging 2 decomposition-level IB-LUTs
    localparam GP2_COL_BANK_NUM = 8; // A total of column banks for the underlying IB-RAM merging 2 decomposition-level IB-LUTs
    localparam GP1_COL_SEL_WIDTH = 3;
    localparam GP2_COL_SEL_WIDTH = 3;
    localparam GP1_RAM_ADDR_WIDTH = 6; // ROW_ADDR+COL_BANK_SEL=QUAN_SIZE+3
    localparam GP2_RAM_ADDR_WIDTH = 6; // ROW_ADDR+COL_BANK_SEL=QUAN_SIZE+3
    localparam GP1_VN_LOAD_CYCLE = 64; // (2**QUAN_SIZE)*GP1_COL_BANK_NUM
    localparam GP2_VN_LOAD_CYCLE = 64; // (2**QUAN_SIZE)*GP2_COL_BANK_NUM
`endif

// Legay (9 Jun, 2024)
//localparam GP1_ROW_ADDR_OFFSET_WIDTH = 1;
//localparam GP2_ROW_ADDR_OFFSET_WIDTH = 2;
//localparam BANK_INTERLEAVE = 1;
//localparam PRELOAD_SET_NUM = 1; //! The number of preload sets stored in the underlying memory cell
//localparam GP1_RD_ADDR_WIDTH = GP1_ROW_ADDR_OFFSET_WIDTH+`QUAN_SIZE;
//localparam GP1_WR_ADDR_WIDTH = GP1_ROW_ADDR_OFFSET_WIDTH+`QUAN_SIZE;
//localparam GP1_WR_WIDTH = `QUAN_SIZE*`BANK_INTERLEAVE;
//localparam GP1_ENTRY_NUM = 16;
//localparam GP2_RD_ADDR_WIDTH = GP2_ROW_ADDR_OFFSET_WIDTH+`QUAN_SIZE;
//localparam GP2_WR_ADDR_WIDTH = GP2_ROW_ADDR_OFFSET_WIDTH+`QUAN_SIZE;
//localparam GP2_WR_WIDTH = `QUAN_SIZE*BANK_INTERLEAVE;
//localparam GP2_ENTRY_NUM = 32;
//-----------------------------------------------------------------------------------------------------
// Shift offset generator for L1PA
//-----------------------------------------------------------------------------------------------------
// Usage guidedance:
//  Only one of below proprecessor with prefix of "SHIFT_OFFSET_" can be enabled
//      a) SHIFT_OFFSET_CUMULATIVE_ADDR. cumulative adder based implementation
//      b) Xilinx Shift Registers (SRL) based implementation
//      c) W^{s}-wide micro barrel shfiter where each input/ouptut message is 1 bit wide
localparam SHIFT_OFFSET_DELAY = 3;
endpackage
