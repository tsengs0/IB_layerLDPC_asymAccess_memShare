`timescale 1ns/1ps

/**
* Latest date: 12th July, 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: memShare_regFile_wrapper
* 
* # I/F
* 1) Output:
*
* 2) Input:
*
* # Param

* # Description
        Register list:
            L1PA_SPR,
            L1PA_PSRA,
            L1PA_START,
            L1PA_END
* # Dependencies
    1) Preprocessor to add any new special function register
        ./memShare_config.vh
*
* # Remark
*	Type-0 Register: 7 bits wide
    Type-0 Register Array: 64 page
    Memory Cell: 64x7bit
*		LUT: 14
        Logic LUT: 8
        LUTRAM: 6
		FF: 3
        I/O: 22
        Freq: 400MHz
        WNS: +1.998 ns
        TNS: 0.0 ns
        WHS: +0.093 ns
        THS: 0.0 ns
        WPWS: 0.718 ns
        TPWS: 0.0 ns
**/
`include "memShare_config.vh"

module memShare_regFile_wrapper #(
    parameter SHIFT_BITWIDTH = 3,
    parameter DELTA_BITWIDTH = 3,
    parameter SEQ_PTR_BITWIDTH = 1, // Bit width of isGtr
    parameter SEQ_SIZE = 2, //! Maximum size of one L1PA shfit pattern sequence
    parameter TYPE0_ADDR_BITWIDTH = 5, //! page number: 32
    parameter TYPE0_REG_BITWIDTH = 7,
    parameter TYPE0_PAGE_NUM =32,
    parameter REGFILE_RD_CYCLE = 1
) (
    // Port 0
    output wire [SHIFT_BITWIDTH-1:0] l1pa_shift_port0_o,
    output wire [DELTA_BITWIDTH-1:0] shift_delta_port0_o,
    output wire isGtr_port0_o,
    input wire [TYPE0_ADDR_BITWIDTH-1:0] regType0_raddr_port0_i,

    input wire [TYPE0_ADDR_BITWIDTH-1:0] regType0_waddr_i,
    input wire [TYPE0_REG_BITWIDTH-1:0] regType0_wdata_i,
    input wire regType0_we_i,
    input wire sys_clk,
    input wire rstn,
    input wire deltaPipe_rstn
);

wire [SHIFT_BITWIDTH-1:0] l1pa_shift_net;
wire [DELTA_BITWIDTH-1:0] shift_delta_net;
wire isGtr_net;
wire [TYPE0_ADDR_BITWIDTH-1:0] regType0_raddr_net;
memShare_regFile_l1paDelta #(
    .SHIFT_BITWIDTH      (SHIFT_BITWIDTH     ),
    .DELTA_BITWIDTH      (DELTA_BITWIDTH     ),
    .SEQ_PTR_BITWIDTH    (SEQ_PTR_BITWIDTH   ), // Bit width of isGtr
    .SEQ_SIZE            (SEQ_SIZE           ), //! Maximum size of one L1PA shfit pattern sequence
    .TYPE0_ADDR_BITWIDTH (TYPE0_ADDR_BITWIDTH), //! page number: 32
    .TYPE0_PAGE_NUM      (TYPE0_PAGE_NUM     ),
    .REGFILE_RD_CYCLE    (REGFILE_RD_CYCLE   )
) l1pa_regFile_unit0 (
    .l1pa_shift_o     (l1pa_shift_net    ),
    .shift_delta_o    (shift_delta_net   ),
    .isGtr_o          (isGtr_net         ),
    .regType0_waddr_i (regType0_waddr_i),
    .regType0_wdata_i (regType0_wdata_i),
    .regType0_raddr_i (regType0_raddr_net),
    .regType0_we_i    (regType0_we_i   ),
    .sys_clk          (sys_clk         ),
    .rstn             (rstn            ),
    .deltaPipe_rstn   (deltaPipe_rstn  )
);
assign regType0_raddr_net = regType0_raddr_port0_i;

// Port 0
assign l1pa_shift_port0_o = l1pa_shift_net;
assign shift_delta_port0_o = shift_delta_net;
assign isGtr_port0_o = isGtr_net;
endmodule
