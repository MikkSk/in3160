SIM ?= ghdl
TOPLEVEL_LANG ?= vhdl

# Use VHDL 2008
EXTRA_ARGS += --std=08

# Top-level VHDL entity
TOPLEVEL ?= decoder
ARCHITECTURE ?= case

# VHDL source files
VHDL_SOURCES += $(PWD)/../src/$(TOPLEVEL)_ent.vhd
VHDL_SOURCES += $(PWD)/../src/$(TOPLEVEL)_$(ARCHITECTURE).vhd

# Generate waveform
SIM_ARGS += --wave=$(TOPLEVEL).ghw

# Python test module
MODULE = tb_$(TOPLEVEL)_$(ARCHITECTURE)

# Include Cocotb rules
include $(shell cocotb-config --makefiles)/Makefile.sim

# Clean rule
clean::
	-@rm -f $(TOPLEVEL)
	-@rm -f e~$(TOPLEVEL).o

