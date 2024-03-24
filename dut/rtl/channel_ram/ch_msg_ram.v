`include "define.vh"
`include "revision_def.vh"
`include "define_sched_5.vh"
// Don't forget to make the RAM[DEPTH] <= 0; by system in a synthesisable manner.
module ch_msg_ram #(
	parameter QUAN_SIZE = 4,
	parameter CH_IN_NUM = 45,
	parameter DEPTH = 255+1, // The (DEPTH)-th page is intentionally preserve for storing all-zero valued data
	parameter DUAL_PORT_WR_DISTANCE = 45, // the distance apart from 1st-port-written memory region to that of 2nd one
	parameter DUAL_PORT_RD_DISTANCE = 45, // the distance apart from 1st-port-written memory region to that of 2nd one
	parameter DATA_OUT_WIDTH = (CH_IN_NUM*1)*QUAN_SIZE,
	parameter DATA_IN_WIDTH =  (765)*QUAN_SIZE,
	parameter DATA_IN_PORT_WIDTH = CH_IN_NUM*QUAN_SIZE,
	parameter MEM_BLOCK_NUM = 8,
	parameter FRAG_WIDTH = 45*QUAN_SIZE,
	parameter ADDR_WIDTH = $clog2(DEPTH),
	parameter GLUT_IN_NUM = 17,
	parameter VNU_FETCH_LATENCY = 2,//`CH_FETCH_LATENCY,//2,
	parameter CNU_FETCH_LATENCY = 1//`CNU_INIT_FETCH_LATENCY//1
) (
	output wire [DATA_OUT_WIDTH-1:0] dout_o,

	// For CNU at first iteration
	output wire [DATA_OUT_WIDTH-1:0] cnu_init_dout_o,

	input wire [DATA_IN_WIDTH-1:0] din_i,
	input wire [ADDR_WIDTH-1:0] portA_read_addr_i, // to forward the data to input of barrel shifters
	input wire [ADDR_WIDTH-1:0] portB_read_addr_i, // to forward the data to CNUs and VNUs
	input wire [ADDR_WIDTH-1:0] write_addr_i,
	input wire we,
	input wire read_clk,
	input wire write_clk,
	input wire rstn
);


wire [ADDR_WIDTH-1:0] portA_sync_addr;
wire [ADDR_WIDTH-1:0] portB_sync_addr;
assign portA_sync_addr[ADDR_WIDTH-1:0] = (we == 1'b1) ? write_addr_i[ADDR_WIDTH-1:0] : portA_read_addr_i[ADDR_WIDTH-1:0];
assign portB_sync_addr[ADDR_WIDTH-1:0] = (we == 1'b1) ? write_addr_i[ADDR_WIDTH-1:0]+DUAL_PORT_WR_DISTANCE : 
														portB_read_addr_i[ADDR_WIDTH-1:0]+DUAL_PORT_RD_DISTANCE;
/*=====================================================================================*/
// Main RAM block(s)
localparam MAIN_CORE_MEM_DATA_WIDTH = (CH_IN_NUM*1)*QUAN_SIZE; // 45x4 bits
localparam MAIN_CORE_MEM_DATA_BIT_OFFSET = FRAG_WIDTH;
localparam MAIN_PORTA_DIN_BIT_OFFSET = MAIN_CORE_MEM_DATA_WIDTH*MEM_BLOCK_NUM + FRAG_WIDTH; // (45x4 bits)x8 RAMs + offset
localparam MAIN_PORTB_DIN_BIT_OFFSET = FRAG_WIDTH;
wire [MAIN_CORE_MEM_DATA_WIDTH-1:0] mainPortA_dout [0:MEM_BLOCK_NUM-1];
wire [MAIN_CORE_MEM_DATA_WIDTH-1:0] mainPortB_dout [0:MEM_BLOCK_NUM-1];
wire [MAIN_CORE_MEM_DATA_WIDTH*MEM_BLOCK_NUM*/*dual-port*/2-1:0] mainPortAB_dout;
generate
	genvar mainRAM_instID;
	for(mainRAM_instID=0; mainRAM_instID<MEM_BLOCK_NUM; mainRAM_instID=mainRAM_instID+1) begin : mainRAM_inst
		wire [MAIN_CORE_MEM_DATA_WIDTH-1:0] mainPortA_din;
		wire [MAIN_CORE_MEM_DATA_WIDTH-1:0] mainPortB_din;
		generic_ram_wrapper #(
			.PORT_NUM       (2),
			.DATA_OUT_WIDTH (MAIN_CORE_MEM_DATA_WIDTH), // 45 quantised data x 8 memBlock x 4bit width per data
			.DATA_IN_WIDTH  (MAIN_CORE_MEM_DATA_WIDTH), // 45 quantised data x 8 memBlock x 4bit width per data
			.DEPTH  		(DEPTH),
			.ADDR_WIDTH     (ADDR_WIDTH)
		) main_coreMem_u0 (
			.portA_dout_o (mainPortA_dout[mainRAM_instID]),
			.portB_dout_o (mainPortB_dout[mainRAM_instID]),
		
			.portA_din_i (mainPortA_din[MAIN_CORE_MEM_DATA_WIDTH-1:0]),
			.portB_din_i (mainPortB_din[MAIN_CORE_MEM_DATA_WIDTH-1:0]),
			.portA_we_i (we),
			.portB_we_i (we),
			.portA_sync_addr (portA_sync_addr[ADDR_WIDTH-1:0]),
			.portB_sync_addr (portB_sync_addr[ADDR_WIDTH-1:0]),
			.write_clk (write_clk),
			.read_clk  (read_clk)
		);
		assign mainPortA_din[MAIN_CORE_MEM_DATA_WIDTH-1:0] = din_i[
																(mainRAM_instID+1)*MAIN_CORE_MEM_DATA_WIDTH-1+
																MAIN_PORTA_DIN_BIT_OFFSET :
																mainRAM_instID*MAIN_CORE_MEM_DATA_WIDTH+
																MAIN_PORTA_DIN_BIT_OFFSET
															];
		assign mainPortB_din[MAIN_CORE_MEM_DATA_WIDTH-1:0] = din_i[
																(mainRAM_instID+1)*MAIN_CORE_MEM_DATA_WIDTH-1+
																MAIN_PORTB_DIN_BIT_OFFSET :
																mainRAM_instID*MAIN_CORE_MEM_DATA_WIDTH+
																MAIN_PORTB_DIN_BIT_OFFSET	
															];
		assign mainPortAB_dout[
								(mainRAM_instID+1)*(MAIN_CORE_MEM_DATA_WIDTH*/*dual-port*/2)-1 :
								 mainRAM_instID   *(MAIN_CORE_MEM_DATA_WIDTH*/*dual-port*/2)
				] = {mainPortA_dout[mainRAM_instID], mainPortB_dout[mainRAM_instID]};
	end
endgenerate
/*=====================================================================================*/
// Fragment RAM block(s)
localparam FRAG_CORE_MEM_DATA_WIDTH = (FRAG_WIDTH/2); // for W=3-bit, 45*3 is not integer, hence single port is configured
localparam FRAG_CORE_MEM_DATA_BIT_OFFSET = 0;
wire [FRAG_CORE_MEM_DATA_WIDTH-1:0] fragPortA_dout;
wire [FRAG_CORE_MEM_DATA_WIDTH-1:0] fragPortB_dout;
wire [FRAG_CORE_MEM_DATA_WIDTH-1:0] fragPortA_din;
wire [FRAG_CORE_MEM_DATA_WIDTH-1:0] fragPortB_din;
generic_ram_wrapper #(
	.PORT_NUM       (2), // for W=3-bit, 45*3 is not integer, hence single port is configured
	.DATA_OUT_WIDTH (FRAG_CORE_MEM_DATA_WIDTH), // 45 quantised data x 8 memBlock x 4bit width per data
	.DATA_IN_WIDTH  (FRAG_CORE_MEM_DATA_WIDTH), // 45 quantised data x 8 memBlock x 4bit width per data
	.DEPTH  		(DEPTH),
	.ADDR_WIDTH     (ADDR_WIDTH)
) frag_coreMem_u0 (
	.portA_dout_o (fragPortA_dout[FRAG_CORE_MEM_DATA_WIDTH-1:0]),
	.portB_dout_o (fragPortB_dout[FRAG_CORE_MEM_DATA_WIDTH-1:0]),

	.portA_din_i (fragPortA_din[FRAG_CORE_MEM_DATA_WIDTH-1:0]),
	.portB_din_i (fragPortB_din[FRAG_CORE_MEM_DATA_WIDTH-1:0]),
	.portA_we_i (we),
	.portB_we_i (we),
	.portA_sync_addr (portA_sync_addr[ADDR_WIDTH-1:0]),
	.portB_sync_addr (portB_sync_addr[ADDR_WIDTH-1:0]),
	.write_clk (write_clk),
	.read_clk  (read_clk)
);
assign fragPortB_din[FRAG_CORE_MEM_DATA_WIDTH-1:0] = din_i[
															FRAG_CORE_MEM_DATA_WIDTH-1+
															FRAG_CORE_MEM_DATA_BIT_OFFSET :
															0+FRAG_CORE_MEM_DATA_BIT_OFFSET
													];
assign fragPortA_din[FRAG_CORE_MEM_DATA_WIDTH-1:0] = din_i[
															FRAG_CORE_MEM_DATA_WIDTH*2-1+
															FRAG_CORE_MEM_DATA_BIT_OFFSET :
															FRAG_CORE_MEM_DATA_WIDTH+FRAG_CORE_MEM_DATA_BIT_OFFSET
													];
/*=====================================================================================*/
chRAM_out_glue #(
	.DATA_OUT_WIDTH (DATA_OUT_WIDTH),
	.DATA_IN_WIDTH (DATA_IN_WIDTH),
	.OR_IN_NUM (GLUT_IN_NUM)
) chRAM_out_glue_u0 (
	.glue_dout_o (dout_o[DATA_OUT_WIDTH-1:0]),
	.glue_din_i (
				{
					mainPortAB_dout[MAIN_CORE_MEM_DATA_WIDTH*MEM_BLOCK_NUM*/*dual-port*/2-1:0],
					fragPortA_dout[FRAG_CORE_MEM_DATA_WIDTH-1:0],
					fragPortB_dout[FRAG_CORE_MEM_DATA_WIDTH-1:0]
				}
	)
);

/*=====================================================================================*/
// Output Port A: to forward the data to input of barrel shifters
//(* ram_style="register" *) reg [DATA_WIDTH-1:0] dout_pipe_a;
//always @(posedge read_clk) begin
//	if(rstn == 1'b0) dout_pipe_a <= 0;
//	else dout_pipe_a <= do_a;
//end
/*=====================================================================================*/
// Output Port B: to forward the data to CNUs and VNUs
(* ram_style="register" *) reg [DATA_OUT_WIDTH-1:0] dout_pipe_b [0:CNU_FETCH_LATENCY-1];
always @(posedge read_clk) begin
	if(rstn == 1'b0) dout_pipe_b[0] <= 0;
	else dout_pipe_b[0] <= dout_o[DATA_OUT_WIDTH-1:0];
end

generate
	genvar i;
	for(i=1;i<CNU_FETCH_LATENCY;i=i+1) begin : cnu_init_dout_inst
		always @(posedge read_clk) begin
			if(rstn == 1'b0) dout_pipe_b[i] <= 0;
			else dout_pipe_b[i] <= dout_pipe_b[i-1];
		end
	end
endgenerate
assign cnu_init_dout_o[DATA_OUT_WIDTH-1:0] = dout_pipe_b[CNU_FETCH_LATENCY-1][DATA_OUT_WIDTH-1:0];
///*=====================================================================================*/
//assign dout_0 [`QUAN_SIZE-1:0]   = dout_pipe_b[VNU_FETCH_LATENCY-1][1*`QUAN_SIZE-1:0*`QUAN_SIZE];
//assign cnu_init_dout_0   [`QUAN_SIZE-1:0] = dout_pipe_b[CNU_FETCH_LATENCY-1][  1*QUAN_SIZE-1:  0*QUAN_SIZE];
//assign bs_src_dout_0   [`QUAN_SIZE-1:0] = dout_pipe_a[  1*`QUAN_SIZE-1:  0*`QUAN_SIZE];
endmodule

module generic_ram_wrapper #(
	parameter PORT_NUM = 2,
	parameter DATA_OUT_WIDTH = (45*4), // 45 quantised data x 8 memBlock x 4bit width per data
	parameter DATA_IN_WIDTH  = (45*4), // 45 quantised data x 8 memBlock x 4bit width per data
	parameter DEPTH = 255+1,
	parameter ADDR_WIDTH = $clog2(DEPTH)
) (
	output reg [DATA_OUT_WIDTH-1:0] portA_dout_o,
	output reg [DATA_OUT_WIDTH-1:0] portB_dout_o,

	input wire [DATA_IN_WIDTH-1:0] portA_din_i,
	input wire [DATA_IN_WIDTH-1:0] portB_din_i,
	input wire portA_we_i,
	input wire portB_we_i,
	input wire [ADDR_WIDTH-1:0] portA_sync_addr,
	input wire [ADDR_WIDTH-1:0] portB_sync_addr,
	input wire write_clk,
	input wire read_clk
);

// Core Memory
// The (DEPTH)-th page is intentionally preserve for storing all-zero valued data
//(* ram_style="lutram" *) reg [DATA_IN_WIDTH-1:0] ram_block [0:DEPTH-1]; initial ram_block[DEPTH-1] <= 0;
(* ram_style="bram" *) reg [DATA_IN_WIDTH-1:0] ram_block [0:DEPTH-1]; initial ram_block[DEPTH-1] <= 0;
// Port-A
always @(posedge write_clk) begin
	if(portA_we_i == 1'b1)
		ram_block[portA_sync_addr] <= portA_din_i;
	else
		portA_dout_o[DATA_OUT_WIDTH-1:0] <= ram_block[portA_sync_addr];
	//ram_block[DEPTH-1] <= 0;
end
/*=====================================================================================*/
generate
	if(PORT_NUM == 2) begin
		// Port-B
		always @(posedge write_clk) begin
			if(portB_we_i == 1'b1)
				ram_block[portB_sync_addr] <= portB_din_i;
			else
				portB_dout_o[DATA_OUT_WIDTH-1:0] <= ram_block[portB_sync_addr];
		end
	end
endgenerate
endmodule

module chRAM_out_glue #(
	parameter DATA_OUT_WIDTH = 45*4,
	parameter DATA_IN_WIDTH = 765*4,
	parameter OR_IN_NUM = 17
) (
	output wire [DATA_OUT_WIDTH-1:0] glue_dout_o,

	input wire [DATA_IN_WIDTH-1:0] glue_din_i
);

localparam SINGLE_OR_IN_WIDTH = DATA_OUT_WIDTH;
wire [SINGLE_OR_IN_WIDTH-1:0] singleOR_in [0:OR_IN_NUM-1];
generate
	genvar i;
	for(i=0; i<OR_IN_NUM; i=i+1) begin : orIN_break_inst
		assign singleOR_in[i] = glue_din_i[(i+1)*SINGLE_OR_IN_WIDTH-1:i*SINGLE_OR_IN_WIDTH];
	end
endgenerate

integer glue_id;
reg [DATA_OUT_WIDTH-1:0] dout_temp;
always @* begin
	dout_temp[DATA_OUT_WIDTH-1:0] = singleOR_in[0][SINGLE_OR_IN_WIDTH-1:0];
	for(glue_id=1; glue_id<OR_IN_NUM; glue_id=glue_id+1) begin
		dout_temp[DATA_OUT_WIDTH-1:0] = dout_temp[DATA_OUT_WIDTH-1:0] | singleOR_in[glue_id][SINGLE_OR_IN_WIDTH-1:0];
	end
end
assign glue_dout_o[DATA_OUT_WIDTH-1:0] = dout_temp[DATA_OUT_WIDTH-1:0];
endmodule