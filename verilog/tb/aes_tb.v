// aes_tb.v
`timescale 1ns/1ps
module aes_tb;
  reg clk = 0;
  reg rstn = 0;
  always #5 clk = ~clk; // 100 MHz

  reg start;
  reg [127:0] key_in;
  reg [127:0] pt;
  wire [127:0] ct;
  wire done;

  // instantiate top-level FSM
  aes_fsm dut (
    .clk(clk), .rstn(rstn),
    .start(start),
    .decrypt(1'b0),
    .key_in(key_in),
    .plaintext(pt),
    .ciphertext(ct),
    .done(done)
  );

  initial begin
    $dumpfile("aes_wave.vcd");
    $dumpvars(0, aes_tb);
    #20;
    rstn = 1;
    #10;

    // NIST test vector
    key_in = 128'h000102030405060708090a0b0c0d0e0f;
    pt     = 128'h00112233445566778899aabbccddeeff;

    start = 1;
    #10 start = 0;

    // wait for done
    wait (done == 1);
    #10;
    $display("Ciphertext = %032x", ct);
    if (ct === 128'h69c4e0d86a7b0430d8cdb78070b4c55a)
      $display("AES TB: PASS");
    else begin
      $display("AES TB: FAIL (expected 69c4...4c55a)");
    end

    #20;
    $finish;
  end
endmodule
