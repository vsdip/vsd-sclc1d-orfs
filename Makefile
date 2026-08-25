REPO_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
DESIGN_CONFIG ?= $(REPO_ROOT)/flow/designs/sclc1d/gcd/config.mk

OPENROAD_EXE ?= $(shell command -v openroad 2>/dev/null)
YOSYS_EXE ?= $(shell command -v yosys 2>/dev/null)
KLAYOUT_CMD ?= $(shell command -v klayout 2>/dev/null)

ORFS_ARGS := \
	DESIGN_CONFIG=$(DESIGN_CONFIG) \
	OPENROAD_EXE=$(OPENROAD_EXE) \
	YOSYS_EXE=$(YOSYS_EXE) \
	KLAYOUT_CMD=$(KLAYOUT_CMD)

.PHONY: install-pdk doctor gcd synth finish gds gui clean

install-pdk:
	@test -n "$(PDK_ZIP)" || \
		(echo "Usage: make install-pdk PDK_ZIP=/path/to/pdk.zip"; exit 1)
	@./scripts/install-pdk.sh "$(PDK_ZIP)"

doctor:
	@./scripts/doctor.sh

gcd: doctor
	$(MAKE) -C flow $(ORFS_ARGS)

synth: doctor
	$(MAKE) -C flow synth $(ORFS_ARGS)

finish: doctor
	$(MAKE) -C flow finish $(ORFS_ARGS) SKIP_REPORT_METRICS=1

gds: doctor
	$(MAKE) -C flow do-gds $(ORFS_ARGS)

gui: doctor
	$(MAKE) -C flow gui_final $(ORFS_ARGS)

clean:
	$(MAKE) -C flow clean_all $(ORFS_ARGS)
