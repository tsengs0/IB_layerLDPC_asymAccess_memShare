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
    import memShare_config_pkg::*;
(
    output logic [memShare_config_pkg::MSGPASS_RD_ADDR_WIDTH-1:0] msgPass_baseAddr_o,
    input logic sys_clk,
    input logic rstn
);

//localparam ADDR_WIDTH = memShare_config_pkg::MSGPASS_RD_ADDR_WIDTH;
//localparam BASE_NUM = memShare_config_pkg::MSGPASS_BASEADDR_NUM;
//memShare_rqstAddr_rebase  memShare_rqstAddr_rebase (
//    .base_addr_o(base_addr_o),
//    .baseAddr_aggregation_i(baseAddr_aggregation_i),
//    .baseAddr_sel_i(baseAddr_sel_i),
//    .sys_clk(sys_clk),
//    .rstn(rstn)
//);
assign msgPass_baseAddr_o = 0; // dummy value for ease of the debugging
endmodule
