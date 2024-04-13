 * Unit design for Information Bottleneck Layered LDPC decoder with asymmetric-access and shared memory mechanism

 ```bash
.
├── IB_LUT_cell
│   └── source
│       ├── LUTMEM_lib.v
│       ├── share2to5_dn_lut_3b.v
│       ├── share2to5_dn_lut_4b.v
│       ├── share2to5_vn_lut_3b.v
│       ├── share2to5_vn_lut_F0F1merge_3b.v
│       ├── share2to5_vn_lut_F0F1merge_4b.v
│       ├── sym_vn_lut.v
│       └── vn_lut_lib.v
├── access_rqst_gen.memShare_sched
│   └── source
│       ├── access_rqst_gen.v
│       ├── arbitration.v
│       ├── assign isColAddr_skid = (isSkid_ever == .sv
│       ├── memShare_centralScheduler.v
│       ├── memShare_control_wrapper.v
│       ├── memShare_delta_reset.sv
│       ├── memShare_mmu.v
│       ├── memShare_onehot2bin.v
│       ├── memShare_regFile_lib.v
│       ├── memShare_rfmu.v
│       ├── memShare_skidBuffer.sv
│       ├── mem_share_ctrl.v
│       ├── mem_share_inst.v
│       ├── mem_share_interconnect.v
│       ├── mem_share_top.v
│       ├── pend_queue.v
│       ├── rowAddrOffset_gen.v
│       ├── shareGroup_shiftCtrl_lib.v
│       └── skid_ctrl_gen.sv
├── channel_ram
│   └── ch_msg_ram.v
├── common_lib
│   ├── (ongoing)memBandwidth_extension.v
│   ├── mux_lib.v
│   └── pipeReg_insert.v
├── global_header
│   ├── define.vh
│   ├── due.vh
│   └── memShare_config.vh
├── lowend_partial_msgPass
│   ├── columnMultiSrc_L1Route.v
│   ├── columnSingleSrc_L1Route.v
│   ├── data_bus_combiner.v
│   ├── doc
│   │   └── quick_note
│   ├── lowend_partial_msgPass_wrapper.v
│   ├── msgPass2pageAlignIF.v
│   ├── qsn_bs.Pc_5.q3
│   │   ├── qsn_controller_pc5.v
│   │   ├── qsn_left_pc5.v
│   │   ├── qsn_merge_pc5.v
│   │   ├── qsn_right_pc5.v
│   │   └── qsn_top_pc5_q3.v
│   ├── qsn_bs.Pc_51.q3
│   │   ├── qsn_controller_pc51.v
│   │   ├── qsn_left_pc51.v
│   │   ├── qsn_merge_pc51.v
│   │   ├── qsn_right_pc51.v
│   │   └── qsn_top_pc51_q3.v
│   ├── simtest
│   │   ├── clean
│   │   ├── file.list
│   │   ├── gtk.tcl
│   │   ├── regression.sh
│   │   ├── run.do
│   │   ├── run.sh
│   │   ├── tb_partial_msgPass_wrapper.sv
│   │   └── v
│   └── testbench
│       └── tb_lowend_partial_msgPass_wrapper.sv
├── lowend_partial_msgPass.q4
│   ├── columnMultiSrc_L1Route.v
│   ├── columnSingleSrc_L1Route.v
│   ├── data_bus_combiner.v
│   ├── lowend_partial_msgPass_wrapper.v
│   ├── msgPass2pageAlignIF.v
│   ├── simtest
│   │   ├── clean
│   │   ├── file.list
│   │   ├── gtk.tcl
│   │   ├── regression.sh
│   │   ├── run.do
│   │   ├── run.sh
│   │   ├── tb_partial_msgPass_wrapper.sv
│   │   └── v
│   └── testbench
│       └── tb_lowend_partial_msgPass_wrapper.sv
├── page_alignment_lib
│   └── source
│       ├── due.v
│       ├── l2pa_logic.v
│       └── l2pa_mem.v
├── partial_msgPass
│   ├── columnMultiSrc_L1Route.v
│   ├── columnSingleSrc_L1Route.v
│   ├── data_bus_combiner.v
│   ├── msgPass2pageAlignIF.v
│   ├── partial_msgPass_wrapper.v
│   ├── qsn_bs.Pc_15.q3
│   │   ├── qsn_controller.v
│   │   ├── qsn_left.v
│   │   ├── qsn_merge.v
│   │   ├── qsn_right.v
│   │   └── qsn_top.v
│   ├── qsn_bs.Pc_15.q4
│   │   ├── qsn_controller.v
│   │   ├── qsn_left.v
│   │   ├── qsn_merge.v
│   │   ├── qsn_right.v
│   │   └── qsn_top.v
│   ├── qsn_bs.Pc_17.q3
│   │   ├── qsn_controller.v
│   │   ├── qsn_left.v
│   │   ├── qsn_merge.v
│   │   ├── qsn_right.v
│   │   └── qsn_top.v
│   ├── qsn_bs.Pc_17.q4
│   │   ├── permutation_wrapper.v
│   │   ├── qsn_controller.v
│   │   ├── qsn_left.v
│   │   ├── qsn_merge.v
│   │   ├── qsn_right.v
│   │   └── qsn_top.v
│   ├── qsn_bs.Pc_3.q3
│   │   ├── qsn_controller.v
│   │   ├── qsn_left.v
│   │   ├── qsn_merge.v
│   │   ├── qsn_right.v
│   │   └── qsn_top.v
│   ├── qsn_bs.Pc_3.q4
│   │   ├── qsn_controller.v
│   │   ├── qsn_left.v
│   │   ├── qsn_merge.v
│   │   ├── qsn_right.v
│   │   └── qsn_top.v
│   └── simtest
│       ├── clean
│       ├── file.list
│       ├── gtk.tcl
│       ├── regression.sh
│       ├── run.do
│       ├── run.sh
│       ├── tb_partial_msgPass_wrapper.sv
│       └── v
├── partial_vnu
│   └── quant.3bits
│       ├── dnu_f0.v
│       ├── mem_map.v
│       ├── mem_sys.v
│       ├── sym_dn_lut.v
│       ├── sym_dn_lut_out.v
│       ├── sym_dn_rank.v
│       ├── sym_vn_lut.v
│       ├── sym_vn_lut_in.v
│       ├── sym_vn_lut_internal.v
│       ├── sym_vn_lut_out.v
│       ├── sym_vn_rank.v
│       ├── vn_cascade_route.v
│       ├── vnu3_f0.v
│       └── vnu3_f1.v
├── shiftOffset_generator
│   ├── formal_verification
│   │   ├── cumulative_sol1_check.m
│   │   ├── cumulative_sol2_check.m
│   │   └── shiftOffset_gen_sol2.m
│   └── source
│       ├── cumulative_shift_gen.v
│       ├── due.v
│       ├── due.vh
│       ├── memShare_shfitOffset_gen.v
│       ├── micro_bs_gen.v
│       └── shiftOffset_gen_if.sv
├── simtest
│   ├── clean
│   ├── file.list
│   ├── gtk.tcl
│   ├── iter.log
│   ├── regression.sh
│   ├── run.do
│   ├── run.sh
│   ├── tb_extend_memOut_port.sv
│   └── v
├── system_wrapper
│   └── source
│       └── msgPass_subsystem_q4.v
├── testbench
│   └── partial_msgPass
│       └── tb_partial_msgPass.sv
└── tree.log

37 directories, 155 files
 ```
