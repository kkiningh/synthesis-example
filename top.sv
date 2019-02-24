// Register file, 1 Sync write port, 1 Async read port
module regfile (
  input logic clock,
  input logic reset_n,

  input logic cs_n,

  input logic w_en_n,
  input logic [ 7:0] w_addr,
  input logic [15:0] w_data,

  input  logic [ 7:0] r_addr,
  output logic [15:0] r_data
);
  logic [255:0][15:0] memory;
  always_ff @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
      memory <= 'b0;
    end else if (~cs_n && ~w_en_n) begin
      memory[w_addr] <= w_data;
    end
  end
  assign r_data = memory[r_addr];
endmodule

module multiplier (
  input logic clock,
  input logic reset_n,
  input logic [15:0] a,
  input logic [15:0] b,

  output logic [15:0] result
);
  logic [15:0] a_ff_0, a_ff_1, b_ff_0, b_ff_1;
  always_ff @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
      a_ff_0 <= 'b0;
      b_ff_0 <= 'b0;
      a_ff_1 <= 'b0;
      b_ff_1 <= 'b0;
      result <= 'b0;
    end else begin
      a_ff_0 <= a;
      b_ff_0 <= b;
      a_ff_1 <= a_ff_0;
      b_ff_1 <= b_ff_0;
      result <= a_ff_1 * b_ff_1;
    end
  end
endmodule

module top (
  input logic clock,
  input logic reset_n,

  /* Write port */
  input logic w_en_n,
  input logic [ 7:0] w_addr,
  input logic [15:0] w_data,

  /* Arith port */
  input  logic [ 7:0] a_addr,
  input  logic [15:0] b_data,
  output logic [15:0] result
);
  logic [15:0] a_data;
  regfile mem (
    .clock(clock),
    .reset_n(reset_n),
    .cs_n(1'b0),
    .w_en_n(w_en_n),
    .w_addr(w_addr),
    .w_data(w_data),
    .r_addr(a_addr),
    .r_data(a_data)
  );

  multiplier alu (
    .clock(clock),
    .reset_n(reset_n),
    .a(a_data),
    .b(b_data),
    .result(result)
  );
endmodule
