//`define MARCH_2021
`define APRIL_2021

`ifdef MARCH_2021

module mem_share_group_4 #(
	parameter PARALLELISM_COL_4_6 = 4,
	parameter PARALLELISM_COL_5_7 = 2,
	parameter QUAN_SIZE = 3,
	parameter ENTRY_ADDR = 5
) (
    output wire [QUAN_SIZE-1:0] Dout_high_group0,
    output wire [QUAN_SIZE-1:0] Dout_high_group1,
    output wire [QUAN_SIZE-1:0] Dout_high_group2,
    output wire [QUAN_SIZE-1:0] Dout_high_group3,
    output wire [QUAN_SIZE-1:0] Dout_low_group0,
    output wire [QUAN_SIZE-1:0] Dout_low_group1,

    input wire [ENTRY_ADDR-1:0] read_addr_high_group_0,
    input wire [ENTRY_ADDR-1:0] read_addr_high_group_1,
    input wire [ENTRY_ADDR-1:0] read_addr_high_group_2,
    input wire [ENTRY_ADDR-1:0] read_addr_high_group_3,
    input wire [ENTRY_ADDR-1:0] read_addr_low_group_0,
    input wire [ENTRY_ADDR-1:0] read_addr_low_group_1,
 
    input wire [QUAN_SIZE-1:0] wr_Din_high_group,
    input wire [QUAN_SIZE-1:0] wr_Din_low_group,
    input wire [ENTRY_ADDR-1:0] write_addr,      
    input wire we,

    input wire write_clk
);

mem_share_high_bank #(
	.PARALLELISM (PARALLELISM_COL_4_6),
	.QUAN_SIZE   (QUAN_SIZE  ),
	.ENTRY_ADDR  (ENTRY_ADDR )
) col_4_6_bank (
    .lut_data0 (Dout_high_group0[QUAN_SIZE-1:0]),
    .lut_data1 (Dout_high_group1[QUAN_SIZE-1:0]),
    .lut_data2 (Dout_high_group2[QUAN_SIZE-1:0]),
    .lut_data3 (Dout_high_group3[QUAN_SIZE-1:0]),

    .read_addr0 (read_addr_high_group_0[ENTRY_ADDR-1:0]),
    .read_addr1 (read_addr_high_group_1[ENTRY_ADDR-1:0]),
    .read_addr2 (read_addr_high_group_2[ENTRY_ADDR-1:0]),
    .read_addr3 (read_addr_high_group_3[ENTRY_ADDR-1:0]),
 
    .lut_in (wr_Din_high_group[QUAN_SIZE-1:0]),
    .write_addr (write_addr[ENTRY_ADDR-1:0]),      
    .we (we),

    .write_clk (write_clk)
);

mem_share_low_bank #(
	.PARALLELISM (PARALLELISM_COL_5_7),
	.QUAN_SIZE   (QUAN_SIZE  ),
	.ENTRY_ADDR  (ENTRY_ADDR )
) col_5_7_bank (
    .lut_data0 (Dout_low_group0[QUAN_SIZE-1:0]),
    .lut_data1 (Dout_low_group1[QUAN_SIZE-1:0]),
         
    .read_addr0 (read_addr_low_group_0[ENTRY_ADDR-1:0]),
    .read_addr1 (read_addr_low_group_1[ENTRY_ADDR-1:0]),
    
    .lut_in (wr_Din_low_group[QUAN_SIZE-1:0]),
    .write_addr (write_addr[ENTRY_ADDR-1:0]),      
    .we (we),

    .write_clk (write_clk)
);
endmodule

module mem_share_high_bank #(
	parameter PARALLELISM = 4,
	parameter QUAN_SIZE = 3,
	parameter ENTRY_ADDR = 5
) (
    output wire [QUAN_SIZE-1:0] lut_data0,
    output wire [QUAN_SIZE-1:0] lut_data1,
    output wire [QUAN_SIZE-1:0] lut_data2,
    output wire [QUAN_SIZE-1:0] lut_data3,

    input wire [ENTRY_ADDR-1:0] read_addr0,
    input wire [ENTRY_ADDR-1:0] read_addr1,
    input wire [ENTRY_ADDR-1:0] read_addr2,
    input wire [ENTRY_ADDR-1:0] read_addr3,
 
    input wire [QUAN_SIZE-1:0] lut_in,
    input wire [ENTRY_ADDR-1:0] write_addr,      
    input wire we,

    input wire write_clk
);

	wire [QUAN_SIZE-1:0] lut_data_port [0:PARALLELISM-1];
	wire [ENTRY_ADDR-1:0] read_addr_port [0:PARALLELISM-1];
	genvar i;
	generate
	  for(i=0;i<PARALLELISM;i=i+1) begin : parallel_bank_inst
	    // RAM32X1S: 32 x 1 posedge write distributed (LUT) RAM (Mapped to a LUT6)
	    //           Kintex UltraScale+
	    // Xilinx HDL Language Template, version 2019.2
	    RAM32X1S #(
	       .INIT(32'h00000000),    // Initial contents of RAM
	       .IS_WCLK_INVERTED(1'b0) // Specifies active high/low WCLK
	    ) RAM32X1S_inst_msb_port03 (
	       .O(lut_data_port[i][2]),       // RAM output
	       .A0(read_addr_port[i][0]),     // RAM address[0] input
	       .A1(read_addr_port[i][1]),     // RAM address[1] input
	       .A2(read_addr_port[i][2]),     // RAM address[2] input
	       .A3(read_addr_port[i][3]),     // RAM address[3] input
	       .A4(read_addr_port[i][4]),     // RAM address[4] input
	       .D(lut_in[2]),       // RAM data input
	       .WCLK(write_clk), // Write clock input
	       .WE(we)      // Write enable input
	    );

	    // RAM32X2S: 32 x 2 posedge write distributed (LUT) RAM (Mapped to a SliceM LUT6)
	    //           Kintex-7
	    // Xilinx HDL Language Template, version 2019.2
	    RAM32X2S #(
	       .INIT_00(32'h00000000), // INIT for bit 0 of RAM
	       .INIT_01(32'h00000000)  // INIT for bit 1 of RAM
	    ) RAM32X2S_inst_magnitude_port03 (
	       .O0(lut_data_port[i][0]),     // RAM data[0] output
	       .O1(lut_data_port[i][1]),     // RAM data[1] output
	       .A0(read_addr_port[i][0]),     // RAM address[0] input
	       .A1(read_addr_port[i][1]),     // RAM address[1] input
	       .A2(read_addr_port[i][2]),     // RAM address[2] input
	       .A3(read_addr_port[i][3]),     // RAM address[3] input
	       .A4(read_addr_port[i][4]),     // RAM address[4] input
	       .D0(lut_in[0]),     // RAM data[0] input
	       .D1(lut_in[1]),     // RAM data[1] input
	       .WCLK(write_clk), // Write clock input
	       .WE(we)      // Write enable input
	    );
	  end
	endgenerate

	assign lut_data0[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[0];
	assign lut_data1[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[1];
	assign lut_data2[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[2];
	assign lut_data3[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[3];
	assign read_addr_port[0] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr0[ENTRY_ADDR-1:0];
	assign read_addr_port[1] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr1[ENTRY_ADDR-1:0];
	assign read_addr_port[2] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr2[ENTRY_ADDR-1:0];
	assign read_addr_port[3] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr3[ENTRY_ADDR-1:0];
endmodule

module mem_share_low_bank #(
	parameter PARALLELISM = 2,
	parameter QUAN_SIZE = 3,
	parameter ENTRY_ADDR = 5
) (
    output wire [QUAN_SIZE-1:0] lut_data0,
    output wire [QUAN_SIZE-1:0] lut_data1,
         
    input wire [ENTRY_ADDR-1:0] read_addr0,
    input wire [ENTRY_ADDR-1:0] read_addr1,
    
    input wire [QUAN_SIZE-1:0] lut_in,
    input wire [ENTRY_ADDR-1:0] write_addr,
 	input wire we,

    input wire write_clk
);

	wire [QUAN_SIZE-1:0] lut_data_port [0:PARALLELISM-1];
	wire [ENTRY_ADDR-1:0] read_addr_port [0:PARALLELISM-1];
	genvar i;
	generate
	  for(i=0;i<PARALLELISM;i=i+1) begin : parallel_bank_inst
	    // RAM32X1S: 32 x 1 posedge write distributed (LUT) RAM (Mapped to a LUT6)
	    //           Kintex UltraScale+
	    // Xilinx HDL Language Template, version 2019.2
	    RAM32X1S #(
	       .INIT(32'h00000000),    // Initial contents of RAM
	       .IS_WCLK_INVERTED(1'b0) // Specifies active high/low WCLK
	    ) RAM32X1S_inst_msb_port03 (
	       .O(lut_data_port[i][2]),       // RAM output
	       .A0(read_addr_port[i][0]),     // RAM address[0] input
	       .A1(read_addr_port[i][1]),     // RAM address[1] input
	       .A2(read_addr_port[i][2]),     // RAM address[2] input
	       .A3(read_addr_port[i][3]),     // RAM address[3] input
	       .A4(read_addr_port[i][4]),     // RAM address[4] input
	       .D(lut_in[2]),       // RAM data input
	       .WCLK(write_clk), // Write clock input
	       .WE(we)      // Write enable input
	    );

	    // RAM32X2S: 32 x 2 posedge write distributed (LUT) RAM (Mapped to a SliceM LUT6)
	    //           Kintex-7
	    // Xilinx HDL Language Template, version 2019.2
	    RAM32X2S #(
	       .INIT_00(32'h00000000), // INIT for bit 0 of RAM
	       .INIT_01(32'h00000000)  // INIT for bit 1 of RAM
	    ) RAM32X2S_inst_magnitude_port03 (
	       .O0(lut_data_port[i][0]),     // RAM data[0] output
	       .O1(lut_data_port[i][1]),     // RAM data[1] output
	       .A0(read_addr_port[i][0]),     // RAM address[0] input
	       .A1(read_addr_port[i][1]),     // RAM address[1] input
	       .A2(read_addr_port[i][2]),     // RAM address[2] input
	       .A3(read_addr_port[i][3]),     // RAM address[3] input
	       .A4(read_addr_port[i][4]),     // RAM address[4] input
	       .D0(lut_in[0]),     // RAM data[0] input
	       .D1(lut_in[1]),     // RAM data[1] input
	       .WCLK(write_clk), // Write clock input
	       .WE(we)      // Write enable input
	    );
	  end
	endgenerate

	assign lut_data0[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[0];
	assign lut_data1[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[1];
	assign read_addr_port[0] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr0[ENTRY_ADDR-1:0];
	assign read_addr_port[1] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr1[ENTRY_ADDR-1:0];
endmodule
`else // `ifdef APRIL_2021

module vn_f0_mem_share_group_2 #(
	parameter PARALLELISM_COL_4_6 = 2,
	parameter PARALLELISM_COL_5_7 = 1,
	parameter QUAN_SIZE = 3,
	parameter ENTRY_ADDR = 5
) (
    output wire [QUAN_SIZE-1:0] Dout_high_group0,
    output wire [QUAN_SIZE-1:0] Dout_high_group1,
    output wire [QUAN_SIZE-1:0] Dout_low_group0,

    input wire [ENTRY_ADDR-1:0] read_addr_high_group_0,
    input wire [ENTRY_ADDR-1:0] read_addr_high_group_1,
    input wire [ENTRY_ADDR-1:0] read_addr_low_group_0,
 
    input wire [QUAN_SIZE-1:0] wr_Din_high_group,
    input wire [QUAN_SIZE-1:0] wr_Din_low_group,
    input wire [ENTRY_ADDR-1:0] write_addr,      
    input wire we,

    input wire write_clk
);

vn_f0_mem_share_high_bank #(
	.PARALLELISM (PARALLELISM_COL_4_6),
	.QUAN_SIZE   (QUAN_SIZE  ),
	.ENTRY_ADDR  (ENTRY_ADDR )
) col_4_6_bank (
    .lut_data0 (Dout_high_group0[QUAN_SIZE-1:0]),
    .lut_data1 (Dout_high_group1[QUAN_SIZE-1:0]),

    .read_addr0 (read_addr_high_group_0[ENTRY_ADDR-1:0]),
    .read_addr1 (read_addr_high_group_1[ENTRY_ADDR-1:0]),
 
    .lut_in (wr_Din_high_group[QUAN_SIZE-1:0]),
    .write_addr (write_addr[ENTRY_ADDR-1:0]),      
    .we (we),

    .write_clk (write_clk)
);

vn_f0_mem_share_low_bank #(
	.PARALLELISM (PARALLELISM_COL_5_7),
	.QUAN_SIZE   (QUAN_SIZE  ),
	.ENTRY_ADDR  (ENTRY_ADDR )
) col_5_7_bank (
    .lut_data0 (Dout_low_group0[QUAN_SIZE-1:0]),
         
    .read_addr0 (read_addr_low_group_0[ENTRY_ADDR-1:0]),
    
    .lut_in (wr_Din_low_group[QUAN_SIZE-1:0]),
    .write_addr (write_addr[ENTRY_ADDR-1:0]),      
    .we (we),

    .write_clk (write_clk)
);
endmodule

module vn_f0_mem_share_high_bank #(
	parameter PARALLELISM = 2,
	parameter QUAN_SIZE = 3,
	parameter ENTRY_ADDR = 5
) (
    output wire [QUAN_SIZE-1:0] lut_data0,
    output wire [QUAN_SIZE-1:0] lut_data1,

    input wire [ENTRY_ADDR-1:0] read_addr0,
    input wire [ENTRY_ADDR-1:0] read_addr1,
 
    input wire [QUAN_SIZE-1:0] lut_in,
    input wire [ENTRY_ADDR-1:0] write_addr,      
    input wire we,

    input wire write_clk
);

	wire [QUAN_SIZE-1:0] lut_data_port [0:PARALLELISM-1];
	wire [ENTRY_ADDR-1:0] read_addr_port [0:PARALLELISM-1];
	genvar i;
	generate
	  for(i=0;i<PARALLELISM;i=i+1) begin : parallel_bank_inst
	    // RAM32X1S: 32 x 1 posedge write distributed (LUT) RAM (Mapped to a LUT6)
	    //           Kintex UltraScale+
	    // Xilinx HDL Language Template, version 2019.2
	    RAM32X1S #(
	       .INIT(32'h00000000),    // Initial contents of RAM
	       .IS_WCLK_INVERTED(1'b0) // Specifies active high/low WCLK
	    ) RAM32X1S_inst_msb_port03 (
	       .O(lut_data_port[i][2]),       // RAM output
	       .A0(read_addr_port[i][0]),     // RAM address[0] input
	       .A1(read_addr_port[i][1]),     // RAM address[1] input
	       .A2(read_addr_port[i][2]),     // RAM address[2] input
	       .A3(read_addr_port[i][3]),     // RAM address[3] input
	       .A4(read_addr_port[i][4]),     // RAM address[4] input
	       .D(lut_in[2]),       // RAM data input
	       .WCLK(write_clk), // Write clock input
	       .WE(we)      // Write enable input
	    );

	    // RAM32X2S: 32 x 2 posedge write distributed (LUT) RAM (Mapped to a SliceM LUT6)
	    //           Kintex-7
	    // Xilinx HDL Language Template, version 2019.2
	    RAM32X2S #(
	       .INIT_00(32'h00000000), // INIT for bit 0 of RAM
	       .INIT_01(32'h00000000)  // INIT for bit 1 of RAM
	    ) RAM32X2S_inst_magnitude_port03 (
	       .O0(lut_data_port[i][0]),     // RAM data[0] output
	       .O1(lut_data_port[i][1]),     // RAM data[1] output
	       .A0(read_addr_port[i][0]),     // RAM address[0] input
	       .A1(read_addr_port[i][1]),     // RAM address[1] input
	       .A2(read_addr_port[i][2]),     // RAM address[2] input
	       .A3(read_addr_port[i][3]),     // RAM address[3] input
	       .A4(read_addr_port[i][4]),     // RAM address[4] input
	       .D0(lut_in[0]),     // RAM data[0] input
	       .D1(lut_in[1]),     // RAM data[1] input
	       .WCLK(write_clk), // Write clock input
	       .WE(we)      // Write enable input
	    );
	  end
	endgenerate

	assign lut_data0[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[0];
	assign lut_data1[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[1];
	assign read_addr_port[0] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr0[ENTRY_ADDR-1:0];
	assign read_addr_port[1] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr1[ENTRY_ADDR-1:0];
endmodule

module vn_f0_mem_share_low_bank #(
	parameter PARALLELISM = 1,
	parameter QUAN_SIZE = 3,
	parameter ENTRY_ADDR = 5
) (
    output wire [QUAN_SIZE-1:0] lut_data0,
         
    input wire [ENTRY_ADDR-1:0] read_addr0,
    
    input wire [QUAN_SIZE-1:0] lut_in,
    input wire [ENTRY_ADDR-1:0] write_addr,
 	input wire we,

    input wire write_clk
);

	wire [QUAN_SIZE-1:0] lut_data_port [0:PARALLELISM-1];
	wire [ENTRY_ADDR-1:0] read_addr_port [0:PARALLELISM-1];
	genvar i;
	generate
	  for(i=0;i<PARALLELISM;i=i+1) begin : parallel_bank_inst
	    // RAM32X1S: 32 x 1 posedge write distributed (LUT) RAM (Mapped to a LUT6)
	    //           Kintex UltraScale+
	    // Xilinx HDL Language Template, version 2019.2
	    RAM32X1S #(
	       .INIT(32'h00000000),    // Initial contents of RAM
	       .IS_WCLK_INVERTED(1'b0) // Specifies active high/low WCLK
	    ) RAM32X1S_inst_msb_port03 (
	       .O(lut_data_port[i][2]),       // RAM output
	       .A0(read_addr_port[i][0]),     // RAM address[0] input
	       .A1(read_addr_port[i][1]),     // RAM address[1] input
	       .A2(read_addr_port[i][2]),     // RAM address[2] input
	       .A3(read_addr_port[i][3]),     // RAM address[3] input
	       .A4(read_addr_port[i][4]),     // RAM address[4] input
	       .D(lut_in[2]),       // RAM data input
	       .WCLK(write_clk), // Write clock input
	       .WE(we)      // Write enable input
	    );

	    // RAM32X2S: 32 x 2 posedge write distributed (LUT) RAM (Mapped to a SliceM LUT6)
	    //           Kintex-7
	    // Xilinx HDL Language Template, version 2019.2
	    RAM32X2S #(
	       .INIT_00(32'h00000000), // INIT for bit 0 of RAM
	       .INIT_01(32'h00000000)  // INIT for bit 1 of RAM
	    ) RAM32X2S_inst_magnitude_port03 (
	       .O0(lut_data_port[i][0]),     // RAM data[0] output
	       .O1(lut_data_port[i][1]),     // RAM data[1] output
	       .A0(read_addr_port[i][0]),     // RAM address[0] input
	       .A1(read_addr_port[i][1]),     // RAM address[1] input
	       .A2(read_addr_port[i][2]),     // RAM address[2] input
	       .A3(read_addr_port[i][3]),     // RAM address[3] input
	       .A4(read_addr_port[i][4]),     // RAM address[4] input
	       .D0(lut_in[0]),     // RAM data[0] input
	       .D1(lut_in[1]),     // RAM data[1] input
	       .WCLK(write_clk), // Write clock input
	       .WE(we)      // Write enable input
	    );
	  end
	endgenerate
	assign lut_data0[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[0];
	assign read_addr_port[0] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr0[ENTRY_ADDR-1:0];
endmodule

module vn_f1_mem_share_high_bank #(
	parameter PARALLELISM = 6,
	parameter QUAN_SIZE = 3,
	parameter ENTRY_ADDR = 5
) (
    output wire [QUAN_SIZE-1:0] lut_data0,
    output wire [QUAN_SIZE-1:0] lut_data1,
    output wire [QUAN_SIZE-1:0] lut_data2,
    output wire [QUAN_SIZE-1:0] lut_data3,
    output wire [QUAN_SIZE-1:0] lut_data4,
    output wire [QUAN_SIZE-1:0] lut_data5,

    input wire [ENTRY_ADDR-1:0] read_addr0,
    input wire [ENTRY_ADDR-1:0] read_addr1,
    input wire [ENTRY_ADDR-1:0] read_addr2,
    input wire [ENTRY_ADDR-1:0] read_addr3,
    input wire [ENTRY_ADDR-1:0] read_addr4,
    input wire [ENTRY_ADDR-1:0] read_addr5,
 
    input wire [QUAN_SIZE-1:0] lut_in,
    input wire [ENTRY_ADDR-1:0] write_addr,      
    input wire we,

    input wire write_clk
);

	wire [QUAN_SIZE-1:0] lut_data_port [0:PARALLELISM-1];
	wire [ENTRY_ADDR-1:0] read_addr_port [0:PARALLELISM-1];
	genvar i;
	generate
	  for(i=0;i<PARALLELISM;i=i+1) begin : parallel_bank_inst
	    // RAM32X1S: 32 x 1 posedge write distributed (LUT) RAM (Mapped to a LUT6)
	    //           Kintex UltraScale+
	    // Xilinx HDL Language Template, version 2019.2
	    RAM32X1S #(
	       .INIT(32'h00000000),    // Initial contents of RAM
	       .IS_WCLK_INVERTED(1'b0) // Specifies active high/low WCLK
	    ) RAM32X1S_inst_msb_port03 (
	       .O(lut_data_port[i][2]),       // RAM output
	       .A0(read_addr_port[i][0]),     // RAM address[0] input
	       .A1(read_addr_port[i][1]),     // RAM address[1] input
	       .A2(read_addr_port[i][2]),     // RAM address[2] input
	       .A3(read_addr_port[i][3]),     // RAM address[3] input
	       .A4(read_addr_port[i][4]),     // RAM address[4] input
	       .D(lut_in[2]),       // RAM data input
	       .WCLK(write_clk), // Write clock input
	       .WE(we)      // Write enable input
	    );

	    // RAM32X2S: 32 x 2 posedge write distributed (LUT) RAM (Mapped to a SliceM LUT6)
	    //           Kintex-7
	    // Xilinx HDL Language Template, version 2019.2
	    RAM32X2S #(
	       .INIT_00(32'h00000000), // INIT for bit 0 of RAM
	       .INIT_01(32'h00000000)  // INIT for bit 1 of RAM
	    ) RAM32X2S_inst_magnitude_port03 (
	       .O0(lut_data_port[i][0]),     // RAM data[0] output
	       .O1(lut_data_port[i][1]),     // RAM data[1] output
	       .A0(read_addr_port[i][0]),     // RAM address[0] input
	       .A1(read_addr_port[i][1]),     // RAM address[1] input
	       .A2(read_addr_port[i][2]),     // RAM address[2] input
	       .A3(read_addr_port[i][3]),     // RAM address[3] input
	       .A4(read_addr_port[i][4]),     // RAM address[4] input
	       .D0(lut_in[0]),     // RAM data[0] input
	       .D1(lut_in[1]),     // RAM data[1] input
	       .WCLK(write_clk), // Write clock input
	       .WE(we)      // Write enable input
	    );
	  end
	endgenerate

	assign lut_data0[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[0];
	assign lut_data1[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[1];
	assign lut_data2[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[2];
	assign lut_data3[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[3];
	assign lut_data4[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[4];
	assign lut_data5[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[5];
	assign read_addr_port[0] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr0[ENTRY_ADDR-1:0];
	assign read_addr_port[1] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr1[ENTRY_ADDR-1:0];
	assign read_addr_port[2] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr2[ENTRY_ADDR-1:0];
	assign read_addr_port[3] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr3[ENTRY_ADDR-1:0];
	assign read_addr_port[4] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr4[ENTRY_ADDR-1:0];
	assign read_addr_port[5] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr5[ENTRY_ADDR-1:0];
endmodule

module vn_f1_mem_share_low_bank #(
	parameter PARALLELISM = 3,
	parameter QUAN_SIZE = 3,
	parameter ENTRY_ADDR = 5
) (
    output wire [QUAN_SIZE-1:0] lut_data0,
    output wire [QUAN_SIZE-1:0] lut_data1,
    output wire [QUAN_SIZE-1:0] lut_data2,
         
    input wire [ENTRY_ADDR-1:0] read_addr0,
    input wire [ENTRY_ADDR-1:0] read_addr1,
    input wire [ENTRY_ADDR-1:0] read_addr2,
    
    input wire [QUAN_SIZE-1:0] lut_in,
    input wire [ENTRY_ADDR-1:0] write_addr,
 	input wire we,

    input wire write_clk
);

	wire [QUAN_SIZE-1:0] lut_data_port [0:PARALLELISM-1];
	wire [ENTRY_ADDR-1:0] read_addr_port [0:PARALLELISM-1];
	genvar i;
	generate
	  for(i=0;i<PARALLELISM;i=i+1) begin : parallel_bank_inst
	    // RAM32X1S: 32 x 1 posedge write distributed (LUT) RAM (Mapped to a LUT6)
	    //           Kintex UltraScale+
	    // Xilinx HDL Language Template, version 2019.2
	    RAM32X1S #(
	       .INIT(32'h00000000),    // Initial contents of RAM
	       .IS_WCLK_INVERTED(1'b0) // Specifies active high/low WCLK
	    ) RAM32X1S_inst_msb_port03 (
	       .O(lut_data_port[i][2]),       // RAM output
	       .A0(read_addr_port[i][0]),     // RAM address[0] input
	       .A1(read_addr_port[i][1]),     // RAM address[1] input
	       .A2(read_addr_port[i][2]),     // RAM address[2] input
	       .A3(read_addr_port[i][3]),     // RAM address[3] input
	       .A4(read_addr_port[i][4]),     // RAM address[4] input
	       .D(lut_in[2]),       // RAM data input
	       .WCLK(write_clk), // Write clock input
	       .WE(we)      // Write enable input
	    );

	    // RAM32X2S: 32 x 2 posedge write distributed (LUT) RAM (Mapped to a SliceM LUT6)
	    //           Kintex-7
	    // Xilinx HDL Language Template, version 2019.2
	    RAM32X2S #(
	       .INIT_00(32'h00000000), // INIT for bit 0 of RAM
	       .INIT_01(32'h00000000)  // INIT for bit 1 of RAM
	    ) RAM32X2S_inst_magnitude_port03 (
	       .O0(lut_data_port[i][0]),     // RAM data[0] output
	       .O1(lut_data_port[i][1]),     // RAM data[1] output
	       .A0(read_addr_port[i][0]),     // RAM address[0] input
	       .A1(read_addr_port[i][1]),     // RAM address[1] input
	       .A2(read_addr_port[i][2]),     // RAM address[2] input
	       .A3(read_addr_port[i][3]),     // RAM address[3] input
	       .A4(read_addr_port[i][4]),     // RAM address[4] input
	       .D0(lut_in[0]),     // RAM data[0] input
	       .D1(lut_in[1]),     // RAM data[1] input
	       .WCLK(write_clk), // Write clock input
	       .WE(we)      // Write enable input
	    );
	  end
	endgenerate
	assign lut_data0[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[0];
	assign lut_data1[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[1];
	assign lut_data2[QUAN_SIZE-1:0] = (we == 1'b1) ? {QUAN_SIZE{1'bz}} : lut_data_port[2];
	assign read_addr_port[0] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr0[ENTRY_ADDR-1:0];
	assign read_addr_port[1] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr1[ENTRY_ADDR-1:0];
	assign read_addr_port[2] = (we == 1'b1) ? write_addr[ENTRY_ADDR-1:0] : read_addr2[ENTRY_ADDR-1:0];
endmodule

`endif



//  RAM64X1S   : In order to incorporate this function into the design,
//   Verilog   : the following instance declaration needs to be placed
//  instance   : in the body of the design code.  The instance name
// declaration : (RAM64X1S_inst) and/or the port declarations within the
//    code     : parenthesis may be changed to properly reference and
//             : connect this function to the design.  All inputs
//             : and outputs must be connected.

//  <-----Cut code below this line---->

   // RAM64X1S: 64 x 1 positive edge write, asynchronous read single-port
   //           distributed RAM (Mapped to a LUT6)
   //           Kintex UltraScale+
   // Xilinx HDL Language Template, version 2018.3

   RAM64X1S #(
      .INIT(64'h0000000000000000), // Initial contents of RAM
      .IS_WCLK_INVERTED(1'b0)      // Specifies active high/low WCLK
   ) RAM64X1S_inst (
      .O(O),        // 1-bit data output
      .A0(A0),      // Address[0] input bit
      .A1(A1),      // Address[1] input bit
      .A2(A2),      // Address[2] input bit
      .A3(A3),      // Address[3] input bit
      .A4(A4),      // Address[4] input bit
      .A5(A5),      // Address[5] input bit
      .D(D),        // 1-bit data input
      .WCLK(WCLK),  // Write clock input
      .WE(WE)       // Write enable input
   );

   // End of RAM64X1S_inst instantiation