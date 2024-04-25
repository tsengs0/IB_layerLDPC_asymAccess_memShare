// Project: access_rqst_gen.memShare_sched
// File: memShare_monitor.sv
// Module: memShare_monitor
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
//
// # Description
// An axuiliary module to keep track of current progress of the SCU.memShare() including
//   a) Flag raising when beginning of a pipeline cycle for SCU.memShare(),
//   b) Design rule 1 is hit,
//   c) Design rule 2 is hit,
//   d) Design rule 3 is hit,
//   e) T.B.D.
//  So that the other control units can easily make decision for generating the proper
//  control signals.
//
// # Dependencies
// 	None

// # Resource utilisation:
// Xilinx:
//  6-input logic LUT: synthesis not started
//  FF: synthesis not started
// ----------------------------------------------------------------------------------------
//  # History
//  Date            Revision    Description                 Editor
//  13.April.2024   v0.01       First created               Bo-Yu Tseng
// ----------------------------------------------------------------------------------------
module memShare_monitor
    import memShare_config_pkg::*;
(
    input logic pipeCycle_begin_o, // To indicate the beginning of a pipeline cycle for SCU.memShare()

    input logic sys_clk,
    input logic rstn
);

endmodule