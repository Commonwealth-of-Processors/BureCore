bure_stage_if_tb:
	verilator --binary --trace --top-module bure_stage_if_tb ./CommonGoods/rtl/cg_counter.sv ./CommonGoods/rtl/cg_memory_interface.sv ./CommonGoods/rtl/cg_memory_beh.sv ./tb/bure_stage_if_tb.sv ./rtl/bure_stage_if.sv
	cd obj_dir ; ./Vbure_stage_if_tb

bure_stage_id_tb:
	verilator --binary --trace --top-module bure_stage_id_tb ./CommonGoods/rtl/cg_rvarch_instr_pkg.sv ./rtl/bure_stage_interface.sv ./rtl/bure_stage_id.sv ./tb/bure_stage_id_tb.sv
	cd obj_dir ; ./Vbure_stage_id_tb

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
