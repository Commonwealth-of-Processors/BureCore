`default_nettype none
module bure_core #(
  parameter DATA_WIDTH  = 32,
  parameter DATA_WIDTH  = 32
)(
  input  logic i_clk,
  input  logic i_rstn,
  CG_memory_interface.to_memory if_dmem,
  CG_memory_interface.to_memory if_imem
);

  localparam INSTR_WIDTH = 32;

  logic [INSTR_WIDTH-1:0] w_instr;
  logic                   w_instr_valid;

  bure_stage_if #(
    .DATA_WIDTH   (DATA_WIDTH   ),
    .ADDR_WIDTH   (ADDR_WIDTH   ),
    .INSTR_WIDTH  (INSTR_WIDTH  )
  ) instruction_fetch (
    .i_clk          (),
    .i_rstn         (),
    .if_imem        (if_imem        ),

    .i_new_pc       (),
    .i_prst         (),

    .o_instr_valid  (w_instr_valid  ),
    .o_instr        (w_instr        )
  );

  bure_stage_id #(
    .DATA_WIDTH   (DATA_WIDTH   ),
    .INSTR_WIDTH  (INSTR_WIDTH  )
  ) instruction_decode (
    .i_clk          (),
    .i_rstn         (),

    .i_instr_valid  (w_instr_valid  ),
    .i_instr        (w_instr        ),

    o_decode_valid  (),
  );

endmodule
`default_nettype wire
