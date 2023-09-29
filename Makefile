-include config.mk

# Tools
SBT         = sbt
SBTFLAGS   ?=

# Project definitions
TOPMOD      = Blinky
MAIN        = BlinkyMain

# Directories
SRCDIR      = $(CURDIR)/src/main/scala
TESTDIR     = $(CURDIR)/src/test/scala
RTLDIR      = $(CURDIR)/rtl
SYNTHDIR    = $(CURDIR)/synth
F4PGADIR    = $(CURDIR)/f4pga
DIRS        = $(SRCDIR) $(TESTDIR) $(RTLDIR)

# Sources
SRCS        = $(shell find $(SRCDIR) -name '*.scala')
TESTS       = $(shell find $(TESTDIR) -name '*.scala')

# Targets (configured in config.mk)
RTLFILE    ?= $(RTLDIR)/$(TOPMOD).sv
MAINTARGET ?= $(MAIN)
TESTTARGET ?= $(TOPMOD)
BOARD      ?= basys3

# F4PGA
F4PGA_INSTALL_DIR  ?= $(CURDIR)/f4pga/tools
F4PGA_EXAMPLES_DIR ?= $(CURDIR)/f4pga/f4pga-examples

# Generic target names
.PHONY: all
all: $(RTLFILE) test

.PHONY: rtl
rtl: $(RTLFILE)

# Generate SystemVerilog
$(RTLFILE): $(SRCS)
	$(SBT) $(SBTFLAGS) "runMain $(MAINTARGET)"

# Synthesize design
.PHONY: synth
synth: $(RTLFILE)
	$(MAKE) -C $(SYNTHDIR) synth BOARD=$(BOARD) TOPMOD=$(TOPMOD) RTLFILE=$(RTLFILE) F4PGA_INSTALL_DIR=$(F4PGA_INSTALL_DIR) F4PGA_EXAMPLES_DIR=$(F4PGA_EXAMPLES_DIR)

# Program FPGA
.PHONY: program
program: $(RTLFILE)
	$(MAKE) -C $(SYNTHDIR) program BOARD=$(BOARD) TOPMOD=$(TOPMOD) RTLFILE=$(RTLFILE) F4PGA_INSTALL_DIR=$(F4PGA_INSTALL_DIR) F4PGA_EXAMPLES_DIR=$(F4PGA_EXAMPLES_DIR)

# Run specific test
.PHONY: test
test: $(SRCS) $(TESTS)
	$(SBT) $(SBTFLAGS) testOnly "$(TESTTARGET)"

# Run all tests
.PHONY: testall
testall: $(SRCS) $(TESTS)
	$(SBT) $(SBTFLAGS) test

# Install synthesis tools
.PHONY: install
install:
	cd $(F4PGADIR) && ./install.sh

# Cleanup working directory
.PHONY: clean
clean:
	@echo "Cleaning workspace"
	$(RM) -rf $(RTLDIR) test_run_dir/ target/ project/target project/project
	$(MAKE) -C $(SYNTHDIR) BOARD=$(BOARD) F4PGA_EXAMPLES_DIR=$(F4PGA_EXAMPLES_DIR) clean

# For debugging Makefile
.PHONY: show
show:
	@echo 'SBT         :' $(SBT)
	@echo 'SBTFLAGS    :' $(SBTFLAGS)
	@echo 'MAIN        :' $(MAIN)
	@echo 'TOPMOD      :' $(TOPMOD)
	@echo 'SRCDIR      :' $(SRCDIR)
	@echo 'TESTDIR     :' $(TESTDIR)
	@echo 'RTLDIR      :' $(RTLDIR)
	@echo 'SYNTHDIR    :' $(SYNTHDIR)
	@echo 'F4PGADIR    :' $(F4PGADIR)
	@echo 'DIRS        :' $(DIRS)
	@echo 'SRCS        :' $(SRCS)
	@echo 'TESTS       :' $(TESTS)
	@echo 'RTLFILE     :' $(RTLFILE)
	@echo 'MAINTARGET  :' $(MAINTARGET)
	@echo 'TESTTARGET  :' $(TESTTARGET)
	@echo 'BOARD       :' $(BOARD)
