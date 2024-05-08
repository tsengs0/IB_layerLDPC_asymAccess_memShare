`define rqstAddr_mag_convert(addr_o, addr_i) \
    genvar i; \
    generate; \
      for(i=0; i<SHARE_GROUP_SIZE; i=i+1) begin: msgPass_addr_mag \
        assign addr_o[ \
                  (i+1)*memShare_config_pkg::RQST_ADDR_BITWIDTH-1: \
                  i*memShare_config_pkg::RQST_ADDR_BITWIDTH \
        ] = addr_i[ \
                  (i+1)*memShare_config_pkg::MSGPASS_BUFF_RQST_WIDTH-2: \
                  i*memShare_config_pkg::MSGPASS_BUFF_RQST_WIDTH \
            ]; \
    end \
    endgenerate \

interface scu_memShare_if;
import memShare_config_pkg::*;

//--------------
// Port 0
//--------------
// Access-request generator
logic [memShare_config_pkg::MEMSHARE_DRC_NUM-1:0] is_drc_o;
logic [(memShare_config_pkg::RQST_ADDR_BITWIDTH*memShare_config_pkg::SHARE_GROUP_SIZE)-1:0] rqst_addr_i;
logic [memShare_config_pkg::RQST_MODE_BITWIDTH-1:0] modeSet_i;
logic scu_memShare_busy_i;
// L1PA regFile-mapping unit
logic [$clog2(memShare_config_pkg::SHARE_GROUP_SIZE)-1:0] l1pa_shift_o; //! shift control instructing the L1PA
logic isGtr_o; //! 1: currently accessed L1PA_SPR is the last pattern in the chosen L1PA shift sequence
// L1PA register file
logic [memShare_config_pkg::L1PA_REGFILE_ADDR_WIDTH-1:0] regType0_waddr_i;
logic [memShare_config_pkg::L1PA_REGFILE_PAGE_WIDTH-1:0] regType0_wdata_i;
logic regType0_we_i;
endinterface

interface msgPass_buff_if;
import memShare_config_pkg::*;

// Status control
logic write_port_conflict_o; // 1: write Port A and B point to the same address

// Read ports
logic [msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH-1:0] rdata_portA_o;
logic [msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH-1:0] rdata_portB_o;
logic [msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH-1:0] raddr_portA_i;
logic [msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH-1:0] raddr_portB_i;

// Write ports
logic [msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH-1:0] wdata_portA_i;
logic [msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH-1:0] wdata_portB_i;
logic [msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH-1:0] waddr_portA_i;
logic [msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH-1:0] waddr_portB_i;

logic wen_portA_i; // active LOW
logic wen_portB_i; // active LOW
endinterface


`include "global_debug.vh"

module memShare_control_wrapper_tb;
import msgPass_config_pkg::*;
import memShare_config_pkg::*;
import scu_memShare_tb_config_pkg::*;

//----------------------------------------------------------------
// Local variables, nets, parameters, I/F, etc.
//----------------------------------------------------------------
msgPass_buff_if msgPass_buff_if();
logic sys_clk;
logic rstn;

//----------------------------------------------------------------
// DUT's I/O ports
//----------------------------------------------------------------
scu_memShare_if scu_memShare_if();

//----------------------------------------------------------------
// Local variables, nets, parameters, I/Fs, tasks, functions, etc.
//----------------------------------------------------------------
`include "scu_memShare_tb_class.sv"
generic_mem_preloader#(.PAGE_NUM(L1PA_REGFILE_PAGE_NUM), .PAGE_SIZE(L1PA_REGFILE_PAGE_WIDTH)) regFile_loader;
//msgPass_buffer_preloader#(.PAGE_NUM(MSGPASS_BUFF_DEPTH), .PAGE_SIZE(MSGPASS_BUFF_RDATA_WIDTH)) msgPass_buffer_loader;
scu_memShare_tb_seq_class tb_seq;
int SIM_TIME=200;
logic buffer_read_begin, buffer_read_end;
//----------------------------------------------------------------
// DUT
//----------------------------------------------------------------
memShare_control_wrapper memShare_control_wrapper (
  .is_drc_o (scu_memShare_if.is_drc_o),
  .rqst_addr_i(scu_memShare_if.rqst_addr_i),
  .modeSet_i(scu_memShare_if.modeSet_i),
  .scu_memShare_busy_i(scu_memShare_if.scu_memShare_busy_i),
  .l1pa_shift_o(scu_memShare_if.l1pa_shift_o),
  .isGtr_o(scu_memShare_if.isGtr_o),
  .regType0_waddr_i(scu_memShare_if.regType0_waddr_i),
  .regType0_wdata_i(scu_memShare_if.regType0_wdata_i),
  .regType0_we_i(scu_memShare_if.regType0_we_i),
  .rstn(rstn),
  .sys_clk(sys_clk)
);
`rqstAddr_mag_convert(scu_memShare_if.rqst_addr_i, msgPass_buff_if.rdata_portA_o);
//----------------------------------------------------------------
// Dummy models
//----------------------------------------------------------------
localparam MSGPASS_BUFF_WR_ENABLE = 1'b0;
localparam MSGPASS_BUFF_WR_DISABLE = 1'b1;
dmy_msgPass_buffer  dmy_msgPass_buffer (
//    .write_port_conflict_o(write_port_conflict_o),
    .rdata_portA_o(msgPass_buff_if.rdata_portA_o),
//    .rdata_portB_o(rdata_portB_o),
    .raddr_portA_i(msgPass_buff_if.raddr_portA_i),
//    .raddr_portB_i(raddr_portB_i),
    .wdata_portA_i(msgPass_buff_if.wdata_portA_i),
//    .wdata_portB_i(wdata_portB_i),
    .waddr_portA_i(msgPass_buff_if.waddr_portA_i),
 //   .waddr_portB_i(msgPass_buff_if.waddr_portB_i),
    .read_clk_i(sys_clk),
    .write_clk_i(sys_clk),
    .wen_portA_i(msgPass_buff_if.wen_portA_i),
    .wen_portB_i(MSGPASS_BUFF_WR_DISABLE),
    .rstn(rstn)
);

dmy_msgPass_addr_gen  dmy_msgPass_addr_gen (
    .addr_o(msgPass_buff_if.raddr_portA_i),
    .is_drc_i(scu_memShare_if.is_drc_o),
  //  .incrementSrc_sel_i(incrementSrc_sel_i),
    .buffer_read_begin_i (buffer_read_begin),
    .buffer_read_end_i (buffer_read_end),
    .sys_clk(sys_clk),
    .rstn(rstn)
);
//----------------------------------------------------------------
// Test Patterns
//----------------------------------------------------------------
// Common initialisation
task common_init;
  regFile_loader = new();
//  msgPass_buffer_loader = new();
  tb_seq = new();
 
  scu_memShare_if.scu_memShare_busy_i = 1'b0;
  msgPass_buff_if.wen_portA_i = MSGPASS_BUFF_WR_DISABLE;
  buffer_read_begin = 1'b0;
  buffer_read_end = 1'b0;
`ifdef VERILATOR_SIM
  regFile_loader.bin_load("tb/config/l1pa_spr_5_gp2Num3_gp2Alloc10101.bin");
`endif // VERILATOR_SIM

`ifdef VIVADO_SIM
  regFile_loader.bin_load("l1pa_spr_5_gp2Num3_gp2Alloc10101.bin");
`endif // VIVADO_SIM

  regFile_loader.bin_view;

  @(posedge sys_clk); // dummy delay
  for(int i=0; i<L1PA_REGFILE_PAGE_NUM; i++)
      regfile_write(L1PA_REGFILE_ADDR_WIDTH'(i), L1PA_REGFILE_PAGE_WIDTH'(i));
  @(posedge sys_clk); // dummy delay
  regFile_loader.dut_mem_bin_view;
endtask

task msgPass_buff_preload;
    msgPass_buff_if.wen_portA_i = MSGPASS_BUFF_WR_ENABLE;
    //tb_seq.posedge_clk(1);
    @(posedge sys_clk) begin
        msgPass_buff_if.waddr_portA_i <= 0;
        msgPass_buff_if.wdata_portA_i <= tb_seq.msgPassBuff_rdata_1seq[0];
    end
    
    //tb_seq.posedge_clk(1);
    @(posedge sys_clk) begin
        msgPass_buff_if.waddr_portA_i <= 1;
        msgPass_buff_if.wdata_portA_i <= tb_seq.msgPassBuff_rdata_2seq[0];
    end
    
    //tb_seq.posedge_clk(1);
    @(posedge sys_clk) begin
        msgPass_buff_if.waddr_portA_i <= 2;
        msgPass_buff_if.wdata_portA_i <= tb_seq.msgPassBuff_rdata_2seq[1];
    end
    
    // The following patterns are treated as error margin of the testbench
    //tb_seq.posedge_clk(1);
    @(posedge sys_clk) begin
        msgPass_buff_if.waddr_portA_i <= {(msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH){1'bx}};
        msgPass_buff_if.wdata_portA_i <= tb_seq.msgPassBuff_rdata_1seq[0];
    end
    
    //tb_seq.posedge_clk(1);
    @(posedge sys_clk) begin
        msgPass_buff_if.waddr_portA_i <= {(msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH){1'bx}};
        msgPass_buff_if.wdata_portA_i <= tb_seq.msgPassBuff_rdata_1seq[0];
    end

    //tb_seq.posedge_clk(1);
    @(posedge sys_clk) begin
        msgPass_buff_if.wen_portA_i <= MSGPASS_BUFF_WR_DISABLE;
    end

    tb_seq.posedge_clk(1);
    $display("Message-Pass Buffer:");
    $display("Addr:\t\tValue [binary]");
    $display("=============================");
    for(int i=0; i<msgPass_config_pkg::MSGPASS_BUFF_DEPTH; i++) begin
      $display("0x%08h:\t%08h (%b)", i, dmy_msgPass_buffer.mem[i], dmy_msgPass_buffer.mem[i]);
    end
    $display("=============================");
endtask

initial begin
    sys_clk = TB_CLK_INITIAL_LEVEL;
    forever #(TB_CLK_PERIOD/2) sys_clk = ~sys_clk;
end

initial begin
    rstn = 1'b0;
    #(TB_CLK_PERIOD*10); rstn = 1'b1;
end

initial begin
    common_init;

    @(posedge sys_clk); // dummy delay
    regFile_loader.bypass_preload;
    repeat(5) @(posedge sys_clk); // dummy delay

    $display("\SCU.memShare()'s internal regFile preloading is completed.\n=============================");
    regFile_loader.dut_mem_bin_view;

    tb_seq.scenarioGen_1seq_2seq_2seq;

    // Preload the 1seq-to-2seq-2se request pattern to the message-pass buffer
    msgPass_buff_preload;

    @(posedge sys_clk) begin
        scu_memShare_if.scu_memShare_busy_i <= 1'b1;
        buffer_read_begin <= 1'b1;
    end

    @(posedge sys_clk);
    buffer_read_begin = #1 1'b0;
     
    wait(msgPass_buff_if.raddr_portA_i==4);
    repeat(5) @(posedge sys_clk);
    buffer_read_end = 1'b1;
    
    @(posedge sys_clk) begin
        scu_memShare_if.scu_memShare_busy_i <= 1'b0;
        buffer_read_end <= 1'b0;
    end
end

// Control of the simulation time span
initial begin
  tb_seq.posedge_clk(SIM_TIME);
  $finish;
end

always @(sysTick_record.sys_tick) $display("(%d cc) -------------------------> %b", sysTick_record.sys_tick, scu_memShare_if.rqst_addr_i);
sysTick_record #(.SYSTICK_MAX_NUM(500)) sysTick_record(.sys_clk(sys_clk), .rstn(rstn));
//dumpvars_config#(.FST_DUMP_EN(1), .VCD_DUMP_EN(0)) dumpvars_config;
//args_config args_config;
endmodule
