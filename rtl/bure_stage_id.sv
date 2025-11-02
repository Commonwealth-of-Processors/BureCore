`default_nettype none
module bure_stage_id 
  import cg_rvarch_instr_field_pkg::*;
#(
  parameter DATA_WIDTH  = 32,
  parameter INSTR_WIDTH = 32
)(
  input  logic i_clk,
  input  logic i_rstn,

  input  logic                    i_instr_valid,
  input  logic [INSTR_WIDTH-1:0]  i_instr,

  output logic                    o_decode_valid,

  // funct
  output logic [2:0]              o_funct3,
  output logic [6:0]              o_funct7,

  // Register
  output logic [4:0]              o_rs1_addr,
  output logic [4:0]              o_rs2_addr,
  output logic                    o_rd_wen,
  output logic [4:0]              o_rd_addr,

  // Immediate
  output logic [DATA_WIDTH-1:0]   o_imm,

  // Op identifier
  output logic                    o_is_imm_op,
  output logic                    o_is_jump_op,
  output logic                    o_is_branch_op,
  output logic                    o_is_load_op,
  output logic                    o_is_store_op
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
    w_decode_valid  = i_instr_valid;

    w_funct3    = funct3(i_instr);
    w_funct7    = funct7(i_instr);

    // Op identifier
    w_is_imm_op     = is_imm_opcode(i_instr);
    w_is_jump_op    = is_jump_opcode(i_instr);
    w_is_branch_op  = is_branch_opcode(i_instr);
    w_is_load_op    = is_load_opcode(i_instr);
    w_is_store_op   = is_store_opcode(i_instr);

    // Deocode Source Register
    w_rs1_addr  = rs1(i_instr);
    w_rs2_addr  = rs2(i_instr);

    // Decode Destination Register
    w_rd_addr   = rd(i_instr);
    w_rd_wen    = is_rd_opcode(i_instr);

    // Decode Immediate
    w_imm       = get_imm(i_instr);
  end

  always_ff @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) begin
      o_decode_valid  <= 1'b0;
    end else begin
      o_decode_valid  <= w_decode_valid;
    end
  end

  always_ff @(posedge i_clk) begin
    o_funct3    <= w_funct3;
    o_funct7    <= w_funct7;
    o_rs1_addr  <= w_rs1_addr;
    o_rs2_addr  <= w_rs2_addr;
    o_rd_data   <= w_rd_data;
    o_rd_wen    <= w_rd_wen;
    o_imm       <= w_imm;

    o_is_imm_op     <= w_is_imm_op;
    o_is_jump_op    <= w_is_jump_op;
    o_is_branch_op  <= w_is_branch_op;
    o_is_load_op    <= w_is_load_op;
    o_is_store_op   <= w_is_store_op;
  end

endmodule
`default_nettype wire
