module sym_dn_rank (
	output wire lut_data0,   
	output wire lut_data1,   

	// For DNU0
	input wire [4:0] page_addr_0,

	// For DNU1
	input wire [4:0] page_addr_1,
	
	input wire lut_in_bank0_replicate_0, // update data in  
	input wire [4:0] page_write_addr_replicate_0,

	input wire lut_in_bank0_replicate_1, // update data in  
	input wire [4:0] page_write_addr_replicate_1,

   	input wire we,
	input wire write_clk
);

	wire bank0_out0;
	wire bank0_out1;
	assign lut_data0 = bank0_out0;
	assign lut_data1 = bank0_out1;

 sym_dn_lut bank0(
	.lut_data0 (bank0_out0),
	.lut_data1 (bank0_out1),
 
	// Write data and page address
	.lut_in_replicate_0 (lut_in_bank0_replicate_0),
	.write_addr_replicate_0 ({page_write_addr_replicate_0[4:0]}),
 
 	.lut_in_replicate_1 (lut_in_bank0_replicate_1),
	.write_addr_replicate_1 ({page_write_addr_replicate_1[4:0]}),
 
	// Read page address and address offset
	.read_addr0 ({page_addr_0[4:0]}),
	.read_addr1 ({page_addr_1[4:0]}),
    
	.we (we),
	.write_clk (write_clk)
 );
endmodule