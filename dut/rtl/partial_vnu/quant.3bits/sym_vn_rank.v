module sym_vn_rank (
	output wire [2:0] lut_data0,   
	output wire [2:0] lut_data1,   

	// For VNU0
	input wire [4:0] page_addr_0,

	// For VNU1
	input wire [4:0] page_addr_1,
	
	input wire [2:0] lut_in_bank0_replicate_0, // update data in  
	input wire [4:0] page_write_addr_replicate_0,

	input wire [2:0] lut_in_bank0_replicate_1, // update data in  
	input wire [4:0] page_write_addr_replicate_1,

   	input wire we,
	input wire write_clk
);

	wire [2:0] bank0_out0;
	wire [2:0] bank0_out1;
	assign lut_data0[2:0] = bank0_out0[2:0];
	assign lut_data1[2:0] = bank0_out1[2:0];

 sym_vn_lut bank0(
	.lut_data0 (bank0_out0[2:0]),
	.lut_data1 (bank0_out1[2:0]),
 
	// Write data and page address
	.lut_in_replicate_0 (lut_in_bank0_replicate_0[2:0]),
	.write_addr_replicate_0 ({page_write_addr_replicate_0[4:0]}),

	.lut_in_replicate_1 (lut_in_bank0_replicate_1[2:0]),
	.write_addr_replicate_1 ({page_write_addr_replicate_1[4:0]}),
        
	// Read page address and address offset
	.read_addr0 ({page_addr_0[4:0]}),
	.read_addr1 ({page_addr_1[4:0]}),
    
	.we (we),
	.write_clk (write_clk)
 );
endmodule