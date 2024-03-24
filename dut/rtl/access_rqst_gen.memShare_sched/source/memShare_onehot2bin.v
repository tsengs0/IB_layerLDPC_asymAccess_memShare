/**
* Latest date: 27th Feb., 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: memShare_onehot2bin
* 
* # I/F
* 1) Output:
*
* 2) Input:
*
* # Param
* 	1) SHARED_BANK_NUM: the number of shared column-bank memories/IB-LUTs
*	2) RQST_ADDR_BITWIDTH: the bit width of every requestor's column address
*	3) SHARED_GROUP_NUM: the number of shared groups to be handled by this scheduler
* # Description
        A onthot-to-binary conversion module to translate the onhot-encoded request signals (from shared group 2)
        into binary forms
* # Dependencies
* 	None
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
module memShare_onehot2bin #(
  parameter ONEHOT_CODE_LEN = 4,
  parameter BIN_CODE_LEN = 2
) (
  output wire [BIN_CODE_LEN-1:0] bin_o,
  input wire [ONEHOT_CODE_LEN-1:0] onehot_i
);

wire [BIN_CODE_LEN-1:0] onehot_detect [0:ONEHOT_CODE_LEN-1];

genvar i;
generate;
  for(i=0; i<ONEHOT_CODE_LEN; i=i+1) begin
    assign onehot_detect[i] = (onehot_i[i]==1'b1) ? i : 0;
  end
endgenerate


assign bin_o[BIN_CODE_LEN-1:0] = onehot_detect[0]^
                                 onehot_detect[1]^
                                 onehot_detect[2]^
                                 onehot_detect[3];
endmodule