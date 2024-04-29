`include "generic_mem_preloader_config.vh"

module args_config;

initial begin
    if ($value$plusargs("SIM_TIME=%d", `TB_PATH.SIM_TIME))
      $display("SIM_TIME value is %d", `TB_PATH.SIM_TIME);
    else begin
      $display("+SIM_TIME= not found, the default SIM_TIME is thereby set to 100");
      `TB_PATH.SIM_TIME = 100;
    end
end
endmodule
