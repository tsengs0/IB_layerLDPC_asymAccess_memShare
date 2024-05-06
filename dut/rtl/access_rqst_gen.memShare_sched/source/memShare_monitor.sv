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
// 	memShare_config_pkg.sv

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
    // For debugging in testbench only, not for synthesis
    output logic [MEMSHARE_DRC_NUM-1:0] is_drc_o, 
    output logic pipeCycle_begin_o, // To indicate the beginning of a pipeline cycle for SCU.memShare()


    input logic isGtr_i, // Flag indicating the requests at the SHIFT_GEN state requires two alloction sequences
    input logic sys_clk,
    input logic rstn
);

//----------------------------------------------------
// Shift registers: Q^{arrival}_{i} for i=0, 1, ..., 3
//----------------------------------------------------
logic [ARR_RQST_TRACK_DEPTH-1:0] arrival_rqst_track;
always_ff @(posedge sys_clk) begin
    if(!rstn) arrival_rqst_track <= {{(ARR_RQST_TRACK_DEPTH-1){1'b0}}, 1'b1};
    else arrival_rqst_track[ARR_RQST_TRACK_DEPTH-1:0] <= {arrival_rqst_track[ARR_RQST_TRACK_DEPTH-2:0], arrival_rqst_track[ARR_RQST_TRACK_DEPTH-1]};
end
//----------------------------------------------------
// Shift registers: Q^{2seq}_{i} for i=0, 1, ..., 3
//----------------------------------------------------
logic [READ_2SEQ_TRACK_DEPTH-1:0] rd_2seq_track;
always_ff @(posedge sys_clk) if(!rstn) rd_2seq_track[0] <= 0; else rd_2seq_track[0] <= isGtr_i;
always_ff @(posedge sys_clk) begin
    if(!rstn) rd_2seq_track[READ_2SEQ_TRACK_DEPTH-1:1] <= 0;
    else rd_2seq_track[READ_2SEQ_TRACK_DEPTH-1:1] <= rd_2seq_track[READ_2SEQ_TRACK_DEPTH-2:0];
end
//----------------------------------------------------
// To detect the assertion of each design rule
//----------------------------------------------------
logic [MEMSHARE_DRC_NUM-1:0] is_drc /*verilator split_var*/;
assign is_drc[MEMSHARE_DRC1] = rd_2seq_track[0] & 
                               ~is_drc[MEMSHARE_DRC2] &
                               ~is_drc[MEMSHARE_DRC3];
assign is_drc[MEMSHARE_DRC2] = &rd_2seq_track[2:0];
assign is_drc[MEMSHARE_DRC3] = //is_drc[MEMSHARE_DRC2] &
                                ~rd_2seq_track[3] &
                                arrival_rqst_track[3];
assign is_drc_o[MEMSHARE_DRC_NUM-1:0] = is_drc[MEMSHARE_DRC_NUM-1:0];
//----------------------------------------------------
// Generation of the control signals or status flags
//----------------------------------------------------
assign pipeCycle_begin_o = is_drc[MEMSHARE_DRC3];
endmodule
