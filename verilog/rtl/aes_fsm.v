// aes_fsm.v
// Orchestrates key expansion then core encryption
// License: Apache-2.0
`timescale 1ns/1ps

module aes_fsm (
    input  wire         clk,
    input  wire         rstn,
    input  wire         start,        // CPU pulses start
    input  wire         decrypt,      // reserved (0=encr)
    input  wire [127:0] key_in,
    input  wire [127:0] plaintext,
    output wire [127:0] ciphertext,
    output wire         done
);
    reg start_kexp;
    wire kexp_done;
    wire [1407:0] roundkeys;
    wire core_done;

    // Key expansion
    aes_keyexp keyexp (
        .clk(clk), .rstn(rstn),
        .start(start_kexp),
        .key_in(key_in),
        .roundkeys(roundkeys),
        .done(kexp_done)
    );

    // AES core (starts when kexp_done pulses)
    reg start_core;
    aes_core core (
        .clk(clk), .rstn(rstn),
        .start(start_core),
        .plaintext(plaintext),
        .roundkeys(roundkeys),
        .ciphertext(ciphertext),
        .done(core_done)
    );

    // FSM: on external start -> pulse keyexp start, then core start when kexp done
    reg [1:0] state;
    localparam IDLE=2'b00, KEXP=2'b01, CORE=2'b10, DONE=2'b11;
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            state <= IDLE;
            start_kexp <= 0;
            start_core <= 0;
        end else begin
            start_kexp <= 0;
            start_core <= 0;
            case (state)
                IDLE: begin
                    if (start) begin
                        start_kexp <= 1;
                        state <= KEXP;
                    end
                end
                KEXP: begin
                    if (kexp_done) begin
                        start_core <= 1;
                        state <= CORE;
                    end
                end
                CORE: begin
                    if (core_done) begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    assign done = (state == DONE);
endmodule

