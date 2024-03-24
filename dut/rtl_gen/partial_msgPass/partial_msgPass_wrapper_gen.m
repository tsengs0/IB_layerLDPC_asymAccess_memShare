function partial_msgPass_wrapper_gen(QUAN_SIZE, LAYER_NUM, ROW_SPLIT_FACTOR, STRIDE_UNIT_SIZE, STRIDE_WIDTH)
fd = fopen('partial_msgPass_wrapper.v','w');

fprintf(fd, "module partial_msgPass_wrapper #(\r\n");
fprintf(fd, "	parameter QUAN_SIZE = %d,\r\n", QUAN_SIZE);
fprintf(fd, "	parameter ROW_SPLIT_FACTOR = %d, // Ns=%d\r\n", ROW_SPLIT_FACTOR);
fprintf(fd, "	parameter CHECK_PARALLELISM = %d,\r\n", STRIDE_UNIT_SIZE);
fprintf(fd, "	parameter STRIDE_UNIT_SIZE = %d,\r\n", STRIDE_UNIT_SIZE);
fprintf(fd, "	parameter STRIDE_WIDTH = %d,\r\n", STRIDE_WIDTH);
fprintf(fd, "	parameter LAYER_NUM = %d,\r\n", LAYER_NUM);
fprintf(fd, "	// Parameters of extrinsic RAMs\r\n");
fprintf(fd, "	parameter RAM_PORTA_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port A,\r\n");
fprintf(fd, "	parameter RAM_PORTB_RANGE = 9, // 9 out of RAM_UNIT_MSG_NUM messages are from/to true dual-port of RAM unit port b,\r\n"); 
fprintf(fd, "	parameter MEM_DEVICE_NUM = 28,\r\n");
fprintf(fd, "	parameter DEPTH = 1024,\r\n");
fprintf(fd, "	parameter DATA_WIDTH = 36,\r\n");
fprintf(fd, "	parameter FRAG_DATA_WIDTH = 12,\r\n");
fprintf(fd, "	parameter ADDR_WIDTH = $clog2(DEPTH)\r\n");
fprintf(fd, ") (\r\n");

for i=0:1:(STRIDE_WIDTH-1)
	fprintf(fd, "/*====== Stride unit %d =================================================== */\r\n", i);
	fprintf(fd, "	// The memory Dout port to variable nodes as instrinsic messages\r\n");
	fprintf(fd, "	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride%d_bit0_o,\r\n", i);
	fprintf(fd, "	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride%d_bit1_o,\r\n", i);
	fprintf(fd, "	output wire [STRIDE_UNIT_SIZE-1:0]  mem2vnu_stride%d_bit2_o,\r\n", i);
	fprintf(fd, "	// The memory Dout port to check nodes as instrinsic messages\r\n");
	fprintf(fd, "	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride%d_bit0_o,\r\n", i);
	fprintf(fd, "	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride%d_bit1_o,\r\n", i);
	fprintf(fd, "	output wire [STRIDE_UNIT_SIZE-1:0]  mem2cnu_stride%d_bit2_o,\r\n", i);
	fprintf(fd, "	// The varible extrinsic message written back onto memory through BS and PA\r\n");
	fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride%d_bit0_i,\r\n", i);
	fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride%d_bit1_i,\r\n", i);
	fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride%d_bit2_i,\r\n", i);
	fprintf(fd, "	// The check extrinsic message written back onto memory through BS and PA\r\n");
	fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride%d_bit0_i,\r\n", i);
	fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride%d_bit1_i,\r\n", i);
	fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride%d_bit2_i,\r\n", i);
	fprintf(fd, "`ifdef DECODER_4bit\r\n");
	fprintf(fd, "	output wire [STRIDE_UNIT_SIZE-1:0] mem2vnu_stride%d_bit3_o,\r\n", i);
	fprintf(fd, "	output wire [STRIDE_UNIT_SIZE-1:0] mem2cnu_stride%d_bit3_o,\r\n", i);
	fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0]  vnu2mem_stride%d_bit3_i,\r\n", i);
	fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0]  cnu2mem_stride%d_bit3_i,\r\n", i);
	fprintf(fd, "`endif\r\n");
endfor
fprintf(fd, "//----------------------------------------------------------------------//\r\n");
fprintf(fd, "	// The following nets for level-2 message passing are reused across all strides*/\r\n");
fprintf(fd, "	// The level-1 message passing\r\n");
fprintf(fd, "	input wire [$clog2(STRIDE_UNIT_SIZE-1)-1:0] L1_vnuBsShift_factor_i,\r\n");
fprintf(fd, "	input wire [$clog2(STRIDE_UNIT_SIZE-1)-1:0] L1_cnuBsShift_factor_i,\r\n");
fprintf(fd, "	// The level-1 page alignment (circular shifter) for aligning variable node incoming messages\r\n");
fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0] L2_vnuPaShift_factor_bit0_i, // shifter factor[bit_0]\r\n");
fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0] L2_vnuPaShift_factor_bit1_i, // shifter factor[bit_1]\r\n");
fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0] L2_vnuPaShift_factor_bit2_i, // shifter factor[bit_2]\r\n");
fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0] L2_vnuPaShift_factor_bit3_i, // shifter factor[bit_3]\r\n");
fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0] L2_vnuPaShift_factor_bit4_i, // shifter factor[bit_4]\r\n");
fprintf(fd, "	// The level-1 page alignment (circular shifter) for aligning variable node incoming messages\r\n");
fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0] L2_cnuPaShift_factor_bit0_i, // shifter factor[bit_0]\r\n");
fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0] L2_cnuPaShift_factor_bit1_i, // shifter factor[bit_1]\r\n");
fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0] L2_cnuPaShift_factor_bit2_i, // shifter factor[bit_2]\r\n");
fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0] L2_cnuPaShift_factor_bit3_i, // shifter factor[bit_3]\r\n");
fprintf(fd, "	input wire [STRIDE_UNIT_SIZE-1:0] L2_cnuPaShift_factor_bit4_i, // shifter factor[bit_4]\r\n");
fprintf(fd, "//----------------------------------------------------------------------//\r\n");
fprintf(fd, "	input wire [ADDR_WIDTH-1:0] cnu_sync_addr_i,\r\n");
fprintf(fd, "	input wire [ADDR_WIDTH-1:0] vnu_sync_addr_i,\r\n");
fprintf(fd, "	input wire [LAYER_NUM-1:0] cnu_layer_status_i,\r\n");
fprintf(fd, "	input wire [LAYER_NUM-1:0] vnu_layer_status_i,\r\n");
fprintf(fd, "	input wire [ROW_SPLIT_FACTOR-1:0] cnu_sub_row_status_i,\r\n");,
fprintf(fd, "	input wire [ROW_SPLIT_FACTOR-1:0] vnu_sub_row_status_i,\r\n");,
fprintf(fd, "	input wire [1:0] last_row_chunk_i, // [0]: check, [1]: variable\r\n");
fprintf(fd, "	input wire [1:0] we, // [0]: check, [1]: variable\r\n");
fprintf(fd, "	input wire sys_clk,\r\n");
fprintf(fd, "	input wire rstn\r\n");
fprintf(fd, "\);\r\n");
fprintf(fd, "\r\n");
fprintf(fd, "//-----------------------------------------------------------------------------//\r\n");
fprintf(fd, "// Message passing for check node messages\r\n");
fprintf(fd, "//-----------------------------------------------------------------------------//\r\n");
fprintf(fd, "//--------------------------\r\n");
fprintf(fd, "// Net and reg declarations\r\n");
fprintf(fd, "//--------------------------\r\n");
fprintf(fd, "// Stride unit 0 - %d\r\n", (STRIDE_WIDTH-1));
for i=0:1:(STRIDE_WIDTH-1)
	fprintf(fd, "wire [STRIDE_UNIT_SIZE-1:0] m2cStride%d_bit[0:QUAN_SIZE-1]; // msgPass-to-CNU @ stride %d\r\n", i, i);
endfor
fprintf(fd, "\r\n");
fprintf(fd, "//columnSingleSrc_L1Route #\(\r\n");
fprintf(fd, "columnSingleSrc_L1Route_emptybox #\(\r\n");
fprintf(fd, "	.QUAN_SIZE\(QUAN_SIZE\),\r\n");
fprintf(fd, "	.STRIDE_UNIT_SIZE\(STRIDE_UNIT_SIZE\),\r\n");
fprintf(fd, "	.STRIDE_WIDTH\(STRIDE_WIDTH\),\r\n");
fprintf(fd, "	.BITWIDTH_SHIFT_FACTOR\($clog2\(STRIDE_UNIT_SIZE-1\)\)\r\n");
fprintf(fd, "\) columnVNU_L1Route \(\r\n");
for i=0:1:(STRIDE_WIDTH-1)
fprintf(fd, "	.stride%d_out_bit0_o (m2cStride%d_bit[0]), // to CNUs of stride unit %d\r\n", i, i, i);
fprintf(fd, "	.stride%d_out_bit1_o (m2cStride%d_bit[1]), // to CNUs of stride unit %d\r\n", i, i, i);
fprintf(fd, "	.stride%d_out_bit2_o (m2cStride%d_bit[2]), // to CNUs of stride unit %d\r\n", i, i, i);
endfor

fprintf(fd, "	`ifdef DECODER_4bit\r\n");
for i=0:1:(STRIDE_WIDTH-1)
	fprintf(fd, "		.stride%d_out_bit3_o \(m2cStride%d_bit[3]\),\r\n", i, i);
endfor
fprintf(fd, "	`endif\r\n");
fprintf(fd, "\r\n");
for i=0:1:(STRIDE_WIDTH-1)
	fprintf(fd, "	.stride%d_bit0_i (vnu2mem_stride%d_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit %d\r\n", i, i, i);
	fprintf(fd, "	.stride%d_bit1_i (vnu2mem_stride%d_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit %d\r\n", i, i, i);
	fprintf(fd, "	.stride%d_bit2_i (vnu2mem_stride%d_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from VN extrinsic MSGs of stride unit %d\r\n", i, i, i);
endfor
fprintf(fd, "\r\n");
fprintf(fd, "	`ifdef DECODER_4bit\r\n");
for i=0:1:(STRIDE_WIDTH-1)
	fprintf(fd, "		.stride%d_bit3_i (vnu2mem_stride%d_bit3_i[STRIDE_UNIT_SIZE-1:0]),\r\n", i, i);
endfor
fprintf(fd, "	`endif\r\n");
fprintf(fd, "	.shift_factor        \(L1_vnuBsShift_factor_i[$clog2\(STRIDE_UNIT_SIZE-1\)-1:0]\),\r\n");
fprintf(fd, "	.sys_clk             \(sys_clk\),\r\n");
fprintf(fd, "	.rstn                \(rstn\)\r\n");
fprintf(fd, "\);\r\n");
fprintf(fd, "generate\r\n");
fprintf(fd, "	genvar strideUnit_id;\r\n");
fprintf(fd, "	for(strideUnit_id=0; strideUnit_id<STRIDE_UNIT_SIZE; strideUnit_id=strideUnit_id+1) begin : columnVNU_L2Route_inst\r\n");
fprintf(fd, "		msgPass2pageAlignIF #(\r\n");
fprintf(fd, "			.SHIFT_LENGTH        (STRIDE_WIDTH       ),\r\n");
fprintf(fd, "			.QUAN_SIZE           (QUAN_SIZE          )\r\n");
fprintf(fd, "		) columnVNU_L2Route (\r\n");

fprintf(fd, "			.msgPass2paOut_bit0_o      ({");
for i=(STRIDE_WIDTH-1):-1:1
	fprintf(fd, "mem2cnu_stride%d_bit0_o[strideUnit_id], ", i);
endfor
fprintf(fd, "mem2cnu_stride0_bit0_o[strideUnit_id]}),\r\n");

fprintf(fd, "			.msgPass2paOut_bit1_o      ({");
for i=(STRIDE_WIDTH-1):-1:1
	fprintf(fd, "mem2cnu_stride%d_bit1_o[strideUnit_id], ", i);
endfor
fprintf(fd, "mem2cnu_stride0_bit1_o[strideUnit_id]}),\r\n");

fprintf(fd, "			.msgPass2paOut_bit2_o      ({");
for i=(STRIDE_WIDTH-1):-1:1
	fprintf(fd, "mem2cnu_stride%d_bit2_o[strideUnit_id], ", i);
endfor
fprintf(fd, "mem2cnu_stride0_bit2_o[strideUnit_id]}),\r\n");

fprintf(fd, "\r\n");

fprintf(fd, "			.swIn_bit0_i      ({");
for i=(STRIDE_WIDTH-1):-1:1
	fprintf(fd, "m2cStride%d_bit[0][strideUnit_id], ", i);
endfor
fprintf(fd, "m2cStride0_bit[0][strideUnit_id]}),\r\n");

fprintf(fd, "			.swIn_bit1_i      ({");
for i=(STRIDE_WIDTH-1):-1:1
	fprintf(fd, "m2cStride%d_bit[1][strideUnit_id], ", i);
endfor
fprintf(fd, "m2cStride0_bit[1][strideUnit_id]}),\r\n");

fprintf(fd, "			.swIn_bit2_i      ({");
for i=(STRIDE_WIDTH-1):-1:1
	fprintf(fd, "m2cStride%d_bit[2][strideUnit_id], ", i);
endfor
fprintf(fd, "m2cStride0_bit[2][strideUnit_id]}),\r\n");

fprintf(fd, "\r\n");	
fprintf(fd, "		`ifdef DECODER_4bit\r\n");

fprintf(fd, "			.msgPass2paOut_bit3_o      ({");
for i=(STRIDE_WIDTH-1):-1:1
	fprintf(fd, "mem2cnu_stride%d_bit3_o[strideUnit_id], ", i);
endfor
fprintf(fd, "mem2cnu_stride0_bit3_o[strideUnit_id]}),\r\n");

fprintf(fd, "			.swIn_bit3_i      ({");
for i=(STRIDE_WIDTH-1):-1:1
	fprintf(fd, "m2cStride%d_bit[3][strideUnit_id], ", i);
endfor
fprintf(fd, "m2cStride0_bit[3][strideUnit_id]}),\r\n");
fprintf(fd, "		`endif\r\n");

temp = ceil(log2(STRIDE_WIDTH));
fprintf(fd, "			.L1_paShift_factor_i ({");
for i=(temp-1):-1:1
	fprintf(fd, "L2_cnuPaShift_factor_bit%d_i[strideUnit_id], ", i);
endfor
fprintf(fd, "L2_cnuPaShift_factor_bit0_i[strideUnit_id]}),\r\n");

fprintf(fd, "			.sys_clk                   \(sys_clk\),\r\n");
fprintf(fd, "			.rstn                      \(rstn\)\r\n");
fprintf(fd, "		\);\r\n");
fprintf(fd, "	end\r\n");
fprintf(fd, "endgenerate\r\n");
fprintf(fd, "//-----------------------------------------------------------------------------//\r\n");
fprintf(fd, "// Message passing for check node messages\r\n");
fprintf(fd, "//-----------------------------------------------------------------------------//\r\n");
fprintf(fd, "// Stride unit 0 - %d\r\n", (STRIDE_WIDTH-1));
for i=0:1:(STRIDE_WIDTH-1)
	fprintf(fd, "wire [STRIDE_UNIT_SIZE-1:0] m2vStride%d_bit[0:QUAN_SIZE-1]; // msgPass-to-VNU for stride %d\r\n", i, i);
endfor
fprintf(fd, "columnSingleSrc_L1Route #(\r\n");
fprintf(fd, "	.QUAN_SIZE(QUAN_SIZE),\r\n");
fprintf(fd, "	.STRIDE_UNIT_SIZE(STRIDE_UNIT_SIZE),\r\n");
fprintf(fd, "	.STRIDE_WIDTH(STRIDE_WIDTH),\r\n");
fprintf(fd, "	.BITWIDTH_SHIFT_FACTOR($clog2(STRIDE_UNIT_SIZE-1))\r\n");
fprintf(fd, ") columnCNU_L1Route_u0 (\r\n");

for i=0:1:(STRIDE_WIDTH-1)
	fprintf(fd, "	.stride%d_out_bit0_o (m2vStride%d_bit[0]), // to VNUs of stride unit %d\r\n", i, i, i);
	fprintf(fd, "	.stride%d_out_bit1_o (m2vStride%d_bit[1]), // to VNUs of stride unit %d\r\n", i, i, i);
	fprintf(fd, "	.stride%d_out_bit2_o (m2vStride%d_bit[2]), // to VNUs of stride unit %d\r\n", i, i, i);
endfor

fprintf(fd, "	`ifdef DECODER_4bit\r\n");
for i=0:1:(STRIDE_WIDTH-1)
	fprintf(fd, "		.stride%d_out_bit3_o (m2vStride%d_bit[3]),\r\n", i, i);
endfor
fprintf(fd, "	`endif\r\n");

for i=0:1:(STRIDE_WIDTH-1)
	fprintf(fd, "	.stride%d_bit0_i     (cnu2mem_stride%d_bit0_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit %d\r\n", i, i, i);
	fprintf(fd, "	.stride%d_bit1_i     (cnu2mem_stride%d_bit1_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit %d\r\n", i, i, i);
	fprintf(fd, "	.stride%d_bit2_i     (cnu2mem_stride%d_bit2_i[STRIDE_UNIT_SIZE-1:0]), // from CN extrinsic MSGs of stride unit %d\r\n", i, i, i);
endfor

fprintf(fd, "	`ifdef DECODER_4bit\r\n");
for i=0:1:(STRIDE_WIDTH-1)
	fprintf(fd, "		.stride%d_bit3_i     (cnu2mem_stride%d_bit3_i[STRIDE_UNIT_SIZE-1:0]),\r\n", i, i);
endfor
fprintf(fd, "	`endif\r\n");

fprintf(fd, "	.shift_factor        (L1_cnuBsShift_factor_i[$clog2(STRIDE_UNIT_SIZE-1)-1:0]),\r\n");
fprintf(fd, "	.sys_clk             (sys_clk),\r\n");
fprintf(fd, "	.rstn                (rstn)\r\n");
fprintf(fd, ");\r\n");

fprintf(fd, "generate\r\n");
fprintf(fd, "	for(strideUnit_id=0; strideUnit_id<STRIDE_UNIT_SIZE; strideUnit_id=strideUnit_id+1) begin : columnCNU_L2Route_inst\r\n");
fprintf(fd, "		msgPass2pageAlignIF #(\r\n");
fprintf(fd, "			.SHIFT_LENGTH        (STRIDE_WIDTH       ),\r\n");
fprintf(fd, "			.QUAN_SIZE           (QUAN_SIZE          )\r\n");
fprintf(fd, "		) columnCNU_L2Route (\r\n");

fprintf(fd, "			.msgPass2paOut_bit0_o      ({");
for i=(STRIDE_WIDTH-1):-1:1
	fprintf(fd, "mem2vnu_stride%d_bit0_o[strideUnit_id], ", i);
endfor
fprintf(fd, "mem2vnu_stride0_bit0_o[strideUnit_id]}),\r\n");

fprintf(fd, "			.msgPass2paOut_bit1_o      ({");
for i=(STRIDE_WIDTH-1):-1:1
	fprintf(fd, "mem2vnu_stride%d_bit1_o[strideUnit_id], ", i);
endfor
fprintf(fd, "mem2vnu_stride0_bit1_o[strideUnit_id]}),\r\n");

fprintf(fd, "			.msgPass2paOut_bit2_o      ({");
for i=(STRIDE_WIDTH-1):-1:1
	fprintf(fd, "mem2vnu_stride%d_bit2_o[strideUnit_id], ", i);
endfor
fprintf(fd, "mem2vnu_stride0_bit2_o[strideUnit_id]}),\r\n");

fprintf(fd, "\r\n");
fprintf(fd, "			.swIn_bit0_i               ({");
for i=(STRIDE_WIDTH-1):-1:1
	fprintf(fd, "m2vStride%d_bit[0][strideUnit_id], ", i);
endfor
fprintf(fd, "m2vStride0_bit[0][strideUnit_id]}),\r\n");

fprintf(fd, "			.swIn_bit1_i               ({");
for i=(STRIDE_WIDTH-1):-1:1
	fprintf(fd, "m2vStride%d_bit[1][strideUnit_id], ", i);
endfor
fprintf(fd, "m2vStride0_bit[1][strideUnit_id]}),\r\n");

fprintf(fd, "			.swIn_bit2_i               ({");
for i=(STRIDE_WIDTH-1):-1:1
	fprintf(fd, "m2vStride%d_bit[2][strideUnit_id], ", i);
endfor
fprintf(fd, "m2vStride0_bit[2][strideUnit_id]}),\r\n");

fprintf(fd, "		`ifdef DECODER_4bit\r\n");

fprintf(fd, "			.msgPass2paOut_bit3_o      ({");
for i=(STRIDE_WIDTH-1):-1:1
	fprintf(fd, "mem2vnu_stride%d_bit3_o[strideUnit_id], ", i);
endfor
fprintf(fd, "mem2vnu_stride0_bit3_o[strideUnit_id]}),\r\n");

fprintf(fd, "			.swIn_bit3_i               ({");
for i=(STRIDE_WIDTH-1):-1:1
	fprintf(fd, "m2vStride%d_bit[3][strideUnit_id], ", i);
endfor
fprintf(fd, "m2vStride0_bit[3][strideUnit_id]}),\r\n");

fprintf(fd, "		`endif\r\n");

temp = ceil(log2(STRIDE_WIDTH));
fprintf(fd, "			.L1_paShift_factor_i ({");
for i=(temp-1):-1:1
	fprintf(fd, "L2_vnuPaShift_factor_bit%d_i[strideUnit_id], ", i);
endfor
fprintf(fd, "L2_vnuPaShift_factor_bit0_i[strideUnit_id]}),\r\n");

fprintf(fd, "			.sys_clk                   (sys_clk),\r\n");
fprintf(fd, "			.rstn                      (rstn)\r\n");
fprintf(fd, "		);\r\n");
fprintf(fd, "	end\r\n");
fprintf(fd, "endgenerate\r\n");
fprintf(fd, "endmodule");

fclose(fd);
endfunction