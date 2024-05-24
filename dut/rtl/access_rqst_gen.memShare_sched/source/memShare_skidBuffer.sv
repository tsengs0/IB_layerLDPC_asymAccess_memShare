// Project: access_rqst_gen.memShare_sched
// File: memShare_skidBuffer.sv
// Module: memShare_skidBuffer
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
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
    input logic update_mask_i, // To disable the buffer update, active HIGH
    input logic sys_clk,
    input logic rstn
);

localparam NOSKID = 1'b0;
localparam SKID = 1'b1;
logic [SHARE_GROUP_SIZE-1:0] skid_buffer [0:1];
//always @(posedge sys_clk) begin
//    if(!rstn) skid_buffer <= 0;
//    else skid_buffer <= share_rqstFlag_i;
//end

always @(posedge sys_clk) begin
    if(!rstn) begin
        skid_buffer[0] <= 0;
        skid_buffer[1] <= 0;
    end
    else if(update_mask_i) begin
        skid_buffer[0] <= skid_buffer[0];
        skid_buffer[1] <= skid_buffer[1];
    end
    else begin
        skid_buffer[0] <= share_rqstFlag_i;
        skid_buffer[1] <= skid_buffer[0];
    end
end

logic temp; always @(posedge sys_clk) if(!rstn) temp<=0; else temp<=isColAddr_skid_i;
assign share_rqstFlag_o = (isColAddr_skid_i == NOSKID && temp != SKID) ? share_rqstFlag_i : skid_buffer[0];
endmodule
