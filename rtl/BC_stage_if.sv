`default_nettype none
module BC_stage_if #(
  parameter DATA_WIDTH  = 32,
  parameter ADDR_WIDTH  = 32,
  parameter INSTR_WIDTH = 32
)(
  input  logic i_clk,
  input  logic i_rstn,

  CG_memory_interface.to_memory   if_imem,

  input  logic [ADDR_WIDTH-1:0]   i_new_pc,
  input  logic                    i_prst,

  output logic                    o_instr_valid,
  output logic [INSTR_WIDTH-1:0]  o_instr
);

  logic [DATA_WIDTH-1:0]  w_pc;

  CG_counter #(
    .DATA_WIDTH (ADDR_WIDTH )
  ) program_counter (
    .i_clk      (i_clk                ),
    .i_rstn     (i_rstn               ),
    .i_prst     (i_prst               ),
    .i_stop     (~if_imem.raddr_ready ),
    .i_default  (i_new_pc             ),
    .o_count    (w_pc                 )
  );

  always_comb begin
    // memory addr
    if_imem.raddr       = w_pc;
    if_imem.raddr_valid = i_rstn; // During reset, then signals is not valid
    if_imem.rdata_ready = 1'b1;

    // Not use
    if_imem.wen         = 1'b0;
    if_imem.wdata_valid = 1'b0;
    if_imem.waddr       = '0;
    if_imem.wdata       = '0;
  end

  always_ff @(posedge i_clk, negedge i_rstn) begin
    if(!i_rstn) begin
      o_instr_valid <= '0;
    end else if (!if_imem.raddr_ready) begin
      o_instr_valid <= '0;
    end else begin
      o_instr_valid <= if_imem.rdata_valid;
    end
  end

  always_ff @(posedge i_clk) begin
    if (!if_imem.raddr_ready) begin
      o_instr <= o_instr;
    end else begin
      o_instr <= if_imem.rdata;
    end
  end

endmodule
`default_nettype wire
