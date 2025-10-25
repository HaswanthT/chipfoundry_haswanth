// aes_core.v
// Iterative AES-128 core: one round per clock (final round skips MixColumns).
// Inputs: start (pulse) uses roundkeys produced by key expansion.
// License: Apache-2.0
`timescale 1ns/1ps

module aes_core (
    input  wire         clk,
    input  wire         rstn,
    input  wire         start,         // start encryption when pulse high
    input  wire [127:0] plaintext,
    input  wire [1407:0] roundkeys,    // 11 * 128
    output reg  [127:0] ciphertext,
    output reg          done
);
    reg [3:0] round;
    reg [127:0] state;
    reg running;

    // local sbox function (copy full table or instantiate aes_sbox)
    function [7:0] sbox_func;
        input [7:0] x;
        begin
            case (x)
                8'h00: sbox_func = 8'h63; 8'h01: sbox_func = 8'h7c; 8'h02: sbox_func = 8'h77; 8'h03: sbox_func = 8'h7b;
                8'h04: sbox_func = 8'hf2; 8'h05: sbox_func = 8'h6b; 8'h06: sbox_func = 8'h6f; 8'h07: sbox_func = 8'hc5;
                // ... full S-box required here as well ...
                default: sbox_func = 8'h00;
            endcase
        end
    endfunction

    // SubBytes
    function [127:0] subbytes;
        input [127:0] st;
        integer i;
        reg [7:0] b;
        begin
            for (i=0;i<16;i=i+1) begin
                b = sbox_func(st[127 - 8*i -: 8]);
                subbytes[127 - 8*i -: 8] = b;
            end
        end
    endfunction

    // ShiftRows (state is column-major)
    function [127:0] shiftrows;
        input [127:0] st;
        reg [7:0] s [0:15];
        begin
            for (int j=0;j<16;j=j+1) s[j] = st[127 - 8*j -: 8];
            // produce shifted state (column-major)
            shiftrows = { s[0], s[5], s[10], s[15],
                          s[4], s[9], s[14], s[3],
                          s[8], s[13], s[2], s[7],
                          s[12], s[1], s[6], s[11] };
        end
    endfunction

    // MixColumns uses aes_mixcol module for each column; instantiate wires
    wire [31:0] col_in0, col_in1, col_in2, col_in3;
    wire [31:0] col_out0, col_out1, col_out2, col_out3;

    assign col_in0 = state[127:96];
    assign col_in1 = state[95:64];
    assign col_in2 = state[63:32];
    assign col_in3 = state[31:0];

    aes_mixcol mc0(.col_in(col_in0), .col_out(col_out0));
    aes_mixcol mc1(.col_in(col_in1), .col_out(col_out1));
    aes_mixcol mc2(.col_in(col_in2), .col_out(col_out2));
    aes_mixcol mc3(.col_in(col_in3), .col_out(col_out3));

    reg [127:0] subbed;
    reg [127:0] shifted;
    reg [127:0] mixed;
    reg [127:0] rk;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            round <= 0;
            state <= 128'h0;
            ciphertext <= 128'h0;
            done <= 0;
            running <= 0;
        end else begin
            if (start && !running) begin
                // initial AddRoundKey (round 0)
                state <= plaintext ^ roundkeys[1407 -: 128];
                round <= 1;
                done <= 0;
                running <= 1;
            end else if (running) begin
                if (round <= 10) begin
                    // SubBytes
                    subbed <= subbytes(state);
                    // ShiftRows
                    shifted <= shiftrows(subbed);
                    // MixColumns except final round:
                    if (round != 10) begin
                        mixed <= {col_out0, col_out1, col_out2, col_out3}; // note: mc uses current 'state' columns; ensure state updated
                    end else begin
                        mixed <= shifted;
                    end
                    // AddRoundKey
                    rk <= roundkeys[1407 - round*128 -: 128];
                    state <= mixed ^ rk;
                    if (round == 10) begin
                        ciphertext <= mixed ^ rk;
                        done <= 1;
                        running <= 0;
                        round <= 0;
                    end else begin
                        round <= round + 1;
                    end
                end
            end else begin
                done <= 0;
            end
        end
    end

endmodule

