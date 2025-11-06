`default_nettype none
module bure_stage_if 
  import bure_stage_interface_pkg::bure_if_interface;
#(
  parameter DATA_WIDTH  = 32,
  parameter ADDR_WIDTH  = 32,
  parameter INSTR_WIDTH = 32
)(
  input  logic i_clk,
  input  logic i_rstn,

  cg_memory_interface.to_memory if_imem,

  bure_if_interface.master      if_if
);

  logic w_instr_valid;

  logic [DATA_WIDTH-1:0]  w_pc;

  cg_counter #(
    .DATA_WIDTH (ADDR_WIDTH )
  ) program_counter (
    .i_clk      (i_clk                ),
    .i_rstn     (i_rstn               ),
    .i_prst     (if_if.prst           ),
    .i_stop     (~if_imem.raddr_ready ),
    .i_default  (if_if.new_pc         ),
    .o_count    (w_pc                 )
  );

  always_comb begin
    // memory addr
    if_imem.rdata_ready = 1'b1;
    if_imem.raddr       = w_pc;

    if(!if_imem.raddr_ready) begin
      w_instr_valid     = '0;
    end else begin
      w_instr_valid     = if_imem.rdata_valid;
    end
    // During reset, signal is not valid
    if(i_prst | !i_rstn) begin
      if_imem.raddr_valid = 1'b0; 
    end else begin
      if_imem.raddr_valid = 1'b1; 
    end
    // Not use
    if_imem.wen         = 1'b0;
    if_imem.wdata_valid = 1'b0;
    if_imem.waddr       = '0;
    if_imem.wdata       = '0;
  end

  always_ff @(posedge i_clk, negedge i_rstn) begin
    if(!i_rstn) begin
      if_if.instr_valid <= '0;
    end else begin
      if_if.instr_valid <= w_instr_valid;
    end
  end

  always_ff @(posedge i_clk) begin
    if (!if_imem.raddr_ready) begin
      if_if.instr <= if_ifinstr;
    end else begin
      if_if.instr <= if_imem.rdata;
    end
  end

endmodule
`default_nettype wire
