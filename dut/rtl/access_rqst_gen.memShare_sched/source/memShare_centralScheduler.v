`timescale 1ns/1ps
/**
* Latest date: 12th Feb., 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: memShare_centralScheduler
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
module memShare_centralScheduler #(
  parameter SHARED_BANK_NUM = 4, //! the number of shared column-bank memories/IB-LUTs
  parameter RQST_ADDR_BITWIDTH = 2, //! bit width of every requestor's column address
  parameter TYPE0_ADDR_BITWIDTH = 6, //! page number: 64
  parameter MODE_BITWIDTH = 3, //! the bit width of "mode set signals",
  parameter C2V_MEM_ADDR_BITWIDTH = 10 //! bit width of write-back address (to C2V MEM)
) (
  output wire [TYPE0_ADDR_BITWIDTH-1:0] regFile_raddr_o, //! Read address -> memShare_refFile.regType0_raddr_i
  output wire [C2V_MEM_ADDR_BITWIDTH-1:0] c2vMEM_wb_waddr_o, //! write-back address to C2V MEM

  input wire [SHARED_BANK_NUM-1:0] share_rqstFlag_i, //! Request flags to shared group 2
  input wire [MODE_BITWIDTH-1:0] modeSet_i,
  input wire sys_clk,
  input wire rstn
);

//---------------------------------------------
// Empty box bypassing (although it is wrong connection)
// in order to avoid elimination/optimisation from Logic Synthesiser
reg [TYPE0_ADDR_BITWIDTH-1:0] raddr_reg; initial raddr_reg <= 0;
always @(posedge sys_clk) begin
  if(!rstn) raddr_reg <= 0;
  else raddr_reg <= {share_rqstFlag_i, modeSet_i[MODE_BITWIDTH-2:0]};
end
assign regFile_raddr_o = raddr_reg;
assign c2vMEM_wb_waddr_o = {raddr_reg, modeSet_i[0]};
//---------------------------------------------
endmodule