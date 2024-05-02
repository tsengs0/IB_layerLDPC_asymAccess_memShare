// Project: access_rqst_gen.memShare_sched
// File: dmy_msgPass_addr_gen.sv
// Module: dmy_msgPass_addr_gen
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
// Status: WIP
// # Description
//  A dummy model to simulate the read address generator of the message-pass buffer
//  which only bypasses the base addresses of the SCU.memShare()'s target memory region
//  to the output port.

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
//  30.April.2024   v0.01       First created               Bo-Yu Tseng
// ----------------------------------------------------------------------------------------

module dmy_msgPass_addr_gen
    import msgPass_config_pkg::*;
    import memShare_config_pkg::*;
(
    output logic [msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH-1:0] addr_o,    

    input logic [MEMSHARE_DRC_NUM-1:0] is_drc_i,
    input logic [msgPass_config_pkg::INCREMENT_SRC_SEL_WIDTH-1:0] incrementSrc_sel_i,
    input logic sys_clk,
    input logic rstn
);

//----------------------------------------------------------------
// Local variables, nets, parameters
//----------------------------------------------------------------
localparam ADDR_WIDTH = msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH;
localparam INCREMENT_VAL_WIDTH = memShare_config_pkg::MSGPASS_RD_ADDR_WIDTH;

//----------------------------------------------------------------
// Operand A: base address
//----------------------------------------------------------------
logic [INCREMENT_VAL_WIDTH-1:0] base_addr;
//localparam ADDR_WIDTH = memShare_config_pkg::MSGPASS_RD_ADDR_WIDTH;
//localparam BASE_NUM = memShare_config_pkg::MSGPASS_BASEADDR_NUM;
//memShare_rqstAddr_rebase  memShare_rqstAddr_rebase (
//    .base_addr_o(base_addr_o),
//    .baseAddr_aggregation_i(baseAddr_aggregation_i),
//    .baseAddr_sel_i(baseAddr_sel_i),
//    .sys_clk(sys_clk),
//    .rstn(rstn)
//);
assign base_addr[INCREMENT_VAL_WIDTH-1:0] = 0; // dummy value for ease of the debugging
//----------------------------------------------------------------
// Operand B: incrementing value
//----------------------------------------------------------------
logic [INCREMENT_VAL_WIDTH-1:0] increment_val_net;
logic [INCREMENT_VAL_WIDTH-1:0] increment_val_pipe0;
logic [INCREMENT_VAL_WIDTH-1:0] increment_src_vec [0:INCREMENT_SRC_NUM-1];
logic [INCREMENT_VAL_WIDTH-1:0] memShare_increment_val;
memShare_rqstAddr_ctrl  memShare_rqstAddr_ctrl (
    .increment_operand_o(memShare_increment_val),
//    .drc_base_addr_o(drc_base_addr_o),
    .msgPass_raddr_operand_i(increment_val_net),
    .is_drc_i(is_drc_i),
//    .scu_begin_i(scu_begin_i),
    .sys_clk(sys_clk),
    .rstn(rstn)
);

assign increment_src_vec[0] = increment_val_pipe0;
assign increment_src_vec[1] = 1;
assign increment_src_vec[2] = memShare_increment_val;
assign increment_val_net[INCREMENT_VAL_WIDTH-1:0] = increment_src_vec[incrementSrc_sel_i];
always @(posedge sys_clk) if(!rstn) increment_val_pipe0 <= 0; else increment_val_pipe0 <= increment_val_net;
//----------------------------------------------------------------
// Binary adder
//----------------------------------------------------------------
assign addr_o[ADDR_WIDTH-1:0] = base_addr[INCREMENT_VAL_WIDTH-1:0]+increment_val_net[INCREMENT_VAL_WIDTH-1:0];
endmodule
