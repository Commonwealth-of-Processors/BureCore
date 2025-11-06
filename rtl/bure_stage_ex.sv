`default_nettype none
module bure_stage_ex #(
  parameter DATA_WIDTH  = 32,
  parameter INSTR_WIDTH = 32
)(
  input  logic i_clk,
  input  logic i_rstn,

  bure_id_interface.slave   if_id,
  bure_ex_interface.master  if_ex
);

  logic [DATA_WIDTH-1:0]  w_data_rhs;
  logic [DATA_WIDTH-1:0]  w_alu_data;

  bure_alu #(
    .DATA_WIDTH (DATA_WIDTH )
  ) alu (
    .i_force_add(if_id.is_imm_op),
    .i_funct3   (if_id.funct3   ),
    .i_funct7   (if_id.funct7   ),
    .i_data_rhs (w_data_rhs     ),
    .i_data_lhs (if_id.rs1_data ),
    .o_data     (w_alu_data     )
  );

  always_comb begin
    w_data_rhs  = if_id.is_imm_op ? if_id.imm : if_id.rs2_data;
  end

  always_ff @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) begin
    end else begin
    end
  end

  always_ff @(posedge i_clk) begin
    if_ex.execute_valid <= if_id.decode_valid;
  end

endmodule
`default_nettype wire
