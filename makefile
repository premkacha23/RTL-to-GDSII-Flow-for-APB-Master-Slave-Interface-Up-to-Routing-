# Makefile for Physical Design Flow using OpenROAD

OPENROAD = openroad
DESIGN = apb

# Step TCL scripts
FLOORPLAN_TCL = floor.tcl
PLACEMENT_TCL = place.tcl
CTS_TCL       = cts.tcl
ROUTING_TCL   = route.tcl

# Output directories
RESULTS_DIR = results
LOGS_DIR = logs

# Output DEF files
FLOORPLAN_DEF = $(RESULTS_DIR)/floor.odb
PLACEMENT_DEF = $(RESULTS_DIR)/place.odb
CTS_DEF       = $(RESULTS_DIR)/cts.odb
ROUTED_DEF    = $(RESULTS_DIR)/route.odb

# Targets
.PHONY: all floorplan placement cts routing clean

all: floorplan placement cts routing

floorplan:
	@echo "Running Floorplan..."
	mkdir -p $(RESULTS_DIR) $(LOGS_DIR)
	$(OPENROAD)  floor.tcl | tee $(LOGS_DIR)/floorplan.log

placement: $(FLOORPLAN_DEF)
	@echo "Running Placement..."
	$(OPENROAD)  place.tcl | tee $(LOGS_DIR)/placement.log

cts: $(PLACEMENT_DEF)
	@echo "Running Clock Tree Synthesis..."
	$(OPENROAD) cts.tcl | tee $(LOGS_DIR)/cts.log

routing: $(CTS_DEF)
	@echo "Running Routing..."
	$(OPENROAD) route.tcl | tee $(LOGS_DIR)/routing.log

clean:
	@echo "Cleaning output files..."
	rm -rf $(RESULTS_DIR)/* $(LOGS_DIR)/*

