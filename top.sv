// Register file, 1 Sync write port, 1 Async read port
module top (
  input logic clock,
  input logic reset_n,

  input logic cs_n,

  input logic w_en_n,
  input logic [2:0] w_addr,
  input logic [3:0] w_data,

  input  logic [2:0] r_addr,
  output logic [3:0] r_data
);
  logic [7:0][3:0] memory;
  always_ff @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
      memory <= 'b0;
    end else if (~cs_n && ~w_en_n) begin
      memory[w_addr] <= w_data;
    end
  end
  assign r_data = memory[r_addr];
endmodule
