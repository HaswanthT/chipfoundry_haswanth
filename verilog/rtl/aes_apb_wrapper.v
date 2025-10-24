// aes_apb_wrapper.v
// Simple APB-lite register interface for AES accelerator
// License: Apache-2.0
`timescale 1ns/1ps

module aes_apb_wrapper (
    input  wire        PCLK,
    input  wire        PRESETn,
    input  wire [31:0] PADDR,
    input  wire        PSEL,
    input  wire        PENABLE,
    input  wire        PWRITE,
    input  wire [31:0] PWDATA,
    output reg  [31:0] PRDATA,
    output reg         PREADY,
    output reg         PSLVERR,

    // Internal AES interface
    output reg         start,
    output reg  [127:0] key_in,
    output reg  [127:0] plaintext,
    input  wire [127:0] ciphertext,
    input  wire        done
);
    // Address map (word offsets)
    localparam ADDR_KEY0  = 32'h00;
    localparam ADDR_KEY4  = 32'h04;
    localparam ADDR_KEY8  = 32'h08;
    localparam ADDR_KEY12 = 32'h0C;
    localparam ADDR_PT0   = 32'h10;
    localparam ADDR_PT4   = 32'h14;
    localparam ADDR_PT8   = 32'h18;
    localparam ADDR_PT12  = 32'h1C;
    localparam ADDR_CTRL  = 32'h20;
    localparam ADDR_STATUS= 32'h24;
    localparam ADDR_CT0   = 32'h28;
    localparam ADDR_CT4   = 32'h2C;
    localparam ADDR_CT8   = 32'h30;
    localparam ADDR_CT12  = 32'h34;

    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            key_in <= 128'h0;
            plaintext <= 128'h0;
            start <= 0;
            PRDATA <= 32'h0;
            PREADY <= 1;
            PSLVERR <= 0;
        end else begin
            PREADY <= 1; PSLVERR <= 0;
            if (PSEL && PENABLE && PWRITE) begin
                case (PADDR)
                    ADDR_KEY0: key_in[127:96] <= PWDATA;
                    ADDR_KEY4: key_in[95:64]  <= PWDATA;
                    ADDR_KEY8: key_in[63:32]  <= PWDATA;
                    ADDR_KEY12:key_in[31:0]   <= PWDATA;
                    ADDR_PT0: plaintext[127:96] <= PWDATA;
                    ADDR_PT4: plaintext[95:64]  <= PWDATA;
                    ADDR_PT8: plaintext[63:32]  <= PWDATA;
                    ADDR_PT12:plaintext[31:0]   <= PWDATA;
                    ADDR_CTRL: begin
                        start <= PWDATA[0];
                    end
                    default: ;
                endcase
            end else if (PSEL && !PWRITE) begin
                case (PADDR)
                    ADDR_STATUS: PRDATA <= {31'b0, done};
                    ADDR_CT0: PRDATA <= ciphertext[127:96];
                    ADDR_CT4: PRDATA <= ciphertext[95:64];
                    ADDR_CT8: PRDATA <= ciphertext[63:32];
                    ADDR_CT12:PRDATA <= ciphertext[31:0];
                    default: PRDATA <= 32'h0;
                endcase
            end
        end
    end
endmodule

