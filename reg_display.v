module reg_display (
    input [2:0] SW,                  // Switches to select register
    input [15:0] R0, R1, R2, R3, R4, R5, R6, R7,
    output [6:0] HEX0, HEX1, HEX2, HEX3
);

    reg [15:0] selected_value;

    // choosing registers
    always @(*) begin
        case (SW)
            3'b000: selected_value = R0;
            3'b001: selected_value = R1;
            3'b010: selected_value = R2;
            3'b011: selected_value = R3;
            3'b100: selected_value = R4;
            3'b101: selected_value = R5;
            3'b110: selected_value = R6;
            3'b111: selected_value = R7;
            default: selected_value = 16'h0000;
        endcase
    end


    four_bit_binary_to_7Seg FB1(.binary(selected_value[3:0]),   .sevenSeg(HEX0));
    four_bit_binary_to_7Seg FB2(.binary(selected_value[7:4]),   .sevenSeg(HEX1));
    four_bit_binary_to_7Seg FB3(.binary(selected_value[11:8]),  .sevenSeg(HEX2));
    four_bit_binary_to_7Seg FB4(.binary(selected_value[15:12]), .sevenSeg(HEX3));

endmodule
