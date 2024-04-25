`timescale 1ns/1ps
/**
* Latest date: 25th March, 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: accessRqstGen
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
*
*	4 bits:
*		LUT:
*		FF:
**/
module accessRqstGen #(
	parameter SHARED_BANK_NUM = 5, //! Number of requestors joining a share group (GP1+GP2)
	parameter RQST_ADDR_BITWIDTH = 2, //! Bit width of every requestor's column address
	parameter MODE_BITWIDTH = 3, //! Bit width of "mode set signals"
	parameter [SHARED_BANK_NUM-1:0] SHARE_COL_CONFIG = 5'b10100, //! '1': shared column
	parameter GP_ELEMENT_ROW_ADDR_WIDTH = 7 //! Bit width of row address offset
) (
	output reg [SHARED_BANK_NUM-1:0] share_rqstFlag_o, //! Request flags to shared group 2

	input wire [(RQST_ADDR_BITWIDTH*SHARED_BANK_NUM)-1:0] rqst_addr_i,
	input wire [MODE_BITWIDTH-1:0] modeSet_i
);

//--------------------------------------
// GP2 request flag generator
//--------------------------------------
accessRqstGen_2gp #(
	.SHARED_BANK_NUM    (SHARED_BANK_NUM   ),
	.RQST_ADDR_BITWIDTH (RQST_ADDR_BITWIDTH),
	.MODE_BITWIDTH      (MODE_BITWIDTH     )
) accessRqstGen_2gp (
	.share_rqstFlag_o (share_rqstFlag_o[SHARED_BANK_NUM-1:0]), //! Request flags to shared group 2

	.rqst_addr_i (rqst_addr_i[(RQST_ADDR_BITWIDTH*SHARED_BANK_NUM)-1:0]),
	.modeSet_i (modeSet_i[MODE_BITWIDTH-1:0])
);
//--------------------------------------
// Row address offset generator
//--------------------------------------
endmodule
