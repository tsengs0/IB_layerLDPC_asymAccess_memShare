class scu_memShare_tb_seq_class;
import memShare_config_pkg::*;
import scu_memShare_tb_config_pkg::*;

// Virtual interfaces
virtual msgPass_buff_if msgPass_buff_vif;
virtual scu_memShare_if scu_memShare_vif;
virtual sys_ctrl_if sys_ctrl_vif;

// Internal signals
typedef logic [SHARE_GROUP_SIZE-1:0][MSGPASS_BUFF_RQST_WIDTH-1:0] msgPassBuff_rdata_ws5_q3_t;
typedef logic [SHARE_GROUP_SIZE-1:0][RQST_ADDR_BITWIDTH-1:0] rqst_addr_ws5_q3_t;
//rand rqst_addr_ws5_q3_t [9:0] rqst_addr_scenarios;
msgPassBuff_rdata_ws5_q3_t [SHARE_GROUP_SIZE*RQST_ADDR_BITWIDTH-1:0] msgPassBuff_rdata_1seq;
msgPassBuff_rdata_ws5_q3_t [SHARE_GROUP_SIZE*RQST_ADDR_BITWIDTH-1:0] msgPassBuff_rdata_2seq;
rqst_addr_ws5_q3_t [SHARE_GROUP_SIZE*RQST_ADDR_BITWIDTH-1:0] rqst_addr_1seq;
rqst_addr_ws5_q3_t [SHARE_GROUP_SIZE*RQST_ADDR_BITWIDTH-1:0] rqst_addr_2seq;
int arrival_rqst_id;

// Constructor
function new(virtual sys_ctrl_if sys_ctrl_if_i, virtual msgPass_buff_if msgPass_buff_if_i, virtual scu_memShare_if scu_memShare_if_i);
    sys_ctrl_vif = sys_ctrl_if_i;
    msgPass_buff_vif = msgPass_buff_if_i;
    scu_memShare_vif = scu_memShare_if_i;
endfunction

task posedge_clk(input int cycle_num);
    #(TB_CLK_DELAY+TB_CLK_PERIOD*cycle_num);
endtask

task negedge_clk(input int cycle_num);
    #(TB_CLK_DELAY + TB_CLK_PERIOD/2 + TB_CLK_PERIOD*cycle_num);
endtask
//----------------------------------------------------------------------------
// Generation of the test sequence: 1seq-to-2seq-to-2seq
//----------------------------------------------------------------------------
task scenarioGen_1seq_2seq_2seq;
    // Initial state
    msgPassBuff_rdata_1seq[0] = {
        {1'b0, GP2_BANK0_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP2_BANK1_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP1_BANK0_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP1_BANK0_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP1_BANK1_ADDR}  // Signed bit (MSB) is an X value
    };
    rqst_addr_1seq[0] = {
        GP2_BANK0_ADDR,
        GP2_BANK1_ADDR,
        GP1_BANK0_ADDR,
        GP1_BANK0_ADDR,
        GP1_BANK1_ADDR
    };

    msgPassBuff_rdata_2seq[0] = {(SHARE_GROUP_SIZE){1'b0, GP2_BANK0_ADDR}};
    msgPassBuff_rdata_2seq[1] = {(SHARE_GROUP_SIZE){1'b0, GP2_BANK1_ADDR}};
    rqst_addr_2seq[0] = {(SHARE_GROUP_SIZE){GP2_BANK0_ADDR}};
    rqst_addr_2seq[1] = {(SHARE_GROUP_SIZE){GP2_BANK1_ADDR}};
    arrival_rqst_id = 0;
    $display("-----> rqst_addr_1seq[0]: {0x%h, 0x%h, 0x%h, 0x%h, 0x%h}", rqst_addr_1seq[0][4], rqst_addr_1seq[0][3], rqst_addr_1seq[0][2], rqst_addr_1seq[0][1], rqst_addr_1seq[0][0]);
    $display("-----> rqst_addr_2seq[0]: {0x%h, 0x%h, 0x%h, 0x%h, 0x%h}", rqst_addr_2seq[0][4], rqst_addr_2seq[0][3], rqst_addr_2seq[0][2], rqst_addr_2seq[0][1], rqst_addr_2seq[0][0]);
    $display("-----> rqst_addr_2seq[1]: {0x%h, 0x%h, 0x%h, 0x%h, 0x%h}", rqst_addr_2seq[1][4], rqst_addr_2seq[1][3], rqst_addr_2seq[1][2], rqst_addr_2seq[1][1], rqst_addr_2seq[1][0]);
endtask
//----------------------------------------------------------------------------
// To load the test sequence, 1seq-to-2seq-to-2seq, into the message-pass buffer
//----------------------------------------------------------------------------
task scenarioLoad_1seq_2seq_2seq;
    msgPass_buff_vif.wen_portA_i = MSGPASS_BUFF_WR_ENABLE;
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= 0;
        msgPass_buff_vif.wdata_portA_i <= msgPassBuff_rdata_1seq[0];
    end
    
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= 1;
        msgPass_buff_vif.wdata_portA_i <= msgPassBuff_rdata_2seq[0];
    end
    
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= 2;
        msgPass_buff_vif.wdata_portA_i <= msgPassBuff_rdata_2seq[1];
    end
    
    // The following patterns are treated as error margin of the testbench
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= {(msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH){1'bx}};
        msgPass_buff_vif.wdata_portA_i <= msgPassBuff_rdata_1seq[0];
    end

    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= {(msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH){1'bx}};
        msgPass_buff_vif.wdata_portA_i <= msgPassBuff_rdata_1seq[0];
    end
    
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.wen_portA_i <= MSGPASS_BUFF_WR_DISABLE;
    end
endtask
//----------------------------------------------------------------------------
// Generation of the test sequence: 2seq-to-2seq
//----------------------------------------------------------------------------
task scenarioGen_2seq_2seq;
    // Initial state
    msgPassBuff_rdata_1seq[0] = {
        {1'b0, GP2_BANK0_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP2_BANK1_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP1_BANK0_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP1_BANK0_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP1_BANK1_ADDR}  // Signed bit (MSB) is an X value
    };
    rqst_addr_1seq[0] = {
        GP2_BANK0_ADDR,
        GP2_BANK1_ADDR,
        GP1_BANK0_ADDR,
        GP1_BANK0_ADDR,
        GP1_BANK1_ADDR
    };

    msgPassBuff_rdata_2seq[0] = {(SHARE_GROUP_SIZE){1'b0, GP2_BANK0_ADDR}};
    msgPassBuff_rdata_2seq[1] = {(SHARE_GROUP_SIZE){1'b0, GP2_BANK1_ADDR}};
    rqst_addr_2seq[0] = {(SHARE_GROUP_SIZE){GP2_BANK0_ADDR}};
    rqst_addr_2seq[1] = {(SHARE_GROUP_SIZE){GP2_BANK1_ADDR}};
    arrival_rqst_id = 0;
    $display("-----> rqst_addr_2seq[0]: {0x%h, 0x%h, 0x%h, 0x%h, 0x%h}", rqst_addr_2seq[0][4], rqst_addr_2seq[0][3], rqst_addr_2seq[0][2], rqst_addr_2seq[0][1], rqst_addr_2seq[0][0]);
    $display("-----> rqst_addr_2seq[1]: {0x%h, 0x%h, 0x%h, 0x%h, 0x%h}", rqst_addr_2seq[1][4], rqst_addr_2seq[1][3], rqst_addr_2seq[1][2], rqst_addr_2seq[1][1], rqst_addr_2seq[1][0]);
endtask
//----------------------------------------------------------------------------
// To load the test sequence, 2seq-to-2seq, into the message-pass buffer
//----------------------------------------------------------------------------
task scenarioLoad_2seq_2seq;
    msgPass_buff_vif.wen_portA_i = MSGPASS_BUFF_WR_ENABLE;
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= 0;
        msgPass_buff_vif.wdata_portA_i <= msgPassBuff_rdata_2seq[0];
    end
    
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= 1;
        msgPass_buff_vif.wdata_portA_i <= msgPassBuff_rdata_2seq[1];
    end
    
    // The following patterns are treated as error margin of the testbench
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= 2;
        msgPass_buff_vif.wdata_portA_i <= {(msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH){1'bx}};
    end

    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= 3;
        msgPass_buff_vif.wdata_portA_i <= {(msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH){1'bx}};
    end

    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= 4;
        msgPass_buff_vif.wdata_portA_i <= {(msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH){1'bx}};
    end
    
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.wen_portA_i <= MSGPASS_BUFF_WR_DISABLE;
    end
endtask
//----------------------------------------------------------------------------
// Generation of the test sequence: 1seq-to-1seq
//----------------------------------------------------------------------------
task scenarioGen_1seq_1seq;
    // Initial state
    msgPassBuff_rdata_1seq[0] = {
        {1'b0, GP2_BANK0_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP2_BANK1_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP1_BANK0_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP1_BANK0_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP1_BANK1_ADDR}  // Signed bit (MSB) is an X value
    };
    rqst_addr_1seq[0] = {
        GP2_BANK0_ADDR,
        GP2_BANK1_ADDR,
        GP1_BANK0_ADDR,
        GP1_BANK0_ADDR,
        GP1_BANK1_ADDR
    };
    msgPassBuff_rdata_1seq[1] = {
        {1'b0, GP1_BANK0_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP2_BANK1_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP2_BANK0_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP1_BANK0_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP1_BANK1_ADDR}  // Signed bit (MSB) is an X value
    };
    rqst_addr_1seq[1] = {
        GP1_BANK0_ADDR,
        GP2_BANK1_ADDR,
        GP2_BANK0_ADDR,
        GP1_BANK0_ADDR,
        GP1_BANK1_ADDR
    };


    msgPassBuff_rdata_2seq[0] = {(SHARE_GROUP_SIZE){1'b0, GP2_BANK0_ADDR}};
    msgPassBuff_rdata_2seq[1] = {(SHARE_GROUP_SIZE){1'b0, GP2_BANK1_ADDR}};
    rqst_addr_2seq[0] = {(SHARE_GROUP_SIZE){GP2_BANK0_ADDR}};
    rqst_addr_2seq[1] = {(SHARE_GROUP_SIZE){GP2_BANK1_ADDR}};
    arrival_rqst_id = 0;
    $display("-----> rqst_addr_1seq[0]: {0x%h, 0x%h, 0x%h, 0x%h, 0x%h}", rqst_addr_1seq[0][4], rqst_addr_1seq[0][3], rqst_addr_1seq[0][2], rqst_addr_1seq[0][1], rqst_addr_1seq[0][0]);
    $display("-----> rqst_addr_1seq[1]: {0x%h, 0x%h, 0x%h, 0x%h, 0x%h}", rqst_addr_1seq[1][4], rqst_addr_1seq[1][3], rqst_addr_1seq[1][2], rqst_addr_1seq[1][1], rqst_addr_1seq[1][0]);
endtask
//----------------------------------------------------------------------------
// To load the test sequence, 1seq-to-1seq, into the message-pass buffer
//----------------------------------------------------------------------------
task scenarioLoad_1seq_1seq;
    msgPass_buff_vif.wen_portA_i = MSGPASS_BUFF_WR_ENABLE;
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= 0;
        msgPass_buff_vif.wdata_portA_i <= msgPassBuff_rdata_1seq[0];
    end
    
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= 1;
        msgPass_buff_vif.wdata_portA_i <= msgPassBuff_rdata_1seq[1];
    end
    
    // The following patterns are treated as error margin of the testbench
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= 2;
        msgPass_buff_vif.wdata_portA_i <= {(msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH){1'bx}};
    end

    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= 3;
        msgPass_buff_vif.wdata_portA_i <= {(msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH){1'bx}};
    end

    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= 4;
        msgPass_buff_vif.wdata_portA_i <= {(msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH){1'bx}};
    end
    
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.wen_portA_i <= MSGPASS_BUFF_WR_DISABLE;
    end
endtask
//----------------------------------------------------------------------------
// Generation of the test sequence: 2seq-to-1seq-to-2seq
//----------------------------------------------------------------------------
task scenarioGen_2seq_1seq_2seq;
    // Initial state
    msgPassBuff_rdata_1seq[0] = {
        {1'b0, GP1_BANK0_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP2_BANK1_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP2_BANK0_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP1_BANK0_ADDR}, // Signed bit (MSB) is an X value
        {1'b0, GP1_BANK1_ADDR}  // Signed bit (MSB) is an X value
    };
    rqst_addr_1seq[0] = {
        GP1_BANK0_ADDR,
        GP2_BANK1_ADDR,
        GP2_BANK0_ADDR,
        GP1_BANK0_ADDR,
        GP1_BANK1_ADDR
    };

    msgPassBuff_rdata_2seq[0] = {(SHARE_GROUP_SIZE){1'b0, GP2_BANK0_ADDR}};
    msgPassBuff_rdata_2seq[1] = {(SHARE_GROUP_SIZE){1'b0, GP2_BANK1_ADDR}};
    rqst_addr_2seq[0] = {(SHARE_GROUP_SIZE){GP2_BANK0_ADDR}};
    rqst_addr_2seq[1] = {(SHARE_GROUP_SIZE){GP2_BANK1_ADDR}};
    arrival_rqst_id = 0;
    $display("-----> rqst_addr_1seq[0]: {0x%h, 0x%h, 0x%h, 0x%h, 0x%h}", rqst_addr_1seq[0][4], rqst_addr_1seq[0][3], rqst_addr_1seq[0][2], rqst_addr_1seq[0][1], rqst_addr_1seq[0][0]);
    $display("-----> rqst_addr_2seq[0]: {0x%h, 0x%h, 0x%h, 0x%h, 0x%h}", rqst_addr_2seq[0][4], rqst_addr_2seq[0][3], rqst_addr_2seq[0][2], rqst_addr_2seq[0][1], rqst_addr_2seq[0][0]);
    $display("-----> rqst_addr_2seq[1]: {0x%h, 0x%h, 0x%h, 0x%h, 0x%h}", rqst_addr_2seq[1][4], rqst_addr_2seq[1][3], rqst_addr_2seq[1][2], rqst_addr_2seq[1][1], rqst_addr_2seq[1][0]);
endtask
//----------------------------------------------------------------------------
// To load the test sequence, 2seq-to-1seq-to-2seq, into the message-pass buffer
//----------------------------------------------------------------------------
task scenarioLoad_2seq_1seq_2seq;
    msgPass_buff_vif.wen_portA_i = MSGPASS_BUFF_WR_ENABLE;
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= 0;
        msgPass_buff_vif.wdata_portA_i <= msgPassBuff_rdata_2seq[0];
    end
    
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= 1;
        msgPass_buff_vif.wdata_portA_i <= msgPassBuff_rdata_1seq[0];
    end
    
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= 2;
        msgPass_buff_vif.wdata_portA_i <= msgPassBuff_rdata_2seq[1];
    end
    
    // The following patterns are treated as error margin of the testbench
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= {(msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH){1'bx}};
        msgPass_buff_vif.wdata_portA_i <= msgPassBuff_rdata_1seq[0];
    end

    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.waddr_portA_i <= {(msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH){1'bx}};
        msgPass_buff_vif.wdata_portA_i <= msgPassBuff_rdata_1seq[0];
    end
    
    @(posedge sys_ctrl_vif.sys_clk) begin
        msgPass_buff_vif.wen_portA_i <= MSGPASS_BUFF_WR_DISABLE;
    end
endtask
endclass
