`timescale 1ns/1ps
/**
* Latest date: 12th July, 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: accessRqstGen_2gp_q4 (four column banks in a subgroup 2)
* 
* # I/F
* 1) Output:
*	share_rqstFlag_o: the request flags of which the indexed requestors need to access to partially-parallelised column banks
*
* 2) Input:
*	rqst_addr_i: concatenation of a members' column addresses
*	modeSet_i: the mode set signals to determine the members (column banks) of shared group 1
* # Param
* 	1) SHARED_BANK_NUM: the number of shared column-bank memories/IB-LUTs
*	2) RQST_ADDR_BITWIDTH: the bit width of every requestor's column address
*	3) MODE_BITWIDTH: the bit width of "mode set signals"
* # Description
* 	An access request generator which supports an on-the-fly reconfiguration.
*	The generator handles the two shared groups as follows.
*		a) rqstFlag_gp1_o: the shared group 0 representing the fully-parallelised column banks
*		b) rqstFlag_gp2_o: the shared group 1 representing the partially-parallelised column banks
		This design only shared two column banks
* # Dependencies
* 	None
*
* # Remark
*	4 bits:
*		LUT:
*		FF:
**/
module accessRqstGen_2gp_q4 #(
	parameter SHARED_BANK_NUM = 5, //! Number of requestors joining a share group (GP1+GP2)
	parameter RQST_ADDR_BITWIDTH = 3, //! Bit width of every requestor's column address
	parameter MODE_BITWIDTH = 7, //! Bit width of "mode set signals"
	parameter PIPELINE_NUM = 1, // one stage of pipeline registers inserted
	parameter RQST_FLAG_CYCLE = 1
) (
	output reg [SHARED_BANK_NUM-1:0] share_rqstFlag_o, //! Request flags to shared group 2

	input wire [(RQST_ADDR_BITWIDTH*SHARED_BANK_NUM)-1:0] rqst_addr_i,
	input wire [MODE_BITWIDTH-1:0] modeSet_i
);

wire [RQST_ADDR_BITWIDTH-1:0] rqst_vec [0:SHARED_BANK_NUM-1];
generate
	genvar i;
	for(i=0; i<SHARED_BANK_NUM; i=i+1) begin
		assign rqst_vec[i] = rqst_addr_i[(i+1)*RQST_ADDR_BITWIDTH-1:i*RQST_ADDR_BITWIDTH];

		always @(*) begin
			case(rqst_vec[i])
				0: share_rqstFlag_o[i] = 1;
				2: share_rqstFlag_o[i] = 1;
				4: share_rqstFlag_o[i] = 1;
				6: share_rqstFlag_o[i] = 1;
				default: share_rqstFlag_o[i] = 0;
			endcase
		end
	end
endgenerate

task rqstGen_gp2;
	output rqst_flag;
	input [MODE_BITWIDTH-1:0] modeIn;
	input [RQST_ADDR_BITWIDTH-1:0] rqstIn;
	begin
		/*
		casez({modeIn[MODE_BITWIDTH-1:0], rqstIn[RQST_ADDR_BITWIDTH-1:0]})
			{3'b000, 2'b0?}: rqst_flag = 1'b1; // col_0, col_1
			{3'b001, 2'b1?}: rqst_flag = 1'b1; // col_2, col_3
			{3'b010, 2'b?0}: rqst_flag = 1'b1; // col_0, col_2
			{3'b011, 2'b?1}: rqst_flag = 1'b1; // col_1, col_3
			{3'b100, 2'b01}: rqst_flag = 1'b1; // col_1, col_2 -> (request pattern 0)
			{3'b100, 2'b10}: rqst_flag = 1'b1; // col_1, col_2 -> (request pattern 1)
			{3'b101, 2'b00}: rqst_flag = 1'b1; // col_0, col_3 -> (request pattern 0)
			{3'b101, 2'b11}: rqst_flag = 1'b1; // col_0, col_3 -> (request pattern 1)			
			default: rqst_flag = 1'b0;
		endcase
		*/
		if(rqstIn==0 || rqstIn==1 || rqstIn==2 || rqstIn==3) 
			rqst_flag = 1'b1;
		else
			rqst_flag = 1'b0;
	end
endtask
endmodule

/**
* Latest date: 4th Feb., 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: accessRqstGen_gp2_fix
* 
* # I/F
* 1) Output:
* 2) Input:
* 
* # Param
* 	1) SHARED_BANK_NUM: the number of shared column-bank memories/IB-LUTs
*	2) RQST_ADDR_BITWIDTH
* # Description
* 	A hard-wired access request generator which does not support an on-the-fly reconfiguration.
*	The generator handles the two shared groups.
* # Dependencies
* 	None
**/
//module accessRqstGen_gp2_fix #(
//	parameter SHARED_BANK_NUM = 4,
//	parameter RQST_ADDR_BITWIDTH = 3
//) (
//	output wire [SHARED_BANK_NUM-1:0] rqst_flag,
//	input wire [RQST_ADDR_BITWIDTH-1:0] rqst_addr
//);
//
//assign rqst_flag[0] = ({rqst_addr[2], rqst_addr[0]} == 2'b00) ? 1'b1 : 1'b0;
//assign rqst_flag[1] = ({rqst_addr[2], rqst_addr[0]} == 2'b01) ? 1'b1 : 1'b0;
//assign rqst_flag[2] = ({rqst_addr[2], rqst_addr[1]} == 2'b10) ? 1'b1 : 1'b0;
//assign rqst_flag[3] = ({rqst_addr[2], rqst_addr[1]} == 2'b11) ? 1'b1 : 1'b0;
//endmodule

//module memShare_centralScheduler #(
//	parameter SHARED_BANK_NUM = 4,
//	parameter END_FLAG_WIDTH = 1,
//	parameter L1PA_MAX_PIPELINE_LEN = 3
//)(
//	output wire [END_FLAG_WIDTH-1:0] endFlag_o,
//	output wire [SHARED_BANK_NUM-1:0] invalid_pos_o,
//
//	input wire [SHARED_BANK_NUM-1:0] share_rqstFlag_i,
//
//	input wire sys_clk,
//	input wire rstn
//);
//
//reg [L1PA_CTRL_WIDTH-1:0] shift_net;
//reg [L1PA_CTRL_WIDTH-1:0] invalid_net;
//always @(*) begin
//	L1PA_shiftGen(shift_net, invalid_net, share_rqstFlag_i);
//end
//
//reg [L1PA_CTRL_WIDTH-1:0] shift_pipe [0:L1PA_MAX_PIPELINE_LEN-1];
//reg [L1PA_CTRL_WIDTH-1:0] invalid_pipe [0:L1PA_MAX_PIPELINE_LEN-1];
//genvar i;
//generate;
//	for(i=0; i<L1PA_MAX_PIPELINE_LEN; i=i+1) begin
//		if(i==0) begin
//			always @(posedge sys_clk) begin	if(!rstn) shift_pipe[0]<=0; else shift_pipe[0]<=shift_net; end
//			always @(posedge sys_clk) begin	if(!rstn) invalid_pipe[0]<=0; else invalid_pipe[0]<=invalid_net; end
//		end
//		else begin
//			always @(posedge sys_clk) begin	if(!rstn) shift_pipe[i]<=0; else shift_pipe[i]<=shift_pipe[i-1]; end
//			always @(posedge sys_clk) begin	if(!rstn) invalid_pipe[i]<=0; else invalid_pipe[i]<=invalid_pipe[i-1]; end
//		end
//	end
//endgenerate
//
//task L1PA_shiftGen;
//	output [L1PA_CTRL_WIDTH-1:0] shift;
//	output [SHARED_BANK_NUM-1:0] invalid;
//	input [SHARED_BANK_NUM-1:0] gp2_rqstFlag;
//	begin
//		casez({gp2_rqstFlag})
//			/*
//			{3'b000, 2'b0?}: rqst_flag = 1'b1;
//			{3'b001, 2'b01}: rqst_flag = 1'b1;
//			{3'b001, 2'b10}: rqst_flag = 1'b1;
//			{3'b010, 2'b1?}: rqst_flag = 1'b1;
//			{3'b011, 2'b00}: rqst_flag = 1'b1;
//			{3'b011, 2'b11}: rqst_flag = 1'b1;
//			{3'b100, 2'b?0}: rqst_flag = 1'b1;
//			{3'b101, 2'b?1}: rqst_flag = 1'b1;
//			default: rqst_flag = 1'b0;
//			*/
//		endcase
//	end
//endtask
//endmodule

/*
L1PA shift pattern
For a settigs of which the size of share group is 4:
	">>0"	=>	1000
	">>1"	=>	0100 
	">>2"	=>	0010
	">>3"	=>	0001

	input wire [SHARED_BANK_NUM-1:0] share_rqstFlag_i,
	input wire [SHARED_BANK_NUM-1:0] gp2_pos_i //! All positions/indices of subgroup 2, '1': the bit position represents the one in subgroup 2

gp2_pos_i = 'b1010
share_rqstFlag_i | (Output) shift | (Output) invalid
-----------------------------------------------
0000			 | 0	 | 0000
________________________________
0111			 | 1     | 0001
                 | 0     | 1101
________________________________
1111			 | 0	 | 0101
				 | 1	 | 0101


*/
