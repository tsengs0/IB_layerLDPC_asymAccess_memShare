// Project: Parameterised/Reconfigurable SRAM macros
// File: reconfig_sp_sram.sv
// Module: reconfig_sp_sram
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
//
// # Description
// A parameterisable/reconfigurable single-port SRAM macro where the
// read data port can be either synchronous or asyncronous with the "sys_clk".

// # Dependencies
// 	None

// # Resource utilisation:
// Xilinx:
//  6-input logic LUT: 
//  FF: 
// ----------------------------------------------------------------------------------------
//  # History
//  Date            Revision    Description                 Editor
//  24.March.2022   v0.01       First created               Bo-Yu Tseng
// ----------------------------------------------------------------------------------------

module memShare_vn_ibLUT #(
    parameter RD_ADDR_BITWIDTH = 6,
    parameter WR_ADDR_BITWIDTH = 6,
    parameter RD_BITWIDTH = 4,
    parameter WR_BITWIDTH = 4,
    parameter VN_LOAD_CYCLE = 64,
    parameter MSG_BITWIDTH = 4
)(
    output logic [MSG_BITWIDTH-1:0] msgOut_o,

    input logic [RD_ADDR_BITWIDTH-1:0] raddr_i,
    input logic [WR_ADDR_BITWIDTH-1:0] waddr_i,
    input logic wen_i, // active LOW
    input logic sys_clk,
    input logic rstn // active LOW
);

endmodule