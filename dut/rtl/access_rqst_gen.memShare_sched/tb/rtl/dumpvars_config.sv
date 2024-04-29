`include "generic_mem_preloader_config.vh"

module dumpvars_config;
parameter FST_DUMP_EN = 1;
parameter VCD_DUMP_EN = 0;

generate;
if(FST_DUMP_EN==1) begin
    initial begin
        $dumpfile("log/scu_memShare_tb.fst");
        $dumpvars(10, memShare_control_wrapper_tb);
    end
end

if(VCD_DUMP_EN==1) begin
    initial begin
        $dumpfile("log/scu_memShare_tb.vcd");
        $dumpvars(10, memShare_control_wrapper_tb);
    end
end
endgenerate
endmodule
