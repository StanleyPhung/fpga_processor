`timescale 1ns / 1ps
 
module processor_extensionwithPUSH_TB;
 
	// ------------------ Instantiate module ------------------

 
	reg [5:0] count;
        reg clk, rst; 

	wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7,A, G,BusWires;
         wire [5:0] state, next_state;


        processor p1(
    .clk(clk),
    .rst(rst),
    .R0(R0), .R1(R1), .R2(R2), .R3(R3), .R4(R4), .R5(R5), .R6(R6), .R7(R7),
    .A(A), .G(G),
    .BusWires(BusWires),
    .state(state), 
    .next_state(next_state)
);

 	
	initial begin 
		count = 6'b00000;
		rst=1;
		clk=0;
	end
	
	always begin
    		#25 clk = 1;     
    		#25 clk = 0;     
    		count = count + 6'd1; 
		rst=0;
	end


     initial begin

        $dumpfile("processor_extensionwithPUSH_TB.vcd");

        $dumpvars(0, processor_extensionwithPUSH_TB);

        #20000

        $finish;

    end
 
endmodule