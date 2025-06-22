module test_PMEM;
    reg [4:0] address;
    wire [15:0] instr_out;

    // Instantiate the program_memory
    program_memory uut (
        .address(address),
        .instr_out(instr_out)
    );

    initial begin
        $display("Time\tAddress\tExpected\t\tinstr_out");
        
        // Test address 0: load R0 => 16'b0000000000000000
        address = 5'd0; #10;
        $display("%0t\t%0d\t%016b\t%016b", $time, address, 16'b0000000000000000, instr_out);
        
        // Test address 1: data:6 => 16'b0000000000000110
        address = 5'd1; #10;
        $display("%0t\t%0d\t%016b\t%016b", $time, address, 16'b0000000000000110, instr_out);
        
        // Test address 2: LSL R0,2 => 16'b1010000000000010
        address = 5'd2; #10;
        $display("%0t\t%0d\t%016b\t%016b", $time, address, 16'b1010000000000010, instr_out);
        
        // Test address 3: LSR R0,1 => 16'b1011000000000001
        address = 5'd3; #10;
        $display("%0t\t%0d\t%016b\t%016b", $time, address, 16'b1011000000000001, instr_out);
        
        // Test address 4: SUBi R0, -> 16'b1001000000000000
        address = 5'd4; #10;
        $display("%0t\t%0d\t%016b\t%016b", $time, address, 16'b1001000000000000, instr_out);
        
        // Test address 5: data:4 => 16'b0000000000000100
        address = 5'd5; #10;
        $display("%0t\t%0d\t%016b\t%016b", $time, address, 16'b0000000000000100, instr_out);
        
        // Test address 6: push r0 => 16'b1100000000000000
        address = 5'd6; #10;
        $display("%0t\t%0d\t%016b\t%016b", $time, address, 16'b1100000000000000, instr_out);
        
        // Test address 7: pop r1 => 16'b1101000100000000
        address = 5'd7; #10;
        $display("%0t\t%0d\t%016b\t%016b", $time, address, 16'b1101000100000000, instr_out);
        
        // Test address 8: str r1, addr=0 => 16'b1110000100000000
        address = 5'd8; #10;
        $display("%0t\t%0d\t%016b\t%016b", $time, address, 16'b1110000100000000, instr_out);
        
        // Test address 9: load r2, addr=0 => 16'b1111001000000000
        address = 5'd9; #10;
        $display("%0t\t%0d\t%016b\t%016b", $time, address, 16'b1111001000000000, instr_out);
        
        // Test address 10: ADDI instruction => 16'b0110000100000001 
        // (example: opcode = 4'b0110, reg field 0001, immediate 00000001)
        address = 5'd10; #10;
        $display("%0t\t%0d\t%016b\t%016b", $time, address, 16'b0110000100000001, instr_out);
        
        // Test address 11: JMP instruction => 16'b0101001000000000 
        // (example: opcode = 4'b0101, jump address in bits[11:7])
        address = 5'd11; #10;
        $display("%0t\t%0d\t%016b\t%016b", $time, address, 16'b0101001000000000, instr_out);
        
        // Test address 12: BRNE instruction => 16'b1000000000000000 
        // (example: opcode = 4'b1000; branch taken if not zero)
        address = 5'd12; #10;
        $display("%0t\t%0d\t%016b\t%016b", $time, address, 16'b1000000000000000, instr_out);
        
        // Test address 13: CMP instruction => 16'b0111001000110100 
        // (example: opcode = 4'b0111, with chosen register fields)
        address = 5'd13; #10;
        $display("%0t\t%0d\t%016b\t%016b", $time, address, 16'b0111001000110100, instr_out);
        
        // Test default case: address 14 should return default 16'b1111111111111111
        address = 5'd14; #10;
        $display("%0t\t%0d\t%016b\t%016b", $time, address, 16'b1111111111111111, instr_out);

        $finish;
    end
endmodule