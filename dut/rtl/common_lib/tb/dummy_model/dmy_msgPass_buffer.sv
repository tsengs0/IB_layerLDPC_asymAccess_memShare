// Clock gating is only applied on the read ports
module dmy_msgPass_buffer 
    import msgPass_config_pkg::*;
(
    // Status control
    output logic write_port_conflict_o, // 1: write Port A and B point to the same address

    // Read ports
    output logic [msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH-1:0] rdata_portA_o,
    output logic [msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH-1:0] rdata_portB_o,
    input logic [msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH-1:0] raddr_portA_i,
    input logic [msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH-1:0] raddr_portB_i,

    // Write ports
    input logic [msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH-1:0] wdata_portA_i,
    input logic [msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH-1:0] wdata_portB_i,
    input logic [msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH-1:0] waddr_portA_i,
    input logic [msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH-1:0] waddr_portB_i,

    input logic cen_i, // active LOW
    input logic read_clk_i,
    input logic write_clk_i,
    input logic wen_portA_i, // active LOW
    input logic wen_portB_i, // active LOW
    input rstn
);

localparam DATA_WIDTH = msgPass_config_pkg::MSGPASS_BUFF_RDATA_WIDTH;
logic [DATA_WIDTH-1:0] mem [0:msgPass_config_pkg::MSGPASS_BUFF_DEPTH-1] = '{default:'0};;
logic [DATA_WIDTH-1:0] wdata_portA_temp;
logic [DATA_WIDTH-1:0] wdata_portB_temp;
logic [DATA_WIDTH-1:0] rdata_portA_pipe0;
logic [DATA_WIDTH-1:0] rdata_portB_pipe0;
logic write_conflict;
logic read_gclk;
assign write_conflict = (
    waddr_portA_i == waddr_portB_i && 
    wen_portA_i==1'b0 && wen_portB_i==1'b0
) ? 1'b1 : 1'b0;
assign write_port_conflict_o = write_conflict;
assign read_gclk = read_clk_i & cen_i;
//-----------------------------------------------------------------------------------------------------
// Port A
//-----------------------------------------------------------------------------------------------------
// Read operation
always @(posedge read_gclk) begin
    if(wen_portA_i) rdata_portA_pipe0 <= mem[raddr_portA_i];
    else rdata_portA_pipe0 <= {DATA_WIDTH{1'b0}};
end
assign rdata_portA_o = rdata_portA_pipe0 & {(DATA_WIDTH){cen_i}};

// Write operation
// There is no internal conflict resolution circuitry.
// Therefore, two write operations (port A and B) to the same address will casue an unknown write data
always @(*) begin
    case({wen_portA_i, write_conflict})
        2'b00: wdata_portA_temp = wdata_portA_i;
        2'b01: wdata_portA_temp = {DATA_WIDTH{1'bx}};
        default: wdata_portA_temp = {DATA_WIDTH{1'bx}};
    endcase
end
always @(posedge write_clk_i) begin
    if(!wen_portA_i) mem[waddr_portA_i] = wdata_portA_temp;
end
//-----------------------------------------------------------------------------------------------------
// Port B
//-----------------------------------------------------------------------------------------------------
// Read operation
always @(posedge read_gclk) begin
    if(wen_portB_i) rdata_portB_pipe0 <= mem[raddr_portB_i];
    else rdata_portB_pipe0 <= {DATA_WIDTH{1'b0}};
end
assign rdata_portB_o = rdata_portB_pipe0 & {(DATA_WIDTH){cen_i}};

// Write operation
// There is no internal conflict resolution circuitry.
// Therefore, two write operations (port A and B) to the same address will casue an unknown write data
always @(*) begin
    case({wen_portA_i, write_conflict})
        2'b00: wdata_portA_temp = wdata_portA_i;
        2'b01: wdata_portA_temp = {DATA_WIDTH{1'bx}};
        default: wdata_portA_temp = {DATA_WIDTH{1'bx}};
    endcase
end
always @(posedge write_clk_i) begin
    if(!wen_portB_i) mem[waddr_portB_i] = wdata_portB_temp;
end
endmodule
