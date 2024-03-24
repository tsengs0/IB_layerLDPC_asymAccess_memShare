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

//`define MSGPASS_SOL_1
`define MSGPASS_SOL_3

`ifdef MSGPASS_SOL_1
module msgPass2pageAlignIF #(
	parameter SHIFT_LENGTH = 3,
	parameter QUAN_SIZE = 4,
	parameter L1_PA_MUX_SEL_WIDTH = 2
) (
	// Output
	output wire [SHIFT_LENGTH-1:0] msgPass2paOut_bit0_o,
	output wire [SHIFT_LENGTH-1:0] msgPass2paOut_bit1_o,
	output wire [SHIFT_LENGTH-1:0] msgPass2paOut_bit2_o,

	// To the Extrinsic mesg RAM for level-1 page alignment later
	output wire [SHIFT_LENGTH-1:0] L1_paOut_bit0_i,
	output wire [SHIFT_LENGTH-1:0] L1_paOut_bit1_i,
	output wire [SHIFT_LENGTH-1:0] L1_paOut_bit2_i,

	// Input
	// From the level-1 msgPass output
	input wire [SHIFT_LENGTH-1:0] swIn_bit0_i,
	input wire [SHIFT_LENGTH-1:0] swIn_bit1_i,
	input wire [SHIFT_LENGTH-1:0] swIn_bit2_i,

	// From the Extrinsic mesg RAM
	input wire [SHIFT_LENGTH-1:0] memSrcIn_bit0_i,
	input wire [SHIFT_LENGTH-1:0] memSrcIn_bit1_i,
	input wire [SHIFT_LENGTH-1:0] memSrcIn_bit2_i,

`ifdef DECODER_4bit
	output wire [SHIFT_LENGTH-1:0] msgPass2paOut_bit3_o,
	output wire [SHIFT_LENGTH-1:0] L1_paOut_bit3_i,
	input wire [SHIFT_LENGTH-1:0] swIn_bit3_i,
	input wire [SHIFT_LENGTH-1:0] memSrcIn_bit3_i,
`endif
	// Control signals
	input wire [$clog2(SHIFT_LENGTH)-1:0] L1_paShift_factor_i,
	input wire [(SHIFT_LENGTH*L1_PA_MUX_SEL_WIDTH)-1:0] L1_paSel_i,
	input wire [SHIFT_LENGTH-1:0] L2_dataCombiner_pattern_i,
	input wire sys_clk,
	input wire rstn
);

localparam LEFT_SEL_WIDTH = $clog2(SHIFT_LENGTH);
localparam RIGHT_SEL_WIDTH = $clog2(SHIFT_LENGTH);

//--------------------------
// Net and reg declarations
//--------------------------
wire [SHIFT_LENGTH-1:0] sw_in_bit[0:QUAN_SIZE-1];
wire [SHIFT_LENGTH-1:0] sw_out_bit [0:QUAN_SIZE-1];

wire [LEFT_SEL_WIDTH-1:0]  left_sel;
wire [RIGHT_SEL_WIDTH-1:0]  right_sel;
wire [SHIFT_LENGTH-2:0] merge_sel;
qsn_top_len3 vnu_qsn_top_len3_u0 (
	.sw_out_bit0 (sw_out_bit[0]),
	.sw_out_bit1 (sw_out_bit[1]),	
	.sw_out_bit2 (sw_out_bit[2]),
`ifdef DECODER_4bit	
	.sw_out_bit3 (sw_out_bit[3]),
`endif

	.sys_clk     (sys_clk),
	.rstn		 (rstn),

	.sw_in_bit0  (sw_in_bit[0]),
	.sw_in_bit1  (sw_in_bit[1]),
	.sw_in_bit2  (sw_in_bit[2]),
	`ifdef DECODER_4bit
		.sw_in_bit3  (sw_in_bit[3]),
	`endif

	.left_sel    (left_sel),
	.right_sel   (right_sel),
	.merge_sel   (merge_sel)
);
		
qsn_controller_len3 #(
	.PERMUTATION_LENGTH(SHIFT_LENGTH)
) vnu_qsn_controller_len3_u0 (
	.left_sel     (left_sel ),
	.right_sel    (right_sel),
	.merge_sel    (merge_sel),
	.shift_factor (L1_paShift_factor_i) // offset shift factor of submatrix_1
	//.rstn         (rstn),
	//.sys_clk      (sys_clk)
);

// Level-1 page alignment
wire [SHIFT_LENGTH-1:0] L1_paOut_bit [0:QUAN_SIZE-1];
generate
	genvar strideID;
	for(strideID=0; strideID<SHIFT_LENGTH; strideID=strideID+1) begin : l1_pa_inst
		L1_pageALign #(
			.QUAN_SIZE (QUAN_SIZE)
		) L1_pageALign_stride(
		`ifdef DECODER_3bit
			.L1_paOut ({L1_paOut_bit[2][strideID], L1_paOut_bit[1][strideID], L1_paOut_bit[0][strideID]}),
		
			.L1_paIn_direct ({sw_out_bit[2][strideID], sw_out_bit[1][strideID], sw_out_bit[0][strideID]}),
			.L1_paIn_mem ({memSrcIn_bit2_i[strideID], memSrcIn_bit1_i[strideID], memSrcIn_bit0_i[strideID]}),
		`endif

		`ifdef DECODER_4bit
			.L1_paOut ({L1_paOut_bit[3][strideID], L1_paOut_bit[2][strideID], L1_paOut_bit[1][strideID], L1_paOut_bit[0][strideID]}),
		
			.L1_paIn_direct ({sw_out_bit[3][strideID], sw_out_bit[2][strideID], sw_out_bit[1][strideID], sw_out_bit[0][strideID]}),
			.L1_paIn_mem ({memSrcIn_bit3_i[strideID], memSrcIn_bit2_i[strideID], memSrcIn_bit1_i[strideID], memSrcIn_bit0_i[strideID]}),
		`endif
			.L1_paSel (L1_paSel_i[(strideID+1)*L1_PA_MUX_SEL_WIDTH-1:(strideID*L1_PA_MUX_SEL_WIDTH)]),
			.sys_clk (sys_clk),
			.rstn (rstn)
		);
	end
endgenerate

// Level-2 bus combiner
data_bus_combiner #(
		.UNIT_NUM(SHIFT_LENGTH),
		.UNIT_WIDTH(QUAN_SIZE)
) data_bus_combiner_stride (
	.port_out_o (
		{
			// Stride 2
			`ifdef DECODER_4bit
				msgPass2paOut_bit3_o[2],
			`endif
			msgPass2paOut_bit2_o[2], 
			msgPass2paOut_bit1_o[2], 
			msgPass2paOut_bit0_o[2],
			// Stride 1
			`ifdef DECODER_4bit
				msgPass2paOut_bit3_o[1],
			`endif
			msgPass2paOut_bit2_o[1], 
			msgPass2paOut_bit1_o[1], 
			msgPass2paOut_bit0_o[1],
			// Stride 0
			`ifdef DECODER_4bit
				msgPass2paOut_bit3_o[0],
			`endif
			msgPass2paOut_bit2_o[0], 
			msgPass2paOut_bit1_o[0], 
			msgPass2paOut_bit0_o[0]
		}
	),

	.port_in_i  (
		{
			// Stride 2
			`ifdef DECODER_4bit
				memSrcIn_bit3_i[2],
			`endif
			memSrcIn_bit2_i[2], 
			memSrcIn_bit1_i[2], 
			memSrcIn_bit0_i[2],
			// Stride 1
			`ifdef DECODER_4bit
				memSrcIn_bit3_i[1],
			`endif
			memSrcIn_bit2_i[1], 
			memSrcIn_bit1_i[1], 
			memSrcIn_bit0_i[1],
			// Stride 0
			`ifdef DECODER_4bit
				memSrcIn_bit3_i[0],
			`endif
			memSrcIn_bit2_i[0], 
			memSrcIn_bit1_i[0], 
			memSrcIn_bit0_i[0]
		}
	),

	.load_en_i  (L2_dataCombiner_pattern_i[SHIFT_LENGTH-1:0]),
	.sys_clk    (sys_clk),
	.rstn       (rstn)
);

// Stride unit 0~(`QUAN_SIZE-1)
// Nets as input sources to circular shifters
assign sw_in_bit[0] = swIn_bit0_i[SHIFT_LENGTH-1:0];
assign sw_in_bit[1] = swIn_bit1_i[SHIFT_LENGTH-1:0];
assign sw_in_bit[2] = swIn_bit2_i[SHIFT_LENGTH-1:0];

assign L1_paOut_bit0_i[SHIFT_LENGTH-1:0] = L1_paOut_bit[0][SHIFT_LENGTH-1:0];
assign L1_paOut_bit1_i[SHIFT_LENGTH-1:0] = L1_paOut_bit[1][SHIFT_LENGTH-1:0];
assign L1_paOut_bit2_i[SHIFT_LENGTH-1:0] = L1_paOut_bit[2][SHIFT_LENGTH-1:0];

`ifdef DECODER_4bit
	assign sw_in_bit[3] = swIn_bit3_i[SHIFT_LENGTH-1:0];
	assign L1_paOut_bit3_i[SHIFT_LENGTH-1:0] = L1_paOut_bit[3][SHIFT_LENGTH-1:0];
`endif
endmodule
`endif // MSGPASS_SOL_1

`ifdef MSGPASS_SOL_3
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
module msgPass2pageAlignIF #(
	parameter SHIFT_LENGTH = 17,
	parameter QUAN_SIZE = 4
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
	input wire sys_clk,
	input wire rstn
);

localparam LEFT_SEL_WIDTH = $clog2(SHIFT_LENGTH);
localparam RIGHT_SEL_WIDTH = $clog2(SHIFT_LENGTH);

//--------------------------
// Net and reg declarations
//--------------------------
wire [SHIFT_LENGTH-1:0] sw_in_bit[0:QUAN_SIZE-1];
wire [SHIFT_LENGTH-1:0] sw_out_bit [0:QUAN_SIZE-1];

// Level-1 page alignment
// or called Level-2 permutation
wire [LEFT_SEL_WIDTH-1:0]  left_sel;
wire [RIGHT_SEL_WIDTH-1:0]  right_sel;
wire [SHIFT_LENGTH-2:0] merge_sel;
qsn_top_len17 vnu_qsn_top_len17_u0 (
	.sw_out_bit0 (sw_out_bit[0]),
	.sw_out_bit1 (sw_out_bit[1]),	
	.sw_out_bit2 (sw_out_bit[2]),
`ifdef DECODER_4bit	
	.sw_out_bit3 (sw_out_bit[3]),
`endif

	.sys_clk     (sys_clk),
	.rstn		 (rstn),

	.sw_in_bit0  (sw_in_bit[0]),
	.sw_in_bit1  (sw_in_bit[1]),
	.sw_in_bit2  (sw_in_bit[2]),
	`ifdef DECODER_4bit
		.sw_in_bit3  (sw_in_bit[3]),
	`endif

	.left_sel    (left_sel),
	.right_sel   (right_sel),
	.merge_sel   (merge_sel)
);
		
qsn_controller_len17 #(
	.PERMUTATION_LENGTH(SHIFT_LENGTH)
) vnu_qsn_controller_len17_u0 (
	.left_sel     (left_sel ),
	.right_sel    (right_sel),
	.merge_sel    (merge_sel),
	.shift_factor (L1_paShift_factor_i) // offset shift factor of submatrix_1
	//.rstn         (rstn),
	//.sys_clk      (sys_clk)
);

// Stride unit 0~(`QUAN_SIZE-1)
// Nets as input sources to circular shifters
assign sw_in_bit[0] = swIn_bit0_i[SHIFT_LENGTH-1:0];
assign sw_in_bit[1] = swIn_bit1_i[SHIFT_LENGTH-1:0];
assign sw_in_bit[2] = swIn_bit2_i[SHIFT_LENGTH-1:0];
assign msgPass2paOut_bit0_o[SHIFT_LENGTH-1:0] = sw_out_bit[0];
assign msgPass2paOut_bit1_o[SHIFT_LENGTH-1:0] = sw_out_bit[1];
assign msgPass2paOut_bit2_o[SHIFT_LENGTH-1:0] = sw_out_bit[2];

`ifdef DECODER_4bit
	assign sw_in_bit[3] = swIn_bit3_i[SHIFT_LENGTH-1:0];
	assign msgPass2paOut_bit3_o[SHIFT_LENGTH-1:0] = sw_out_bit[3];
`endif
endmodule
`endif // MSGPASS_SOL_3

module L1_pageALign #(
	parameter QUAN_SIZE = 3
) (
	// Output
	output wire [QUAN_SIZE-1:0] L1_paOut,
	
	// Input
	input wire [QUAN_SIZE-1:0] L1_paIn_direct,
	input wire [QUAN_SIZE-1:0] L1_paIn_mem,
	input wire [1:0] L1_paSel,
	input wire sys_clk,
	input wire rstn
);

reg [QUAN_SIZE-1:0] L1_paIn_pipe0; initial L1_paIn_pipe0 <= 0;
always @(posedge sys_clk) begin if(!rstn) L1_paIn_pipe0 <= 0; else L1_paIn_pipe0[QUAN_SIZE-1:0] <= L1_paIn_direct[QUAN_SIZE-1:0]; end
assign L1_paOut[QUAN_SIZE-1:0] = (L1_paSel[1:0] == 2'd0) ? L1_paIn_direct[QUAN_SIZE-1:0] :
								 (L1_paSel[1:0] == 2'd1) ? L1_paIn_pipe0[QUAN_SIZE-1:0] :
								  /*L1_paSel[1:0] == 2'd2*/L1_paIn_mem[QUAN_SIZE-1:0];
endmodule