THIS_FILE := $(lastword $(MAKEFILE_LIST))

TARGET      := $(BOARD)
FPGA_FAM    := xc7
current_dir := ${CURDIR}
XDC         := $(current_dir)/$(TARGET).xdc
TOP         := $(TOPMOD)
SOURCES     := $(RTLFILE)

.ONESHELL:
SHELL = bash

.PHONY: synth
synth:
	export FPGA_FAM=$(FPGA_FAM)
	export F4PGA_INSTALL_DIR=$(F4PGA_INSTALL_DIR)
	source "${F4PGA_INSTALL_DIR}/xc7/conda/etc/profile.d/conda.sh"
	conda activate xc7
	$(MAKE) -f $(THIS_FILE) all


.PHONY: program
program:
	export FPGA_FAM=$(FPGA_FAM)
	export F4PGA_INSTALL_DIR=$(F4PGA_INSTALL_DIR)
	source "${F4PGA_INSTALL_DIR}/xc7/conda/etc/profile.d/conda.sh"
	conda activate xc7
	$(MAKE) -f $(THIS_FILE) download

include ${F4PGA_EXAMPLES_DIR}/common/common.mk
