.PHONY: all

# RTL settings
DUT_FILELIST=./dotfile/dut_rtl.f
DUT_SRC = $(shell cat $(DUT_FILELIST))

# Testbench settings
TB_FILELIST=./dotfile/tb_rtl.f
TB_SRC = $(shell cat $(TB_FILELIST))
TB_TOP = memShare_control_wrapper_tb

# Verilator built env.
SIMV = obj_dir/sim # equivalaent to the "simv"

HDL_COMPILER_CMD = verilator
VERILATOR_SRC_OPT = \
	-sv $(DUT_SRC) \
	-sv $(TB_SRC) \
	--top $(TB_TOP) \

VERILATOR_WAIVE_OPT = \
	-Wno-UNUSEDPARAM \
	-Wno-UNUSEDSIGNAL \
        -Wno-PINMISSING \

VERILATOR_LINT_OPT = \
	-lint-only -Wall \
	-sv $(DUT_SRC) \
	--top memShare_control_wrapper \
	$(VERILATOR_WAIVE_OPT) \

VERILATOR_TRACE_FST_OPT = \
		--trace-fst \
		--trace-threads 4 \
		--trace-params \
		--trace-structs \
		--trace-underscore \

VERILATOR_TRACE_VCD_OPT = \
		--trace \
		--trace-threads 4 \
		--trace-params \
		--trace-structs \
		--trace-underscore \

VERILATOR_BUILD_OPT = \
		--assert \
		--binary \
		--timing \
		$(VERILATOR_TRACE_FST_OPT) \
		-o sim \
		-j 0 \
		$(VERILATOR_SRC_OPT) \
		$(VERILATOR_WAIVE_OPT) \
		$
#		--debug

VERILATOR_SIM_OPT = \
		+SIM_TIME=200 \
#----------------------------------------------------------------------
lint_check:
	$(HDL_COMPILER_CMD) $(VERILATOR_LINT_OPT)

build:
	$(HDL_COMPILER_CMD) $(VERILATOR_BUILD_OPT)

run:
	$(SIMV) $(VERILATOR_SIM_OPT) > log/$(TB_TOP).log

clean:
	rm -rf obj_dir log/*.log log/*.vcd log/*.fst
