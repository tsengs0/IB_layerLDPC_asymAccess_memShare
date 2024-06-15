// Project: IB-RAM implementation for the IB-RAM column-bank sharing scheme
// File: reconfig_sp_sram_multibank2.sv
// Module: reconfig_sp_sram_multibank2
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
//
// # Description

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
//  10.June.2024   v0.01       First created               Bo-Yu Tseng
// ----------------------------------------------------------------------------------------

module reconfig_sp_sram_multibank2 #(
    parameter BANK_INTERLEAVE_TYPE = 0, // 0: {bank_addr, page_addr}, 1: {page_addr, bank_addr}
    parameter BANK_INTERLEAVE_NUM = 2, // # of the interleaving banks
    parameter ADDR_WIDTH = 6, // bank_addr+page_addr
    parameter BANK_ADDR_WIDTH = $clog2(BANK_INTERLEAVE_NUM),
    parameter PAGE_ADDR_WIDTH = ADDR_WIDTH-BANK_ADDR_WIDTH,
    parameter PAGE_SIZE = 4,
    parameter WDATA_SIZE = PAGE_SIZE*BANK_INTERLEAVE_NUM,
    parameter PAGE_NUM = 32,
    parameter ASYNC_RD_EN = 1 // 0: synchronous read, 1: asynchronous read
)(
    output logic [PAGE_SIZE-1:0] rdata_o,

    input logic [WDATA_SIZE-1:0] wdata_i,
    input logic [ADDR_WIDTH-1:0] access_addr_i, // Concatenation of bank and page addresses
    input logic wen_n_i, // active LOW
    input logic sys_clk,
    input logic rstn
);

logic bank_addr_net;
logic [PAGE_ADDR_WIDTH-1:0] page_addr_net;
logic [PAGE_SIZE-1:0] rdata_bank [0:BANK_INTERLEAVE_NUM-1];
logic [PAGE_SIZE-1:0] wdata_bank [0:BANK_INTERLEAVE_NUM-1];

genvar bank_id;
generate;
if(BANK_INTERLEAVE_TYPE==0) begin // access_addr_i = {bank_addr, page_addr}
    for(bank_id=0; bank_id<BANK_INTERLEAVE_NUM; bank_id=bank_id+1) begin: sp_sram_bank
        reconfig_sp_sram # (
            .ADDR_BITWIDTH(PAGE_ADDR_WIDTH),
            .PAGE_SIZE(PAGE_SIZE),
            .PAGE_NUM(PAGE_NUM),
            .ASYNC_RD_EN(ASYNC_RD_EN)
        ) sp_sram (
            .rdata_o(rdata_bank[bank_id]),
            .wdata_i(wdata_bank[bank_id]),
            .access_addr_i(page_addr_net[PAGE_ADDR_WIDTH-1:0]),
            .wen_n_i(wen_n_i),
            .sys_clk(sys_clk),
            .rstn(rstn)
        );
        assign wdata_bank[bank_id] = wdata_i[(bank_id+1)*PAGE_SIZE-1:bank_id*PAGE_SIZE];
    end
    assign bank_addr_net = access_addr_i[ADDR_WIDTH-1];
    assign page_addr_net[PAGE_ADDR_WIDTH-1:0] = access_addr_i[ADDR_WIDTH-2:0];
end
else begin // access_addr_i = {page_addr, bank_addr}
    for(bank_id=0; bank_id<BANK_INTERLEAVE_NUM; bank_id=bank_id+1) begin: sp_sram_bank
        reconfig_sp_sram # (
            .ADDR_BITWIDTH(PAGE_ADDR_WIDTH),
            .PAGE_SIZE(PAGE_SIZE),
            .PAGE_NUM(PAGE_NUM),
            .ASYNC_RD_EN(ASYNC_RD_EN)
        ) sp_sram (
            .rdata_o(rdata_bank[bank_id]),
            .wdata_i(wdata_bank[bank_id]),
            .access_addr_i(page_addr_net[PAGE_ADDR_WIDTH-1:0]),
            .wen_n_i(wen_n_i),
            .sys_clk(sys_clk),
            .rstn(rstn)
        );
        assign wdata_bank[bank_id] = wdata_i[(bank_id+1)*PAGE_SIZE-1:bank_id*PAGE_SIZE];
    end
    assign bank_addr_net = access_addr_i[0];
    assign page_addr_net[PAGE_ADDR_WIDTH-1:0] = access_addr_i[ADDR_WIDTH-1:1];
end
endgenerate
assign rdata_o[PAGE_SIZE-1:0] = (bank_addr_net==1'b0) ? rdata_bank[0] : rdata_bank[1];
endmodule
