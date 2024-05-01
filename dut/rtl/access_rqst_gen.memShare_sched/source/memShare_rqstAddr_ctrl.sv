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

    input logic [MEMSHARE_DRC_NUM-1:0] is_drc_i,
    input logic scu_begin_i, // Indicating the start point of the SCU.memShare() 
    input logic sys_clk,
    input logic rstn
);

//----------------------------------------------------------------
// Local variables, nets, parameters
//----------------------------------------------------------------

//----------------------------------------------------------------
// DRC factor checking
//----------------------------------------------------------------
// According to the design spec., only DRC1 will cause an address rebase
logic exclusive_drc_1 = is_drc_i[MEMSHARE_DRC1]==1'b1 &&
                        is_drc_i[MEMSHARE_DRC2]==1'b0 &&
                        is_drc_i[MEMSHARE_DRC3]==1'b0;
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
always @(posedge sys_clk) begin: rqstAddr_operand_gen
    if(!rstn) increment_operand_o <= 0;
    else if(exclusive_drc_1) 
end
endmodule
