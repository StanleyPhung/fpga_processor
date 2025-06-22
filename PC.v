module program_counter (
    input clk,
    input rst,
    input done,                  // done to increment address
    input JMP,                  // JMP signal
    input [15:0] instr,
    output reg [4:0] pc         // current address
);


always @(posedge clk or posedge rst) begin
    if (rst)
        pc <= 5'b00000;
    else if (rst==0 && JMP==1) 
 	pc <= instr[11:7]; 
    else if (rst==0 && JMP==0 && done)
        pc <= pc + 1;
end

endmodule
