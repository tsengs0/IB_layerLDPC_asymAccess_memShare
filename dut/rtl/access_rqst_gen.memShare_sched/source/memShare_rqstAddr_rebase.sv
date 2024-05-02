// Project: access_rqst_gen.memShare_sched
// File: memShare_rqstAddr_rebase.sv
// Module: memShare_rqstAddr_rebase
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
// Status: WIP
// # Description
//  The design block to generate/redirect the base address of the message-pass buffer
//  which is corresponded to the request address of the SCU.memShare().

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
//  29.April.2024   v0.01       First created               Bo-Yu Tseng
// ----------------------------------------------------------------------------------------

module memShare_rqstAddr_rebase 
    import memShare_config_pkg::*;
(
    output logic [memShare_config_pkg::MSGPASS_RD_ADDR_WIDTH-1:0] base_addr_o,
    input logic [memShare_config_pkg::MSGPASS_BASEADDR_AGG-1:0] baseAddr_aggregation_i,
    input logic [$clog2(memShare_config_pkg::MSGPASS_BASEADDR_NUM)-1:0] baseAddr_sel_i,
    input logic sys_clk,
    input logic rstn
);

localparam ADDR_WIDTH = memShare_config_pkg::MSGPASS_RD_ADDR_WIDTH;
localparam BASE_NUM = memShare_config_pkg::MSGPASS_BASEADDR_NUM;
logic [ADDR_WIDTH-1:0] baseAddr_pipe0 [0:BASE_NUM-1];
logic [$clog2(BASE_NUM)-1:0] base_sel_pipe0;
genvar i;
generate;
for(i=0; i<BASE_NUM; i=i+1) begin: baseAddr_buffer_vec
    always @(posedge sys_clk) begin
        if(!rstn) base_addr_buffer[i] <= 0;
        else baseAddr_pipe0[i] = baseAddr_aggregation_i[(i+1)*ADDR_WIDTH-1:i*ADDR_WIDTH];
    end
end
endgenerate
always @(posedge sys_clk) if(!rstn) base_sel_pipe0 <= 0; else base_sel_pipe0 <= baseAddr_sel_i;

assign base_addr_o[ADDR_WIDTH-1:0] = baseAddr_pipe0[base_sel_pipe0];
endmodule
