interface bure_if_interface #(
  parameter DATA_WIDTH  = 32,
  parameter ADDR_WIDTH  = 32,
  parameter INSTR_WIDTH = 32
)(
);
  logic [ADDR_WIDTH-1:0]  new_pc;
  logic                   prst;

  logic                   instr_valid;
  logic [INSTR_WIDTH-1:0] instr;

  modport master (
    input  new_pc,
    input  prst,

    output instr_valid,
    output instr
  );

  modport slave (
    output new_pc,
    output prst,

    input  instr_valid,
    input  instr
  );
endinterface

interface bure_id_interface #(
  parameter DATA_WIDTH  = 32,
  parameter INSTR_WIDTH = 32
)(
);
  logic                   decode_valid;

  // funct
  logic [2:0]             funct3;
  logic [6:0]             funct7;

  // Register
  logic [4:0]             rs1_addr;
  logic [4:0]             rs2_addr;
  logic                   rd_wen;
  logic [4:0]             rd_addr;

  logic [DATA_WIDTH-1:0]  rs1_data;
  logic [DATA_WIDTH-1:0]  rs2_data;

  // Immediate
  logic [DATA_WIDTH-1:0]  imm;

  // Op identifier
  logic                   is_imm_op;
  logic                   is_jump_op;
  logic                   is_branch_op;
  logic                   is_load_op;
  logic                   is_store_op;

  modport master (
    output decode_valid,

    output funct3,
    output funct7,

    output rs1_addr,
    output rs2_addr,
    output rd_wen,
    output rd_addr,

    output imm,

    output is_imm_op,
    output is_jump_op,
    output is_branch_op,
    output is_load_op,
    output is_store_op
  );

  modport slave (
    input  decode_valid,

    input  funct3,
    input  funct7,

    input  rs1_addr,
    input  rs2_addr,
    input  rd_wen,
    input  rd_addr,

    input  rs1_data,
    input  rs2_data,

    input  imm,

    input  is_imm_op,
    input  is_jump_op,
    input  is_branch_op,
    input  is_load_op,
    input  is_store_op
  );
endinterface

interface bure_ex_interface #(
  parameter DATA_WIDTH  = 32,
  parameter INSTR_WIDTH = 32
)(
);

  logic [4:0] rd_addr;
endinterface

interface bure_mem_interface #(
  parameter DATA_WIDTH  = 32
)(
);
endinterface

interface bure_wb_interface #(
  parameter DATA_WIDTH  = 32
)(
);
endinterface
