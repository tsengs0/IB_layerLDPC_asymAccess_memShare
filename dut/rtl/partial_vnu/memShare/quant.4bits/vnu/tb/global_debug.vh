`ifndef __GLOBAL_DEBUG_H
`define __GLOBAL_DEBUG_H

//`define TB_DEBUG

//-----------------------------------------------------------------------------
// To enable one of preprocessors below accroding to the RTL simulator you use.
//-----------------------------------------------------------------------------
`define VIVADO_SIM
//`define VERILATOR_SIM

//-----------------------------------------------------------------------------
// Macros for the SVAs
//-----------------------------------------------------------------------------
`define DUT_ROOT memShare_control_wrapper_tb
`endif // __GLOBAL_DEBUG_H
