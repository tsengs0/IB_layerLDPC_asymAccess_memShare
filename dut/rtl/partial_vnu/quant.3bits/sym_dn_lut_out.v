`include "revision_def.vh"
module sym_dn_lut_out (
	// For read operation
	// Port A
	output `ifdef SYM_NO_IO_CONV reg `else wire `endif t_c_A,
	input wire transpose_en_inA,
	input wire [2:0] y0_in_A,
	input wire [2:0] y1_in_A,

	// Port B
	output `ifdef SYM_NO_IO_CONV reg `else wire `endif t_c_B,
	input wire transpose_en_inB,
	input wire [2:0] y0_in_B,
	input wire [2:0] y1_in_B,

	//output wire read_addr_offset_out,
	input wire read_addr_offset,
	input wire read_clk,
//////////////////////////////////////////////////////////
	// For write operation
	input wire lut_in_bank0_replicate_0, // input data
	input wire [4:0] page_write_addr_replicate_0, // write address
	/*deprecated*/input wire write_addr_offset_replicate_0, // write address offset

	input wire lut_in_bank0_replicate_1, // input data
	input wire [4:0] page_write_addr_replicate_1, // write address
	/*deprecated*/input wire write_addr_offset_replicate_1, // write address offset

	input wire we,
	input wire write_clk
);
`ifdef SYM_VN_REV_1
	// Input port of Read Port A to D
	wire [2:0] y0_mux_A, y1_mux_A;
	assign y0_mux_A[1:0] = y0_in_A[1:0];
	xor transpose_y02A(y0_mux_A[2], transpose_en_inA, y0_in_A[2]);
	assign y1_mux_A[2:0] = (y0_mux_A[2] == 1'b1) ? ~y1_in_A[2:0] : y1_in_A[2:0];

	wire [2:0] y0_mux_B, y1_mux_B;
	assign y0_mux_B[1:0] = y0_in_B[1:0];
	xor transpose_y02B(y0_mux_B[2], transpose_en_inB, y0_in_B[2]);
	assign y1_mux_B[2:0] = (y0_mux_B[2] == 1'b1) ? ~y1_in_B[2:0] : y1_in_B[2:0];
`elsif SYM_NO_IO_CONV
	// Input port of Read Port A to D
	wire [2:0] y0_mux_A, y1_mux_A;
	wire dnu_sel_A;
	//assign y0_mux_A[3] = y0_in_A[3]^transpose_en_inA;
	assign y0_mux_A[1:0] = {~y0_in_A[1], ~y0_in_A[0]};
	assign dnu_sel_A = y0_in_A[2];
	assign y1_mux_A[2] = dnu_sel_A^y1_in_A[2];
	assign y1_mux_A[1:0] = y1_in_A[1:0];

	wire [2:0] y0_mux_B, y1_mux_B;
	wire dnu_sel_B;
	//assign y0_mux_B[2] = y0_in_B[2]^transpose_en_inB;
	assign y0_mux_B[1:0] = {~y0_in_B[1], ~y0_in_B[0]};
	assign dnu_sel_B = y0_in_B[2];
	assign y1_mux_B[2] = dnu_sel_B^y1_in_B[2];
	assign y1_mux_B[1:0] = y1_in_B[1:0];

	wire msb_A, msb_B;
	assign msb_A = dnu_sel_A;
	assign msb_B = dnu_sel_B;
`else
	// Input port of Read Port A to D
	wire [2:0] y0_mux_A, y1_mux_A;
	xor transpose_y01A(y0_mux_A[1], y0_in_A[1], y0_in_A[2]);
	xor transpose_y00A(y0_mux_A[0], y0_in_A[0], y0_in_A[2]);
	xor transpose_y02A(y0_mux_A[2], transpose_en_inA, y0_in_A[2]);
	assign y1_mux_A[2:0] = (y0_mux_A[2] == 1'b1) ? ~y1_in_A[2:0] : y1_in_A[2:0];

	wire [2:0] y0_mux_B, y1_mux_B;
	xor transpose_y01B(y0_mux_B[1], y0_in_B[1], y0_in_B[2]);
	xor transpose_y00B(y0_mux_B[0], y0_in_B[0], y0_in_B[2]);
	xor transpose_y02B(y0_mux_B[2], transpose_en_inB, y0_in_B[2]);
	assign y1_mux_B[2:0] = (y0_mux_B[2] == 1'b1) ? ~y1_in_B[2:0] : y1_in_B[2:0];
`endif
/////////////////////////B//////////////////////////////////////////////////////////////////
	// Pipeline Stage 0
	reg [1:0] y0_pipe0_A, y0_pipe0_B;
	reg [2:0] y1_pipe0_A, y1_pipe0_B;
	reg msb_pipe0_A, msb_pipe0_B;
	reg read_addr_offset_pipe0;
	initial begin
		y0_pipe0_A[1:0] <= 0;
		y0_pipe0_B[1:0] <= 0;
		y1_pipe0_A[2:0] <= 0;
		y1_pipe0_B[2:0] <= 0;
		read_addr_offset_pipe0 <= 0;
		msb_pipe0_A <= 0;
		msb_pipe0_B <= 0;
	end
	always @(posedge read_clk) begin
		y0_pipe0_A[1:0] <= y0_mux_A[1:0];
		y0_pipe0_B[1:0] <= y0_mux_B[1:0];
		y1_pipe0_A[2:0] <= y1_mux_A[2:0];
		y1_pipe0_B[2:0] <= y1_mux_B[2:0];
	end
	always @(posedge read_clk) begin
		msb_pipe0_A <= msb_A;
		msb_pipe0_B <= msb_B;
	end
	always @(posedge read_clk) read_addr_offset_pipe0 <= read_addr_offset;
////////////////////////////////////////////////////////////////////////////////////////////
	// Pipeline Stage 1
	wire [4:0] page_addr_pipe0_A, page_addr_pipe0_B;
	vn_addr_bus addr_bus(
		// For port A (output)
		.page_addr_A (page_addr_pipe0_A[4:0]),

		// For port B (output)
		.page_addr_B (page_addr_pipe0_B[4:0]),
		
		// For port A (input, two coreesponding incoming messages)
		.y0_in_A (y0_pipe0_A[1:0]),
		.y1_in_A (y1_pipe0_A[2:0]),
		// For port B (input, two coreesponding incoming messages)
		.y0_in_B (y0_pipe0_B[1:0]),
		.y1_in_B (y1_pipe0_B[2:0])
	);		
	
	wire OutA, OutB;
	reg OutA_pipe1, OutB_pipe1;
	reg msb_pipe1_A, msb_pipe1_B;
	//reg read_addr_offset_pipe1;
	sym_dn_rank rank_m(
		// For read operation
	   .lut_data0    (OutA),   
	   .lut_data1    (OutB),   

	   // For VNU0
	   .page_addr_0        (page_addr_pipe0_A[4:0]),

	   // For VNU1
	   .page_addr_1        (page_addr_pipe0_B[4:0]),
	   /////////////////////////////////////////////////////////////////////
	   // For write operation
	   .lut_in_bank0_replicate_0 (lut_in_bank0_replicate_0), // update data in  
	   .page_write_addr_replicate_0   (page_write_addr_replicate_0[4:0]),

	   .lut_in_bank0_replicate_1 (lut_in_bank0_replicate_1), // update data in  
	   .page_write_addr_replicate_1   (page_write_addr_replicate_1[4:0]),

   	   .we (we),
	   .write_clk (write_clk)
	);

	initial begin
		OutA_pipe1  <= 0;
		OutB_pipe1  <= 0;
		msb_pipe1_A <= 0;
		msb_pipe1_B <= 0;
		//read_addr_offset_pipe1 <= 0;
	end
	always @(posedge read_clk) OutA_pipe1 <= OutA;
	always @(posedge read_clk) OutB_pipe1 <= OutB;
	always @(posedge read_clk) begin
		msb_pipe1_A <= msb_pipe0_A;
		msb_pipe1_B <= msb_pipe0_B;
	end
	//always @(posedge read_clk) read_addr_offset_pipe1 <= read_addr_offset_pipe0;
////////////////////////////////////////////////////////////////////////////////////////////
	// Pipeline Stage 2
`ifdef SYM_NO_IO_CONV
	always @(posedge read_clk) t_c_A <= OutA_pipe1^msb_pipe1_A;
	always @(posedge read_clk) t_c_B <= OutB_pipe1^msb_pipe1_B;
`else
	xor hard_decision_portA (t_c_A, OutA_pipe1, msb_pipe1_A);
	xor hard_decision_portB (t_c_B, OutB_pipe1, msb_pipe1_B);
`endif
	//assign read_addr_offset_out = read_addr_offset_pipe1;
endmodule