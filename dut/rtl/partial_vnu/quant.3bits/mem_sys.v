`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2020 02:21:12 PM
// Design Name: 
// Module Name: mem_sys
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "define.vh"
module mem_sys (
	output wire [`VN_RD_BW-1:0] vn_iter0_m0_portA_dout,
	output wire [`VN_RD_BW-1:0] vn_iter0_m0_portB_dout,
	output wire [`VN_RD_BW-1:0] vn_iter0_m1_portA_dout,
	output wire [`VN_RD_BW-1:0] vn_iter0_m1_portB_dout,
	output wire [`DN_RD_BW-1:0] dn_iter0_portA_dout,
	output wire [`DN_RD_BW-1:0] dn_iter0_portB_dout,
	
	output wire [`VN_RD_BW-1:0] vn_iter1_m0_portA_dout,
	output wire [`VN_RD_BW-1:0] vn_iter1_m0_portB_dout,
	output wire [`VN_RD_BW-1:0] vn_iter1_m1_portA_dout,
	output wire [`VN_RD_BW-1:0] vn_iter1_m1_portB_dout,
	output wire [`DN_RD_BW-1:0] dn_iter1_portA_dout,
	output wire [`DN_RD_BW-1:0] dn_iter1_portB_dout,


	input wire [`VN_ADDR_BW-1:0] vn_iter0_m0_portA_addr,
	input wire [`VN_ADDR_BW-1:0] vn_iter0_m0_portB_addr,
	input wire [`VN_ADDR_BW-1:0] vn_iter0_m1_portA_addr,
	input wire [`VN_ADDR_BW-1:0] vn_iter0_m1_portB_addr,
	input wire [`DN_ADDR_BW-1:0] dn_iter0_portA_addr,
	input wire [`DN_ADDR_BW-1:0] dn_iter0_portB_addr,

	input wire [`VN_ADDR_BW-1:0] vn_iter1_m0_portA_addr,
	input wire [`VN_ADDR_BW-1:0] vn_iter1_m0_portB_addr,
	input wire [`VN_ADDR_BW-1:0] vn_iter1_m1_portA_addr,
	input wire [`VN_ADDR_BW-1:0] vn_iter1_m1_portB_addr,
	input wire [`DN_ADDR_BW-1:0] dn_iter1_portA_addr,
	input wire [`DN_ADDR_BW-1:0] dn_iter1_portB_addr,

	input wire vn_write_clk,
	input wire dn_write_clk
    );
	
ib_rom_system_wrapper mem_u0 (
    .dn_iter0_portA_addr    (dn_iter0_portA_addr   ),
    .dn_iter0_portA_clk     (dn_write_clk    ),
    .dn_iter0_portA_dout    (dn_iter0_portA_dout   ),
    .dn_iter0_portB_addr    (dn_iter0_portB_addr   ),
    .dn_iter0_portB_clk     (dn_write_clk    ),
    .dn_iter0_portB_dout    (dn_iter0_portB_dout   ),
    .dn_iter1_portA_addr    (dn_iter1_portA_addr   ),
    .dn_iter1_portA_clk     (dn_write_clk    ),
    .dn_iter1_portA_dout    (dn_iter1_portA_dout   ),
    .dn_iter1_portB_addr    (dn_iter1_portB_addr   ),
    .dn_iter1_portB_clk     (dn_write_clk    ),
    .dn_iter1_portB_dout    (dn_iter1_portB_dout   ),
    .vn_iter0_m0_portA_addr (vn_iter0_m0_portA_addr),
    .vn_iter0_m0_portA_clk  (vn_write_clk ),
    .vn_iter0_m0_portA_dout (vn_iter0_m0_portA_dout),
    .vn_iter0_m0_portB_addr (vn_iter0_m0_portB_addr),
    .vn_iter0_m0_portB_clk  (vn_write_clk ),
    .vn_iter0_m0_portB_dout (vn_iter0_m0_portB_dout),
    .vn_iter0_m1_portA_addr (vn_iter0_m1_portA_addr),
    .vn_iter0_m1_portA_clk  (vn_write_clk ),
    .vn_iter0_m1_portA_dout (vn_iter0_m1_portA_dout),
    .vn_iter0_m1_portB_addr (vn_iter0_m1_portB_addr),
    .vn_iter0_m1_portB_clk  (vn_write_clk ),
    .vn_iter0_m1_portB_dout (vn_iter0_m1_portB_dout),
    .vn_iter1_m0_portA_addr (vn_iter1_m0_portA_addr),
    .vn_iter1_m0_portA_clk  (vn_write_clk ),
    .vn_iter1_m0_portA_dout (vn_iter1_m0_portA_dout),
    .vn_iter1_m0_portB_addr (vn_iter1_m0_portB_addr),
    .vn_iter1_m0_portB_clk  (vn_write_clk ),
    .vn_iter1_m0_portB_dout (vn_iter1_m0_portB_dout),
    .vn_iter1_m1_portA_addr (vn_iter1_m1_portA_addr),
    .vn_iter1_m1_portA_clk  (vn_write_clk ),
    .vn_iter1_m1_portA_dout (vn_iter1_m1_portA_dout),
    .vn_iter1_m1_portB_addr (vn_iter1_m1_portB_addr),
    .vn_iter1_m1_portB_clk  (vn_write_clk ),
    .vn_iter1_m1_portB_dout (vn_iter1_m1_portB_dout)  	
);
endmodule
