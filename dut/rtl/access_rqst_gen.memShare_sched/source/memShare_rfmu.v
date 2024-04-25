`timescale 1ns/1ps
/**
* Latest date: 9th July, 2023
* Developer: Bo-Yu Tseng
* Email: tsengs0@gamil.com
* Module name: memShare_rfmu
* 
* # I/F
* 1) Output: (not maintained yet)

* 2) Input: (not maintained yet)

* # Param (not maintained yet)

* # Description
    A register file mapping unit to convert a given set of request flags into a specific read address for L1PA register file.
                                       
 _______                    ______________ (Feedback datapath)  _______
|       |                  |              |-->isGtr----------->|       |
| RFMU  |-->regFile_raddr->| L1PA regFile |-->shift----------->| RFMU  |-->isGtr (to system)
|       |                  |______________|-->shiftDelta------>|       |-->L1PA_shift (to L1PA)
|       |______________________________________________________|       |
|______________________________________________________________________|

* # Dependencies
*
* # Remark
		LUT: 2
        Logic LUT: 2 
        LUTRAM: 0
		FF: 3
        I/O: 23
        Freq: 400MHz
        WNS:  ns
        TNS:  ns
        WHS:  ns
        THS:  ns
        WPWS: ns
        TPWS: ns
**/
module memShare_rfmu #(
    parameter RQST_BITWIDTH = 5, //! Size of request flag
    parameter REGFILE_PAGE_NUM = 43, //! Number of pages in memShare_regFile
    // Configuration of memShare register file
    parameter REGFILE_ADDR_WIDTH = RQST_BITWIDTH,
    parameter L1PA_SHIFT_BITWIDTH = $clog2(RQST_BITWIDTH),
    parameter SHIFTDELTA_ALU_CYCLE = 1
) (
      // I/F to L1PA
      output wire [L1PA_SHIFT_BITWIDTH-1:0] l1pa_shift_o, //! shift control instructing the L1PA
      // I/F to regFile
      output wire [REGFILE_ADDR_WIDTH-1:0] regFile_raddr_o, //! read address for memShare_regFile
      // I/F to system
      output wire isGtr_o, //! 1: currently accessed L1PA_SPR is the last pattern in the chosen L1PA shift sequence

      input wire [RQST_BITWIDTH-1:0] rqstFlag_i, //! Request flags to shared group 2 (GP2)

      // Feedback signals from memShare_regFile.L1PA_SPR
      input wire [L1PA_SHIFT_BITWIDTH-1:0] l1pa_shift_fb_i,
      input wire [L1PA_SHIFT_BITWIDTH-1:0] shiftDelta_fb_i,
      input wire isGtr_fb_i, //! Feedback of "isGreaterThan-0" extracted from LSB of L1PA_SPR
      input wire rstn,
      input wire sys_clk      
);

reg [REGFILE_ADDR_WIDTH-1:0] mapped_addr;
// Pipeline stage 1.a for the upstream module: RFMU-to-regFile, i.e. output logic behaviour of RFMU
always_comb begin
    addr_map_unit(mapped_addr[REGFILE_ADDR_WIDTH-1:0], rqstFlag_i[RQST_BITWIDTH-1:0]);
end
assign regFile_raddr_o[REGFILE_ADDR_WIDTH-1:0] = mapped_addr[REGFILE_ADDR_WIDTH-1:0];  

// Pipeline stage 1.b for the upstream module: regFile-to-RFMU, i.e. feedback from regFile
wire [L1PA_SHIFT_BITWIDTH:0] l1pa_shift_net;

// Pipeline stage 2 for the upstream module
wire [L1PA_SHIFT_BITWIDTH:0] l1pa_shift_pipeN;
wire isGtr_fb_pipeN;
pipeReg_insert #(
    .BITWIDTH(L1PA_SHIFT_BITWIDTH+1+1),
    .PIPELINE_STAGE(SHIFTDELTA_ALU_CYCLE)
) shiftDelta_alu_pipeReg (
    .pipe_reg_o    ({l1pa_shift_pipeN[L1PA_SHIFT_BITWIDTH:0], isGtr_fb_pipeN}),
    //.stage_probe_o (),
    .sig_net_i     ({l1pa_shift_net[L1PA_SHIFT_BITWIDTH:0], isGtr_fb_i}),
    .pipeLoad_en_i ({SHIFTDELTA_ALU_CYCLE{1'b1}}),
    .sys_clk       (sys_clk),
    .rstn          (rstn)
);
assign l1pa_shift_net[L1PA_SHIFT_BITWIDTH:0] = {1'b0, l1pa_shift_fb_i[L1PA_SHIFT_BITWIDTH-1:0]} + {1'b0, shiftDelta_fb_i[L1PA_SHIFT_BITWIDTH-1:0]};
assign l1pa_shift_o[L1PA_SHIFT_BITWIDTH-1:0] = l1pa_shift_pipeN[L1PA_SHIFT_BITWIDTH-1:0];

// Pipeline stage 2 for the upstream module: RFMU-to-Sytem (the system is T.B.D.)
assign isGtr_o = isGtr_fb_pipeN;

// Replacable rqstFlag-to-regFile.raddr mapping table/unit
task addr_map_unit;
	output [REGFILE_ADDR_WIDTH-1:0] mapped_addr_o;
	input [RQST_BITWIDTH-1:0] rqstIn;
	begin
        mapped_addr_o[REGFILE_ADDR_WIDTH-1:0] = rqstIn[RQST_BITWIDTH-1:0];
	end
endtask
endmodule
