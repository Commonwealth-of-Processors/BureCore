`default_nettype none
module bure_alu 
  import cg_rvarch_instr_field_pkg::*;
#(
  parameter DATA_WIDTH  = 32
)(
  input  logic                  i_force_add,
  input  logic [2:0]            i_funct3,
  input  logic [6:0]            i_funct7,
  input  logic [DATA_WIDTH-1:0] i_data_rhs,
  input  logic [DATA_WIDTH-1:0] i_data_lhs,
  output logic [DATA_WIDTH-1:0] o_data
);

  logic [DATA_WIDTH-1:0]  w_add_data;
  logic [DATA_WIDTH-1:0]  w_and_data;
  logic [DATA_WIDTH-1:0]  w_or_data;
  logic [DATA_WIDTH-1:0]  w_slt_data;
  logic [DATA_WIDTH-1:0]  w_sltu_data;
  logic [DATA_WIDTH-1:0]  w_sra_data;
  logic [DATA_WIDTH-1:0]  w_sll_data;
  logic [DATA_WIDTH-1:0]  w_srl_data;
  logic [DATA_WIDTH-1:0]  w_sub_data;
  logic [DATA_WIDTH-1:0]  w_xor_data;

  always_comb begin
    if (i_force_add) begin
      // make address for load and store
      o_data  = w_add_data;
    end else begin
      case(i_funct3)
        FUNCT3_ADD_SUB  : begin
          case(i_funct7)
            7'b0100000  : o_data  = w_sub_data;
            default     : o_data  = w_add_data;
          endcase
        end
        FUNCT3_SLL      : o_data  = w_sll_data; 
        FUNCT3_SLT      : o_data  = w_slt_data;
        FUNCT3_SLTU     : o_data  = w_sltu_data;
        FUNCT3_XOR      : o_data  = w_xor_data;
        FUNCT3_SRL_SRA  : begin
          case(i_funct7)
            7'b0100000  : o_data  = w_sra_data;
            default     : o_data  = w_srl_data;
          endcase
        end
        FUNCT3_OR       : o_data  = w_or_data;
        FUNCT3_AND      : o_data  = w_and_data;
        default         : o_data  = '0;
      endcase
    end
  end

  cg_adder #(
    .DATA_WIDTH (DATA_WIDTH )
  ) alu_add (
    .i_data_rhs (i_data_rhs ),
    .i_data_lhs (i_data_lhs ),
    .o_data     (w_add_data )
  );

  cg_and #(
    .DATA_WIDTH (DATA_WIDTH )
  ) alu_and (
    .i_data_rhs (i_data_rhs ),
    .i_data_lhs (i_data_lhs ),
    .o_data     (w_and_data )
  );

  cg_or #(
    .DATA_WIDTH (DATA_WIDTH )
  ) alu_or (
    .i_data_rhs (i_data_rhs ),
    .i_data_lhs (i_data_lhs ),
    .o_data     (w_or_data  )
  );

  cg_set_less_than #(
    .DATA_WIDTH (DATA_WIDTH )
  ) alu_slt (
    .i_data_rhs (i_data_rhs ),
    .i_data_lhs (i_data_lhs ),
    .o_data     (w_slt_data )
  );

  cg_set_less_than_unsigned #(
    .DATA_WIDTH (DATA_WIDTH )
  ) alu_sltu (
    .i_data_rhs (i_data_rhs ),
    .i_data_lhs (i_data_lhs ),
    .o_data     (w_sltu_data)
  );

  cg_shifter_arithmetic_right #(
    .DATA_WIDTH (DATA_WIDTH )
  ) alu_sra (
    .i_data_rhs (i_data_rhs ),
    .i_data_lhs (i_data_lhs ),
    .o_data     (w_sra_data )
  );

  cg_shifter_logical_left #(
    .DATA_WIDTH (DATA_WIDTH )
  ) alu_sll (
    .i_data_rhs (i_data_rhs ),
    .i_data_lhs (i_data_lhs ),
    .o_data     (w_sll_data )
  );

  cg_shifter_logical_right #(
    .DATA_WIDTH (DATA_WIDTH )
  ) alu_srl (
    .i_data_rhs (i_data_rhs ),
    .i_data_lhs (i_data_lhs ),
    .o_data     (w_srl_data )
  );

  cg_subtractor #(
    .DATA_WIDTH (DATA_WIDTH )
  ) alu_sub (
    .i_data_rhs (i_data_rhs ),
    .i_data_lhs (i_data_lhs ),
    .o_data     (w_sub_data )
  );

  cg_xor #(
    .DATA_WIDTH (DATA_WIDTH )
  ) alu_xor (
    .i_data_rhs (i_data_rhs ),
    .i_data_lhs (i_data_lhs ),
    .o_data     (w_xor_data )
  );

endmodule
`default_nettype wire
