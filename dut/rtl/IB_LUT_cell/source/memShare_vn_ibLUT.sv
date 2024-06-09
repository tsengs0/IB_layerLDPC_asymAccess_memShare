// Project: IB-RAM implementation for the IB-RAM column-bank sharing scheme
// File: memShare_vn_ibLUT.sv
// Module: memShare_vn_ibLUT
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
//
// # Description
// A memory wrapper to realise the IB-RAM configured as either GP1 or GP2 based VN

// # Dependencies
// 	None

// # Resource utilisation:
// Xilinx:
//  6-input logic LUT: 
//  6-input LUTRAM:
//  FF: 
// ----------------------------------------------------------------------------------------
//  # History
//  Date            Revision    Description                 Editor
//  24.March.2023   v0.01       First created               Bo-Yu Tseng
// ----------------------------------------------------------------------------------------

module memShare_vn_ibLUT #(
    parameter ADDR_WIDTH = 6,
    parameter VN_LOAD_CYCLE = 64,
    parameter MSG_WIDTH = 4,
    parameter SHARE_GROUP = 1 // 1: GP1, 2: GP2
)(
    output logic [MSG_WIDTH-1:0] msgOut_o, // IB-LUT mapping resut

    input logic [MSG_WIDTH-1:0] remap_dataIn_i, // Input of the IB-LUT remapping data
    input logic [ADDR_WIDTH-1:0] map_remap_addr_i, // Common address port for IB-LUT mapping and remapping
    input logic remap_en_n, // active LOW
    input logic sys_clk, // Common clock for IB-RAM read and write
    input logic rstn // active LOW
);

reconfig_sp_sram # (
    .ADDR_BITWIDTH(ADDR_WIDTH),
    .PAGE_SIZE(MSG_WIDTH),
    .PAGE_NUM(VN_LOAD_CYCLE),
    .ASYNC_RD_EN(1)
) sp_sram (
    .rdata_o(msgOut_o[MSG_WIDTH-1:0]),
    .wdata_i(remap_dataIn_i[MSG_WIDTH-1:0]),
    .access_addr_i(map_remap_addr_i[ADDR_WIDTH-1:0]),
    .wen_n_i(remap_en_n),
    .sys_clk(sys_clk),
    .rstn(rstn)
);
endmodule