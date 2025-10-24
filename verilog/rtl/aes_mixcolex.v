// aes_mixcol.v
// MixColumns helper and xtime (Galois multiply by 2)
// License: Apache-2.0

module aes_gf (
    input  wire [7:0] a,
    output wire [7:0] xtime_a
);
assign xtime_a = {a[6:0],1'b0} ^ (8'h1b & {8{a[7]}});
endmodule

module aes_mixcol (
    input  wire [31:0] col_in,
    output wire [31:0] col_out
);
wire [7:0] a0 = col_in[31:24], a1 = col_in[23:16], a2 = col_in[15:8], a3 = col_in[7:0];
wire [7:0] xa0, xa1, xa2, xa3;
aes_gf gx0(.a(a0), .xtime_a(xa0));
aes_gf gx1(.a(a1), .xtime_a(xa1));
aes_gf gx2(.a(a2), .xtime_a(xa2));
aes_gf gx3(.a(a3), .xtime_a(xa3));

assign col_out[31:24] = xa0 ^ (a1 ^ xa1) ^ a2 ^ a3;
assign col_out[23:16] = a0 ^ xa1 ^ (a2 ^ xa2) ^ a3;
assign col_out[15:8]  = a0 ^ a1 ^ xa2 ^ (a3 ^ xa3);
assign col_out[7:0]   = (a0 ^ xa0) ^ a1 ^ a2 ^ xa3;
endmodule
