`timescale 1ns/1ps
/**
* Latest date: 19th July, 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: cumulative_shift_gen (tentative)
* 
* # I/F
* 1) Output:
* 2) Input:
* 
* # Param

* # Description
    The module to generate the final shift factor of L2PA for V2C permutation
* # Dependencies
        memShare_config.vh

  # H/W utilisation on Xilinx 7-series FPGA
        1) SHIFT_OFFSET_CUMULATIVE_ADDR
            Ws=5
                Total LUT: 10
                Logic LUT: 10
                LUTRAM: 0
                FF: 58
                I/O: ?
**/
`include "memShare_config.vh"
module memShare_shiftOffset_gen #(
`ifdef SHIFT_OFFSET_CUMULATIVE_ADDR
    parameter SHARED_BANK_NUM = 5, //! Number of IB-LUTs joining a share group (GP2)
    parameter SHIFT_WIDTH = $clog2(SHARED_BANK_NUM),
    parameter REF_WIDTH = SHIFT_WIDTH, //! Upper bound, actual reference might be less, e.g. ceil(log2(W^{s}))
    parameter PIPE_NUM = 2 //! Number of pipeline register sets (equivalent to pipeline stages - 1)
`endif // SHIFT_OFFSET_CUMULATIVE_ADDR

`ifdef SHIFT_OFFSET_MICRO_BS
    parameter SHARED_BANK_NUM = 5, //! Number of IB-LUTs joining a share group (GP2)
    parameter SHIFT_WIDTH = $clog2(SHARED_BANK_NUM),
    parameter REF_WIDTH = SHIFT_WIDTH //! Upper bound, actual reference might be less, e.g. ceil(log2(W^{s}))
`endif // SHIFT_OFFSET_MICRO_BS
) (
`ifdef SHIFT_OFFSET_CUMULATIVE_ADDR
    output wire [SHIFT_WIDTH-1:0] cumulative_shift_o,

    input wire [SHIFT_WIDTH-1:0] shiftOffset_prev_i,
    input wire [SHIFT_WIDTH-1:0] shift_i,
    input wire shiftOffset_mask_i, // To mask the incoming O^{shift}_{m-1} by all-zero reset
                                   // at share memory allocatin for VN.f0
                                   // 0: not masked, 1: masked
    input wire is_preV2CPerm_i, //! To indicate is the subsequent phase is "preprocessing V2C permutation"
    // Reconfigurable signal(s)
    input wire [REF_WIDTH-1:0] directRef_reconfig_i, //! Equivalent to W^{s}
    input wire [REF_WIDTH-1:0] leqRef_reconfig_i, //! Equivalent to floor(W^{s}/2)
    input wire sys_clk,
    input wire rstn
`endif //SHIFT_OFFSET_CUMULATIVE_ADDR

`ifdef SHIFT_OFFSET_MICRO_BS
    output wire [SHIFT_WIDTH-1:0] shiftOffset_new_o, //! Equivalent to relative O^{shift}_{m}

    input wire [SHIFT_WIDTH-1:0] shiftOffset_past_i, //! Equivalent to relative O^{shift}_{m-1}
    input wire [SHIFT_WIDTH-1:0] l1pa_shift_shareGroup_i, //! Latest L1PA shift generated by memShare_control_wrapper 
    input wire [REF_WIDTH-1:0] directRef_reconfig_i, //! Equivalent to W^{s}
    input wire sys_clk,
    input wire rstn
`endif // SHIFT_OFFSET_MICRO_BS
);

`ifdef SHIFT_OFFSET_CUMULATIVE_ADDR
    cumulative_shift_gen #(
        .SHARED_BANK_NUM(SHARED_BANK_NUM),
        .SHIFT_WIDTH(SHIFT_WIDTH),
        .REF_WIDTH(REF_WIDTH),
        .PIPE_NUM (2)
    ) cumulative_shift_gen (
        .cumulative_shift_o   (cumulative_shift_o),
        .shift_i              (shift_i),
        .directRef_reconfig_i (directRef_reconfig_i),
        .leqRef_reconfig_i    (leqRef_reconfig_i),
        .sys_clk              (sys_clk),
        .rstn                 (rstn)
    );


    cumulative_shift_gen #(
        .SHARED_BANK_NUM(SHARED_BANK_NUM),
        .SHIFT_WIDTH(SHIFT_WIDTH),
        .REF_WIDTH(REF_WIDTH),
        .PIPE_NUM(PIPE_NUM)
    ) cumulative_shift_gen (
        .shiftOffset_cur_o    (cumulative_shift_o),
        .shiftOffset_prev_i   (shiftOffset_prev_i),
        .shift_i              (shift_i),
        .shiftOffset_mask_i   (shiftOffset_mask_i),
        .is_preV2CPerm_i      (is_preV2CPerm_i),
        .directRef_reconfig_i (directRef_reconfig_i),
        .sys_clk              (sys_clk),
        .rstn                 (rstn)
    );

`endif // SHIFT_OFFSET_CUMULATIVE_ADDR
endmodule