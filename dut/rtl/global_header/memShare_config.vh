`ifndef __MEMSHARD_REGLIST_H
`define __MEMSHARD_REGLIST_H

//`define L2PA_ENABLE
//`define ENABLE_DEPRECATED_DESIGN

//-----------------------------------------------------------------------------------------------------
// Shared memory allocation (Top control)
//-----------------------------------------------------------------------------------------------------
//`define MEMSHARE_SCHED_SOL_1
//`define MEMSHARE_SCHED_SOL_2
`define MEMSHARE_SCHED_SOL_3
`define MEMSHARE_REGFILE_SOL4

`define DECODER_3bit
//`define DECODER_4bit

`define SHARE_GROUP_SIZE 5 // Number of requestors joining a share group (GP1+GP2)
`define SHARE_COL_CONFIG 5'b10101 //! '1': shared column
//-----------------------------------------------------------------------------------------------------
// Shared memory allocation:
// Configuration of access-request generator
//-----------------------------------------------------------------------------------------------------
`ifdef DECODER_3bit
    `define RQST_ADDR_BITWIDTH 2 // Bit width of every requestor's column address
    `define RQST_MODE_BITWIDTH 3 // Bit width of "mode set signals" for sake of reconfigurability
`endif // DECODER_3bit

`ifdef DECODER_4bit
    `define RQST_ADDR_BITWIDTH 3 // Bit width of every requestor's column address
    `define RQST_MODE_BITWIDTH 7 // Bit width of "mode set signals" for sake of reconfigurability
`endif // DECODER_4bit
//-----------------------------------------------------------------------------------------------------
// Configuration of L1BS
//-----------------------------------------------------------------------------------------------------
`define L1BS_CYCLE 2 // followed up the autogen of barrel shifter
`define L1BSOUT_EXTRA_DELAY 1 // additional dely on L1BS output for timing sync.
//-----------------------------------------------------------------------------------------------------
// Shared memory allocation:
// Configuration of L1PA regFile-mapping unit
//-----------------------------------------------------------------------------------------------------
`define MAX_MEMSHARE_INSTANCES 3 // Maximum number of required L1PA shfit patterns to complete an instance of shared memory allocation
                         // i.e. maximum number of shift patterns in a shift sequence
                         // In other words, maximum number of memShare allocation instances to complete
                         // a set of W^{s} requestors' IB-RAM accesses
//-----------------------------------------------------------------------------------------------------
// Shared memory allocation:
// Configuration of L1PA control register file
//-----------------------------------------------------------------------------------------------------
`ifdef MEMSHARE_REGFILE_SOL4
    `define L1PA_SHIFT_BITWIDTH $clog2(`SHARE_GROUP_SIZE) // 5 requestors in a share group
    `define L1PA_SHIFT_DELTA_WIDTH $clog2(`SHARE_GROUP_SIZE)
    `define L1PA_REGFILE_PAGE_NUM 32 // Number of pages in memShare_regFile
    `define L1PA_REGFILE_PAGE_WIDTH 7
    `define L1PA_REGFILE_ADDR_WIDTH 5
    `define MEMSHARE_RQSTFLAG_CYCLE 1
    `define MEMSHARE_REGFILE_RD_CYCLE 1
    `define MEMSHARE_SHIFTDELTA_ALU_CYCLE 1 

    // Type-0 register bit segments
    //  __________________________________________________________________________________________________________________________
    // | L1PA pattern[L1PA_SHIFT_BITWIDTH-1:0] | L1PA shfit delta[L1PA_SHIFT_DELTA_WIDTH-1:0] | isGtr                               |
    // |____________________________________|_________________________________|___________________________________________________|
    `define L1PA_SHIFT_DELTA_SEGMENT_MSB `L1PA_SHIFT_DELTA_WIDTH
    `define L1PA_SHIFT_DELTA_SEGMENT_LSB 1
    `define L1PA_SHIFT_SEGMENT_MSB (`L1PA_SHIFT_BITWIDTH+`L1PA_SHIFT_DELTA_WIDTH)
    `define L1PA_SHIFT_SEGMENT_LSB (`L1PA_SHIFT_DELTA_WIDTH+1)

    `define L1PA_SEQ_PTR_BITWIDTH 1 // Bit width of isGtr
    `define L1PA_SEQ_SIZE `MAX_MEMSHARE_INSTANCES // Maximum size of one L1PA shfit pattern sequence
`endif // MEMSHARE_REGFILE_SOL4


`ifdef ENABLE_DEPRECATED_DESIGN
    `ifdef L2PA_ENABLE
        `define L1PA_SPR_BITWIDTH  2
        `define L2PA_LPR_BITWIDTH  4

        // Type-0 register bit segments
        //  _____________________________________________________________________________________________
        // | L1PA_isEnd | L2PA_isEnd | L1PA_SPR[L1PA_REG_BITWIDTH-1:0] | L2PA_LPR[L2PA_REG_BITWIDTH-1:0] |
        // |____________|____________|_________________________________|_________________________________|
        `define TYPE0_REG_BITWIDTH (2+(L1PA_REG_BITWIDTH+L2PA_REG_BITWIDTH))

        `define TYPE0_ADDR_BITWIDTH 6 //! page number: 64
        `define L1PA_PIPE_NUM 1
        `define L2PA_PIPE_NUM 2
    `else //undef L2PA_ENABLE
        `define GP_ELEMENT_4_ROW_OFFSET_WIDTH 2
        `define GP_ELEMENT_3_ROW_OFFSET_WIDTH 1
        `define GP_ELEMENT_2_ROW_OFFSET_WIDTH 2
        `define GP_ELEMENT_1_ROW_OFFSET_WIDTH 1
        `define GP_ELEMENT_0_ROW_OFFSET_WIDTH 1

    // `define L1PA_SPR_BITWIDTH 2 // 4 requestors in ashare group
        `define L1PA_SPR_BITWIDTH 3 // 5 requestors in a share group
        `define L1PA_ENDFLAG_WIDTH 2
        `define GP_ELEMENT_ROW_ADDR_WIDTH (`GP_ELEMENT_4_ROW_OFFSET_WIDTH+`GP_ELEMENT_3_ROW_OFFSET_WIDTH+`GP_ELEMENT_2_ROW_OFFSET_WIDTH+`GP_ELEMENT_1_ROW_OFFSET_WIDTH+`GP_ELEMENT_0_ROW_OFFSET_WIDTH)


        // Type-0 register bit segments
        //  __________________________________________________________________________________________________________________________
        // | L1PA_isEnd[L1PA_ENDFLAG_WIDTH-1:0] | L1PA_SPR[L1PA_REG_BITWIDTH-1:0] | Row Address Offset[GP_ELEMENT_ROW_ADDR_WIDTH-1:0] |
        // |____________________________________|_________________________________|___________________________________________________|
        `define TYPE0_REG_BITWIDTH (`L1PA_ENDFLAG_WIDTH+`L1PA_SPR_BITWIDTH+`GP_ELEMENT_ROW_ADDR_WIDTH)   
    `endif
`endif // ENABLE_DEPRECATED_DESIGN
//-----------------------------------------------------------------------------------------------------
// Column-bank IB-LUT sharing scheme
//-----------------------------------------------------------------------------------------------------
`define GP1_ROW_ADDR_OFFSET_WIDTH 1
`define GP2_ROW_ADDR_OFFSET_WIDTH 2
`define BANK_INTERLEAVE 1
`define PRELOAD_SET_NUM 1 //! The number of preload sets stored in the underlying memory cell
`define GP1_RD_ADDR_WIDTH (`GP1_ROW_ADDR_OFFSET_WIDTH+`QUAN_SIZE)
`define GP1_WR_ADDR_WIDTH (`GP1_ROW_ADDR_OFFSET_WIDTH+`QUAN_SIZE)
`define GP1_WR_WIDTH (`QUAN_SIZE*`BANK_INTERLEAVE)
`define GP1_ENTRY_NUM 16
`define GP2_RD_ADDR_WIDTH (`GP2_ROW_ADDR_OFFSET_WIDTH+`QUAN_SIZE)
`define GP2_WR_ADDR_WIDTH (`GP2_ROW_ADDR_OFFSET_WIDTH+`QUAN_SIZE)
`define GP2_WR_WIDTH (`QUAN_SIZE*`BANK_INTERLEAVE)
`define GP2_ENTRY_NUM 32
//-----------------------------------------------------------------------------------------------------
// Shift offset generator for L1PA
//-----------------------------------------------------------------------------------------------------
// Usage guidedance:
//  Only one of below proprecessor with prefix of "SHIFT_OFFSET_" can be enabled
//      a) SHIFT_OFFSET_CUMULATIVE_ADDR. cumulative adder based implementation
//      b) Xilinx Shift Registers (SRL) based implementation
//      c) W^{s}-wide micro barrel shfiter where each input/ouptut message is 1 bit wide
`define SHIFT_OFFSET_CUMULATIVE_ADDR
//`define SHIFT_OFFSET_SRL
//`define SHIFT_OFFSET_MICRO_BS
`define SHIFT_OFFSET_DELAY 3

`endif // __MEMSHARD_REGLIST_H
