`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.11.2022 23:57:41
// Design Name: 
// Module Name: permutation_wrapper
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


module permutation_wrapper #(
	parameter PERMUTATION_LENGTH = 765,
	parameter PIPELINE_STAGES = 4,
	parameter QUAN_SIZE = 3
) (
	output wire [764:0] sw_out_bit0,
	output wire [764:0] sw_out_bit1,
	output wire [764:0] sw_out_bit2,
//	output wire [764:0] sw_out_bit3,

	input wire sys_clk,
	input wire rstn,
	input wire [764:0] sw_in_bit0,
	input wire [764:0] sw_in_bit1,
	input wire [764:0] sw_in_bit2,
//	input wire [764:0] sw_in_bit3,
	input wire [9:0] shift_factor
 );

wire [9:0] left_sel;
wire [9:0] right_sel;
wire [763:0] merge_sel;

qsn_top_len765 qsn_top_len765_u0 (
	.sw_out_bit0 (sw_out_bit0),
	.sw_out_bit1 (sw_out_bit1),
	.sw_out_bit2 (sw_out_bit2),
//	.sw_out_bit3 (sw_out_bit3),

	.sys_clk (sys_clk),
	.rstn (rstn),
	.sw_in_bit0 (sw_in_bit0),
	.sw_in_bit1 (sw_in_bit1),
	.sw_in_bit2 (sw_in_bit2),
//	.sw_in_bit3 (sw_in_bit3),
	.left_sel  (left_sel ),
	.right_sel (right_sel),
	.merge_sel (merge_sel) 
);

qsn_controller_len765 #(
	.PERMUTATION_LENGTH (PERMUTATION_LENGTH)
) qsn_controller_len765_u0 (
	.left_sel     (left_sel),
	.right_sel    (right_sel),
	.merge_sel    (merge_sel),
	.shift_factor (shift_factor),
	.rstn (rstn),
	.sys_clk (sys_clk)
);
endmodule