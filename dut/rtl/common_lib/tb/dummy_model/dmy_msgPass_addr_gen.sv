// Project: access_rqst_gen.memShare_sched
// File: dmy_msgPass_addr_gen.sv
// Module: dmy_msgPass_addr_gen
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
// Status: WIP
// # Description
//  A dummy model to simulate the read address generator of the message-pass buffer
//  which only bypasses the base addresses of the SCU.memShare()'s target memory region
//  to the output port.

//
// # Dependencies
// 	memShare_config_pkg.sv

// # Resource utilisation:
// Xilinx:
//  6-input logic LUT: synthesis not started
//  FF: synthesis not started
// ----------------------------------------------------------------------------------------
//  # History
//  Date            Revision    Description                 Editor
//  30.April.2024   v0.01       First created               Bo-Yu Tseng
// ----------------------------------------------------------------------------------------

module dmy_msgPass_addr_gen
    import msgPass_config_pkg::*;
    import memShare_config_pkg::*;
(
    output logic [msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH-1:0] addr_o,

    input logic [MEMSHARE_DRC_NUM-1:0] is_drc_i,
    input logic buffer_read_begin_i, // active HIGH, assertion type: pulse
    input logic buffer_read_end_i, // active HIGH, assertion type: pulse
//    input logic [msgPass_config_pkg::INCREMENT_SRC_SEL_WIDTH-1:0] incrementSrc_sel_i,
    input logic sys_clk,
    input logic rstn
);

//----------------------------------------------------------------
// Local variables, nets, parameters
//----------------------------------------------------------------
localparam ADDR_WIDTH = msgPass_config_pkg::MSGPASS_BUFF_ADDR_WIDTH;
localparam INCREMENT_VAL_WIDTH = memShare_config_pkg::MSGPASS_RD_ADDR_WIDTH;
logic gclk;

//----------------------------------------------------------------
// Clock gating: the underlying circuit does not work as long as
// the input signal, buffer_read_begin_i, is not asserted once
//----------------------------------------------------------------
logic bufferStart_once, bufferEnd_once, bufferStart_once_pipe0;
always @(posedge sys_clk) begin: bufferRdStart_once_latch
    if(!rstn) bufferStart_once <= 1'b0; 
    else if(buffer_read_end_i) bufferStart_once <= 1'b0;
    else if(buffer_read_begin_i) bufferStart_once <= 1'b1;
end
always @(posedge sys_clk) if(!rstn) bufferStart_once_pipe0 <= 0; else bufferStart_once_pipe0 <= bufferStart_once;
always @(posedge sys_clk) begin: bufferRdEnd_once_latch
    if(!rstn) bufferEnd_once <= 1'b0; 
    else if(buffer_read_begin_i) bufferEnd_once <= 1'b0;
    else if(buffer_read_end_i) bufferEnd_once <= 1'b1;
end
assign gclk = sys_clk & bufferStart_once & ~bufferEnd_once;
//----------------------------------------------------------------
// Operand A: base address
//----------------------------------------------------------------
logic [INCREMENT_VAL_WIDTH-1:0] base_addr;
//localparam ADDR_WIDTH = memShare_config_pkg::MSGPASS_RD_ADDR_WIDTH;
//localparam BASE_NUM = memShare_config_pkg::MSGPASS_BASEADDR_NUM;
//memShare_rqstAddr_rebase  memShare_rqstAddr_rebase (
//    .base_addr_o(base_addr_o),
//    .baseAddr_aggregation_i(baseAddr_aggregation_i),
//    .baseAddr_sel_i(baseAddr_sel_i),
//    .sys_clk(gclk),
//    .rstn(rstn)
//);
assign base_addr[INCREMENT_VAL_WIDTH-1:0] = 0; // dummy value for ease of the debugging
//----------------------------------------------------------------
// Operand B: incrementing value
//----------------------------------------------------------------
logic [INCREMENT_VAL_WIDTH-1:0] increment_val_net;
logic [INCREMENT_VAL_WIDTH-1:0] increment_val_mux;
logic [INCREMENT_VAL_WIDTH-1:0] increment_val_pipe0;
logic [INCREMENT_VAL_WIDTH-1:0] increment_src_vec [0:INCREMENT_SRC_NUM-1];
logic [INCREMENT_VAL_WIDTH-1:0] memShare_increment_val;
memShare_rqstAddr_ctrl  memShare_rqstAddr_ctrl (
    .increment_operand_o(memShare_increment_val),
//    .drc_base_addr_o(drc_base_addr_o),
    .msgPass_raddr_operand_i(increment_val_net),
    .is_drc_i(is_drc_i),
//    .scu_begin_i(scu_begin_i),
    .sys_clk(gclk),
    .rstn(rstn)
);

always @(*) begin: increment_logic
    increment_src_vec[0] = increment_val_pipe0 + 1'b1;
end
assign increment_src_vec[1] = memShare_increment_val;
assign increment_val_net[INCREMENT_VAL_WIDTH-1:0] = (is_drc_i[MEMSHARE_DRC1]==1'b1) ? increment_src_vec[1] : increment_src_vec[0];
assign increment_val_mux[INCREMENT_VAL_WIDTH-1:0] = (buffer_read_begin_i==1'b1 || bufferStart_once==1'b0 || bufferStart_once_pipe0==1'b0) ? {INCREMENT_VAL_WIDTH{1'b0}} : increment_val_net[INCREMENT_VAL_WIDTH-1:0];
always @(posedge gclk, negedge rstn) if(!rstn) increment_val_pipe0 <= 0; else increment_val_pipe0 <= increment_val_mux[INCREMENT_VAL_WIDTH-1:0];
//----------------------------------------------------------------
// Binary adder
//----------------------------------------------------------------
localparam int ADDR_ZERO_PAD_WIDTH = ADDR_WIDTH-INCREMENT_VAL_WIDTH;
generate;
if(ADDR_ZERO_PAD_WIDTH > 0)
    assign addr_o[ADDR_WIDTH-1:0] = {{ADDR_ZERO_PAD_WIDTH{1'b0}}, base_addr[INCREMENT_VAL_WIDTH-1:0]}+{{ADDR_ZERO_PAD_WIDTH{1'b0}}, increment_val_mux[INCREMENT_VAL_WIDTH-1:0]};
else // ADDR_ZERO_PAD_WIDTH==0, and ADDR_ZERO_PAD_WIDTH<0 should be prohibidded
    assign addr_o[ADDR_WIDTH-1:0] = base_addr[INCREMENT_VAL_WIDTH-1:0]+increment_val_mux[INCREMENT_VAL_WIDTH-1:0];
endgenerate
endmodule
