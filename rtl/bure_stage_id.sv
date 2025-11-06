`default_nettype none
module bure_stage_id 
  import cg_rvarch_instr_field_pkg::*;
  import bure_stage_interface_pkg::bure_if_interface;
  import bure_stage_interface_pkg::bure_id_interface;
#(
  parameter DATA_WIDTH  = 32,
  parameter INSTR_WIDTH = 32
)(
  input  logic i_clk,
  input  logic i_rstn,

  bure_if_interface.slave   if_if,
  bure_id_interface.master  if_id
);

  logic w_decode_valid;

  logic [2:0]             w_funct3;
  logic [6:0]             w_funct7;
  
  logic [4:0]             w_rs1_addr;
  logic [4:0]             w_rs2_addr;

  logic                   w_rd_wen;
  logic [4:0]             w_rd_addr;

  logic [DATA_WIDTH-1:0]  w_imm;

  logic                   w_is_imm_op;
  logic                   w_is_jump_op;
  logic                   w_is_branch_op;
  logic                   w_is_load_op;
  logic                   w_is_store_op;

  always_comb begin
    w_decode_valid  = if_if.instr_valid;

    w_funct3    = funct3(if_if.instr);
    w_funct7    = funct7(if_if.instr);

    // Op identifier
    w_is_imm_op     = is_imm_opcode(if_if.instr);
    w_is_jump_op    = is_jump_opcode(if_if.instr);
    w_is_branch_op  = is_branch_opcode(if_if.instr);
    w_is_load_op    = is_load_opcode(if_if.instr);
    w_is_store_op   = is_store_opcode(if_if.instr);

    // Deocode Source Register
    w_rs1_addr  = rs1(if_if.instr);
    w_rs2_addr  = rs2(if_if.instr);

    // Decode Destination Register
    w_rd_addr   = rd(if_if.instr);
    w_rd_wen    = is_rd_opcode(if_if.instr);

    // Decode Immediate
    w_imm       = get_imm(if_if.instr);
  end

  always_ff @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) begin
      if_id.decode_valid  <= 1'b0;
    end else begin
      if_id.decode_valid  <= w_decode_valid;
    end
  end

  always_ff @(posedge i_clk) begin
    if_id.funct3    <= w_funct3;
    if_id.funct7    <= w_funct7;
    if_id.rs1_addr  <= w_rs1_addr;
    if_id.rs2_addr  <= w_rs2_addr;
    if_id.rd_data   <= w_rd_data;
    if_id.rd_wen    <= w_rd_wen;
    if_id.imm       <= w_imm;

    if_id.is_imm_op     <= w_is_imm_op;
    if_id.is_jump_op    <= w_is_jump_op;
    if_id.is_branch_op  <= w_is_branch_op;
    if_id.is_load_op    <= w_is_load_op;
    if_id.is_store_op   <= w_is_store_op;
  end

endmodule
`default_nettype wire
