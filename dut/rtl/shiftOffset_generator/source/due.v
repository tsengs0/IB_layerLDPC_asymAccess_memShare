`include "define.vh"
`include "due.vh"

module cumulative_sol2_due #(
    parameter QUAN_SIZE = 3,
    parameter TRIAL0 = 3,
    parameter TRIAL1 = 5,
    parameter TRIAL2 = 9,
    parameter TRIAL3 = 15,
    parameter TRIAL4 = 17,
    parameter TRIAL5 = 45,
    parameter TRIAL6 = 51,
    parameter TRIAL7 = 85,
    parameter TRIAL8 = 153,
    parameter TRIAL9 = 255
) (

`CUMULATIVE_SOL2_DUE_IF(0)
`CUMULATIVE_SOL2_DUE_IF(1)
`CUMULATIVE_SOL2_DUE_IF(2)
`CUMULATIVE_SOL2_DUE_IF(3)
`CUMULATIVE_SOL2_DUE_IF(4)
`CUMULATIVE_SOL2_DUE_IF(5)
`CUMULATIVE_SOL2_DUE_IF(6)
`CUMULATIVE_SOL2_DUE_IF(7)
`CUMULATIVE_SOL2_DUE_IF(8)
`CUMULATIVE_SOL2_DUE_IF(9)

input wire sys_clk,
input wire rstn
);

cumulative_shift_gen #(
    .SHARED_BANK_NUM (TRIAL0),
    .SHIFT_WIDTH ($clog2(TRIAL0)),
    .REF_WIDTH ($clog2(TRIAL0)),
    .PIPELINE_STAGE (2)
) cumuilative_trial0 (
    `CUMULATIVE_SOL2_INST_DUE_IF(0)
);

cumulative_shift_gen #(
    .SHARED_BANK_NUM (TRIAL1),
    .SHIFT_WIDTH ($clog2(TRIAL1)),
    .REF_WIDTH ($clog2(TRIAL1)),
    .PIPELINE_STAGE (2)
) cumuilative_trial1 (
    `CUMULATIVE_SOL2_INST_DUE_IF(1)
);
cumulative_shift_gen #(
    .SHARED_BANK_NUM (TRIAL2),
    .SHIFT_WIDTH ($clog2(TRIAL2)),
    .REF_WIDTH ($clog2(TRIAL2)),
    .PIPELINE_STAGE (2)
) cumuilative_trial2 (
    `CUMULATIVE_SOL2_INST_DUE_IF(2)
);
cumulative_shift_gen #(
    .SHARED_BANK_NUM (TRIAL3),
    .SHIFT_WIDTH ($clog2(TRIAL3)),
    .REF_WIDTH ($clog2(TRIAL3)),
    .PIPELINE_STAGE (2)
) cumuilative_trial3 (
    `CUMULATIVE_SOL2_INST_DUE_IF(3)
);
cumulative_shift_gen #(
    .SHARED_BANK_NUM (TRIAL4),
    .SHIFT_WIDTH ($clog2(TRIAL4)),
    .REF_WIDTH ($clog2(TRIAL4)),
    .PIPELINE_STAGE (2)
) cumuilative_trial4 (
    `CUMULATIVE_SOL2_INST_DUE_IF(4)
);

cumulative_shift_gen #(
    .SHARED_BANK_NUM (TRIAL5),
    .SHIFT_WIDTH ($clog2(TRIAL5)),
    .REF_WIDTH ($clog2(TRIAL5)),
    .PIPELINE_STAGE (2)
) cumuilative_trial5 (
    `CUMULATIVE_SOL2_INST_DUE_IF(5)
);
cumulative_shift_gen #(
    .SHARED_BANK_NUM (TRIAL6),
    .SHIFT_WIDTH ($clog2(TRIAL6)),
    .REF_WIDTH ($clog2(TRIAL6)),
    .PIPELINE_STAGE (2)
) cumuilative_trial6 (
    `CUMULATIVE_SOL2_INST_DUE_IF(6)
);
cumulative_shift_gen #(
    .SHARED_BANK_NUM (TRIAL7),
    .SHIFT_WIDTH ($clog2(TRIAL7)),
    .REF_WIDTH ($clog2(TRIAL7)),
    .PIPELINE_STAGE (2)
) cumuilative_trial7 (
    `CUMULATIVE_SOL2_INST_DUE_IF(7)
);
cumulative_shift_gen #(
    .SHARED_BANK_NUM (TRIAL8),
    .SHIFT_WIDTH ($clog2(TRIAL8)),
    .REF_WIDTH ($clog2(TRIAL8)),
    .PIPELINE_STAGE (2)
) cumuilative_trial8 (
    `CUMULATIVE_SOL2_INST_DUE_IF(8)
);
cumulative_shift_gen #(
    .SHARED_BANK_NUM (TRIAL9),
    .SHIFT_WIDTH ($clog2(TRIAL9)),
    .REF_WIDTH ($clog2(TRIAL9)),
    .PIPELINE_STAGE (2)
) cumuilative_trial9 (
    `CUMULATIVE_SOL2_INST_DUE_IF(9)
);
endmodule

module bs_due #(
    parameter TRIAL0 = 3,
    parameter TRIAL1 = 5,
    parameter TRIAL2 = 9,
    parameter TRIAL3 = 15,
    parameter TRIAL4 = 17,
    parameter TRIAL5 = 45,
    parameter TRIAL6 = 51,
    parameter TRIAL7 = 85,
    parameter TRIAL8 = 153,
    parameter TRIAL9 = 255
) (

`BS_DUE_IF(0)
`BS_DUE_IF(1)
`BS_DUE_IF(2)
`BS_DUE_IF(3)
`BS_DUE_IF(4)
`BS_DUE_IF(5)
`BS_DUE_IF(6)
`BS_DUE_IF(7)
`BS_DUE_IF(8)
`BS_DUE_IF(9)

input wire sys_clk,
input wire rstn
);

qsn_wrapper_len3_pipe0_q1 qsn3 (
    `BS_INST_IF(0)
);
qsn_wrapper_len5_pipe0_q1 qsn5 (
    `BS_INST_IF(1)
);
qsn_wrapper_len9_pipe1_q1 qsn9 (
    `BS_INST_IF(2)
);
qsn_wrapper_len15_pipe2_q1 qsn15 (
    `BS_INST_IF(3)
);
qsn_wrapper_len17_pipe2_q1 qsn17 (
    `BS_INST_IF(4)
);
qsn_wrapper_len45_pipe2_q1 qsn45 (
    `BS_INST_IF(5)
);
qsn_wrapper_len51_pipe2_q1 qsn51 (
    `BS_INST_IF(6)
);
qsn_wrapper_len85_pipe2_q1 qsn85 (
    `BS_INST_IF(7)
);
qsn_wrapper_len153_pipe3_q1 qsn153 (
    `BS_INST_IF(8)
);
qsn_wrapper_len255_pipe3_q1 qsn255 (
    `BS_INST_IF(9)
);
endmodule

module micro_bs_gen_due #(
    parameter TRIAL0 = 3,
    parameter TRIAL1 = 5,
    parameter TRIAL2 = 9,
    parameter TRIAL3 = 15,
    parameter TRIAL4 = 17,
    parameter TRIAL5 = 45,
    parameter TRIAL6 = 51
) (

`MICRO_BS_DUE_IF(0)
`MICRO_BS_DUE_IF(1)
`MICRO_BS_DUE_IF(2)
`MICRO_BS_DUE_IF(3)
`MICRO_BS_DUE_IF(4)
`MICRO_BS_DUE_IF(5)
`MICRO_BS_DUE_IF(6)

input wire sys_clk,
input wire rstn
);

micro_bs_gen #(
    .SHARED_BANK_NUM (TRIAL0),
    .SHIFT_WIDTH ($clog2(TRIAL0))
) micro_bs_gen_trial0 (
    `MICRO_BS_INST_IF(0)
);
micro_bs_gen #(
    .SHARED_BANK_NUM (TRIAL1),
    .SHIFT_WIDTH ($clog2(TRIAL1))
) micro_bs_gen_trial1 (
    `MICRO_BS_INST_IF(1)
);
micro_bs_gen #(
    .SHARED_BANK_NUM (TRIAL2),
    .SHIFT_WIDTH ($clog2(TRIAL2))
) micro_bs_gen_trial2 (
    `MICRO_BS_INST_IF(2)
);
micro_bs_gen #(
    .SHARED_BANK_NUM (TRIAL3),
    .SHIFT_WIDTH ($clog2(TRIAL3))
) micro_bs_gen_trial3 (
    `MICRO_BS_INST_IF(3)
);
micro_bs_gen #(
    .SHARED_BANK_NUM (TRIAL4),
    .SHIFT_WIDTH ($clog2(TRIAL4))
) micro_bs_gen_trial4 (
    `MICRO_BS_INST_IF(4)
);
micro_bs_gen #(
    .SHARED_BANK_NUM (TRIAL5),
    .SHIFT_WIDTH ($clog2(TRIAL5))
) micro_bs_gen_trial5 (
    `MICRO_BS_INST_IF(5)
);
micro_bs_gen #(
    .SHARED_BANK_NUM (TRIAL6),
    .SHIFT_WIDTH ($clog2(TRIAL6))
) micro_bs_gen_trial6 (
    `MICRO_BS_INST_IF(6)
);
endmodule