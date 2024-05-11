package scu_memShare_tb_config_pkg;

localparam TB_CLK_DELAY = 0; // Delay from the starting point
localparam TB_CLK_PERIOD = 10;
localparam logic TB_CLK_INITIAL_LEVEL = 1'b0;

// Testbench settings for the message-pass buffer
localparam MSGPASS_BUFF_WR_ENABLE = 1'b0;
localparam MSGPASS_BUFF_WR_DISABLE = 1'b1;
endpackage: scu_memShare_tb_config_pkg
