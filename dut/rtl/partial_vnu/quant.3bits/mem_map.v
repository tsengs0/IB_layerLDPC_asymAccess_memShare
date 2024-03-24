`timescale 1ns / 1ps
// Description: 
// To decode the address mapping scheme in a bank-interleaving fashion
// 1) page address: 6-bit, i.e., depth of 64 per device
// 2) bank address: 1-bit, i.e., two interleaving banks
module vn_addr_map (
    output wire [4:0] page_addr,
	
    input wire [1:0] y0,
    input wire [2:0] y1
    );
	
	assign page_addr[3:0] = {y0[1:0], y1[2:0]};
endmodule

// Description:
// Concatenation of page and bank address bus for a multiple-port decomposed LUT
module vn_addr_bus (
	// For port A (output)
    output wire [4:0] page_addr_A,

	// For port B (output)
    output wire [4:0] page_addr_B,

	// For port A (input, two coreesponding incoming messages)
    input wire [1:0] y0_in_A,
    input wire [2:0] y1_in_A,
	// For port B (input, two coreesponding incoming messages)
    input wire [1:0] y0_in_B,
    input wire [2:0] y1_in_B
	);
	
	vn_addr_map vn_map_u0(
		.page_addr (page_addr_A[4:0]),
		
		.y0 (y0_in_A[1:0]),
		.y1 (y1_in_A[2:0])
	);
	vn_addr_map vn_map_u1(
		.page_addr (page_addr_B[4:0]),
		
		.y0 (y0_in_B[1:0]),
		.y1 (y1_in_B[2:0])
	);
endmodule