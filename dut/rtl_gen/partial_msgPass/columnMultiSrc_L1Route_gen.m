function columnMultiSrc_L1Route_gen(QUAN_SIZE, STRIDE_UNIT_SIZE, STRIDE_WIDTH)
fd = fopen('columnMultiSrc_L1Route.v','w');

fprintf(fd, "/**\r\n");
fprintf(fd, "* Created date:\r\n");
fprintf(fd, "* Developer: Bo-Yu Tseng\r\n");
fprintf(fd, "* Email: tsengs0@gamil.com\r\n");
fprintf(fd, "* Module name: columnMultiSrc_L1Route\r\n");
fprintf(fd, "\r\n");
fprintf(fd, "* # I/F\r\n");
fprintf(fd, "* 1\) Output:\r\n");
fprintf(fd, "\r\n");
fprintf(fd, "* 2) Input:\r\n");
fprintf(fd, "*\r\n");
fprintf(fd, "* # Param\r\n");
fprintf(fd, "*\r\n"); 
fprintf(fd, "* # Description\r\n");
fprintf(fd, "* To perform the (base matrix) column-wise 1st-level circular shifting opertion for passing CNU outgoing messages\r\n");
fprintf(fd, "* # Dependencies\r\n");
fprintf(fd, "*   1\) devine.vh -> quantisatin bit with of messages\r\n");
fprintf(fd, "**\/\r\n");
fprintf(fd, "`include \"define.vh\"\r\n");
fprintf("\r\n");
fprintf(fd, "module columnMultiSrc_L1Route #(\r\n");
fprintf(fd, "\tparameter QUAN_SIZE = %d,\r\n", QUAN_SIZE);
fprintf(fd, "\tparameter STRIDE_UNIT_SIZE = %d,\r\n", STRIDE_UNIT_SIZE);
fprintf(fd, "\tparameter STRIDE_WIDTH = %d,\r\n", STRIDE_WIDTH);
fprintf(fd, "\tparameter BITWIDTH_SHIFT_FACTOR = $clog2(STRIDE_UNIT_SIZE-1)\r\n");
fprintf(fd, ") (\r\n");

fprintf(fd, "  //--------------\r\n");
fprintf(fd, "    // Output ports\r\n");
fprintf(fd, "    //--------------\r\n");
for i=0:1:(STRIDE_WIDTH-1)
  fprintf(fd, "  // Stride unit %d\r\n", i);
  fprintf(fd, "  output wire [STRIDE_UNIT_SIZE-1:0] stride%d_out_bit0_o,\r\n", i);
  fprintf(fd, "  output wire [STRIDE_UNIT_SIZE-1:0] stride%d_out_bit1_o,\r\n", i);
  fprintf(fd, "  output wire [STRIDE_UNIT_SIZE-1:0] stride%d_out_bit2_o,\r\n", i);
endfor
fprintf(fd, "  `ifdef DECODER_4bit\r\n");
for i=0:1:(STRIDE_WIDTH-1)
  fprintf(fd, "    output wire [STRIDE_UNIT_SIZE-1:0] stride%d_out_bit3_o,\r\n", i);
endfor
fprintf(fd, "  `endif\r\n");

fprintf(fd, "\r\n");
fprintf(fd, "  //--------------\r\n");
fprintf(fd, "  // Input ports\r\n");
fprintf(fd, "  //--------------\r\n");
fprintf(fd, "  // Stride unit %d\r\n", i);
fprintf(fd, "  // From channel messages\r\n");
for i=0:1:(STRIDE_WIDTH-1)
  fprintf(fd, "  input wire [STRIDE_UNIT_SIZE-1:0] stride%d_in0_bit0_i,\r\n", i);
  fprintf(fd, "  input wire [STRIDE_UNIT_SIZE-1:0] stride%d_in0_bit1_i,\r\n", i);
  fprintf(fd, "  input wire [STRIDE_UNIT_SIZE-1:0] stride%d_in0_bit2_i,\r\n", i);
  fprintf(fd, "  // From VNUs\r\n");
  fprintf(fd, "  input wire [STRIDE_UNIT_SIZE-1:0] stride%d_in1_bit0_i,\r\n", i);
  fprintf(fd, "  input wire [STRIDE_UNIT_SIZE-1:0] stride%d_in1_bit1_i,\r\n", i);
  fprintf(fd, "  input wire [STRIDE_UNIT_SIZE-1:0] stride%d_in1_bit2_i,\r\n", i);
endfor
fprintf(fd, "  `ifdef DECODER_4bit\r\n");
for i=0:1:(STRIDE_WIDTH-1)
  fprintf(fd, "    input wire [STRIDE_UNIT_SIZE-1:0] stride%d_in0_bit3_i,\r\n", i);
  fprintf(fd, "    input wire [STRIDE_UNIT_SIZE-1:0] stride%d_in1_bit3_i,\r\n", i);
endfor
fprintf(fd, "  `endif\r\n");
fprintf(fd, "\r\n");
fprintf(fd, "  // selector of permutatoin input source\r\n");
fprintf(fd, "  input wire [BITWIDTH_SHIFT_FACTOR-1:0] shift_factor,\r\n");
fprintf(fd, "  input wire sw_in_src,\r\n");
fprintf(fd, "  input wire sys_clk,\r\n");
fprintf(fd, "  input wire rstn\r\n");
fprintf(fd, "\);\r\n");
fprintf(fd, "\r\n");
fprintf(fd, "localparam LEFT_SEL_WIDTH = $clog2\(STRIDE_UNIT_SIZE\);\r\n");
fprintf(fd, "localparam RIGHT_SEL_WIDTH = $clog2\(STRIDE_UNIT_SIZE\);\r\n");
fprintf(fd, "\r\n");
fprintf(fd, "//--------------------------\r\n");
fprintf(fd, "// Net and reg declarations\r\n");
fprintf(fd, "//--------------------------\r\n");
fprintf(fd, "wire [STRIDE_UNIT_SIZE-1:0] shared_sw_in_bit [0:STRIDE_WIDTH-1][0:QUAN_SIZE-1];\r\n");
fprintf(fd, "wire [STRIDE_UNIT_SIZE-1:0] sw_out_bit [0:STRIDE_WIDTH-1][0:QUAN_SIZE-1];\r\n");
fprintf(fd, "\r\n");
fprintf(fd, "genvar stride_unit_id;\r\n");
fprintf(fd, "generate\r\n");
fprintf(fd, "  for(stride_unit_id=0; stride_unit_id<STRIDE_WIDTH; stride_unit_id=stride_unit_id+1) begin : strideBs_group_inst\r\n");
fprintf(fd, "    wire [LEFT_SEL_WIDTH-1:0]  left_sel;\r\n");
fprintf(fd, "    wire [RIGHT_SEL_WIDTH-1:0]  right_sel;\r\n");
fprintf(fd, "    wire [STRIDE_UNIT_SIZE-2:0] merge_sel;\r\n");
fprintf(fd, "    qsn_top_len%d vnu_qsn_top_len%d_u0 (\r\n", STRIDE_UNIT_SIZE, STRIDE_UNIT_SIZE);
fprintf(fd, "      .sw_out_bit0 (sw_out_bit[stride_unit_id][0]),\r\n");
fprintf(fd, "      .sw_out_bit1 (sw_out_bit[stride_unit_id][1]),\r\n");
fprintf(fd, "      .sw_out_bit2 (sw_out_bit[stride_unit_id][2]),\r\n");
fprintf(fd, "    `ifdef DECODER_4bit\r\n");
fprintf(fd, "      .sw_out_bit3 (sw_out_bit[stride_unit_id][3]),\r\n");
fprintf(fd, "    `endif\r\n");
fprintf(fd, "\r\n");
fprintf(fd, "      .sys_clk     (sys_clk),\r\n");
fprintf(fd, "      .rstn    (rstn),\r\n");
fprintf(fd, "\r\n");
fprintf(fd, "      .sw_in_bit0  (shared_sw_in_bit[stride_unit_id][0]),\r\n");
fprintf(fd, "      .sw_in_bit1  (shared_sw_in_bit[stride_unit_id][1]),\r\n");
fprintf(fd, "      .sw_in_bit2  (shared_sw_in_bit[stride_unit_id][2]),\r\n");
fprintf(fd, "      `ifdef DECODER_4bit\r\n");
fprintf(fd, "        .sw_in_bit3  (shared_sw_in_bit[stride_unit_id][3]),\r\n");
fprintf(fd, "      `endif\r\n");
fprintf(fd, "\r\n");
fprintf(fd, "      .left_sel    (left_sel),\r\n");
fprintf(fd, "      .right_sel   (right_sel),\r\n");
fprintf(fd, "      .merge_sel   (merge_sel)\r\n");
fprintf(fd, "    );\r\n");
fprintf(fd, "\r\n");
fprintf(fd, "    qsn_controller_len%d #(\r\n", STRIDE_UNIT_SIZE);
fprintf(fd, "      .PERMUTATION_LENGTH(STRIDE_UNIT_SIZE)\r\n");
fprintf(fd, "    ) vnu_qsn_controller_len%d_u0 (\r\n", STRIDE_UNIT_SIZE);
fprintf(fd, "      .left_sel     (left_sel ),\r\n");
fprintf(fd, "      .right_sel    (right_sel),\r\n");
fprintf(fd, "      .merge_sel    (merge_sel),\r\n");
fprintf(fd, "      .shift_factor (shift_factor) // offset shift factor of submatrix_1\r\n");
fprintf(fd, "      //.rstn         (rstn),\r\n");
fprintf(fd, "      //.sys_clk      (sys_clk)\r\n");
fprintf(fd, "    );\r\n");
fprintf(fd, "  end\r\n");
fprintf(fd, "endgenerate\r\n");
fprintf(fd, "\r\n");
for i=0:1:(STRIDE_WIDTH-1)
  fprintf(fd, "// Stride unit %d\r\n", i);
  fprintf(fd, "scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) strideUnit%d_shared_sw_in_u0 (.sw_out(shared_sw_in_bit[/*strideUnit_%d*/%d][0]), .sw_in_0(stride%d_in0_bit0_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride%d_in1_bit0_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));\r\n", i,i,i,i,i);
  fprintf(fd, "scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) strideUnit%d_shared_sw_in_u1 (.sw_out(shared_sw_in_bit[/*strideUnit_%d*/%d][1]), .sw_in_0(stride%d_in0_bit1_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride%d_in1_bit1_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));\r\n", i,i,i,i,i);
  fprintf(fd, "scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) strideUnit%d_shared_sw_in_u2 (.sw_out(shared_sw_in_bit[/*strideUnit_%d*/%d][2]), .sw_in_0(stride%d_in0_bit2_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride%d_in1_bit2_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));\r\n", i,i,i,i,i);
  fprintf(fd, "`ifdef DECODER_4bit\r\n");
  fprintf(fd, "  scalable_mux #(.BITWIDTH(STRIDE_UNIT_SIZE)) strideUnit%d_shared_sw_in_u3 (.sw_out(shared_sw_in_bit[/*strideUnit_%d*/%d][3]), .sw_in_0(stride%d_in0_bit3_i[STRIDE_UNIT_SIZE-1:0]), .sw_in_1(stride%d_in1_bit3_i[STRIDE_UNIT_SIZE-1:0]), .in_src(sw_in_src));\r\n", i,i,i,i,i);
  fprintf(fd, "`endif\r\n");
  fprintf(fd, "assign stride%d_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_%d*/%d][0];\r\n", i,i,i);
  fprintf(fd, "assign stride%d_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_%d*/%d][1];\r\n", i,i,i);
  fprintf(fd, "assign stride%d_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_%d*/%d][2];\r\n", i,i,i);
  fprintf(fd, "`ifdef DECODER_4bit\r\n");
  fprintf(fd, "  assign stride%d_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = sw_out_bit[/*strideUnit_%d*/%d][3];\r\n", i,i,i);
  fprintf(fd, "`endif\r\n");
endfor
fprintf(fd, "endmodule");
fclose(fd);
endfunction
