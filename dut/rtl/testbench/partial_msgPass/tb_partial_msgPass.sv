
`timescale 1ns/1ps

module tb_partial_msgPass_wrapper (); /* this is automatically generated */

	// clock
	logic clk;
	initial begin
		clk = '0;
		forever #(5) clk = ~clk;
	end

	// synchronous reset
	logic srstb;
	initial begin
		srstb <= '0;
		repeat(10)@(posedge clk);
		srstb <= '1;
	end

	// (*NOTE*) replace reset, clock, others

	parameter            QUAN_SIZE = 4;
	parameter     ROW_SPLIT_FACTOR = 5;
	parameter    CHECK_PARALLELISM = 15;
	parameter     STRIDE_UNIT_SIZE = 15;
	parameter         STRIDE_WIDTH = 3;
	parameter PAGE_ALIGN_SEL_WIDTH = 2;
	parameter            LAYER_NUM = 3;
	parameter  L1_PA_MUX_SEL_WIDTH = 2;
	parameter      RAM_PORTA_RANGE = 9;
	parameter      RAM_PORTB_RANGE = 9;
	parameter       MEM_DEVICE_NUM = 28;
	parameter                DEPTH = 1024;
	parameter           DATA_WIDTH = 36;
	parameter      FRAG_DATA_WIDTH = 12;
	parameter           ADDR_WIDTH = $clog2(DEPTH);

	logic           [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride0_bit0_o;
	logic           [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride0_bit1_o;
	logic           [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride0_bit2_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride0_bit0_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride0_bit1_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride0_bit2_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride0_bit0_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride0_bit1_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride0_bit2_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride0_bit0_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride0_bit1_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride0_bit2_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride0_bit0_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride0_bit1_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride0_bit2_o;
	logic           [STRIDE_UNIT_SIZE-1:0] ch2bs_stride0_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] ch2bs_stride0_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] ch2bs_stride0_bit2_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnu2mem_stride0_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnu2mem_stride0_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnu2mem_stride0_bit2_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnu2mem_stride0_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnu2mem_stride0_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnu2mem_stride0_bit2_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride0_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride0_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride0_bit2_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride0_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride0_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride0_bit2_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnuPaMuxSel_stride0_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnuPaMuxSel_stride0_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnuPaMuxSel_stride0_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnuPaMuxSel_stride0_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride0_bit3_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride0_bit3_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride0_bit3_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride0_bit3_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride0_bit3_o;
	logic           [STRIDE_UNIT_SIZE-1:0] ch2bs_stride0_bit3_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnu2mem_stride0_bit3_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnu2mem_stride0_bit3_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride0_bit3_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride0_bit3_i;
	logic           [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride1_bit0_o;
	logic           [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride1_bit1_o;
	logic           [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride1_bit2_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride1_bit0_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride1_bit1_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride1_bit2_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride1_bit0_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride1_bit1_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride1_bit2_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride1_bit0_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride1_bit1_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride1_bit2_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride1_bit0_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride1_bit1_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride1_bit2_o;
	logic           [STRIDE_UNIT_SIZE-1:0] ch2bs_stride1_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] ch2bs_stride1_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] ch2bs_stride1_bit2_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnu2mem_stride1_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnu2mem_stride1_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnu2mem_stride1_bit2_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnu2mem_stride1_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnu2mem_stride1_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnu2mem_stride1_bit2_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride1_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride1_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride1_bit2_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride1_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride1_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride1_bit2_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnuPaMuxSel_stride1_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnuPaMuxSel_stride1_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnuPaMuxSel_stride1_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnuPaMuxSel_stride1_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride1_bit3_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride1_bit3_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride1_bit3_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride1_bit3_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride1_bit3_o;
	logic           [STRIDE_UNIT_SIZE-1:0] ch2bs_stride1_bit3_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnu2mem_stride1_bit3_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnu2mem_stride1_bit3_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride1_bit3_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride1_bit3_i;
	logic           [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride2_bit0_o;
	logic           [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride2_bit1_o;
	logic           [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride2_bit2_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride2_bit0_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride2_bit1_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride2_bit2_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride2_bit0_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride2_bit1_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride2_bit2_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride2_bit0_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride2_bit1_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride2_bit2_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride2_bit0_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride2_bit1_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride2_bit2_o;
	logic           [STRIDE_UNIT_SIZE-1:0] ch2bs_stride2_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] ch2bs_stride2_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] ch2bs_stride2_bit2_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnu2mem_stride2_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnu2mem_stride2_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnu2mem_stride2_bit2_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnu2mem_stride2_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnu2mem_stride2_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnu2mem_stride2_bit2_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride2_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride2_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride2_bit2_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride2_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride2_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride2_bit2_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnuPaMuxSel_stride2_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnuPaMuxSel_stride2_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnuPaMuxSel_stride2_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnuPaMuxSel_stride2_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] pa2chRAM_stride2_bit3_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride2_bit3_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2vnu_stride2_bit3_o;
	logic           [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride2_bit3_o;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_pa2cnu_stride2_bit3_o;
	logic           [STRIDE_UNIT_SIZE-1:0] ch2bs_stride2_bit3_i;
	logic           [STRIDE_UNIT_SIZE-1:0] vnu2mem_stride2_bit3_i;
	logic           [STRIDE_UNIT_SIZE-1:0] cnu2mem_stride2_bit3_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_vnuStride2_bit3_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L1_mem2pa_cnuStride2_bit3_i;
	logic [$clog2(STRIDE_UNIT_SIZE-1)-1:0] L1_vnuBsShift_factor_i;
	logic [$clog2(STRIDE_UNIT_SIZE-1)-1:0] L1_cnuBsShift_factor_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L2_vnuPaShift_factor_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L2_vnuPaShift_factor_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L2_cnuPaShift_factor_bit0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L2_cnuPaShift_factor_bit1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L2_vnuPaDCombine_patternStride0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L2_vnuPaDCombine_patternStride1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L2_vnuPaDCombine_patternStride2_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L2_cnuPaDCombine_patternStride0_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L2_cnuPaDCombine_patternStride1_i;
	logic           [STRIDE_UNIT_SIZE-1:0] L2_cnuPaDCombine_patternStride2_i;
	logic                                  L1_vnuBs_swInSrc;
	logic                 [ADDR_WIDTH-1:0] cnu_sync_addr_i;
	logic                 [ADDR_WIDTH-1:0] vnu_sync_addr_i;
	logic                  [LAYER_NUM-1:0] cnu_layer_status_i;
	logic                  [LAYER_NUM-1:0] vnu_layer_status_i;
	logic           [ROW_SPLIT_FACTOR-1:0] cnu_sub_row_status_i;
	logic           [ROW_SPLIT_FACTOR-1:0] vnu_sub_row_status_i;
	logic                            [1:0] last_row_chunk_i;
	logic                            [1:0] we;
	logic                                  sys_clk;
	logic                                  rstn;

	partial_msgPass_wrapper #(
			.QUAN_SIZE(QUAN_SIZE),
			.ROW_SPLIT_FACTOR(ROW_SPLIT_FACTOR),
			.CHECK_PARALLELISM(CHECK_PARALLELISM),
			.STRIDE_UNIT_SIZE(STRIDE_UNIT_SIZE),
			.STRIDE_WIDTH(STRIDE_WIDTH),
			.PAGE_ALIGN_SEL_WIDTH(PAGE_ALIGN_SEL_WIDTH),
			.LAYER_NUM(LAYER_NUM),
			.L1_PA_MUX_SEL_WIDTH(L1_PA_MUX_SEL_WIDTH),
			.RAM_PORTA_RANGE(RAM_PORTA_RANGE),
			.RAM_PORTB_RANGE(RAM_PORTB_RANGE),
			.MEM_DEVICE_NUM(MEM_DEVICE_NUM),
			.DEPTH(DEPTH),
			.DATA_WIDTH(DATA_WIDTH),
			.FRAG_DATA_WIDTH(FRAG_DATA_WIDTH),
			.ADDR_WIDTH(ADDR_WIDTH)
		) inst_partial_msgPass_wrapper (
			.pa2chRAM_stride0_bit0_o           (pa2chRAM_stride0_bit0_o),
			.pa2chRAM_stride0_bit1_o           (pa2chRAM_stride0_bit1_o),
			.pa2chRAM_stride0_bit2_o           (pa2chRAM_stride0_bit2_o),
			.mem2vnu_stride0_bit0_o            (mem2vnu_stride0_bit0_o),
			.mem2vnu_stride0_bit1_o            (mem2vnu_stride0_bit1_o),
			.mem2vnu_stride0_bit2_o            (mem2vnu_stride0_bit2_o),
			.L1_pa2vnu_stride0_bit0_o          (L1_pa2vnu_stride0_bit0_o),
			.L1_pa2vnu_stride0_bit1_o          (L1_pa2vnu_stride0_bit1_o),
			.L1_pa2vnu_stride0_bit2_o          (L1_pa2vnu_stride0_bit2_o),
			.mem2cnu_stride0_bit0_o            (mem2cnu_stride0_bit0_o),
			.mem2cnu_stride0_bit1_o            (mem2cnu_stride0_bit1_o),
			.mem2cnu_stride0_bit2_o            (mem2cnu_stride0_bit2_o),
			.L1_pa2cnu_stride0_bit0_o          (L1_pa2cnu_stride0_bit0_o),
			.L1_pa2cnu_stride0_bit1_o          (L1_pa2cnu_stride0_bit1_o),
			.L1_pa2cnu_stride0_bit2_o          (L1_pa2cnu_stride0_bit2_o),
			.ch2bs_stride0_bit0_i              (ch2bs_stride0_bit0_i),
			.ch2bs_stride0_bit1_i              (ch2bs_stride0_bit1_i),
			.ch2bs_stride0_bit2_i              (ch2bs_stride0_bit2_i),
			.vnu2mem_stride0_bit0_i            (vnu2mem_stride0_bit0_i),
			.vnu2mem_stride0_bit1_i            (vnu2mem_stride0_bit1_i),
			.vnu2mem_stride0_bit2_i            (vnu2mem_stride0_bit2_i),
			.cnu2mem_stride0_bit0_i            (cnu2mem_stride0_bit0_i),
			.cnu2mem_stride0_bit1_i            (cnu2mem_stride0_bit1_i),
			.cnu2mem_stride0_bit2_i            (cnu2mem_stride0_bit2_i),
			.L1_mem2pa_vnuStride0_bit0_i       (L1_mem2pa_vnuStride0_bit0_i),
			.L1_mem2pa_vnuStride0_bit1_i       (L1_mem2pa_vnuStride0_bit1_i),
			.L1_mem2pa_vnuStride0_bit2_i       (L1_mem2pa_vnuStride0_bit2_i),
			.L1_mem2pa_cnuStride0_bit0_i       (L1_mem2pa_cnuStride0_bit0_i),
			.L1_mem2pa_cnuStride0_bit1_i       (L1_mem2pa_cnuStride0_bit1_i),
			.L1_mem2pa_cnuStride0_bit2_i       (L1_mem2pa_cnuStride0_bit2_i),
			.vnuPaMuxSel_stride0_bit0_i        (vnuPaMuxSel_stride0_bit0_i),
			.vnuPaMuxSel_stride0_bit1_i        (vnuPaMuxSel_stride0_bit1_i),
			.cnuPaMuxSel_stride0_bit0_i        (cnuPaMuxSel_stride0_bit0_i),
			.cnuPaMuxSel_stride0_bit1_i        (cnuPaMuxSel_stride0_bit1_i),
			.pa2chRAM_stride0_bit3_o           (pa2chRAM_stride0_bit3_o),
			.mem2vnu_stride0_bit3_o            (mem2vnu_stride0_bit3_o),
			.L1_pa2vnu_stride0_bit3_o          (L1_pa2vnu_stride0_bit3_o),
			.mem2cnu_stride0_bit3_o            (mem2cnu_stride0_bit3_o),
			.L1_pa2cnu_stride0_bit3_o          (L1_pa2cnu_stride0_bit3_o),
			.ch2bs_stride0_bit3_i              (ch2bs_stride0_bit3_i),
			.vnu2mem_stride0_bit3_i            (vnu2mem_stride0_bit3_i),
			.cnu2mem_stride0_bit3_i            (cnu2mem_stride0_bit3_i),
			.L1_mem2pa_vnuStride0_bit3_i       (L1_mem2pa_vnuStride0_bit3_i),
			.L1_mem2pa_cnuStride0_bit3_i       (L1_mem2pa_cnuStride0_bit3_i),
			.pa2chRAM_stride1_bit0_o           (pa2chRAM_stride1_bit0_o),
			.pa2chRAM_stride1_bit1_o           (pa2chRAM_stride1_bit1_o),
			.pa2chRAM_stride1_bit2_o           (pa2chRAM_stride1_bit2_o),
			.mem2vnu_stride1_bit0_o            (mem2vnu_stride1_bit0_o),
			.mem2vnu_stride1_bit1_o            (mem2vnu_stride1_bit1_o),
			.mem2vnu_stride1_bit2_o            (mem2vnu_stride1_bit2_o),
			.L1_pa2vnu_stride1_bit0_o          (L1_pa2vnu_stride1_bit0_o),
			.L1_pa2vnu_stride1_bit1_o          (L1_pa2vnu_stride1_bit1_o),
			.L1_pa2vnu_stride1_bit2_o          (L1_pa2vnu_stride1_bit2_o),
			.mem2cnu_stride1_bit0_o            (mem2cnu_stride1_bit0_o),
			.mem2cnu_stride1_bit1_o            (mem2cnu_stride1_bit1_o),
			.mem2cnu_stride1_bit2_o            (mem2cnu_stride1_bit2_o),
			.L1_pa2cnu_stride1_bit0_o          (L1_pa2cnu_stride1_bit0_o),
			.L1_pa2cnu_stride1_bit1_o          (L1_pa2cnu_stride1_bit1_o),
			.L1_pa2cnu_stride1_bit2_o          (L1_pa2cnu_stride1_bit2_o),
			.ch2bs_stride1_bit0_i              (ch2bs_stride1_bit0_i),
			.ch2bs_stride1_bit1_i              (ch2bs_stride1_bit1_i),
			.ch2bs_stride1_bit2_i              (ch2bs_stride1_bit2_i),
			.vnu2mem_stride1_bit0_i            (vnu2mem_stride1_bit0_i),
			.vnu2mem_stride1_bit1_i            (vnu2mem_stride1_bit1_i),
			.vnu2mem_stride1_bit2_i            (vnu2mem_stride1_bit2_i),
			.cnu2mem_stride1_bit0_i            (cnu2mem_stride1_bit0_i),
			.cnu2mem_stride1_bit1_i            (cnu2mem_stride1_bit1_i),
			.cnu2mem_stride1_bit2_i            (cnu2mem_stride1_bit2_i),
			.L1_mem2pa_vnuStride1_bit0_i       (L1_mem2pa_vnuStride1_bit0_i),
			.L1_mem2pa_vnuStride1_bit1_i       (L1_mem2pa_vnuStride1_bit1_i),
			.L1_mem2pa_vnuStride1_bit2_i       (L1_mem2pa_vnuStride1_bit2_i),
			.L1_mem2pa_cnuStride1_bit0_i       (L1_mem2pa_cnuStride1_bit0_i),
			.L1_mem2pa_cnuStride1_bit1_i       (L1_mem2pa_cnuStride1_bit1_i),
			.L1_mem2pa_cnuStride1_bit2_i       (L1_mem2pa_cnuStride1_bit2_i),
			.vnuPaMuxSel_stride1_bit0_i        (vnuPaMuxSel_stride1_bit0_i),
			.vnuPaMuxSel_stride1_bit1_i        (vnuPaMuxSel_stride1_bit1_i),
			.cnuPaMuxSel_stride1_bit0_i        (cnuPaMuxSel_stride1_bit0_i),
			.cnuPaMuxSel_stride1_bit1_i        (cnuPaMuxSel_stride1_bit1_i),
			.pa2chRAM_stride1_bit3_o           (pa2chRAM_stride1_bit3_o),
			.mem2vnu_stride1_bit3_o            (mem2vnu_stride1_bit3_o),
			.L1_pa2vnu_stride1_bit3_o          (L1_pa2vnu_stride1_bit3_o),
			.mem2cnu_stride1_bit3_o            (mem2cnu_stride1_bit3_o),
			.L1_pa2cnu_stride1_bit3_o          (L1_pa2cnu_stride1_bit3_o),
			.ch2bs_stride1_bit3_i              (ch2bs_stride1_bit3_i),
			.vnu2mem_stride1_bit3_i            (vnu2mem_stride1_bit3_i),
			.cnu2mem_stride1_bit3_i            (cnu2mem_stride1_bit3_i),
			.L1_mem2pa_vnuStride1_bit3_i       (L1_mem2pa_vnuStride1_bit3_i),
			.L1_mem2pa_cnuStride1_bit3_i       (L1_mem2pa_cnuStride1_bit3_i),
			.pa2chRAM_stride2_bit0_o           (pa2chRAM_stride2_bit0_o),
			.pa2chRAM_stride2_bit1_o           (pa2chRAM_stride2_bit1_o),
			.pa2chRAM_stride2_bit2_o           (pa2chRAM_stride2_bit2_o),
			.mem2vnu_stride2_bit0_o            (mem2vnu_stride2_bit0_o),
			.mem2vnu_stride2_bit1_o            (mem2vnu_stride2_bit1_o),
			.mem2vnu_stride2_bit2_o            (mem2vnu_stride2_bit2_o),
			.L1_pa2vnu_stride2_bit0_o          (L1_pa2vnu_stride2_bit0_o),
			.L1_pa2vnu_stride2_bit1_o          (L1_pa2vnu_stride2_bit1_o),
			.L1_pa2vnu_stride2_bit2_o          (L1_pa2vnu_stride2_bit2_o),
			.mem2cnu_stride2_bit0_o            (mem2cnu_stride2_bit0_o),
			.mem2cnu_stride2_bit1_o            (mem2cnu_stride2_bit1_o),
			.mem2cnu_stride2_bit2_o            (mem2cnu_stride2_bit2_o),
			.L1_pa2cnu_stride2_bit0_o          (L1_pa2cnu_stride2_bit0_o),
			.L1_pa2cnu_stride2_bit1_o          (L1_pa2cnu_stride2_bit1_o),
			.L1_pa2cnu_stride2_bit2_o          (L1_pa2cnu_stride2_bit2_o),
			.ch2bs_stride2_bit0_i              (ch2bs_stride2_bit0_i),
			.ch2bs_stride2_bit1_i              (ch2bs_stride2_bit1_i),
			.ch2bs_stride2_bit2_i              (ch2bs_stride2_bit2_i),
			.vnu2mem_stride2_bit0_i            (vnu2mem_stride2_bit0_i),
			.vnu2mem_stride2_bit1_i            (vnu2mem_stride2_bit1_i),
			.vnu2mem_stride2_bit2_i            (vnu2mem_stride2_bit2_i),
			.cnu2mem_stride2_bit0_i            (cnu2mem_stride2_bit0_i),
			.cnu2mem_stride2_bit1_i            (cnu2mem_stride2_bit1_i),
			.cnu2mem_stride2_bit2_i            (cnu2mem_stride2_bit2_i),
			.L1_mem2pa_vnuStride2_bit0_i       (L1_mem2pa_vnuStride2_bit0_i),
			.L1_mem2pa_vnuStride2_bit1_i       (L1_mem2pa_vnuStride2_bit1_i),
			.L1_mem2pa_vnuStride2_bit2_i       (L1_mem2pa_vnuStride2_bit2_i),
			.L1_mem2pa_cnuStride2_bit0_i       (L1_mem2pa_cnuStride2_bit0_i),
			.L1_mem2pa_cnuStride2_bit1_i       (L1_mem2pa_cnuStride2_bit1_i),
			.L1_mem2pa_cnuStride2_bit2_i       (L1_mem2pa_cnuStride2_bit2_i),
			.vnuPaMuxSel_stride2_bit0_i        (vnuPaMuxSel_stride2_bit0_i),
			.vnuPaMuxSel_stride2_bit1_i        (vnuPaMuxSel_stride2_bit1_i),
			.cnuPaMuxSel_stride2_bit0_i        (cnuPaMuxSel_stride2_bit0_i),
			.cnuPaMuxSel_stride2_bit1_i        (cnuPaMuxSel_stride2_bit1_i),
			.pa2chRAM_stride2_bit3_o           (pa2chRAM_stride2_bit3_o),
			.mem2vnu_stride2_bit3_o            (mem2vnu_stride2_bit3_o),
			.L1_pa2vnu_stride2_bit3_o          (L1_pa2vnu_stride2_bit3_o),
			.mem2cnu_stride2_bit3_o            (mem2cnu_stride2_bit3_o),
			.L1_pa2cnu_stride2_bit3_o          (L1_pa2cnu_stride2_bit3_o),
			.ch2bs_stride2_bit3_i              (ch2bs_stride2_bit3_i),
			.vnu2mem_stride2_bit3_i            (vnu2mem_stride2_bit3_i),
			.cnu2mem_stride2_bit3_i            (cnu2mem_stride2_bit3_i),
			.L1_mem2pa_vnuStride2_bit3_i       (L1_mem2pa_vnuStride2_bit3_i),
			.L1_mem2pa_cnuStride2_bit3_i       (L1_mem2pa_cnuStride2_bit3_i),
			.L1_vnuBsShift_factor_i            (L1_vnuBsShift_factor_i),
			.L1_cnuBsShift_factor_i            (L1_cnuBsShift_factor_i),
			.L2_vnuPaShift_factor_bit0_i       (L2_vnuPaShift_factor_bit0_i),
			.L2_vnuPaShift_factor_bit1_i       (L2_vnuPaShift_factor_bit1_i),
			.L2_cnuPaShift_factor_bit0_i       (L2_cnuPaShift_factor_bit0_i),
			.L2_cnuPaShift_factor_bit1_i       (L2_cnuPaShift_factor_bit1_i),
			.L2_vnuPaDCombine_patternStride0_i (L2_vnuPaDCombine_patternStride0_i),
			.L2_vnuPaDCombine_patternStride1_i (L2_vnuPaDCombine_patternStride1_i),
			.L2_vnuPaDCombine_patternStride2_i (L2_vnuPaDCombine_patternStride2_i),
			.L2_cnuPaDCombine_patternStride0_i (L2_cnuPaDCombine_patternStride0_i),
			.L2_cnuPaDCombine_patternStride1_i (L2_cnuPaDCombine_patternStride1_i),
			.L2_cnuPaDCombine_patternStride2_i (L2_cnuPaDCombine_patternStride2_i),
			.L1_vnuBs_swInSrc                  (L1_vnuBs_swInSrc),
			.cnu_sync_addr_i                   (cnu_sync_addr_i),
			.vnu_sync_addr_i                   (vnu_sync_addr_i),
			.cnu_layer_status_i                (cnu_layer_status_i),
			.vnu_layer_status_i                (vnu_layer_status_i),
			.cnu_sub_row_status_i              (cnu_sub_row_status_i),
			.vnu_sub_row_status_i              (vnu_sub_row_status_i),
			.last_row_chunk_i                  (last_row_chunk_i),
			.we                                (we),
			.sys_clk                           (sys_clk),
			.rstn                              (rstn)
		);

	task init();
		ch2bs_stride0_bit0_i              <= '1;
		ch2bs_stride0_bit1_i              <= '1;
		ch2bs_stride0_bit2_i              <= '1;
		vnu2mem_stride0_bit0_i            <= '1;
		vnu2mem_stride0_bit1_i            <= '1;
		vnu2mem_stride0_bit2_i            <= '1;
		cnu2mem_stride0_bit0_i            <= '1;
		cnu2mem_stride0_bit1_i            <= '1;
		cnu2mem_stride0_bit2_i            <= '1;
		L1_mem2pa_vnuStride0_bit0_i       <= '1;
		L1_mem2pa_vnuStride0_bit1_i       <= '1;
		L1_mem2pa_vnuStride0_bit2_i       <= '1;
		L1_mem2pa_cnuStride0_bit0_i       <= '1;
		L1_mem2pa_cnuStride0_bit1_i       <= '1;
		L1_mem2pa_cnuStride0_bit2_i       <= '1;
		vnuPaMuxSel_stride0_bit0_i        <= '1;
		vnuPaMuxSel_stride0_bit1_i        <= '1;
		cnuPaMuxSel_stride0_bit0_i        <= '1;
		cnuPaMuxSel_stride0_bit1_i        <= '1;
		ch2bs_stride0_bit3_i              <= '1;
		vnu2mem_stride0_bit3_i            <= '1;
		cnu2mem_stride0_bit3_i            <= '1;
		L1_mem2pa_vnuStride0_bit3_i       <= '1;
		L1_mem2pa_cnuStride0_bit3_i       <= '1;
		ch2bs_stride1_bit0_i              <= '1;
		ch2bs_stride1_bit1_i              <= '1;
		ch2bs_stride1_bit2_i              <= '1;
		vnu2mem_stride1_bit0_i            <= '1;
		vnu2mem_stride1_bit1_i            <= '1;
		vnu2mem_stride1_bit2_i            <= '1;
		cnu2mem_stride1_bit0_i            <= '1;
		cnu2mem_stride1_bit1_i            <= '1;
		cnu2mem_stride1_bit2_i            <= '1;
		L1_mem2pa_vnuStride1_bit0_i       <= '1;
		L1_mem2pa_vnuStride1_bit1_i       <= '1;
		L1_mem2pa_vnuStride1_bit2_i       <= '1;
		L1_mem2pa_cnuStride1_bit0_i       <= '1;
		L1_mem2pa_cnuStride1_bit1_i       <= '1;
		L1_mem2pa_cnuStride1_bit2_i       <= '1;
		vnuPaMuxSel_stride1_bit0_i        <= '1;
		vnuPaMuxSel_stride1_bit1_i        <= '1;
		cnuPaMuxSel_stride1_bit0_i        <= '1;
		cnuPaMuxSel_stride1_bit1_i        <= '1;
		ch2bs_stride1_bit3_i              <= '1;
		vnu2mem_stride1_bit3_i            <= '1;
		cnu2mem_stride1_bit3_i            <= '1;
		L1_mem2pa_vnuStride1_bit3_i       <= '1;
		L1_mem2pa_cnuStride1_bit3_i       <= '1;
		ch2bs_stride2_bit0_i              <= '1;
		ch2bs_stride2_bit1_i              <= '1;
		ch2bs_stride2_bit2_i              <= '1;
		vnu2mem_stride2_bit0_i            <= '1;
		vnu2mem_stride2_bit1_i            <= '1;
		vnu2mem_stride2_bit2_i            <= '1;
		cnu2mem_stride2_bit0_i            <= '1;
		cnu2mem_stride2_bit1_i            <= '1;
		cnu2mem_stride2_bit2_i            <= '1;
		L1_mem2pa_vnuStride2_bit0_i       <= '1;
		L1_mem2pa_vnuStride2_bit1_i       <= '1;
		L1_mem2pa_vnuStride2_bit2_i       <= '1;
		L1_mem2pa_cnuStride2_bit0_i       <= '1;
		L1_mem2pa_cnuStride2_bit1_i       <= '1;
		L1_mem2pa_cnuStride2_bit2_i       <= '1;
		vnuPaMuxSel_stride2_bit0_i        <= '1;
		vnuPaMuxSel_stride2_bit1_i        <= '1;
		cnuPaMuxSel_stride2_bit0_i        <= '1;
		cnuPaMuxSel_stride2_bit1_i        <= '1;
		ch2bs_stride2_bit3_i              <= '1;
		vnu2mem_stride2_bit3_i            <= '1;
		cnu2mem_stride2_bit3_i            <= '1;
		L1_mem2pa_vnuStride2_bit3_i       <= '1;
		L1_mem2pa_cnuStride2_bit3_i       <= '1;
		L1_vnuBsShift_factor_i            <= '1;
		L1_cnuBsShift_factor_i            <= '1;
		L2_vnuPaShift_factor_bit0_i       <= '1;
		L2_vnuPaShift_factor_bit1_i       <= '1;
		L2_cnuPaShift_factor_bit0_i       <= '1;
		L2_cnuPaShift_factor_bit1_i       <= '1;
		L2_vnuPaDCombine_patternStride0_i <= '1;
		L2_vnuPaDCombine_patternStride1_i <= '1;
		L2_vnuPaDCombine_patternStride2_i <= '1;
		L2_cnuPaDCombine_patternStride0_i <= '1;
		L2_cnuPaDCombine_patternStride1_i <= '1;
		L2_cnuPaDCombine_patternStride2_i <= '1;
		L1_vnuBs_swInSrc                  <= '1;
		cnu_sync_addr_i                   <= '1;
		vnu_sync_addr_i                   <= '1;
		cnu_layer_status_i                <= '1;
		vnu_layer_status_i                <= '1;
		cnu_sub_row_status_i              <= '1;
		vnu_sub_row_status_i              <= '1;
		last_row_chunk_i                  <= '1;
		we                                <= '1;
		assign sys_clk                     = clk;
		assign rstn                        = srstb;
	endtask

	task drive(int iter);
		for(int it = 0; it < iter; it++) begin
			ch2bs_stride0_bit0_i              <= '1;
			ch2bs_stride0_bit1_i              <= '1;
			ch2bs_stride0_bit2_i              <= '1;
			vnu2mem_stride0_bit0_i            <= '1;
			vnu2mem_stride0_bit1_i            <= '1;
			vnu2mem_stride0_bit2_i            <= '1;
			cnu2mem_stride0_bit0_i            <= '1;
			cnu2mem_stride0_bit1_i            <= '1;
			cnu2mem_stride0_bit2_i            <= '1;
			L1_mem2pa_vnuStride0_bit0_i       <= '1;
			L1_mem2pa_vnuStride0_bit1_i       <= '1;
			L1_mem2pa_vnuStride0_bit2_i       <= '1;
			L1_mem2pa_cnuStride0_bit0_i       <= '1;
			L1_mem2pa_cnuStride0_bit1_i       <= '1;
			L1_mem2pa_cnuStride0_bit2_i       <= '1;
			vnuPaMuxSel_stride0_bit0_i        <= '1;
			vnuPaMuxSel_stride0_bit1_i        <= '1;
			cnuPaMuxSel_stride0_bit0_i        <= '1;
			cnuPaMuxSel_stride0_bit1_i        <= '1;
			ch2bs_stride0_bit3_i              <= '1;
			vnu2mem_stride0_bit3_i            <= '1;
			cnu2mem_stride0_bit3_i            <= '1;
			L1_mem2pa_vnuStride0_bit3_i       <= '1;
			L1_mem2pa_cnuStride0_bit3_i       <= '1;
			ch2bs_stride1_bit0_i              <= '1;
			ch2bs_stride1_bit1_i              <= '1;
			ch2bs_stride1_bit2_i              <= '1;
			vnu2mem_stride1_bit0_i            <= '1;
			vnu2mem_stride1_bit1_i            <= '1;
			vnu2mem_stride1_bit2_i            <= '1;
			cnu2mem_stride1_bit0_i            <= '1;
			cnu2mem_stride1_bit1_i            <= '1;
			cnu2mem_stride1_bit2_i            <= '1;
			L1_mem2pa_vnuStride1_bit0_i       <= '1;
			L1_mem2pa_vnuStride1_bit1_i       <= '1;
			L1_mem2pa_vnuStride1_bit2_i       <= '1;
			L1_mem2pa_cnuStride1_bit0_i       <= '1;
			L1_mem2pa_cnuStride1_bit1_i       <= '1;
			L1_mem2pa_cnuStride1_bit2_i       <= '1;
			vnuPaMuxSel_stride1_bit0_i        <= '1;
			vnuPaMuxSel_stride1_bit1_i        <= '1;
			cnuPaMuxSel_stride1_bit0_i        <= '1;
			cnuPaMuxSel_stride1_bit1_i        <= '1;
			ch2bs_stride1_bit3_i              <= '1;
			vnu2mem_stride1_bit3_i            <= '1;
			cnu2mem_stride1_bit3_i            <= '1;
			L1_mem2pa_vnuStride1_bit3_i       <= '1;
			L1_mem2pa_cnuStride1_bit3_i       <= '1;
			ch2bs_stride2_bit0_i              <= '1;
			ch2bs_stride2_bit1_i              <= '1;
			ch2bs_stride2_bit2_i              <= '1;
			vnu2mem_stride2_bit0_i            <= '1;
			vnu2mem_stride2_bit1_i            <= '1;
			vnu2mem_stride2_bit2_i            <= '1;
			cnu2mem_stride2_bit0_i            <= '1;
			cnu2mem_stride2_bit1_i            <= '1;
			cnu2mem_stride2_bit2_i            <= '1;
			L1_mem2pa_vnuStride2_bit0_i       <= '1;
			L1_mem2pa_vnuStride2_bit1_i       <= '1;
			L1_mem2pa_vnuStride2_bit2_i       <= '1;
			L1_mem2pa_cnuStride2_bit0_i       <= '1;
			L1_mem2pa_cnuStride2_bit1_i       <= '1;
			L1_mem2pa_cnuStride2_bit2_i       <= '1;
			vnuPaMuxSel_stride2_bit0_i        <= '1;
			vnuPaMuxSel_stride2_bit1_i        <= '1;
			cnuPaMuxSel_stride2_bit0_i        <= '1;
			cnuPaMuxSel_stride2_bit1_i        <= '1;
			ch2bs_stride2_bit3_i              <= '1;
			vnu2mem_stride2_bit3_i            <= '1;
			cnu2mem_stride2_bit3_i            <= '1;
			L1_mem2pa_vnuStride2_bit3_i       <= '1;
			L1_mem2pa_cnuStride2_bit3_i       <= '1;
			L1_vnuBsShift_factor_i            <= L1_vnuBsShift_factor_i+1;
			L1_cnuBsShift_factor_i            <= L1_cnuBsShift_factor_i+1;
			L2_vnuPaShift_factor_bit0_i       <= 0;
			L2_vnuPaShift_factor_bit1_i       <= 1;
			L2_cnuPaShift_factor_bit0_i       <= 0;
			L2_cnuPaShift_factor_bit1_i       <= 1;
			L2_vnuPaDCombine_patternStride0_i <= '1;
			L2_vnuPaDCombine_patternStride1_i <= '1;
			L2_vnuPaDCombine_patternStride2_i <= '1;
			L2_cnuPaDCombine_patternStride0_i <= '1;
			L2_cnuPaDCombine_patternStride1_i <= '1;
			L2_cnuPaDCombine_patternStride2_i <= '1;
			L1_vnuBs_swInSrc                  <= '1;
			cnu_sync_addr_i                   <= '1;
			vnu_sync_addr_i                   <= '1;
			cnu_layer_status_i                <= '1;
			vnu_layer_status_i                <= '1;
			cnu_sub_row_status_i              <= '1;
			vnu_sub_row_status_i              <= '1;
			last_row_chunk_i                  <= '1;
			we                                <= '1;

			@(posedge clk);
		end
	endtask

	initial begin
		// do something

		init();
		repeat(10)@(posedge clk);

		drive(20);

		repeat(1000)@(posedge clk);
		$finish;
	end

	// dump wave
	initial begin
		//$display("random seed : %0d", $unsigned($get_initial_random_seed()));
		//if ( $test$plusargs("fsdb") ) begin
		//	$fsdbDumpfile("tb_partial_msgPass_wrapper.fsdb");
		//	$fsdbDumpvars(0, "tb_partial_msgPass_wrapper", "+mda", "+functions");
		//end
	end

endmodule
