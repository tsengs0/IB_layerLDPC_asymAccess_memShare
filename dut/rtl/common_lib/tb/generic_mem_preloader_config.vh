`ifndef __GENERIC_MEM_PRELOADER_CONFIG_H
`define __GENERIC_MEM_PRELOADER_CONFIG_H

`define TB_PATH memShare_control_wrapper_tb

// Internal register file of the SCU.memShare()
`define DUT_MEM_PATH `TB_PATH.memShare_control_wrapper.memShare_regFile_wrapper.l1pa_regFile_unit0.lutMem_1bankX1port_regType0
`define DUT_MEM_CELL mem

// Message-Pass Buffer
`define MSGPASS_BUFF_PATH `TB_PATH.dmy_msgPass_buffer
`define MSGPASS_BUFF_MEM_CELL mem

`endif // __GENERIC_MEM_PRELOADER_CONFIG_H