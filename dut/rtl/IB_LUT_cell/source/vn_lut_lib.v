`timescale 1ns/1ps

//`include "memShare_regList.vh"

module vn_lut_areaEval (
    // share2to5_gp2_vn_lut_3b
    output wire [3-1:0] lut_data0_u0,
    input wire [5-1+1:0] read_addr0_u0,
    input wire [3-1:0] lut_in_u0,
    input wire [5-1+1:0] write_addr_u0,
    input wire we_u0,

    // share2to5_gp1_vn_lut_3b
    output wire [3-1:0] lut_data0_u1,
    input wire [4-1+1:0] read_addr0_u1,
    input wire [3-1:0] lut_in_u1,
    input wire [4-1+1:0] write_addr_u1,
    input wire we_u1,

    // share2to5_gp1_vn_lut_3b x 2 inst.
    output wire [3*2-1:0] lut_data0_u2,
    input wire [4*2-1+1:0] read_addr0_u2,
    input wire [3*2-1:0] lut_in_u2,
    input wire [4*2-1+1:0] write_addr_u2,
    input wire we_u2,

    // sym_vn_lut
    output wire [2:0] lut_data0_u3,
    output wire [2:0] lut_data1_u3,
    input wire [2:0] lut_in_replicate_0_u3,
    input wire [4+1:0] write_addr_replicate_0_u3,
    input wire [2:0] lut_in_replicate_1_u3,
    input wire [4+1:0] write_addr_replicate_1_u3,
    input wire [4+1:0] read_addr0_u3,
    input wire [4+1:0] read_addr1_u3,
    input wire we_u3,

    input wire write_clk,
    input wire sys_clk, //! exclusive bypass of read_clk and write_clk is switched at higher layer of hierarchy
    input wire rstn
);

share2to5_gp2_vn_lut_3b #(
  .MSG_BITWIDTH(3),
  .VN_LOAD_CYCLE(32*2),
  .RD_BITWIDTH(3),
  .RD_ADDR_BITWIDTH(5+1),
  .WR_BITWIDTH(3),
  .WR_ADDR_BITWIDTH (5+1)
) share2to5_gp2_vn_lut_3b_u0 (
  .lut_data0 (lut_data0_u0),
  .read_addr0 (read_addr0_u0),
  .lut_in (lut_in_u0),
  .write_addr (write_addr_u0),
  .we (we_u0),
  .sys_clk (sys_clk ),
  .rstn  ( rstn)
);

share2to5_gp1_vn_lut_3b #(
  .MSG_BITWIDTH(3),
  .VN_LOAD_CYCLE(16*2),
  .RD_BITWIDTH(3),
  .RD_ADDR_BITWIDTH(4+1),
  .WR_BITWIDTH(3),
  .WR_ADDR_BITWIDTH (4+1)
) share2to5_gp1_vn_lut_3b_u1 (
  .lut_data0 (lut_data0_u1),
  .read_addr0 (read_addr0_u1),
  .lut_in (lut_in_u1),
  .write_addr (write_addr_u1),
  .we (we_u1),
  .sys_clk (sys_clk ),
  .rstn  ( rstn)
);

share2to5_gp1_vn_lut_3b #(
  .MSG_BITWIDTH(3*2),
  .VN_LOAD_CYCLE(256*2),
  .RD_BITWIDTH(3*2),
  .RD_ADDR_BITWIDTH(4*2+1),
  .WR_BITWIDTH(3*2),
  .WR_ADDR_BITWIDTH (4*2+1)
) share2to5_gp1_vn_lut_3b_u2 (
  .lut_data0 (lut_data0_u2),
  .read_addr0 (read_addr0_u2),
  .lut_in (lut_in_u2),
  .write_addr (write_addr_u2),
  .we (we_u2),
  .sys_clk (sys_clk ),
  .rstn  ( rstn)
);

sym_vn_lut_3b #(
    .RD_ADDR_BITWIDTH(5+1),
    .WR_BITWIDTH(3),
    .WR_ADDR_BITWIDTH(5+1),
    .VN_LOAD_CYCLE(32*2)
) sym_vn_lut_u3 (
  .lut_data0 (lut_data0_u3 ),
  .lut_data1 (lut_data1_u3 ),
  .lut_in_replicate_0 (lut_in_replicate_0_u3 ),
  .write_addr_replicate_0 (write_addr_replicate_0_u3 ),
  .lut_in_replicate_1 (lut_in_replicate_1_u3 ),
  .write_addr_replicate_1 (write_addr_replicate_1_u3 ),
  .read_addr0 (read_addr0_u3 ),
  .read_addr1 (read_addr1_u3 ),
  .we (we_u3),
  .write_clk  (write_clk)
);
endmodule
//---------------------------------------------------------------------------------------------------------
/**
* Latest date: 5th March., 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: share2to5_gp2_vn_lut_3b
* 
* # I/F
* 1) Output:
*
* 2) Input:
*
* # Param

* # Description

* # Dependencies
    1) Preprocessor to add any new special function register
        ./memShare_regList.vh
*
* # Remark
*	Type-0 Register: 7 bits wide
    Type-0 Register Array: 64 page
    Memory Cell: 64x7bit
*		LUT: 11
        Logic LUT: 4
        LUTRAM: 7
		FF: 13
        I/O: 30
        Freq: 400MHz
        WNS: +1.895 ns
        TNS: 0.0 ns
        WHS: +0.070 ns
        THS: 0.0 ns
        WPWS: 0.718 ns
        TPWS: 0.0 ns
**/
module share2to5_gp2_vn_lut_3b #(
    parameter MSG_BITWIDTH = 3,     //! bit width per qunatised/compressed message
    parameter VN_LOAD_CYCLE = 32,
    parameter RD_BITWIDTH = 3,      //! bit width of read data
    parameter RD_ADDR_BITWIDTH = 5, //! bit width of read address
    parameter WR_BITWIDTH = 3,      //! bit width of write data
    parameter WR_ADDR_BITWIDTH = 5  //! bit width of write address
) (
    output wire [MSG_BITWIDTH-1:0] lut_data0,
    
    input wire [RD_ADDR_BITWIDTH-1:0] read_addr0,
    input wire [WR_BITWIDTH-1:0] lut_in,
    input wire [WR_ADDR_BITWIDTH-1:0] write_addr,

    input wire we,
    input wire sys_clk, //! exclusive bypass of read_clk and write_clk is switched at higher layer of hierarchy
    input wire rstn
);
//`define SINGLE_PORT_RAM
//`define SDP_RAM
`define LUTRAM_INFER

`ifdef SINGLE_PORT_RAM
//---------------------------------------------
// IB-LUT memory cell
// Instantiation of single-port RAM
//---------------------------------------------
wire [RD_ADDR_BITWIDTH-1:0] access_addr;
lutMem_1bankX1port #(
    .QUAN_SIZE(MSG_BITWIDTH),
    .PAGE_NUM(VN_LOAD_CYCLE),
    .ADDR_BITWIDTH(RD_ADDR_BITWIDTH)
) lutMem_1bankX1port_regType0 (
    .read_page_o   (lut_data0),
    .write_data_i  (lut_in),
    .access_addr_i (access_addr),
    .we_i          (we),
    .sys_clk       (sys_clk)
);
assign access_addr[RD_ADDR_BITWIDTH-1:0] = (we == 1'b0) ? read_addr0[RD_ADDR_BITWIDTH-1:0] : write_addr[WR_ADDR_BITWIDTH-1:0];
`endif // SINGLE_PORT_RAM

`ifdef SDP_RAM
//---------------------------------------------
// IB-LUT memory cell
// Instantiation of Simple Dual-Port RAM
//---------------------------------------------
lutMem_1bank_sdp #(
	.QUAN_SIZE (MSG_BITWIDTH),
    .PAGE_NUM (VN_LOAD_CYCLE),
	.ADDR_BITWIDTH (RD_ADDR_BITWIDTH)
) lutMem_1bank_sdp (
    .read_page_o (lut_data0),
 
    .write_data_i (lut_in),
    .write_addr_i (write_addr),
    .read_addr_i (read_addr0),
    .we_i (we),
    .read_clk (sys_clk),
    .write_clk (sys_clk)
);
`endif // SDP_RAM

`ifdef LUTRAM_INFER
//---------------------------------------------
// IB-LUT memory cell
// Inferring the Xilinx LUTRAM
// Instantiation of Asynchronous single-port RAM
//---------------------------------------------
lutMem_async_1bankX1port_3b #(
    .QUAN_SIZE (MSG_BITWIDTH),
    .PAGE_NUM (VN_LOAD_CYCLE),
    .ADDR_BITWIDTH (RD_ADDR_BITWIDTH),
    .XILINX_LUTRAM_INFER (1)
) lutMem_async_1bankX1port_3b (
    .read_page_o (lut_data0),

    .read_addr_i (read_addr0),
    .write_data_i (lut_in),
    .write_addr_i (write_addr),
    .we_i (we),
    .write_clk (sys_clk)
);
`endif // LUTRAM_INFER
endmodule

/**
* Latest date: 5th March., 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: share2to5_gp1_vn_lut_3b
* 
* # I/F
* 1) Output:
*
* 2) Input:
*
* # Param

* # Description

* # Dependencies
    1) Preprocessor to add any new special function register
        ./memShare_regList.vh
*
* # Remark
*	Type-0 Register: 7 bits wide
    Type-0 Register Array: 64 page
    Memory Cell: 64x7bit
*		LUT: 11
        Logic LUT: 4
        LUTRAM: 7
		FF: 13
        I/O: 30
        Freq: 400MHz
        WNS: +1.895 ns
        TNS: 0.0 ns
        WHS: +0.070 ns
        THS: 0.0 ns
        WPWS: 0.718 ns
        TPWS: 0.0 ns
**/
module share2to5_gp1_vn_lut_3b #(
    parameter MSG_BITWIDTH = 3,     //! bit width per qunatised/compressed message
    parameter VN_LOAD_CYCLE = 16,
    parameter RD_BITWIDTH = 3,      //! bit width of read data
    parameter RD_ADDR_BITWIDTH = 4, //! bit width of read address
    parameter WR_BITWIDTH = 3,      //! bit width of write data
    parameter WR_ADDR_BITWIDTH = 4  //! bit width of write address
) (
    output wire [MSG_BITWIDTH-1:0] lut_data0,
    
    input wire [RD_ADDR_BITWIDTH-1:0] read_addr0,
    input wire [WR_BITWIDTH-1:0] lut_in,
    input wire [WR_ADDR_BITWIDTH-1:0] write_addr,

    input wire we,
    input wire sys_clk, //! exclusive bypass of read_clk and write_clk is switched at higher layer of hierarchy
    input wire rstn
);

//`define SINGLE_PORT_RAM
//`define SDP_RAM
`define LUTRAM_INFER

`ifdef SINGLE_PORT_RAM
//---------------------------------------------
// IB-LUT memory cell
// Instantiation of single-port RAM
//---------------------------------------------
wire [RD_ADDR_BITWIDTH-1:0] access_addr;
lutMem_1bankX1port #(
    .QUAN_SIZE(MSG_BITWIDTH),
    .PAGE_NUM(VN_LOAD_CYCLE),
    .ADDR_BITWIDTH(RD_ADDR_BITWIDTH)
) lutMem_1bankX1port_regType0 (
    .read_page_o   (lut_data0),
    .write_data_i  (lut_in),
    .access_addr_i (access_addr),
    .we_i          (we),
    .sys_clk       (sys_clk)
);
assign access_addr[RD_ADDR_BITWIDTH-1:0] = (we == 1'b0) ? read_addr0[RD_ADDR_BITWIDTH-1:0] : write_addr[WR_ADDR_BITWIDTH-1:0];
`endif // SINGLE_PORT_RAM

`ifdef SDP_RAM
//---------------------------------------------
// IB-LUT memory cell
// Instantiation of Simple Dual-Port RAM
//---------------------------------------------
lutMem_1bank_sdp #(
	.QUAN_SIZE (MSG_BITWIDTH),
    .PAGE_NUM (VN_LOAD_CYCLE),
	.ADDR_BITWIDTH (RD_ADDR_BITWIDTH)
) lutMem_1bank_sdp (
    .read_page_o (lut_data0),
 
    .write_data_i (lut_in),
    .write_addr_i (write_addr),
    .read_addr_i (read_addr0),
    .we_i (we),
    .read_clk (sys_clk),
    .write_clk (sys_clk)
);
`endif // SDP_RAM

`ifdef LUTRAM_INFER
//---------------------------------------------
// IB-LUT memory cell
// Inferring the Xilinx LUTRAM
// Instantiation of Asynchronous single-port RAM
//---------------------------------------------
lutMem_async_1bankX1port_3b #(
    .QUAN_SIZE (MSG_BITWIDTH),
    .PAGE_NUM (VN_LOAD_CYCLE),
    .ADDR_BITWIDTH (RD_ADDR_BITWIDTH),
    .XILINX_LUTRAM_INFER (1)
) lutMem_async_1bankX1port_3b (
    .read_page_o (lut_data0),

    .read_addr_i (read_addr0),
    .write_data_i (lut_in),
    .write_addr_i (write_addr),
    .we_i (we),
    .write_clk (sys_clk)
);
`endif // LUTRAM_INFER
endmodule