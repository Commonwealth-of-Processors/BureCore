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

  bure_if_interface #(
    .DATA_WIDTH   (DATA_WIDTH   ),
    .ADDR_WIDTH   (ADDR_WIDTH   ),
    .INSTR_WIDTH  (INSTR_WIDTH  )
  ) if_if ();

  bure_id_interface #(
    .DATA_WIDTH   (DATA_WIDTH   ),
    .ADDR_WIDTH   (ADDR_WIDTH   ),
    .INSTR_WIDTH  (INSTR_WIDTH  )
  ) if_id ();

  bure_ex_interface #(
    .DATA_WIDTH   (DATA_WIDTH   ),
    .ADDR_WIDTH   (ADDR_WIDTH   ),
    .INSTR_WIDTH  (INSTR_WIDTH  )
  ) if_ex ();

  bure_mem_interface #(
    .DATA_WIDTH   (DATA_WIDTH   )
  ) if_mem ();

  bure_wb_interface #(
    .DATA_WIDTH   (DATA_WIDTH   )
  ) if_wb ();

  bure_stage_if #(
    .DATA_WIDTH   (DATA_WIDTH   ),
    .ADDR_WIDTH   (ADDR_WIDTH   ),
    .INSTR_WIDTH  (INSTR_WIDTH  )
  ) instruction_fetch (
    .i_clk    (),
    .i_rstn   (),

    .if_imem  (if_imem  ),
    .if_if    (if_if    )
  );

  bure_stage_id #(
    .DATA_WIDTH   (DATA_WIDTH   ),
    .INSTR_WIDTH  (INSTR_WIDTH  )
  ) instruction_decode (
    .i_clk    (i_clk  ),
    .i_rstn   (i_rstn ),

    .if_if    (if_if  ),
    .if_id    (if_id  )
  );

  bure_stage_ex #(
    .DATA_WIDTH   (DATA_WIDTH   ),
    .INSTR_WIDTH  (INSTR_WIDTH  )
  ) instruction_decode (
    .i_clk  (i_clk  ),
    .i_rstn (i_rstn ),

    .if_id  (if_id  )
    .if_ex  (if_ex  )
  );



endmodule
`default_nettype wire
