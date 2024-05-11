class scu_memShare_tb_class;
import memShare_config_pkg::*;
import scu_memShare_tb_config_pkg::*;

// Virtual interfaces
virtual msgPass_buff_if msgPass_buff_vif;
virtual scu_memShare_if scu_memShare_vif;
virtual sys_ctrl_if sys_ctrl_vif;

// Constructor
function new(virtual sys_ctrl_if sys_ctrl_if_i, virtual msgPass_buff_if msgPass_buff_if_i, virtual scu_memShare_if scu_memShare_if_i);
    sys_ctrl_vif = sys_ctrl_if_i;
    msgPass_buff_vif = msgPass_buff_if_i;
    scu_memShare_vif = scu_memShare_if_i;
endfunction

task regfile_write (
    input logic [L1PA_REGFILE_ADDR_WIDTH-1:0] waddr_i,
    input logic [L1PA_REGFILE_PAGE_WIDTH-1:0] wdata_i
);
    @(posedge sys_ctrl_vif.sys_clk) begin
        scu_memShare_vif.regType0_we_i <= 1'b1;
        scu_memShare_vif.regType0_waddr_i <= waddr_i;
        scu_memShare_vif.regType0_wdata_i <= wdata_i;
    end
    
    @(posedge sys_ctrl_vif.sys_clk) begin
        scu_memShare_vif.regType0_we_i <= 1'b0;
    end
endtask
endclass
