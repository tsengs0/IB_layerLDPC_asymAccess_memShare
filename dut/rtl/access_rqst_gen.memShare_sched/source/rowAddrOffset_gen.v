/**
* Latest date: 7th April, 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: rowAddrOffset_gen
* 
* # I/F
* 1) Output:

* 2) Input:

* # Param
* 	1) SHARED_BANK_NUM: the number of shared column-bank memories/IB-LUTs
*	2) RQST_ADDR_BITWIDTH: the bit width of every requestor's column address
*	3) MODE_BITWIDTH: the bit width of "mode set signals"
* # Description

* # Dependencies
* 	The number of output ports rowAddr_offset*_o is dependent on the override value of parameter SHARED_BANK_NUM 
*
* # Remark
*	3 bits:
*		LUT: 
*		FF: 
*
*	4 bits:
*		LUT:
*		FF:
**/
module rowAddrOffset_gen #(
	parameter SHARED_BANK_NUM = 5, //! Number of IB-LUTs joining a share group (GP2)
	parameter RQST_ADDR_BITWIDTH = 2, //! Bit width of every requestor's column address
	parameter MODE_BITWIDTH = 3, //! Bit width of "mode set signals"
	parameter GP1_ROW_ADDR_OFFSET_WIDTH = 1,
	parameter GP2_ROW_ADDR_OFFSET_WIDTH = 2,
	parameter [SHARED_BANK_NUM-1:0] SHARE_COL_CONFIG = 5'b10100 //! '1': shared column
) (
	output wire [GP1_ROW_ADDR_OFFSET_WIDTH-1:0] rowAddr_offset0_o, //! Row address offset 0
	output wire [GP1_ROW_ADDR_OFFSET_WIDTH-1:0] rowAddr_offset1_o, //! Row address offset 1
	output wire [GP2_ROW_ADDR_OFFSET_WIDTH-1:0] rowAddr_offset2_o, //! Row address offset 2
	output wire [GP1_ROW_ADDR_OFFSET_WIDTH-1:0] rowAddr_offset3_o, //! Row address offset 3
	output wire [GP2_ROW_ADDR_OFFSET_WIDTH-1:0] rowAddr_offset4_o, //! Row address offset 4

	input wire [(RQST_ADDR_BITWIDTH*SHARED_BANK_NUM)-1:0] rqst_addr_i,
	input wire [MODE_BITWIDTH-1:0] modeSet_i
);

wire [RQST_ADDR_BITWIDTH-1:0] rqst_vec [0:SHARED_BANK_NUM-1];
reg [GP2_ROW_ADDR_OFFSET_WIDTH-1:0] offset_vec [0:SHARED_BANK_NUM-1];
generate
	genvar i;
	for(i=0; i<SHARED_BANK_NUM; i=i+1) begin
		assign rqst_vec[i] = rqst_addr_i[(i+1)*RQST_ADDR_BITWIDTH-1:i*RQST_ADDR_BITWIDTH];

		always @(*) begin
			offset_gen(offset_vec[i], modeSet_i[MODE_BITWIDTH-1:0], rqst_vec[i]);
		end
	end
endgenerate
assign rowAddr_offset0_o[GP1_ROW_ADDR_OFFSET_WIDTH-1:0] = offset_vec[0][0];
assign rowAddr_offset1_o[GP1_ROW_ADDR_OFFSET_WIDTH-1:0] = offset_vec[1][0];
assign rowAddr_offset2_o[GP1_ROW_ADDR_OFFSET_WIDTH-1:0] = offset_vec[2][GP2_ROW_ADDR_OFFSET_WIDTH-1:0];
assign rowAddr_offset3_o[GP1_ROW_ADDR_OFFSET_WIDTH-1:0] = offset_vec[3][0];
assign rowAddr_offset4_o[GP2_ROW_ADDR_OFFSET_WIDTH-1:0] = offset_vec[4][GP2_ROW_ADDR_OFFSET_WIDTH-1:0];

task offset_gen;
	output [GP2_ROW_ADDR_OFFSET_WIDTH-1:0] row_offset;
	input  [MODE_BITWIDTH-1:0] modeIn;
	input  [RQST_ADDR_BITWIDTH-1:0] rqstIn;
	begin
		casez({modeIn[MODE_BITWIDTH-1:0], rqstIn[RQST_ADDR_BITWIDTH-1:0]})
			3'b000: row_offset =  rqstIn[1] &  rqstIn[0]; // col_{2'b10, 2'b11} mapped to GP1
			3'b001: row_offset = ~rqstIn[1] &  rqstIn[0]; // col_{2'b00, 2'b01} mapped to GP1
			3'b010: row_offset =  rqstIn[1] &  rqstIn[0]; // col_{2'b01, 2'b11} mapped to GP1
			3'b011: row_offset =  rqstIn[1] & ~rqstIn[0]; // col_{2'b00, 2'b10} mapped to GP1
			3'b100: row_offset =  rqstIn[0]; // col_{2'b00, 2'b11} mapped to GP1
			3'b101: row_offset =  rqstIn[0]; // col_{2'b01, 2'b10} mapped to GP1	
			default: row_offset = rqstIn[1:0];
		endcase
	end
endtask
endmodule