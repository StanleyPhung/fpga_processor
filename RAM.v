module RAM (
    input clk,
    input rst,
    input we,              // write enable
    input [7:0] addr,      // direct address access
    input PUSH,            // push
    input POP,             // pop
    input load,		 //load 
    input [15:0] data_in,
    output reg [15:0] data_out
);

    reg [15:0] mem [0:255];  // 256-word RAM
    reg [7:0] sp;            // Stack Pointer

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sp <= 8'd255;
            data_out <= 16'd0;
        end
        else if (PUSH) begin
            mem[sp] <= data_in;
            sp <= sp - 1;
        end
        else if (POP) begin
            sp <= sp + 1;
            data_out <= mem[sp + 1];  // sp+1 !
        end
        else if (we) begin
            mem[addr] <= data_in;
        end
        else if (load) begin
            data_out <= mem[addr];   
        end
        // otherwise, keep data_out unchanged

    end

endmodule