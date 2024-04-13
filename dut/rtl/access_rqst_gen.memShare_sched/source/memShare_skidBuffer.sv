// Project: access_rqst_gen.memShare_sched
// File: memShare_skidBuffer.sv
// Module: memShare_skidBuffer
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
//
// # I/F
// 1) Output:
//
// 2) Input:
//
// # Parameter
//
// # Description
// A skid buffer insetted in between "request flag generator (inst: accessRqstGen)"
// and the "shift ctrl register file (inst: memShare_rfmu+memShare_regFile_wrapper)".

// # Dependencies
// 	None

// # Resource utilisation:
// Xilinx:
//  6-input logic LUT: 1
//  FF: 4
// ----------------------------------------------------------------------------------------
//  # History
//  Date            Revision    Description                 Editor
//  24.March.2024   v0.01       First created               Bo-Yu Tseng
// ----------------------------------------------------------------------------------------
module memShare_skidBuffer #(
    parameter SHARE_GROUP_SIZE = 5 // // Number of requestors joining a share group
) (
    output logic [SHARE_GROUP_SIZE-1:0] share_rqstFlag_o,

    input logic [SHARE_GROUP_SIZE-1:0] share_rqstFlag_i, //! Request flags to shared group 2
    input logic isColAddr_skid_i, // Selector signal for the skid buffer
    input logic sys_clk,
    input logic rstn
);

localparam NOSKID = 1'b0;
localparam SKID = 1'b1;
logic [SHARE_GROUP_SIZE-1:0] skid_buffer;
always @(posedge sys_clk) begin
    if(!rstn) skid_buffer <= 0;
    else skid_buffer <= share_rqstFlag_i;
end
assign share_rqstFlag_o = (isColAddr_skid_i == NOSKID) ? share_rqstFlag_i : skid_buffer;
endmodule