// Project: access_rqst_gen.memShare_sched
// File: memShare_delta_reset.sv
// Module: memShare_delta_reset
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
// The reset signal generator to the delta FF placed between
// the FSM states of READ_COL_ADDR and SHFIT_GEN.
// Note that the associated delta FF must be designed w/ a SYNCHRONOUS reset
//
// # Dependencies
// 	None
//
// # Resource utilisation:
// Xilinx:
//  6-input logic LUT: 
//  FF: 
// ----------------------------------------------------------------------------------------
//  # History
//  Date            Revision    Description                 Editor
//  31.March.2024   v0.01       First created               Bo-Yu Tseng
// ----------------------------------------------------------------------------------------
module memShare_delta_reset #(
    parameter logic RST_POLARITY = 1'b0 // 0: active LOW, 1: active HIGH
) (
    output logic reset_o, // synchrounous reset signal connected to the delta FF
    input logic isGtr_i, // isGtr obtainned from RFMU at SHFIT_GEN state
    input logic sys_clk,
    input logic rstn
);

always_ff @(posedge sys_clk) begin
    if(!rstn) reset_o <= RST_POLARITY;
    else reset_o <= reset_o^isGtr_i;
end
endmodule
