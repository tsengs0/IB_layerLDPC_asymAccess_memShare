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
//-----------------------------------------------------------------------------
// Read file (for sake of configuration, etc.)
//-----------------------------------------------------------------------------
`define gp2_ibram_preload_filename "memShare_ibram_prload/dec_iter_0/ib_ram_gp2_iter0_layer0_decompMerge2_baseDecomp0_quan4.hex"
`define gp1_ibram_preload_filename "memShare_ibram_prload/dec_iter_0/ib_ram_gp1_iter0_layer0_decompMerge2_baseDecomp0_quan4.hex"

`endif // __GLOBAL_DEBUG_H
