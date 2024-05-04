task regfile_write (
    input logic [L1PA_REGFILE_ADDR_WIDTH-1:0] waddr_i,
    input logic [L1PA_REGFILE_PAGE_WIDTH-1:0] wdata_i
);
    @(posedge sys_clk);
    scu_memShare_if.regType0_we_i = 1'b1;
    scu_memShare_if.regType0_waddr_i = waddr_i;
    scu_memShare_if.regType0_wdata_i = wdata_i;

    @(posedge sys_clk);
    scu_memShare_if.regType0_we_i = 1'b0;
endtask
