module bure_stage_id_tb;

  logic i_clk   = 0;
  logic i_rstn  = 1;

  bure_if_interface #(
    .DATA_WIDTH (32 ),
    .ADDR_WIDTH (32 ),
    .INSTR_WIDTH(32 )
  ) if_if ();

  bure_id_interface #(
    .DATA_WIDTH (32 ),
    .INSTR_WIDTH(32 )
  ) if_id ();

  always #1 begin
    i_clk <= ~i_clk;
  end

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, bure_stage_id_tb);
  end

  bure_stage_id #(
    .DATA_WIDTH (32 ),
    .INSTR_WIDTH(32 )
  ) DUT (
    .i_clk  (i_clk  ),
    .i_rstn (i_rstn ),

    .if_if  (if_if  ),
    .if_id  (if_id  )
  );

  initial begin
    i_rstn  = 1'b1;
    #2
    i_rstn  = 1'b0;
    #2
    i_rstn  = 1'b1;
    #2
    if_if.instr_valid = 1'b1;
    if_if.instr       = 32'b0000000_00001_00010_000_00011_0110011;
    #2
    if_if.instr_valid = 1'b1;
    if_if.instr       = 32'b100000000001_00010_000_00011_0010011;
    #2
    if_if.instr_valid = 1'b1;
    if_if.instr       = 32'b000000000001_00010_000_00011_0010011;
    #2
    $finish;
  end

endmodule
