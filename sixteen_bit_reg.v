module sixteen_bit_reg (
    input [15:0] D, 
    input clk, 
    input rst, 
    input enable,       
    output reg [15:0] Q
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 16'b0;
        end else if (enable) begin
            Q <= D;
        end
    end

endmodule
