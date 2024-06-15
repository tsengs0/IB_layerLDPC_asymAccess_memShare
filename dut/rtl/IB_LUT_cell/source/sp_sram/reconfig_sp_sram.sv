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

module reconfig_sp_sram #(
    parameter ADDR_BITWIDTH = 6,
    parameter PAGE_SIZE = 4,
    parameter PAGE_NUM = 64,
    parameter ASYNC_RD_EN = 1 // 0: synchronous read, 1: asynchronous read
) (
    output logic [PAGE_SIZE-1:0] rdata_o,
    
    input logic [PAGE_SIZE-1:0] wdata_i,
    input logic [ADDR_BITWIDTH-1:0] access_addr_i,
    input logic wen_n_i, // active LOW
    input logic sys_clk,
    input rstn // active LOW
);

(* ram_style = "distributed" *) reg [PAGE_SIZE-1:0] mem [0:PAGE_NUM-1];

generate;
// Synchronous or Asynchronous read with the "sys_clk"
if(ASYNC_RD_EN==1) begin
    assign rdata_o[PAGE_SIZE-1:0] = mem[ access_addr_i[ADDR_BITWIDTH-1:0] ];
end
else begin
    always @(posedge sys_clk) begin
        if(!rstn) rdata_o[PAGE_SIZE-1:0] <= 0;
        else rdata_o[PAGE_SIZE-1:0] <= mem[ access_addr_i[ADDR_BITWIDTH-1:0] ];
    end
end
endgenerate

always @(posedge sys_clk) begin
    if(!wen_n_i) mem[ access_addr_i[ADDR_BITWIDTH-1:0] ] <= wdata_i[PAGE_SIZE-1:0];
end
endmodule
