
module memShare_control_wrapper_tb;
import memShare_config_pkg::*;

// Parameters
//localparam  SHARE_GROUP_SIZE = 0;
//localparam  RQST_ADDR_BITWIDTH = 0;
//localparam  MODE_BITWIDTH = 0;
//localparam  RQST_FLAG_CYCLE = 0;
//localparam  RQST_BITWIDTH = 0;
//localparam  REGFILE_PAGE_NUM = 0;
//localparam  MAX_MEMSHARE_INSTANCES = 0;
//localparam  REGFILE_ADDR_WIDTH = 0;
//localparam  L1PA_SHIFT_BITWIDTH = 0;

//----------------------------------------------------------------
// DUT's I/O ports
//----------------------------------------------------------------
logic [(RQST_ADDR_BITWIDTH*SHARE_GROUP_SIZE)-1:0] rqst_addr_i;
logic [RQST_MODE_BITWIDTH-1:0] modeSet_i;
// L1PA regFile-mapping unit
logic [$clog2(SHARE_GROUP_SIZE)-1:0] l1pa_shift_o; //! shift control instructing the L1PA
logic isGtr_o; //! 1: currently accessed L1PA_SPR is the last pattern in the chosen L1PA shift sequence
// L1PA register file
logic [L1PA_REGFILE_ADDR_WIDTH-1:0] regType0_waddr_i;
logic [L1PA_REGFILE_PAGE_WIDTH-1:0] regType0_wdata_i;
logic regType0_we_i;
logic rstn;
logic sys_clk;  
//----------------------------------------------------------------
// Local variables
//----------------------------------------------------------------
generic_mem_preloader regFile_loader;

memShare_control_wrapper memShare_control_wrapper (
  .rqst_addr_i(rqst_addr_i),
  .modeSet_i(modeSet_i),
  .l1pa_shift_o(l1pa_shift_o),
  .isGtr_o(isGtr_o),
  .regType0_waddr_i(regType0_waddr_i),
  .regType0_wdata_i(regType0_wdata_i),
  .regType0_we_i(regType0_we_i),
  .rstn(rstn),
  .sys_clk(sys_clk)
);

initial begin
    sys_clk = 1'b0;
    forever #5 sys_clk = ~sys_clk;
end

initial begin
    rstn = 1'b0;
    #(5*2*10); rstn = 1'b1;
end

initial begin
    regFile_loader = new();
    regFile_loader.bin_load("tb/config/l1pa_spr_5_gp2Num3_gp2Alloc10101.bin");
    regFile_loader.bin_view;
    #(5*2*100) $finish;
end

endmodule
