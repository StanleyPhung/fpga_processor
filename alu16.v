`timescale 1ns/1ps
module alu16(
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire clk, 
    input  wire [2:0]  ALUop,   // 000=ADD,001=SUB,010=XOR，001=cmp, 111=idle
    output reg  [15:0] Y,
    output reg  zero_flag      
);

    wire [15:0] sum  = A + B;
    wire [15:0] diff = A - B;
    wire [15:0] xorr = A ^ B;
    wire [15:0] cmp = A - B;
    wire [15:0] LSL = A << B[4:0];
    wire [15:0] LSR = A >> B[4:0];


    always @(*) begin
        case(ALUop)
            3'b000: Y = sum;
            3'b001: Y = diff;
            3'b010: Y = xorr;
            3'b011: Y = cmp;
            3'b100: Y = LSL;
            3'b101: Y = LSR;
            default: Y = 16'd0;
        endcase
    end


always @(posedge clk) begin
    if (ALUop != 3'b111) begin
        if (Y == 16'd0)
            zero_flag <= 1'b1;
        else
            zero_flag <= 1'b0;
    end
    // else: keep zero_flag unchanged
end


endmodule
