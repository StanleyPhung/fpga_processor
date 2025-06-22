module project_instantiate(SW, KEY, HEX3, HEX2, HEX1, HEX0,LEDR);

	input[9:0] SW;
    input [3:0] KEY;  //tbd
	output [6:0] HEX0, HEX1, HEX2, HEX3,HEX4,HEX5;
	output [9:0] LEDR;

	 wire[15:0] A, G,BUS,R0, R1, R2, R3, R4, R5, R6, R7;
         wire [5:0] state, next_state;
	
	//instantiate and connect 

        processor p_ins(
    .clk(KEY[0]),
    .rst(SW[0]),
    .R0(R0), .R1(R1), .R2(R2), .R3(R3), .R4(R4), .R5(R5), .R6(R6), .R7(R7),
    .A(A), .G(G),
    .BusWires(BUS),
    .state(state), 
    .next_state(next_state)
);
 	reg_display (
    .SW(SW[5:3]),                  // Switches to select register
    .R0(R0), .R1(R1), .R2(R2), .R3(R3), .R4(R4), .R5(R5), .R6(R6), .R7(R7),
    .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3)
);

	wire[3:0] temp;
     assign  temp={2'b00,state[5:4]}

     four_bit_binary_to_7Seg FB5(.binary(state[3:0]),   .sevenSeg(HEX4));
    four_bit_binary_to_7Seg FB6(.binary(temp),   .sevenSeg(HEX5));


		
endmodule