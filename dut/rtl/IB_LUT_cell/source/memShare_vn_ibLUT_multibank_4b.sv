// Project: IB-RAM implementation for the IB-RAM column-bank sharing scheme
// File: memShare_vn_ibLUT_multibank_4b.sv
// Module: memShare_vn_ibLUT_multibank_4b
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
//
// # Description
// A memory wrapper to realise the IB-RAM configured as either GP1 or GP2 based VN

// # Dependencies
// 	ibRAM_config_pkg.sv

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

module memShare_vn_ibLUT_multibank_4b
    import ibRAM_config_pkg::*;
#(
    parameter BANK_INTERLEAVE_NUM = 2, // # of the interleaving banks
    parameter ADDR_WIDTH = 6,
    parameter VN_LOAD_CYCLE = 64,
    parameter MSG_WIDTH = 4,
    parameter REMAP_DATAIN_WIDTH = 16,
    parameter SHARE_GROUP = 1 // 1: GP1, 2: GP2
)(
    output logic [MSG_WIDTH-1:0] msgOut_o, // IB-LUT mapping resut

    input logic [REMAP_DATAIN_WIDTH-1:0] remap_dataIn_i, // Input of the IB-LUT remapping data
    input logic [ADDR_WIDTH-1:0] map_remap_addr_i, // Common address port for IB-LUT mapping and remapping
    input logic remap_en_n, // active LOW
    input logic sys_clk, // Common clock for IB-RAM read and write
    input logic rstn // active LOW
);

generate;
if(BANK_INTERLEAVE_NUM==2) begin
    reconfig_sp_sram_multibank2 #(
        .BANK_INTERLEAVE_TYPE (Q4_BI2_BANK_INTERLEAVE_TYPE),
        .BANK_INTERLEAVE_NUM  (Q4_BI2_BANK_INTERLEAVE_NUM ),
        .ADDR_WIDTH           (Q4_BI2_ADDR_WIDTH          ),
        .BANK_ADDR_WIDTH      (Q4_BI2_BANK_ADDR_WIDTH     ),
        .PAGE_ADDR_WIDTH      (Q4_BI2_PAGE_ADDR_WIDTH     ),
        .PAGE_SIZE            (Q4_BI2_PAGE_SIZE           ),
        .WDATA_SIZE           (Q4_BI2_WDATA_SIZE          ),
        .PAGE_NUM             (Q4_BI2_PAGE_NUM            ),
        .ASYNC_RD_EN          (Q4_BI2_ASYNC_RD_EN         )
    ) sp_sram (
        .rdata_o(msgOut_o[MSG_WIDTH-1:0]),
        .wdata_i(remap_dataIn_i[REMAP_DATAIN_WIDTH-1:0]),
        .access_addr_i(map_remap_addr_i[ADDR_WIDTH-1:0]),
        .wen_n_i(remap_en_n),
        .sys_clk(sys_clk),
        .rstn(rstn)
    );
end
else begin // BANK_INTERLEAVE_NUM=4
    reconfig_sp_sram_multibank4 #(
        .BANK_INTERLEAVE_TYPE (Q4_BI4_BANK_INTERLEAVE_TYPE),
        .BANK_INTERLEAVE_NUM  (Q4_BI4_BANK_INTERLEAVE_NUM ),
        .ADDR_WIDTH           (Q4_BI4_ADDR_WIDTH          ),
        .BANK_ADDR_WIDTH      (Q4_BI4_BANK_ADDR_WIDTH     ),
        .PAGE_ADDR_WIDTH      (Q4_BI4_PAGE_ADDR_WIDTH     ),
        .PAGE_SIZE            (Q4_BI4_PAGE_SIZE           ),
        .WDATA_SIZE           (Q4_BI4_WDATA_SIZE          ),
        .PAGE_NUM             (Q4_BI4_PAGE_NUM            ),
        .ASYNC_RD_EN          (Q4_BI4_ASYNC_RD_EN         )
    ) sp_sram (
        .rdata_o(msgOut_o[MSG_WIDTH-1:0]),
        .wdata_i(remap_dataIn_i[REMAP_DATAIN_WIDTH-1:0]),
        .access_addr_i(map_remap_addr_i[ADDR_WIDTH-1:0]),
        .wen_n_i(remap_en_n),
        .sys_clk(sys_clk),
        .rstn(rstn)
    );
end
endgenerate
endmodule
