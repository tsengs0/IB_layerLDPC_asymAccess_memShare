class scu_memShare_tb_seq_class;
import memShare_config_pkg::*;
import scu_memShare_tb_config_pkg::*;

typedef logic [SHARE_GROUP_SIZE-1:0][RQST_ADDR_BITWIDTH-1:0] rqst_addr_ws5_q3_t;
//rand rqst_addr_ws5_q3_t [9:0] rqst_addr_scenarios;
rqst_addr_ws5_q3_t [9:0] rqst_addr_1seq;
rqst_addr_ws5_q3_t [9:0] rqst_addr_2seq;
logic sys_clk;

int arrival_rqst_id;

task posedge_clk(input int cycle_num);
    if(TB_CLK_INITAL_LEVEL==1'b0)
        #(TB_CLK_DELAY + TB_CLK_PERIOD/2 + TB_CLK_PERIOD*cycle_num);
    else
        #(TB_CLK_DELAY+TB_CLK_PERIOD*cycle_num);
endtask

task negedge_clk(input int cycle_num);
    if(TB_CLK_INITAL_LEVEL==1'b0)
        #(TB_CLK_DELAY+TB_CLK_PERIOD*cycle_num);
    else
        #(TB_CLK_DELAY + TB_CLK_PERIOD/2 + TB_CLK_PERIOD*cycle_num);
endtask

task scenario_1seq_2seq_2seq (
    output logic [(RQST_ADDR_BITWIDTH*SHARE_GROUP_SIZE)-1:0] rqst_addr_o
);
    // Initial state
    rqst_addr_1seq[0] = {
        GP2_BANK0_ADDR,
        GP2_BANK1_ADDR,
        GP1_BANK0_ADDR,
        GP1_BANK0_ADDR,
        GP1_BANK1_ADDR
    };
    rqst_addr_2seq[0] = {(SHARE_GROUP_SIZE){GP2_BANK0_ADDR}};
    rqst_addr_2seq[1] = {(SHARE_GROUP_SIZE){GP2_BANK1_ADDR}};
    arrival_rqst_id = 0;
    sys_clk = memShare_control_wrapper_tb.sys_clk;    
    $display("-----> rqst_addr_1seq[0]: {0x%h, 0x%h, 0x%h, 0x%h, 0x%h}", rqst_addr_1seq[0][4], rqst_addr_1seq[0][3], rqst_addr_1seq[0][2], rqst_addr_1seq[0][1], rqst_addr_1seq[0][0]);
    $display("-----> rqst_addr_2seq[0]: {0x%h, 0x%h, 0x%h, 0x%h, 0x%h}", rqst_addr_2seq[0][4], rqst_addr_2seq[0][3], rqst_addr_2seq[0][2], rqst_addr_2seq[0][1], rqst_addr_2seq[0][0]);
    $display("-----> rqst_addr_2seq[1]: {0x%h, 0x%h, 0x%h, 0x%h, 0x%h}", rqst_addr_2seq[1][4], rqst_addr_2seq[1][3], rqst_addr_2seq[1][2], rqst_addr_2seq[1][1], rqst_addr_2seq[1][0]);
    
    posedge_clk(1);
    rqst_addr_o = rqst_addr_1seq[0];

    posedge_clk(1);
    rqst_addr_o = rqst_addr_2seq[0];

    posedge_clk(1);
    rqst_addr_o = rqst_addr_2seq[1];
endtask

endclass
