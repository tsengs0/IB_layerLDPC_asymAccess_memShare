function columnSingleSrc_L1Route_emptybox_gen(QUAN_SIZE, STRIDE_UNIT_SIZE, STRIDE_WIDTH)
fd = fopen('columnSingleSrc_L1Route_emptybox.v','w');

fprintf(fd, "/**\r\n");
fprintf(fd, "* Created date:\r\n");
fprintf(fd, "* Developer: Bo-Yu Tseng\r\n");
fprintf(fd, "* Email: tsengs0@gmail.com\r\n");
fprintf(fd, "* Module name: columnSingleSrc_L1Route_emptybox\r\n");
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
fprintf(fd, "module columnSingleSrc_L1Route_emptybox #(\r\n");
fprintf(fd, "\tparameter QUAN_SIZE = %d,\r\n", QUAN_SIZE);
fprintf(fd, "\tparameter STRIDE_UNIT_SIZE = %d,\r\n", STRIDE_UNIT_SIZE);
fprintf(fd, "\tparameter STRIDE_WIDTH = %d,\r\n", STRIDE_WIDTH);
fprintf(fd, "\tparameter BITWIDTH_SHIFT_FACTOR = $clog2\(STRIDE_UNIT_SIZE-1\)\r\n");
fprintf(fd, ") (\r\n");

fprintf(fd, "\t//--------------\r\n");
fprintf(fd, "\t// Output ports\r\n");
fprintf(fd, "\t//--------------\r\n");

for i=0:1:(STRIDE_WIDTH-1)
  fprintf(fd, "\t// Stride unit %d\r\n", i);
  fprintf(fd, "\toutput wire [STRIDE_UNIT_SIZE-1:0] stride%d_out_bit0_o,\r\n", i);
  fprintf(fd, "\toutput wire [STRIDE_UNIT_SIZE-1:0] stride%d_out_bit1_o,\r\n", i);
  fprintf(fd, "\toutput wire [STRIDE_UNIT_SIZE-1:0] stride%d_out_bit2_o,\r\n", i);
endfor

fprintf(fd, "\t`ifdef DECODER_4bit\r\n");
for i=0:1:(STRIDE_WIDTH-1)
  fprintf(fd, "\t\toutput wire [STRIDE_UNIT_SIZE-1:0] stride%d_out_bit3_o,\r\n", i);
endfor
fprintf(fd, "\t`endif");
fprintf(fd, "\r\n");

fprintf(fd, "\t//--------------\r\n");
fprintf(fd, "\t// Input ports\r\n");
fprintf(fd, "\t//--------------\r\n");
for i=0:1:(STRIDE_WIDTH-1)
  fprintf(fd, "\tinput wire [STRIDE_UNIT_SIZE-1:0] stride%d_bit0_i,\r\n", i);
  fprintf(fd, "\tinput wire [STRIDE_UNIT_SIZE-1:0] stride%d_bit1_i,\r\n", i);
  fprintf(fd, "\tinput wire [STRIDE_UNIT_SIZE-1:0] stride%d_bit2_i,\r\n", i);
endfor

fprintf(fd, "\t`ifdef DECODER_4bit\r\n");
for i=0:1:(STRIDE_WIDTH-1)
  fprintf(fd, "\t\tinput wire [STRIDE_UNIT_SIZE-1:0] stride%d_bit3_i,\r\n", i);
endfor
fprintf(fd, "\t`endif");
fprintf(fd, "\r\n");

fprintf(fd, "\t// selector of permutatoin input source\r\n");
fprintf(fd, "\tinput wire [BITWIDTH_SHIFT_FACTOR-1:0] shift_factor,\r\n");
fprintf(fd, "\tinput wire sys_clk,\r\n");
fprintf(fd, "\tinput wire rstn\r\n");
fprintf(fd, ");\r\n\r\n")

fprintf(fd, "// Nets as output sources from circular shifters\r\n");
for i=0:1:(STRIDE_WIDTH-1)
	fprintf(fd, "assign stride%d_out_bit0_o[STRIDE_UNIT_SIZE-1:0] = stride%d_bit0_i[STRIDE_UNIT_SIZE-1:0];\r\n", i, i);
	fprintf(fd, "assign stride%d_out_bit1_o[STRIDE_UNIT_SIZE-1:0] = stride%d_bit1_i[STRIDE_UNIT_SIZE-1:0];\r\n", i, i);
	fprintf(fd, "assign stride%d_out_bit2_o[STRIDE_UNIT_SIZE-1:0] = stride%d_bit2_i[STRIDE_UNIT_SIZE-1:0];\r\n", i, i);
	fprintf(fd, "`ifdef DECODER_4bit assign stride%d_out_bit3_o[STRIDE_UNIT_SIZE-1:0] = stride%d_bit3_i[STRIDE_UNIT_SIZE-1:0]; `endif\r\n", i, i);
endfor
fprintf(fd, "endmodule");
fclose(fd);
endfunction