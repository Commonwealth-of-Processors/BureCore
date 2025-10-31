module BC_stage_if_tb;

  logic i_clk   = 0;
  logic i_rstn  = 1;

  CG_memory_interface #(
    .DATA_WIDTH (32 ),
    .ADDR_WIDTH (32 )
  ) if_mem (
    .i_clk  (i_clk  ),
    .i_rstn (i_rstn )
  );

  logic         w_instr_valid;
  logic [31:0]  w_instr;

  always #1 begin
    i_clk <= ~i_clk;
  end

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, BC_stage_if_tb);
  end

  CG_memory_beh #(
    .DATA_WIDTH (32   ),
    .ADDR_WIDTH (32   ),
    .WORD_NUM   (1024 )
  ) DUT (
    .if_mem (if_mem )
  );

  BC_stage_if #(
    .DATA_WIDTH (32 ),
    .ADDR_WIDTH (32 ),
    .INSTR_WIDTH(32 )
  ) DUT2 (
    .i_clk  (i_clk  ),
    .i_rstn (i_rstn ),
    
    .if_imem        (if_mem         ),
    .o_instr_valid  (w_instr_valid  ),
    .o_instr        (w_instr        )
  );

  initial begin
    #2
    i_rstn              = 1'b0;
    #8
    i_rstn              = 1'b1;
    #2
    if_mem.wen          = 1'b1;
    if_mem.wdata_valid  = 1'b1;
    if_mem.waddr        = 32'h0000_0000;
    if_mem.wdata        = 32'h0000_0114;
    #2
    if_mem.wen          = 1'b1;
    if_mem.wdata_valid  = 1'b1;
    if_mem.waddr        = 32'h0000_0001;
    if_mem.wdata        = 32'h0000_0214;
    #2
    if_mem.wen          = 1'b1;
    if_mem.wdata_valid  = 1'b1;
    if_mem.waddr        = 32'h0000_0002;
    if_mem.wdata        = 32'hAAAA_AAAA;
    #2
    if_mem.wen          = 1'b1;
    if_mem.wdata_valid  = 1'b1;
    if_mem.waddr        = 32'h0000_0003;
    if_mem.wdata        = 32'hAAAA_AAAB;
    #2
    if_mem.wen          = 1'b1;
    if_mem.wdata_valid  = 1'b1;
    if_mem.waddr        = 32'h0000_0004;
    if_mem.wdata        = 32'hAAAA_AAAC;
    #2
    if_mem.wen          = 1'b1;
    if_mem.wdata_valid  = 1'b1;
    if_mem.waddr        = 32'h0000_0005;
    if_mem.wdata        = 32'hAAAA_AAAD;
    #2
    i_rstn              = 1'b0;
    #8
    i_rstn              = 1'b1;
    #40
    $finish;
  end

endmodule
