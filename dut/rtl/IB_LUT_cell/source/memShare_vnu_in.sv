// Project: IB-RAM implementation for the IB-RAM column-bank sharing scheme
// File: memShare_vnu_in.sv
// Module: memShare_vnu_in
// Developer: Bo-Yu Tseng
// Email: tsengs0@gamil.com
//
// # Description
// A wrapper to realise the partial IB-RAM input component of a share group

// # Dependencies
// 	None

// # Resource utilisation:
// Xilinx:
//  6-input logic LUT: 
//  FF: 
// ----------------------------------------------------------------------------------------
//  # History
//  Date            Revision    Description                 Editor
//  9.June.2024   v0.01       First created               Bo-Yu Tseng
// ----------------------------------------------------------------------------------------

module memShare_vnu_in #(
    // Configuration of shared column
    parameter GROUP_NUM = 5, //! Shared group size
    parameter [GROUP_NUM-1:0] SHARE_COL_CONFIG = 5'b10101 //! '1': shared column
) (

);

endmodule