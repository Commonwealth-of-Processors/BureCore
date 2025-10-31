`default_nettype none
module BC_stage_id 
  import CG_rvarch_instr_field_pkg::*;
#(
  parameter DATA_WIDTH  = 32,
  parameter INSTR_WIDTH = 32
)(
  input  logic i_clk,
  input  logic i_rstn,

  input  logic                    i_instr_valid,
  input  logic [INSTR_WIDTH-1:0]  i_instr,

  output logic                    o_decode_valid,

  output logic [4:0]            o_rs1_addr,
  output logic [4:0]            o_rs2_addr,
  input  logic [DATA_WIDTH-1:0] i_rs1_data,
  input  logic [DATA_WIDTH-1:0] i_rs2_data,

  output logic [DATA_WIDTH-1:0] o_rs1_data,
  output logic [DATA_WIDTH-1:0] o_rs2_data,
  output logic                  o_rd_wen,
  output logic [4:0]            o_rd_addr,

  output logic                  o_branch_ignit
);

  logic w_decode_valid;

  logic [DATA_WIDTH-1:0]  w_rs1_data;
  logic [DATA_WIDTH-1:0]  w_rs2_data;
  logic                   w_rd_wen;
  logic [4:0]             w_rd_addr;

  logic w_branch_ignit;

  always_comb begin
    w_decode_valid  = i_instr_valid;

    // Read Source Register
    o_rs1_addr  = rs1(i_instr);
    o_rs2_addr  = rs2(i_instr);
    w_rs1_data  = i_rs1_data;
    w_rs2_data  = i_rs2_data;

    // Decode Destination Register
    w_rd_addr   = rd(i_instr);
    w_rd_wen    = is_rd_opcode(i_instr);

    // Instant Branch Check
    if (is_branch_opcode(i_instr)) begin
      case(funct3(i_instr))
        3'b000 : begin
          w_branch_ignit  = i_rs1_data == i_rs2_data;
        end
        3'b001 : begin
          w_branch_ignit  = i_rs1_data != i_rs2_data;
        end
        default :begin
          w_branch_ignit  = 1'b0;
        end
      endcase
    end else begin
      w_branch_ignit  = 1'b0;
    end
  end

  always_ff @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) begin
      o_decode_valid  <= 1'b0;
    end else begin
      o_decode_valid  <= w_decode_valid;
    end
  end

  always_ff @(posedge i_clk) begin
    o_rs1_data      <= w_rs1_data;
    o_rs2_data      <= w_rs2_data;
    o_rd_data       <= w_rd_data;
    o_rd_wen        <= w_rd_wen;
    o_branch_ignit  <= w_branch_ignit;
  end

endmodule
`default_nettype wire
