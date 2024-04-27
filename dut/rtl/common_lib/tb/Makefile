TOP ?= tb_syntax_test
# Only used for Surfer, because it does not support adding signals from the
# top-most module.

SRC ?= $(wildcard *.sv)
# Source files

default: run

SIM_MODEL = obj_dir/sim

$(SIM_MODEL): $(SRC)
	@verilator \
		-MAKEFLAGS '-s' \
		--assert \
		--binary \
		--timing \
		--trace-fst \
		-o sim \
		-j 0 \
		$^
# Creates the simulation model

run: $(SIM_MODEL)
	$(SIM_MODEL)
# Executes the model

.PRECIOUS: signals.fst
# Avoid deletion if there is an assertion error during simulation run which
# could trip the waveform viewer.


### Surfer
vis: signals.fst cmds.txt
	surfer $< -c cmds.txt
# Visualizes the signals.

cmds.txt: makefile
	@echo scope_add TOP.$(TOP) > $@


### GTKWave
visg: signals.fst
	gtkwave -A $<
# Visualizes the signals.
# If signals.gtkw is provided as a Gtkwave save file, it will be read.


clean::
	rm -rf obj_dir
	rm -f signals.fst cmds.txt
