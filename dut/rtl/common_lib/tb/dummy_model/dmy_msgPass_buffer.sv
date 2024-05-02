module dmu_msgPass_buffer 
    import msgPass_config_pkg::*;
(
    // Read ports
    output logic [msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH-1:0] rdata_portA_o,
    output logic [msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH-1:0] rdata_portB_o,
    input logic [msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH-1:0] raddr_portA_i,
    input logic [msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH-1:0] raddr_portB_i,

    // Write ports
    input logic [msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH-1:0] wdata_portA_o,
    input logic [msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH-1:0] wdata_portB_o,
    input logic [msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH-1:0] waddr_portA_i,
    input logic [msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH-1:0] waddr_portB_i,

    input logic read_clk_i,
    input logic write_clk_i,
    input rstn
);

endmodule
