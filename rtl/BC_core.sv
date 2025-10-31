`default_nettype none
module BC_core #(
  parameter DATA_WIDTH  = 32,
  parameter DATA_WIDTH  = 32
)(
  CG_memory_interface.to_memory if_dmem,
  CG_memory_interface.to_memory if_imem
);

  localparam INSTR_WIDTH = 32;

  logic [INSTR_WIDTH-1:0] w_instr;
  logic                   w_instr_valid;

  BC_stage_if #(
    .DATA_WIDTH   (DATA_WIDTH   ),
    .ADDR_WIDTH   (ADDR_WIDTH   ),
    .INSTR_WIDTH  (INSTR_WIDTH  )
  ) instruction_fetch (
    .if_imem        (if_imem        ),
    .o_instr_valid  (w_instr_valid  ),
    .o_instr        (w_instr        )
  );

endmodule
`default_nettype wire
