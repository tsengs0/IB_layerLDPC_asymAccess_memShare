`timescale 1ns/1ps
/**
* Latest date: 25th March, 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: accessRqstGen_2gp (two column banks in a subgroup 2)
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
*	3 bits:
*		LUT: 4
*		FF: 0
**/
module accessRqstGen_2gp #(
	parameter SHARED_BANK_NUM = 5, //! Number of requestors joining a share group (GP1+GP2)
	parameter RQST_ADDR_BITWIDTH = 2, //! Bit width of every requestor's column address
	parameter MODE_BITWIDTH = 3, //! Bit width of "mode set signals"
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
			rqstGen_gp2(share_rqstFlag_o[i], modeSet_i[MODE_BITWIDTH-1:0], rqst_vec[i]);
		end
	end
endgenerate

task rqstGen_gp2;
	output rqst_flag;
	input [MODE_BITWIDTH-1:0] modeIn;
	input [RQST_ADDR_BITWIDTH-1:0] rqstIn;
	begin
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
	end
endtask
endmodule
