// Project: access_rqst_gen.memShare_sched
// File: memShare_skid_ctrl.sv
// Module: memShare_skid_ctrl
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
//
// # Description
// The generator of skid buffer control signal which controls the skid buffer's multiplexer
// inside the partial function of the shift control unit for shared memory allocation.
// For detail of the above partial function, please refer to the definition of SCU.memShare().

// # Dependencies
// 	memShare_config_pkg.sv

// # Resource utilisation:
// Xilinx:
//  6-input logic LUT: 1
//  FF: 4
// ----------------------------------------------------------------------------------------
//  # History
//  Date            Revision    Description                 Editor
//  24.March.2024   v0.01       First created               Bo-Yu Tseng
// ----------------------------------------------------------------------------------------
module memShare_skid_ctrl
    import memShare_config_pkg::*;
(
    output logic isColAddr_skid_o,

    input logic scu_memShare_busy_i, // Asserted within overall SCU.memShare() operation
    input logic pipeCycle_begin_i, // To indicate the beginning of a pipeline cycle for SCU.memShare()
    input logic isGtr_i, // isGtr obtainned from RFMU at SHFIT_GEN state
    input logic sys_clk,
    input logic rstn
);

// Internal signals and local parameters
localparam logic NOSKID = 1'b0;
localparam logic SKID = 1'b1;
localparam COND_BACK2BACK = 2**(MAX_ALLOC_SEQ_NUM+1)-1;
logic isColAddr_skid_pipe0;
logic isColAddr_skid_net;

// Design w.r.t. the design rule 2 of SCU.memShare()
logic [MAX_ALLOC_SEQ_NUM:0] isGtr_pipe;
logic isGtr_back2back;
always_ff @(posedge sys_clk) if(!rstn) isGtr_pipe <= {{(MAX_ALLOC_SEQ_NUM){1'b0}}, NOSKID}; else isGtr_pipe[MAX_ALLOC_SEQ_NUM:0] <= {isGtr_pipe[MAX_ALLOC_SEQ_NUM-1:0], isGtr_i};
assign isGtr_back2back = ({isGtr_pipe[MAX_ALLOC_SEQ_NUM-1:0], isGtr_i}==COND_BACK2BACK) ? 1'b1 : 1'b0; // Either 4'b0111 or 4'b1111 matches the back-to-back condition, i.e. DRC2 

// Final decision of skid buffer selector based on the design rule 1, 2 and 3
always_comb begin: drc_skid_sel
    casez({scu_memShare_busy_i, isGtr_i, isGtr_back2back, pipeCycle_begin_i})
        4'b0???: isColAddr_skid_net = NOSKID; // Refer to the Note 1
        4'b1100: isColAddr_skid_net = SKID;   // Design Rule 1
        4'b1?10: isColAddr_skid_net = NOSKID; // Design Rule 2
        4'b1?01: isColAddr_skid_net = NOSKID; // Design Rule 3
        4'b1?11: isColAddr_skid_net = NOSKID; // Design Rule 2 and 3
        default: isColAddr_skid_net = NOSKID;
    endcase
end: drc_skid_sel

always_ff @(posedge sys_clk) if(!rstn) isColAddr_skid_pipe0 <= 1'b0; else isColAddr_skid_pipe0 <= isColAddr_skid_net;
//assign isColAddr_skid_o = isColAddr_skid_pipe0;
assign isColAddr_skid_o = isColAddr_skid_net;

// (Note 1)
// To fix the "isColAddr_skid_net" to its initial value, i.e. NOSKID, before/outside the SCU.memShare() operation.
// Otherwise, the X-value propagation will occur.
endmodule
