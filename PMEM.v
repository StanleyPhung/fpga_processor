module program_memory (
    input [4:0] address,
    output reg [15:0] instr_out
);

always @(*) begin
    case (address)
        5'd0: instr_out = 16'b0000000000000000; // load R0
        5'd1: instr_out = 16'b0000000000000110; // data:6   (then r0=6)
        5'd2: instr_out = 16'b1010000000000010; // LSL R0,2  (then r0=24 =0x18)
        5'd3: instr_out = 16'b1011000000000001; // LSR R0,1  (then r0=12 =0x0c)
        5'd4: instr_out = 16'b1001000000000000; // SUBi R0,4
        5'd5: instr_out = 16'b0000000000000100; // data:4  (then r0=8)
        5'd6: instr_out = 16'b0000010000000000; // load R4
        5'd7: instr_out = 16'b0000000000001001; // data:9   (then r4=9)
        5'd8: instr_out = 16'b0000010100000000; // load R5
        5'd9: instr_out = 16'b0000000000001010; // data:10   (then r5=10)

        5'd10: instr_out = 16'b1100000000000000; // push r0 
        5'd11: instr_out = 16'b1100010000000000; // push r4 
        5'd12: instr_out = 16'b1100010100000000; // push r5 

        5'd13: instr_out = 16'b1101000100000000; // pop r1   (then r1=10)
        5'd14: instr_out = 16'b1101011000000000; // pop r6   (then r6=9)
        5'd15: instr_out = 16'b1101011100000000; // pop r7   (then r7=8)

        5'd16: instr_out = 16'b1110000100000000; // str r1, addr=0
        5'd17: instr_out = 16'b1111001000000000; // load r2, addr=0  (then r2=10)
        5'd18: instr_out = 16'b0000001100000000; // load R3
        5'd19: instr_out = 16'b0000000000000001; // data:1   (then r3=1)
        5'd20: instr_out = 16'b0011001000110000; // SUB R2,R3
        5'd21: instr_out = 16'b0111001000000000; // cmp r2,0
        5'd22: instr_out = 16'b0000000000000000; // data:0
        5'd23: instr_out = 16'b1000101000000000; // if zero_flag=0, br to address 10100=20--SUB R2,R3 ,after the loop, r2=0
         5'd24: instr_out = 16'b0100001000000000; // xor R2,0xffff  
         5'd25: instr_out = 16'b1111111111111111; // data:0xffff   (then r2=0xffff)
         5'd26: instr_out = 16'b0110001100000000; // addi r3,1
         5'd27: instr_out = 16'b0000000000000001; // data:1    (then r3=2)
         5'd28: instr_out = 16'b0101000000000000; // jump to address 00000=0 -- the beginning of the program/restart the program

        default: instr_out = 16'b1111111111111111;
    endcase
end

endmodule
