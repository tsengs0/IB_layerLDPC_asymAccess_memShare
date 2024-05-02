// Project: access_rqst_gen.memShare_sched
// File: memShare_rqstAddr_ctrl.sv
// Module: memShare_rqstAddr_ctrl
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
// Status: WIP
// # Description
//  The design block to generate the operand for the binary adder of which increments/updates
//  the read address of message-passing buffer during the SCU.memShare() period.

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
//  29.April.2024   v0.01       First created               Bo-Yu Tseng
// ----------------------------------------------------------------------------------------

module memShare_rqstAddr_ctrl 
    import memShare_config_pkg::*;
    import msgPass_config_pkg::*;
(
    output logic [memShare_config_pkg::MSGPASS_RD_ADDR_WIDTH-1:0] increment_operand_o,
    output logic [msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH-1:0] drc_base_addr_o,

    input logic [memShare_config_pkg::MSGPASS_RD_ADDR_WIDTH-1:0] msgPass_raddr_operand_i,
    input logic [MEMSHARE_DRC_NUM-1:0] is_drc_i,
    input logic scu_begin_i, // Indicating the start point of the SCU.memShare() 
    input logic sys_clk,
    input logic rstn
);

//----------------------------------------------------------------
// Local variables, nets, parameters
//----------------------------------------------------------------
localparam OPERAND_TRACK_DEPTH = 2;

//----------------------------------------------------------------
// To rebase the rqst address due to the DRC result
//----------------------------------------------------------------
always @(posedge sys_clk) begin: rqstAddr_rebase
    if(!rstn) base_addr_o <= (msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH)'(MSGPASS_ADDR_BASE);
    else if(scu_begin_i) base_addr_o <= (msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH)'(MSGPASS_ADDR_BASE);
    else if(exclusive_drc_1) drc_base_addr_o <= 
    else drc_base_addr_o <= drc_base_addr_o + 1;
end
//----------------------------------------------------------------
// Generation of the adder's operand to output the rqst addr. for 
// the mesage-passing buffer
//----------------------------------------------------------------
logic [memShare_config_pkg::MSGPASS_RD_ADDR_WIDTH-1:0] operand_track_pop;
pipeReg_insert #(
    .BITWIDTH (memShare_config_pkg::MSGPASS_RD_ADDR_WIDTH), //! Bitwidth of the designated signals
    .PIPELINE_STAGE (OPERAND_TRACK_DEPTH) //! Number of the pipeline stages
) operand_track (
    .pipe_reg_o (operand_track_pop[memShare_config_pkg::MSGPASS_RD_ADDR_WIDTH-1:0]),
    .sig_net_i (msgPass_raddr_operand_i[memShare_config_pkg::MSGPASS_RD_ADDR_WIDTH-1:0]),
    .pipeLoad_en_i ({OPERAND_TRACK_DEPTH{1'b1}}),
    .sys_clk (sys_clk),
    .rstn (rstn)
);

always @(posedge sys_clk) begin: rqstAddr_operand_gen
    if(!rstn) increment_operand_o <= 1;
    else if(is_drc_i[MEMSHARE_DRC1]) increment_operand_o <= operand_track_pop;
    else increment_operand_o <= 1;
end
endmodule
