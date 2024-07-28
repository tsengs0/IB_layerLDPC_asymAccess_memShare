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


interface sys_ctrl_if;
//logic sys_clk;
logic read_clk;
logic write_clk;
logic rstn; // acitve LOW
endinterface

interface vn_writeBack_if #(
    parameter V2C_VEC_WIDTH = 20
);
logic [V2C_VEC_WIDTH-1:0] v2c_msg_vec; // Intermediate/final V2C vector
endinterface

interface scu_memShare_l2pa_if;
import memShare_config_pkg::*;
logic [memShare_config_pkg::SHARE_GROUP_SIZE-1:0] shifted_v2c_sign_vec;
logic [memShare_config_pkg::MSGPASS_BUFF_ADDR_WIDTH-1:0] shifted_c2v_vec;
endinterface

interface ibLUT_rank_if #(
    // Choose the max(GP1_COL_SEL_WIDTH, GP2_COL_SEL_WIDTH) for each element in a rank
    // zero padding for GP1 element whilst exact fit for GP2 element
    parameter RANK_COL_ADDR_WIDTH = 10,
    parameter IBRAM_REMAP_VEC_WIDTH = 20   
);
logic [RANK_COL_ADDR_WIDTH-1:0] memShare_colSel_vec; // Bit width based on the 
logic [IBRAM_REMAP_VEC_WIDTH-1:0] remap_dataIn_vec;
logic nRemap_en_i; // active LOW
endinterface

`include "global_debug.vh"

module memShare_vn_group_tb;
import memShare_config_pkg::*;
import ibRAM_config_pkg::*;

//----------------------------------------------------------------
// Local variables, nets, parameters, I/Fs, tasks, functions, etc.
//----------------------------------------------------------------
localparam V2C_WIDTH = MSGPASS_BUFF_RQST_WIDTH;
localparam V2C_VEC_WIDTH = SHARE_GROUP_SIZE*V2C_WIDTH;
localparam C2V_WIDTH = MSGPASS_BUFF_RQST_WIDTH;
localparam C2V_VEC_WIDTH = SHARE_GROUP_SIZE*C2V_WIDTH;
localparam V2C_SIGN_BUF_DEPTH = 2;

// Choose the max(GP1_COL_SEL_WIDTH, GP2_COL_SEL_WIDTH) for each element in a rank
// zero padding for GP1 element whilst exact fit for GP2 element
localparam RANK_COL_ADDR_WIDTH = GP2_COL_SEL_WIDTH*SHARE_GROUP_SIZE;
localparam IBRAM_REMAP_VEC_WIDTH = QUAN_SIZE*SHARE_GROUP_SIZE;

generic_mem_preloader#(
    .PAGE_NUM(memShare_config_pkg::GP1_VN_LOAD_CYCLE),
    .PAGE_SIZE(V2C_WIDTH)
) gp1_ibram_loader;

generic_mem_preloader#(
    .PAGE_NUM(memShare_config_pkg::GP2_VN_LOAD_CYCLE),
    .PAGE_SIZE(V2C_WIDTH)
) gp2_ibram_loader;
scu_memShare_tb_class tb_lib;
scu_memShare_tb_seq_class tb_seq;
int SIM_TIME=200;
logic buffer_read_begin, buffer_read_end;
//----------------------------------------------------------------
// DUT's I/O ports
//----------------------------------------------------------------
sys_ctrl_if tb_sys_ctrl_if();
vn_writeBack_if #(.V2C_VEC_WIDTH(V2C_VEC_WIDTH)) tb_vn_writeBack_if();
scu_memShare_l2pa_if tb_scu_memShare_l2pa_if();
ibLUT_rank_if #(
    .RANK_COL_ADDR_WIDTH(RANK_COL_ADDR_WIDTH),
    .IBRAM_REMAP_VEC_WIDTH(IBRAM_REMAP_VEC_WIDTH)
) ibLUT_rank_if();

assign tb_sys_ctrl_if.read_clk = tb_sys_ctrl_if.sys_clk;
assign tb_sys_ctrl_if.write_clk = tb_sys_ctrl_if.sys_clk;
//----------------------------------------------------------------
// DUT
//----------------------------------------------------------------
memShare_vn_group # (
    .V2C_WIDTH(V2C_WIDTH),
    .V2C_VEC_WIDTH(V2C_VEC_WIDTH),
    .C2V_WIDTH(C2V_WIDTH),
    .C2V_VEC_WIDTH(C2V_VEC_WIDTH),
    .V2C_SIGN_BUF_DEPTH(V2C_SIGN_BUF_DEPTH),
    .RANK_COL_ADDR_WIDTH(RANK_COL_ADDR_WIDTH),
    .IBRAM_REMAP_VEC_WIDTH(IBRAM_REMAP_VEC_WIDTH)
) dut (
    .v2c_msg_vec_o (tb_vn_writeBack_if.v2c_msg_vec),

    .shifted_v2c_sign_vec_i (tb_scu_memShare_l2pa_if.shifted_v2c_sign_vec),
    .shifted_c2v_vec_i      (tb_scu_memShare_l2pa_if.shifted_c2v_vec),

    .memShare_colSel_vec_i (tb_ibLUT_rank_if.memShare_colSel_vec),
    .remap_dataIn_vec_i    (tb_ibLUT_rank_if.remap_dataIn_vec),
    .nRemap_en_i           (tb_ibLUT_rank_if.nRemap_en),

    .read_clk  (tb_sys_ctrl_if.read_clk),
    .write_clk (tb_sys_ctrl_if.write_clk),
    .rstn      (tb_sys_ctrl_if.rstn)
);
//----------------------------------------------------------------
// Dummy models
//----------------------------------------------------------------

//----------------------------------------------------------------
// Test Patterns
//----------------------------------------------------------------
// Common initialisation
task common_init;
    // IB-RAM loaders which contains the GP1 and GP2 configurations
    gp1_ibram_loader = new();
    gp2_ibram_loader = new();
//    tb_seq = new(tb_sys_ctrl_if, tb_msgPass_buff_if, tb_scu_memShare_if);


    gp1_ibram_loader.hex_load("")
  ib_ram_loader.bin_load("l1pa_spr_5_gp2Num3_gp2Alloc10101.bin");

  ib_ram_loader.bin_view;

  @(posedge tb_sys_ctrl_if.sys_clk); // dummy delay
  ib_ram_loader.dut_mem_bin_view;
endtask

task msgPass_buff_preload;
//    tb_seq.scenarioGen_1seq_2seq_2seq; // Generating the designated test sequece
//    tb_seq.scenarioLoad_1seq_2seq_2seq; // Loading the designated test sequence
//    tb_seq.scenarioGen_2seq_2seq; // Generating the designated test sequece
//    tb_seq.scenarioLoad_2seq_2seq; // Loading the designated test sequence
//    tb_seq.scenarioGen_1seq_1seq; // Generating the designated test sequece
//    tb_seq.scenarioLoad_1seq_1seq; // Loading the designated test sequence
    tb_seq.scenarioGen_2seq_1seq_2seq; // Generating the designated test sequece
    tb_seq.scenarioLoad_2seq_1seq_2seq; // Loading the designated test sequence

    tb_seq.posedge_clk(1);
    $display("\n=============================");
    $display("Message-Pass Buffer:");
    $display("Addr:\t\tValue [binary]");
    $display("=============================");
    for(int i=0; i<msgPass_config_pkg::MSGPASS_BUFF_DEPTH; i++) begin
      $display("0x%08h:\t%08h (%b)", i, dmy_msgPass_buffer.mem[i], dmy_msgPass_buffer.mem[i]);
    end
    $display("=============================");
endtask

initial begin
  tb_sys_ctrl_if.sys_clk = TB_CLK_INITIAL_LEVEL;
  forever #(TB_CLK_PERIOD/2) tb_sys_ctrl_if.sys_clk = ~tb_sys_ctrl_if.sys_clk;
end

initial begin
  tb_sys_ctrl_if.rstn = 1'b0;
    #(TB_CLK_PERIOD*10); tb_sys_ctrl_if.rstn = 1'b1;
end

initial begin
    common_init;

    @(posedge tb_sys_ctrl_if.sys_clk); // dummy delay
    regFile_loader.bypass_preload;
    repeat(5) @(posedge tb_sys_ctrl_if.sys_clk); // dummy delay

    $display("SCU.memShare()'s internal regFile preloading is completed.\n=============================");
    regFile_loader.dut_mem_bin_view;

    // Preload the 1seq-to-2seq-2se request pattern to the message-pass buffer
    msgPass_buff_preload;

    @(posedge tb_sys_ctrl_if.sys_clk) begin
        tb_scu_memShare_if.scu_memShare_busy_i <= 1'b1;
        buffer_read_begin <= 1'b1;
    end

    @(posedge tb_sys_ctrl_if.sys_clk) begin
        buffer_read_begin <= 1'b0;
    end
         
    wait(tb_msgPass_buff_if.raddr_portA_i==4);
    repeat(5) @(posedge tb_sys_ctrl_if.sys_clk);
    buffer_read_end = 1'b1;
    
    @(posedge tb_sys_ctrl_if.sys_clk) begin
        tb_scu_memShare_if.scu_memShare_busy_i <= 1'b0;
        buffer_read_end <= 1'b0;
    end
end

// Control of the simulation time span
initial begin
  tb_seq.posedge_clk(SIM_TIME);
  $finish;
end

always @(sysTick_record.sys_tick) $display("(%d cc) -------------------------> %b", sysTick_record.sys_tick, tb_scu_memShare_if.rqst_addr_i);
sysTick_record #(.SYSTICK_MAX_NUM(500)) sysTick_record(.tick_en_i(dmy_msgPass_addr_gen.bufferStart_once_pipe0), .sys_clk(tb_sys_ctrl_if.sys_clk), .rstn(tb_sys_ctrl_if.rstn));
//dumpvars_config#(.FST_DUMP_EN(1), .VCD_DUMP_EN(0)) dumpvars_config;
//args_config args_config;
endmodule
