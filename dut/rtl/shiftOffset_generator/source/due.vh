`define CUMULATIVE_DUE_IF(x) \
    output wire [$clog2(TRIAL``x``)-1:0] cumulative_shift``x``_o, \
    input wire [$clog2(TRIAL``x``)-1:0] shift``x``_i, \
    input wire  [$clog2(TRIAL``x``)-1:0] directRef_reconfig``x``_i, \
    input wire [$clog2(TRIAL``x``)-1:0] leqRef_reconfig``x``_i,

`define CUMULATIVE_SOL2_DUE_IF(x) \
    output wire [$clog2(TRIAL``x``)-1:0] shiftOffset_cur``x``_o, \
    output wire [$clog2(TRIAL``x``)-1:0] preprocessShift``x``_o, \
    input wire [$clog2(TRIAL``x``)-1:0] shiftOffset_prev``x``_i, \
    input wire shiftOffset_mask``x``_i, \
    input wire [$clog2(TRIAL``x``)-1:0] shift``x``_i, \
    input wire [$clog2(TRIAL``x``)-1:0] directRef_reconfig``x``_i,

`define CUMULATIVE_SOL2_INST_DUE_IF(x) \
    .shiftOffset_cur_o (shiftOffset_cur``x``_o), \
    .preprocessShift_o (preprocessShift``x``_o), \
    .shiftOffset_prev_i (shiftOffset_prev``x``_i), \
    .shift_i (shift``x``_i), \
    .shiftOffset_mask_i (shiftOffset_mask``x``_i), \
    .directRef_reconfig_i (TRIAL``x``), \
    .sys_clk (sys_clk), \
    .rstn (rstn)


`define MICRO_BS_DUE_IF(x) \
    output wire [$clog2(TRIAL``x``)-1:0] shiftOffset_new``x``_o, \
    input wire  [$clog2(TRIAL``x``)-1:0] shiftOffset_past``x``_i, \
    input wire  [$clog2(TRIAL``x``)-1:0] l1pa_shift_shareGroup``x``_i, \
    input wire  [$clog2(TRIAL``x``)-1:0] directRef_reconfig``x``_i,

`define MICRO_BS_INST_IF(x) \
    .shiftOffset_new_o (shiftOffset_new``x``_o), \
    .shiftOffset_past_i (shiftOffset_past``x``_i), \
    .l1pa_shift_shareGroup_i (l1pa_shift_shareGroup``x``_i), \
    .directRef_reconfig_i (directRef_reconfig``x``_i), \
    .sys_clk (sys_clk), \
    .rstn (rstn)

`define BS_DUE_IF(x) \
	output wire [TRIAL``x``-1:0] sw_out_bit0_trial``x``, \
	input wire [TRIAL``x``-1:0] sw_in_bit0_trial``x``, \
	input wire [$clog2(TRIAL``x``)-1:0] shift_factor_trial``x``,

`define BS_INST_IF(x) \
    .sw_out_bit0 (sw_out_bit0_trial``x``), \
    .sys_clk (sys_clk), \
    .rstn (rstn), \
    .sw_in_bit0 (sw_in_bit0_trial``x``), \
    .shift_factor (shift_factor_trial``x``)