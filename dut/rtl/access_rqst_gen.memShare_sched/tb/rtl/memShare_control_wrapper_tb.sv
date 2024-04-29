
module memShare_control_wrapper_tb;
import memShare_config_pkg::*;
import scu_memShare_tb_config_pkg::*;

// Parameters

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
`include "scu_memShare_tb_class.sv"
generic_mem_preloader#(.PAGE_NUM(L1PA_REGFILE_PAGE_NUM), .PAGE_SIZE(L1PA_REGFILE_PAGE_WIDTH)) regFile_loader;
scu_memShare_tb_seq_class tb_seq;
int SIM_TIME;

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
    sys_clk = TB_CLK_INITIAL_LEVEL;
    forever #(TB_CLK_PERIOD/2) sys_clk = ~sys_clk;
end

initial begin
    rstn = 1'b0;
    #(TB_CLK_PERIOD*10); rstn = 1'b1;
end

initial begin
    regFile_loader = new();
    tb_seq = new();

    regFile_loader.bin_load("tb/config/l1pa_spr_5_gp2Num3_gp2Alloc10101.bin");
    regFile_loader.bin_view;

    @(posedge sys_clk); // dummy delay
    for(int i=0; i<L1PA_REGFILE_PAGE_NUM; i++)
        regfile_write(L1PA_REGFILE_ADDR_WIDTH'(i), L1PA_REGFILE_PAGE_WIDTH'(i));

    repeat(5) @(posedge sys_clk); // dummy delay

    $display("\n=============================");
    regFile_loader.dut_mem_bin_view;

    tb_seq.scenarioGen_1seq_2seq_2seq;
    tb_seq.posedge_clk(1);
    rqst_addr_i = tb_seq.rqst_addr_1seq[0];

    tb_seq.posedge_clk(1);
    rqst_addr_i = tb_seq.rqst_addr_2seq[0];

    tb_seq.posedge_clk(1);
    rqst_addr_i = tb_seq.rqst_addr_2seq[1];
end

// Control of the simulation time span
initial begin
  tb_seq.posedge_clk(SIM_TIME);
  $finish;
end

always @(posedge sys_clk) $display("-------------------------> %b", rqst_addr_i);
dumpvars_config#(.FST_DUMP_EN(1), .VCD_DUMP_EN(0)) dumpvars_config;
args_config args_config;
endmodule
