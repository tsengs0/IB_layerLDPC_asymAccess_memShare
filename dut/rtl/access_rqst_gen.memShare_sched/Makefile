.PHONY: all

# RTL settings
RTL_FILELIST=./lint_rtl.f
RTL_SRC = $(shell cat ./lint_rtl.f)

HDL_COMPILER_CMD = verilator
VERILATOR_SRC_OPT = \
	-sv $(RTL_SRC) \
	--top memShare_control_wrapper \

VERILATOR_WAIVE_OPT = \
	-Wno-UNUSEDPARAM \
	-Wno-UNUSEDSIGNAL \

VERILATOR_LINT_OPT = \
	-lint-only -Wall \
	$(VERILATOR_SRC_OPT) \
	$(VERILATOR_WAIVE_OPT) \

VERILATOR_BUILD_OPT = \
		--assert \
		--binary \
		--timing \
		-o sim \
		-j 0 \
		$(VERILATOR_SRC_OPT) \
		$(VERILATOR_WAIVE_OPT) \

#----------------------------------------------------------------------
lint_check:
	$(HDL_COMPILER_CMD) $(VERILATOR_LINT_OPT)

build:
	$(HDL_COMPILER_CMD) $(VERILATOR_BUILD_OPT)

run:
	xsim $(TOP_MODULE) $(UVM_SIM_OPTION) $(VIVADO_SIM_OPTION)

clean:
	rm -rf obj_dir 