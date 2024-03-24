
`timescale 1ns/1ps
module tb_lowend_partial_msgPass_wrapper (); /* this is automatically generated */

	// clock
	logic clk;
	initial begin
		clk = '0;
		forever #(0.5) clk = ~clk;
	end

	// synchronous reset
	logic srstb;
	initial begin
		srstb <= '0;
		repeat(10)@(posedge clk);
		srstb <= '1;
	end

	// (*NOTE*) replace reset, clock, others
	parameter              QUAN_SIZE = 3;
	parameter       ROW_SPLIT_FACTOR = 5;
	parameter       STRIDE_UNIT_SIZE = 51;
	parameter           STRIDE_WIDTH = 5;
	parameter              LAYER_NUM = 3;
	parameter        RAM_PORTA_RANGE = 9;
	parameter        RAM_PORTB_RANGE = 9;
	parameter         MEM_DEVICE_NUM = 28;
	parameter                  DEPTH = 1024;
	parameter             DATA_WIDTH = 36;
	parameter        FRAG_DATA_WIDTH = 12;
	parameter             ADDR_WIDTH = $clog2(DEPTH);
	localparam L1BS_SHIFT_CTRL_WIDTH = $clog2(STRIDE_UNIT_SIZE);

	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride0_bit0_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride0_bit1_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride0_bit2_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride0_bit0_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride0_bit1_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride0_bit2_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride0_bit0_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride0_bit1_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride0_bit2_o;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride0_bit0_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride0_bit1_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride0_bit2_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride0_bit0_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride0_bit1_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride0_bit2_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride0_bit0_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride0_bit1_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride0_bit2_i;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride0_bit3_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride0_bit3_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride0_bit3_o;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride0_bit3_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride0_bit3_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride0_bit3_i;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride1_bit0_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride1_bit1_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride1_bit2_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride1_bit0_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride1_bit1_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride1_bit2_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride1_bit0_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride1_bit1_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride1_bit2_o;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride1_bit0_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride1_bit1_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride1_bit2_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride1_bit0_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride1_bit1_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride1_bit2_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride1_bit0_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride1_bit1_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride1_bit2_i;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride1_bit3_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride1_bit3_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride1_bit3_o;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride1_bit3_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride1_bit3_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride1_bit3_i;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride2_bit0_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride2_bit1_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride2_bit2_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride2_bit0_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride2_bit1_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride2_bit2_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride2_bit0_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride2_bit1_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride2_bit2_o;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride2_bit0_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride2_bit1_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride2_bit2_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride2_bit0_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride2_bit1_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride2_bit2_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride2_bit0_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride2_bit1_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride2_bit2_i;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride2_bit3_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride2_bit3_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride2_bit3_o;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride2_bit3_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride2_bit3_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride2_bit3_i;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride3_bit0_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride3_bit1_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride3_bit2_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride3_bit0_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride3_bit1_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride3_bit2_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride3_bit0_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride3_bit1_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride3_bit2_o;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride3_bit0_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride3_bit1_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride3_bit2_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride3_bit0_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride3_bit1_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride3_bit2_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride3_bit0_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride3_bit1_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride3_bit2_i;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride3_bit3_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride3_bit3_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride3_bit3_o;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride3_bit3_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride3_bit3_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride3_bit3_i;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride4_bit0_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride4_bit1_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride4_bit2_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride4_bit0_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride4_bit1_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride4_bit2_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride4_bit0_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride4_bit1_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride4_bit2_o;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride4_bit0_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride4_bit1_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride4_bit2_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride4_bit0_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride4_bit1_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride4_bit2_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride4_bit0_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride4_bit1_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride4_bit2_i;
	logic [STRIDE_UNIT_SIZE-1:0] shift2node_stride4_bit3_o;
	logic [STRIDE_UNIT_SIZE-1:0] shift2rowOffset_stride4_bit3_o;
	logic [STRIDE_UNIT_SIZE-1:0] mux2ctrl_stride4_bit3_o;
	logic [STRIDE_UNIT_SIZE-1:0] mem2shift_stride4_bit3_i;
	logic [STRIDE_UNIT_SIZE-1:0] mem2mux_stride4_bit3_i;
	logic [STRIDE_UNIT_SIZE-1:0] chRAM2mux_stride4_bit3_i;
	logic                        mux2shiftCtrl_sel_i;
	logic     [STRIDE_WIDTH-1:0] L1_nodeBsShift_factor_bit0_i;
	logic     [STRIDE_WIDTH-1:0] L1_nodeBsShift_factor_bit1_i;
	logic     [STRIDE_WIDTH-1:0] L1_nodeBsShift_factor_bit2_i;
	logic     [STRIDE_WIDTH-1:0] L1_nodeBsShift_factor_bit3_i;
	logic     [STRIDE_WIDTH-1:0] L1_nodeBsShift_factor_bit4_i;
	logic     [STRIDE_WIDTH-1:0] L1_nodeBsShift_factor_bit5_i;
	logic [STRIDE_UNIT_SIZE-1:0] L2_nodePaShift_factor_bit0_i;
	logic [STRIDE_UNIT_SIZE-1:0] L2_nodePaShift_factor_bit1_i;
	logic [STRIDE_UNIT_SIZE-1:0] L2_nodePaShift_factor_bit2_i;
	logic [STRIDE_UNIT_SIZE-1:0] L2_nodePaLoad_factor_bit0_i;
	logic [STRIDE_UNIT_SIZE-1:0] L2_nodePaLoad_factor_bit1_i;
	logic [STRIDE_UNIT_SIZE-1:0] L2_nodePaLoad_factor_bit2_i;
	logic [STRIDE_UNIT_SIZE-1:0] L2_nodePaLoad_factor_bit3_i;
	logic [STRIDE_UNIT_SIZE-1:0] L2_nodePaLoad_factor_bit4_i;
	logic       [ADDR_WIDTH-1:0] cnu_sync_addr_i;
	logic       [ADDR_WIDTH-1:0] vnu_sync_addr_i;
	logic        [LAYER_NUM-1:0] cnu_layer_status_i;
	logic        [LAYER_NUM-1:0] vnu_layer_status_i;
	logic [ROW_SPLIT_FACTOR-1:0] cnu_sub_row_status_i;
	logic [ROW_SPLIT_FACTOR-1:0] vnu_sub_row_status_i;
	logic                  [1:0] last_row_chunk_i;
	logic                  [1:0] we;
	logic                        sys_clk;
	logic                        rstn;

	lowend_partial_msgPass_wrapper #(
			.QUAN_SIZE(QUAN_SIZE),
			.ROW_SPLIT_FACTOR(ROW_SPLIT_FACTOR),
			.STRIDE_UNIT_SIZE(STRIDE_UNIT_SIZE),
			.STRIDE_WIDTH(STRIDE_WIDTH),
			.LAYER_NUM(LAYER_NUM),
			.RAM_PORTA_RANGE(RAM_PORTA_RANGE),
			.RAM_PORTB_RANGE(RAM_PORTB_RANGE),
			.MEM_DEVICE_NUM(MEM_DEVICE_NUM),
			.DEPTH(DEPTH),
			.DATA_WIDTH(DATA_WIDTH),
			.FRAG_DATA_WIDTH(FRAG_DATA_WIDTH),
			.ADDR_WIDTH(ADDR_WIDTH)
		) inst_lowend_partial_msgPass_wrapper (
			.shift2node_stride0_bit0_o      (shift2node_stride0_bit0_o),
			.shift2node_stride0_bit1_o      (shift2node_stride0_bit1_o),
			.shift2node_stride0_bit2_o      (shift2node_stride0_bit2_o),
			.shift2rowOffset_stride0_bit0_o (shift2rowOffset_stride0_bit0_o),
			.shift2rowOffset_stride0_bit1_o (shift2rowOffset_stride0_bit1_o),
			.shift2rowOffset_stride0_bit2_o (shift2rowOffset_stride0_bit2_o),
			.mux2ctrl_stride0_bit0_o        (mux2ctrl_stride0_bit0_o),
			.mux2ctrl_stride0_bit1_o        (mux2ctrl_stride0_bit1_o),
			.mux2ctrl_stride0_bit2_o        (mux2ctrl_stride0_bit2_o),
			.mem2shift_stride0_bit0_i       (mem2shift_stride0_bit0_i),
			.mem2shift_stride0_bit1_i       (mem2shift_stride0_bit1_i),
			.mem2shift_stride0_bit2_i       (mem2shift_stride0_bit2_i),
			.mem2mux_stride0_bit0_i         (mem2mux_stride0_bit0_i),
			.mem2mux_stride0_bit1_i         (mem2mux_stride0_bit1_i),
			.mem2mux_stride0_bit2_i         (mem2mux_stride0_bit2_i),
			.chRAM2mux_stride0_bit0_i       (chRAM2mux_stride0_bit0_i),
			.chRAM2mux_stride0_bit1_i       (chRAM2mux_stride0_bit1_i),
			.chRAM2mux_stride0_bit2_i       (chRAM2mux_stride0_bit2_i),
			.shift2node_stride0_bit3_o      (shift2node_stride0_bit3_o),
			.shift2rowOffset_stride0_bit3_o (shift2rowOffset_stride0_bit3_o),
			.mux2ctrl_stride0_bit3_o        (mux2ctrl_stride0_bit3_o),
			.mem2shift_stride0_bit3_i       (mem2shift_stride0_bit3_i),
			.mem2mux_stride0_bit3_i         (mem2mux_stride0_bit3_i),
			.chRAM2mux_stride0_bit3_i       (chRAM2mux_stride0_bit3_i),
			.shift2node_stride1_bit0_o      (shift2node_stride1_bit0_o),
			.shift2node_stride1_bit1_o      (shift2node_stride1_bit1_o),
			.shift2node_stride1_bit2_o      (shift2node_stride1_bit2_o),
			.shift2rowOffset_stride1_bit0_o (shift2rowOffset_stride1_bit0_o),
			.shift2rowOffset_stride1_bit1_o (shift2rowOffset_stride1_bit1_o),
			.shift2rowOffset_stride1_bit2_o (shift2rowOffset_stride1_bit2_o),
			.mux2ctrl_stride1_bit0_o        (mux2ctrl_stride1_bit0_o),
			.mux2ctrl_stride1_bit1_o        (mux2ctrl_stride1_bit1_o),
			.mux2ctrl_stride1_bit2_o        (mux2ctrl_stride1_bit2_o),
			.mem2shift_stride1_bit0_i       (mem2shift_stride1_bit0_i),
			.mem2shift_stride1_bit1_i       (mem2shift_stride1_bit1_i),
			.mem2shift_stride1_bit2_i       (mem2shift_stride1_bit2_i),
			.mem2mux_stride1_bit0_i         (mem2mux_stride1_bit0_i),
			.mem2mux_stride1_bit1_i         (mem2mux_stride1_bit1_i),
			.mem2mux_stride1_bit2_i         (mem2mux_stride1_bit2_i),
			.chRAM2mux_stride1_bit0_i       (chRAM2mux_stride1_bit0_i),
			.chRAM2mux_stride1_bit1_i       (chRAM2mux_stride1_bit1_i),
			.chRAM2mux_stride1_bit2_i       (chRAM2mux_stride1_bit2_i),
			.shift2node_stride1_bit3_o      (shift2node_stride1_bit3_o),
			.shift2rowOffset_stride1_bit3_o (shift2rowOffset_stride1_bit3_o),
			.mux2ctrl_stride1_bit3_o        (mux2ctrl_stride1_bit3_o),
			.mem2shift_stride1_bit3_i       (mem2shift_stride1_bit3_i),
			.mem2mux_stride1_bit3_i         (mem2mux_stride1_bit3_i),
			.chRAM2mux_stride1_bit3_i       (chRAM2mux_stride1_bit3_i),
			.shift2node_stride2_bit0_o      (shift2node_stride2_bit0_o),
			.shift2node_stride2_bit1_o      (shift2node_stride2_bit1_o),
			.shift2node_stride2_bit2_o      (shift2node_stride2_bit2_o),
			.shift2rowOffset_stride2_bit0_o (shift2rowOffset_stride2_bit0_o),
			.shift2rowOffset_stride2_bit1_o (shift2rowOffset_stride2_bit1_o),
			.shift2rowOffset_stride2_bit2_o (shift2rowOffset_stride2_bit2_o),
			.mux2ctrl_stride2_bit0_o        (mux2ctrl_stride2_bit0_o),
			.mux2ctrl_stride2_bit1_o        (mux2ctrl_stride2_bit1_o),
			.mux2ctrl_stride2_bit2_o        (mux2ctrl_stride2_bit2_o),
			.mem2shift_stride2_bit0_i       (mem2shift_stride2_bit0_i),
			.mem2shift_stride2_bit1_i       (mem2shift_stride2_bit1_i),
			.mem2shift_stride2_bit2_i       (mem2shift_stride2_bit2_i),
			.mem2mux_stride2_bit0_i         (mem2mux_stride2_bit0_i),
			.mem2mux_stride2_bit1_i         (mem2mux_stride2_bit1_i),
			.mem2mux_stride2_bit2_i         (mem2mux_stride2_bit2_i),
			.chRAM2mux_stride2_bit0_i       (chRAM2mux_stride2_bit0_i),
			.chRAM2mux_stride2_bit1_i       (chRAM2mux_stride2_bit1_i),
			.chRAM2mux_stride2_bit2_i       (chRAM2mux_stride2_bit2_i),
			.shift2node_stride2_bit3_o      (shift2node_stride2_bit3_o),
			.shift2rowOffset_stride2_bit3_o (shift2rowOffset_stride2_bit3_o),
			.mux2ctrl_stride2_bit3_o        (mux2ctrl_stride2_bit3_o),
			.mem2shift_stride2_bit3_i       (mem2shift_stride2_bit3_i),
			.mem2mux_stride2_bit3_i         (mem2mux_stride2_bit3_i),
			.chRAM2mux_stride2_bit3_i       (chRAM2mux_stride2_bit3_i),
			.shift2node_stride3_bit0_o      (shift2node_stride3_bit0_o),
			.shift2node_stride3_bit1_o      (shift2node_stride3_bit1_o),
			.shift2node_stride3_bit2_o      (shift2node_stride3_bit2_o),
			.shift2rowOffset_stride3_bit0_o (shift2rowOffset_stride3_bit0_o),
			.shift2rowOffset_stride3_bit1_o (shift2rowOffset_stride3_bit1_o),
			.shift2rowOffset_stride3_bit2_o (shift2rowOffset_stride3_bit2_o),
			.mux2ctrl_stride3_bit0_o        (mux2ctrl_stride3_bit0_o),
			.mux2ctrl_stride3_bit1_o        (mux2ctrl_stride3_bit1_o),
			.mux2ctrl_stride3_bit2_o        (mux2ctrl_stride3_bit2_o),
			.mem2shift_stride3_bit0_i       (mem2shift_stride3_bit0_i),
			.mem2shift_stride3_bit1_i       (mem2shift_stride3_bit1_i),
			.mem2shift_stride3_bit2_i       (mem2shift_stride3_bit2_i),
			.mem2mux_stride3_bit0_i         (mem2mux_stride3_bit0_i),
			.mem2mux_stride3_bit1_i         (mem2mux_stride3_bit1_i),
			.mem2mux_stride3_bit2_i         (mem2mux_stride3_bit2_i),
			.chRAM2mux_stride3_bit0_i       (chRAM2mux_stride3_bit0_i),
			.chRAM2mux_stride3_bit1_i       (chRAM2mux_stride3_bit1_i),
			.chRAM2mux_stride3_bit2_i       (chRAM2mux_stride3_bit2_i),
			.shift2node_stride3_bit3_o      (shift2node_stride3_bit3_o),
			.shift2rowOffset_stride3_bit3_o (shift2rowOffset_stride3_bit3_o),
			.mux2ctrl_stride3_bit3_o        (mux2ctrl_stride3_bit3_o),
			.mem2shift_stride3_bit3_i       (mem2shift_stride3_bit3_i),
			.mem2mux_stride3_bit3_i         (mem2mux_stride3_bit3_i),
			.chRAM2mux_stride3_bit3_i       (chRAM2mux_stride3_bit3_i),
			.shift2node_stride4_bit0_o      (shift2node_stride4_bit0_o),
			.shift2node_stride4_bit1_o      (shift2node_stride4_bit1_o),
			.shift2node_stride4_bit2_o      (shift2node_stride4_bit2_o),
			.shift2rowOffset_stride4_bit0_o (shift2rowOffset_stride4_bit0_o),
			.shift2rowOffset_stride4_bit1_o (shift2rowOffset_stride4_bit1_o),
			.shift2rowOffset_stride4_bit2_o (shift2rowOffset_stride4_bit2_o),
			.mux2ctrl_stride4_bit0_o        (mux2ctrl_stride4_bit0_o),
			.mux2ctrl_stride4_bit1_o        (mux2ctrl_stride4_bit1_o),
			.mux2ctrl_stride4_bit2_o        (mux2ctrl_stride4_bit2_o),
			.mem2shift_stride4_bit0_i       (mem2shift_stride4_bit0_i),
			.mem2shift_stride4_bit1_i       (mem2shift_stride4_bit1_i),
			.mem2shift_stride4_bit2_i       (mem2shift_stride4_bit2_i),
			.mem2mux_stride4_bit0_i         (mem2mux_stride4_bit0_i),
			.mem2mux_stride4_bit1_i         (mem2mux_stride4_bit1_i),
			.mem2mux_stride4_bit2_i         (mem2mux_stride4_bit2_i),
			.chRAM2mux_stride4_bit0_i       (chRAM2mux_stride4_bit0_i),
			.chRAM2mux_stride4_bit1_i       (chRAM2mux_stride4_bit1_i),
			.chRAM2mux_stride4_bit2_i       (chRAM2mux_stride4_bit2_i),
			.shift2node_stride4_bit3_o      (shift2node_stride4_bit3_o),
			.shift2rowOffset_stride4_bit3_o (shift2rowOffset_stride4_bit3_o),
			.mux2ctrl_stride4_bit3_o        (mux2ctrl_stride4_bit3_o),
			.mem2shift_stride4_bit3_i       (mem2shift_stride4_bit3_i),
			.mem2mux_stride4_bit3_i         (mem2mux_stride4_bit3_i),
			.chRAM2mux_stride4_bit3_i       (chRAM2mux_stride4_bit3_i),
			.mux2shiftCtrl_sel_i            (mux2shiftCtrl_sel_i),
			.L1_nodeBsShift_factor_bit0_i   (L1_nodeBsShift_factor_bit0_i),
			.L1_nodeBsShift_factor_bit1_i   (L1_nodeBsShift_factor_bit1_i),
			.L1_nodeBsShift_factor_bit2_i   (L1_nodeBsShift_factor_bit2_i),
			.L1_nodeBsShift_factor_bit3_i   (L1_nodeBsShift_factor_bit3_i),
			.L1_nodeBsShift_factor_bit4_i   (L1_nodeBsShift_factor_bit4_i),
			.L1_nodeBsShift_factor_bit5_i   (L1_nodeBsShift_factor_bit5_i),
			.L2_nodePaShift_factor_bit0_i   (L2_nodePaShift_factor_bit0_i),
			.L2_nodePaShift_factor_bit1_i   (L2_nodePaShift_factor_bit1_i),
			.L2_nodePaShift_factor_bit2_i   (L2_nodePaShift_factor_bit2_i),
			.L2_nodePaLoad_factor_bit0_i    (L2_nodePaLoad_factor_bit0_i),
			.L2_nodePaLoad_factor_bit1_i    (L2_nodePaLoad_factor_bit1_i),
			.L2_nodePaLoad_factor_bit2_i    (L2_nodePaLoad_factor_bit2_i),
			.L2_nodePaLoad_factor_bit3_i    (L2_nodePaLoad_factor_bit3_i),
			.L2_nodePaLoad_factor_bit4_i    (L2_nodePaLoad_factor_bit4_i),
			.cnu_sync_addr_i                (cnu_sync_addr_i),
			.vnu_sync_addr_i                (vnu_sync_addr_i),
			.cnu_layer_status_i             (cnu_layer_status_i),
			.vnu_layer_status_i             (vnu_layer_status_i),
			.cnu_sub_row_status_i           (cnu_sub_row_status_i),
			.vnu_sub_row_status_i           (vnu_sub_row_status_i),
			.last_row_chunk_i               (last_row_chunk_i),
			.we                             (we),
			.sys_clk                        (sys_clk),
			.rstn                           (rstn)
		);

	task init();
		mem2shift_stride0_bit0_i     <= '0;
		mem2shift_stride0_bit1_i     <= '0;
		mem2shift_stride0_bit2_i     <= '0;
		mem2mux_stride0_bit0_i       <= '0;
		mem2mux_stride0_bit1_i       <= '0;
		mem2mux_stride0_bit2_i       <= '0;
		chRAM2mux_stride0_bit0_i     <= '0;
		chRAM2mux_stride0_bit1_i     <= '0;
		chRAM2mux_stride0_bit2_i     <= '0;
		mem2shift_stride0_bit3_i     <= '0;
		mem2mux_stride0_bit3_i       <= '0;
		chRAM2mux_stride0_bit3_i     <= '0;
		mem2shift_stride1_bit0_i     <= '0;
		mem2shift_stride1_bit1_i     <= '0;
		mem2shift_stride1_bit2_i     <= '0;
		mem2mux_stride1_bit0_i       <= '0;
		mem2mux_stride1_bit1_i       <= '0;
		mem2mux_stride1_bit2_i       <= '0;
		chRAM2mux_stride1_bit0_i     <= '0;
		chRAM2mux_stride1_bit1_i     <= '0;
		chRAM2mux_stride1_bit2_i     <= '0;
		mem2shift_stride1_bit3_i     <= '0;
		mem2mux_stride1_bit3_i       <= '0;
		chRAM2mux_stride1_bit3_i     <= '0;
		mem2shift_stride2_bit0_i     <= '0;
		mem2shift_stride2_bit1_i     <= '0;
		mem2shift_stride2_bit2_i     <= '0;
		mem2mux_stride2_bit0_i       <= '0;
		mem2mux_stride2_bit1_i       <= '0;
		mem2mux_stride2_bit2_i       <= '0;
		chRAM2mux_stride2_bit0_i     <= '0;
		chRAM2mux_stride2_bit1_i     <= '0;
		chRAM2mux_stride2_bit2_i     <= '0;
		mem2shift_stride2_bit3_i     <= '0;
		mem2mux_stride2_bit3_i       <= '0;
		chRAM2mux_stride2_bit3_i     <= '0;
		mem2shift_stride3_bit0_i     <= '0;
		mem2shift_stride3_bit1_i     <= '0;
		mem2shift_stride3_bit2_i     <= '0;
		mem2mux_stride3_bit0_i       <= '0;
		mem2mux_stride3_bit1_i       <= '0;
		mem2mux_stride3_bit2_i       <= '0;
		chRAM2mux_stride3_bit0_i     <= '0;
		chRAM2mux_stride3_bit1_i     <= '0;
		chRAM2mux_stride3_bit2_i     <= '0;
		mem2shift_stride3_bit3_i     <= '0;
		mem2mux_stride3_bit3_i       <= '0;
		chRAM2mux_stride3_bit3_i     <= '0;
		mem2shift_stride4_bit0_i     <= '0;
		mem2shift_stride4_bit1_i     <= '0;
		mem2shift_stride4_bit2_i     <= '0;
		mem2mux_stride4_bit0_i       <= '0;
		mem2mux_stride4_bit1_i       <= '0;
		mem2mux_stride4_bit2_i       <= '0;
		chRAM2mux_stride4_bit0_i     <= '0;
		chRAM2mux_stride4_bit1_i     <= '0;
		chRAM2mux_stride4_bit2_i     <= '0;
		mem2shift_stride4_bit3_i     <= '0;
		mem2mux_stride4_bit3_i       <= '0;
		chRAM2mux_stride4_bit3_i     <= '0;
		mux2shiftCtrl_sel_i          <= '0;
		L1_nodeBsShift_factor_bit0_i <= '0;
		L1_nodeBsShift_factor_bit1_i <= '0;
		L1_nodeBsShift_factor_bit2_i <= '0;
		L1_nodeBsShift_factor_bit3_i <= '0;
		L1_nodeBsShift_factor_bit4_i <= '0;
		L1_nodeBsShift_factor_bit5_i <= '0;
		L2_nodePaShift_factor_bit0_i <= '0;
		L2_nodePaShift_factor_bit1_i <= '0;
		L2_nodePaShift_factor_bit2_i <= '0;
		L2_nodePaLoad_factor_bit0_i  <= '0;
		L2_nodePaLoad_factor_bit1_i  <= '0;
		L2_nodePaLoad_factor_bit2_i  <= '0;
		L2_nodePaLoad_factor_bit3_i  <= '0;
		L2_nodePaLoad_factor_bit4_i  <= '0;
		cnu_sync_addr_i              <= '0;
		vnu_sync_addr_i              <= '0;
		cnu_layer_status_i           <= '0;
		vnu_layer_status_i           <= '0;
		cnu_sub_row_status_i         <= '0;
		vnu_sub_row_status_i         <= '0;
		last_row_chunk_i             <= '0;
		we                           <= '0;
		sys_clk                      <= '0;
		rstn                         <= '0;
	endtask

	task drive(int iter);
		for(int it = 0; it < iter; it++) begin
			mem2shift_stride0_bit0_i     <= '0;
			mem2shift_stride0_bit1_i     <= '0;
			mem2shift_stride0_bit2_i     <= '0;
			mem2mux_stride0_bit0_i       <= '0;
			mem2mux_stride0_bit1_i       <= '0;
			mem2mux_stride0_bit2_i       <= '0;
			chRAM2mux_stride0_bit0_i     <= '0;
			chRAM2mux_stride0_bit1_i     <= '0;
			chRAM2mux_stride0_bit2_i     <= '0;
			mem2shift_stride0_bit3_i     <= '0;
			mem2mux_stride0_bit3_i       <= '0;
			chRAM2mux_stride0_bit3_i     <= '0;
			mem2shift_stride1_bit0_i     <= '0;
			mem2shift_stride1_bit1_i     <= '0;
			mem2shift_stride1_bit2_i     <= '0;
			mem2mux_stride1_bit0_i       <= '0;
			mem2mux_stride1_bit1_i       <= '0;
			mem2mux_stride1_bit2_i       <= '0;
			chRAM2mux_stride1_bit0_i     <= '0;
			chRAM2mux_stride1_bit1_i     <= '0;
			chRAM2mux_stride1_bit2_i     <= '0;
			mem2shift_stride1_bit3_i     <= '0;
			mem2mux_stride1_bit3_i       <= '0;
			chRAM2mux_stride1_bit3_i     <= '0;
			mem2shift_stride2_bit0_i     <= '0;
			mem2shift_stride2_bit1_i     <= '0;
			mem2shift_stride2_bit2_i     <= '0;
			mem2mux_stride2_bit0_i       <= '0;
			mem2mux_stride2_bit1_i       <= '0;
			mem2mux_stride2_bit2_i       <= '0;
			chRAM2mux_stride2_bit0_i     <= '0;
			chRAM2mux_stride2_bit1_i     <= '0;
			chRAM2mux_stride2_bit2_i     <= '0;
			mem2shift_stride2_bit3_i     <= '0;
			mem2mux_stride2_bit3_i       <= '0;
			chRAM2mux_stride2_bit3_i     <= '0;
			mem2shift_stride3_bit0_i     <= '0;
			mem2shift_stride3_bit1_i     <= '0;
			mem2shift_stride3_bit2_i     <= '0;
			mem2mux_stride3_bit0_i       <= '0;
			mem2mux_stride3_bit1_i       <= '0;
			mem2mux_stride3_bit2_i       <= '0;
			chRAM2mux_stride3_bit0_i     <= '0;
			chRAM2mux_stride3_bit1_i     <= '0;
			chRAM2mux_stride3_bit2_i     <= '0;
			mem2shift_stride3_bit3_i     <= '0;
			mem2mux_stride3_bit3_i       <= '0;
			chRAM2mux_stride3_bit3_i     <= '0;
			mem2shift_stride4_bit0_i     <= '0;
			mem2shift_stride4_bit1_i     <= '0;
			mem2shift_stride4_bit2_i     <= '0;
			mem2mux_stride4_bit0_i       <= '0;
			mem2mux_stride4_bit1_i       <= '0;
			mem2mux_stride4_bit2_i       <= '0;
			chRAM2mux_stride4_bit0_i     <= '0;
			chRAM2mux_stride4_bit1_i     <= '0;
			chRAM2mux_stride4_bit2_i     <= '0;
			mem2shift_stride4_bit3_i     <= '0;
			mem2mux_stride4_bit3_i       <= '0;
			chRAM2mux_stride4_bit3_i     <= '0;
			mux2shiftCtrl_sel_i          <= '0;
			L1_nodeBsShift_factor_bit0_i <= '0;
			L1_nodeBsShift_factor_bit1_i <= '0;
			L1_nodeBsShift_factor_bit2_i <= '0;
			L1_nodeBsShift_factor_bit3_i <= '0;
			L1_nodeBsShift_factor_bit4_i <= '0;
			L1_nodeBsShift_factor_bit5_i <= '0;
			L2_nodePaShift_factor_bit0_i <= '0;
			L2_nodePaShift_factor_bit1_i <= '0;
			L2_nodePaShift_factor_bit2_i <= '0;
			L2_nodePaLoad_factor_bit0_i  <= '0;
			L2_nodePaLoad_factor_bit1_i  <= '0;
			L2_nodePaLoad_factor_bit2_i  <= '0;
			L2_nodePaLoad_factor_bit3_i  <= '0;
			L2_nodePaLoad_factor_bit4_i  <= '0;
			cnu_sync_addr_i              <= '0;
			vnu_sync_addr_i              <= '0;
			cnu_layer_status_i           <= '0;
			vnu_layer_status_i           <= '0;
			cnu_sub_row_status_i         <= '0;
			vnu_sub_row_status_i         <= '0;
			last_row_chunk_i             <= '0;
			we                           <= '0;
			sys_clk                      <= '0;
			rstn                         <= '0;
			@(posedge clk);
		end
	endtask

	initial begin
		// do something

		init();
		repeat(10)@(posedge clk);

		drive(20);

		repeat(10)@(posedge clk);
		$finish;
	end
	// dump wave
//	initial begin
//		$display("random seed : %0d", $unsigned($get_initial_random_seed()));
//		if ( $test$plusargs("fsdb") ) begin
//			$fsdbDumpfile("tb_lowend_partial_msgPass_wrapper.fsdb");
//			$fsdbDumpvars(0, "tb_lowend_partial_msgPass_wrapper", "+mda", "+functions");
//		end
//	end
endmodule