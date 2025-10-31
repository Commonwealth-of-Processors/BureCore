BC_stage_if_tb:
	verilator --binary --trace --top-module BC_stage_if_tb ./CommonGoods/rtl/CG_counter.sv ./CommonGoods/rtl/CG_memory_interface.sv ./CommonGoods/rtl/CG_memory_beh.sv ./tb/BC_stage_if_tb.sv ./rtl/BC_stage_if.sv
	cd obj_dir ; ./VBC_stage_if_tb

view:
	gtkwave -A --rcvar 'fontname_signals Monospace 16' --rcvar 'fontname_waves Monospace 15' ./obj_dir/wave.vcd

clean:
	rm -r obj_dir

FILE := $(filter-out stat, $(MAKECMDGOALS))
ifeq ($(strip $(FILE)),)
  $(error Usage: make stat <your_source_file.sv>)
endif

YS_SCRIPT  = "read_verilog -sv $(FILE); hierarchy -auto-top; synth; stat"

.PHONY: stat

stat:
	@yosys -p $(YS_SCRIPT)
