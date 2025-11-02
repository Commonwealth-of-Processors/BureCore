`default_nettype none
module bure_stage_ex 
#(
  parameter DATA_WIDTH  = 32,
  parameter INSTR_WIDTH = 32
)(
  input  logic i_clk,
  input  logic i_rstn,

  input  logic i_decode_valid,

  input  logic [DATA_WIDTH-1:0] i_rs1_data,
  input  logic [DATA_WIDTH-1:0] i_rs2_data,

  output logic [DATA_WIDTH-1:0] o_ex_data
);

  bure_alu #(
    .DATA_WIDTH (DATA_WIDTH )
  ) alu (
    .i_funct3   (),
    .i_funct7   (),
    .i_data_rhs (),
    .i_data_lhs (),
    .o_data     ()
  );

  always_comb begin
  end

  always_ff @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) begin
    end else begin
    end
  end

  always_ff @(posedge i_clk) begin
  end

endmodule
`default_nettype wire
