/**
* Created date: 23 October, 2022
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: msgPass2pageAlignIF
* 
* # I/F
* 1) Output:
* 2) Input:
* 
* # Param
* 
* # Description
* It consists of three modules:
*	a) 2nd-level circular shifter
*	b) three-input multiplexer
*   c) Data bus combiner
*
* # Dependencies
* 	1) devine.vh -> quantisatin bit with of messages
**/
`include "define.vh"

/**
* Created date: 26 Novemeber, 2022
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: msgPass2pageAlignIF
* 
* # I/F
* 1) Output:
* 2) Input:
* 
* # Param
* 
* # Description
* It consists of three modules:
*	a) 2nd-level circular shifter
*
* # Dependencies
* 	1) devine.vh -> quantisatin bit with of messages
**/
`include "define.vh"

module msgPass2pageAlignIF #(
	parameter SHIFT_LENGTH = 5,
	parameter QUAN_SIZE = 4,
	parameter L2PA_ENABLE = 1, // 0: dummay L2PA operation equivalent to all-zero load_en
	parameter MAX_MEMSHARE_INSTANCES = 3
) (
	// Output
	output wire [SHIFT_LENGTH-1:0] msgPass2paOut_bit0_o,
	output wire [SHIFT_LENGTH-1:0] msgPass2paOut_bit1_o,
	output wire [SHIFT_LENGTH-1:0] msgPass2paOut_bit2_o,

	// Input
	// From the level-1 msgPass output
	input wire [SHIFT_LENGTH-1:0] swIn_bit0_i,
	input wire [SHIFT_LENGTH-1:0] swIn_bit1_i,
	input wire [SHIFT_LENGTH-1:0] swIn_bit2_i,

`ifdef DECODER_4bit
	output wire [SHIFT_LENGTH-1:0] msgPass2paOut_bit3_o,
	input wire [SHIFT_LENGTH-1:0] swIn_bit3_i,
`endif
	// Control signals
	input wire [$clog2(SHIFT_LENGTH)-1:0] L1_paShift_factor_i,
	input wire [SHIFT_LENGTH-1:0] L2_paLoad_factor_i,
	// Layer status control
	input wire is_preV2CPerm_i, //! Current L2PA usage is for preprocessing V2C permutation
	
	input wire sys_clk,
	input wire rstn
);

//--------------------------
// Level-1 page alignment
// or called Level-2 permutation
//--------------------------
wire [SHIFT_LENGTH-1:0] sw_in_bit[0:QUAN_SIZE-1];
wire [SHIFT_LENGTH-1:0] sw_out_bit [0:QUAN_SIZE-1];
qsn_wrapper_len5_pipe0_q4 l1pa (
	.sw_out_bit0 (sw_out_bit[0]),
	.sw_out_bit1 (sw_out_bit[1]),	
	.sw_out_bit2 (sw_out_bit[2]),
`ifdef DECODER_4bit	
	.sw_out_bit3 (sw_out_bit[3]),
`endif

	.sw_in_bit0  (sw_in_bit[0]),
	.sw_in_bit1  (sw_in_bit[1]),
	.sw_in_bit2  (sw_in_bit[2]),
	`ifdef DECODER_4bit
		.sw_in_bit3  (sw_in_bit[3]),
	`endif
	.shift_factor (L1_paShift_factor_i), // offset shift factor of submatrix_1
	.sys_clk (sys_clk),
	.rstn (rstn)
);

// Stride unit 0~(`QUAN_SIZE-1)
// Nets as input sources to circular shifters
assign sw_in_bit[0] = swIn_bit0_i[SHIFT_LENGTH-1:0];
assign sw_in_bit[1] = swIn_bit1_i[SHIFT_LENGTH-1:0];
assign sw_in_bit[2] = swIn_bit2_i[SHIFT_LENGTH-1:0];
`ifdef DECODER_4bit
	assign sw_in_bit[3] = swIn_bit3_i[SHIFT_LENGTH-1:0];
`endif
//--------------------------
// Level-2 page alignment
//--------------------------
generate;
	if(L2PA_ENABLE == 1) begin: l2pa_logic
		l2pa_logic #(
		  .SHIFT_LENGTH (SHIFT_LENGTH),
		  .QUAN_SIZE (QUAN_SIZE),
		  .MAX_MEMSHARE_INSTANCES (MAX_MEMSHARE_INSTANCES)
		) l2pa (
		  .l2paOut_bit2_o (msgPass2paOut_bit2_o[SHIFT_LENGTH-1:0]),
		  .l2paOut_bit1_o (msgPass2paOut_bit1_o[SHIFT_LENGTH-1:0]),
		  .l2paOut_bit0_o (msgPass2paOut_bit0_o[SHIFT_LENGTH-1:0]),
		`ifdef DECODER_4bit
		  .l2paOut_bit3_o (msgPass2paOut_bit3_o[SHIFT_LENGTH-1:0]),
		`endif // DECODER_4bit
		  .l1paOut_bit2_i (sw_out_bit[2]),
		  .l1paOut_bit1_i (sw_out_bit[1]),
		  .l1paOut_bit0_i (sw_out_bit[0]),
		`ifdef DECODER_4bit
		  .l1paOut_bit3_i (sw_out_bit[3]),
		`endif // DECODER_4bit
		  .is_preV2CPerm_i (is_preV2CPerm_i),
		  .shiftROM_load_en_i (L2_paLoad_factor_i[SHIFT_LENGTH-1:0]),
		  .rstn (rstn),
		  .sys_clk  (sys_clk)
		);
	end
else begin: l2pa_dummy // L2PA_ENABLE == 0
		l2pa_dummy #(
			.SHIFT_LENGTH (SHIFT_LENGTH),
			.QUAN_SIZE (QUAN_SIZE)
		  ) l2pa (
			.l2paOut_bit2_o (msgPass2paOut_bit2_o[SHIFT_LENGTH-1:0]),
			.l2paOut_bit1_o (msgPass2paOut_bit1_o[SHIFT_LENGTH-1:0]),
			.l2paOut_bit0_o (msgPass2paOut_bit0_o[SHIFT_LENGTH-1:0]),
		  `ifdef DECODER_4bit
			.l2paOut_bit3_o (msgPass2paOut_bit3_o[SHIFT_LENGTH-1:0]),
		  `endif // DECODER_4bit
			.l1paOut_bit2_i (sw_out_bit[2]),
			.l1paOut_bit1_i (sw_out_bit[1]),
			.l1paOut_bit0_i (sw_out_bit[0]),
		  `ifdef DECODER_4bit
			.l1paOut_bit3_i (sw_out_bit[3]),
		  `endif // DECODER_4bit
			.is_preV2CPerm_i (is_preV2CPerm_i),
			.shiftROM_load_en_i (L2_paLoad_factor_i[SHIFT_LENGTH-1:0]),
			.rstn (rstn),
			.sys_clk  (sys_clk)
		  );
	end
endgenerate
endmodule