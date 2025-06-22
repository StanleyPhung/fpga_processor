module processor (
    input clk,
    input rst,

    output [15:0] R0, R1, R2, R3, R4, R5, R6, R7,
    output [15:0] A, G,
    output [15:0] BusWires,
    output [5:0] state, next_state
);

    // 总线和中间连线
    wire [15:0] alu_out, extern_in, extern1_in;

    wire Ain, Gin, Gout;
    wire [2:0] ALUop;
    wire Extern, Extern1;
    wire [7:0] Rin, Rout;
    wire  zero_flag;


    // instantiate registers with tri-state buff
    sixteen_bit_reg reg0 (.D(BusWires), .clk(clk), .rst(rst), .enable(Rin[0]), .Q(R0));
    tri_buf tb0 (.a(R0), .b(BusWires), .enable(Rout[0]));

    sixteen_bit_reg reg1 (.D(BusWires), .clk(clk), .rst(rst), .enable(Rin[1]), .Q(R1));
    tri_buf tb1 (.a(R1), .b(BusWires), .enable(Rout[1]));

    sixteen_bit_reg reg2 (.D(BusWires), .clk(clk), .rst(rst), .enable(Rin[2]), .Q(R2));
    tri_buf tb2 (.a(R2), .b(BusWires), .enable(Rout[2]));

    sixteen_bit_reg reg3 (.D(BusWires), .clk(clk), .rst(rst), .enable(Rin[3]), .Q(R3));
    tri_buf tb3 (.a(R3), .b(BusWires), .enable(Rout[3]));

    sixteen_bit_reg reg4 (.D(BusWires), .clk(clk), .rst(rst), .enable(Rin[4]), .Q(R4));
    tri_buf tb4 (.a(R4), .b(BusWires), .enable(Rout[4]));

    sixteen_bit_reg reg5 (.D(BusWires), .clk(clk), .rst(rst), .enable(Rin[5]), .Q(R5));
    tri_buf tb5 (.a(R5), .b(BusWires), .enable(Rout[5]));

    sixteen_bit_reg reg6 (.D(BusWires), .clk(clk), .rst(rst), .enable(Rin[6]), .Q(R6));
    tri_buf tb6 (.a(R6), .b(BusWires), .enable(Rout[6]));

    sixteen_bit_reg reg7 (.D(BusWires), .clk(clk), .rst(rst), .enable(Rin[7]), .Q(R7));
    tri_buf tb7 (.a(R7), .b(BusWires), .enable(Rout[7]));

    // A register
    sixteen_bit_reg regA (.D(BusWires), .clk(clk), .rst(rst), .enable(Ain), .Q(A));

    // ALU
    alu16 alu (
        .A(A),
        .B(BusWires),
	.clk(clk),
        .ALUop(ALUop),
        .Y(alu_out),
	.zero_flag(zero_flag)	
    );

    // G register
    sixteen_bit_reg regG (.D(alu_out), .clk(clk), .rst(rst), .enable(Gin), .Q(G));
    tri_buf tbG (.a(G), .b(BusWires), .enable(Gout));


    ControlFSM fsm(
    .clk(clk),
    .rst(rst),
    .instr(instr),
    .zero_flag(zero_flag),
    .data(extern_in),
    .Ain(Ain), 
    .Gin(Gin), 
    .Gout(Gout),
    .ALUop(ALUop),
    .Extern(Extern),
    .Extern1(Extern1),
    .Rin(Rin), 
    .Rout(Rout),
    .done(done),
    .state(state),
    .next_state(next_state),
    .JMP(JMP),
    .RAM_addr(RAM_address),
    .we(we),
    .push(push),
    .pop(pop),
    .load(load)
);
    tri_buf tbD (.a(extern_in), .b(BusWires), .enable(Extern));
 
    wire done, JMP, we, push, pop , load ; 
    wire [15:0] instr;
    wire [4:0] address;
    wire [7:0] RAM_address;

    program_counter pc1(
    .clk(clk),
    .rst(rst),
    .done(done),                  
    .JMP(JMP),
    .instr(instr),
    .pc(address)         
);

    program_memory pm1(
    .address(address),
    .instr_out(instr)
);


 RAM ram1(
    .clk(clk),
    .rst(rst),
    .we(we),              // write enable
    .addr(RAM_address),      // direct address access
    .PUSH(push),            // push
    .POP(pop),             // pop
    .load(load),
    .data_in(BusWires),
    .data_out(extern1_in)
);
tri_buf tbRAM (.a(extern1_in), .b(BusWires), .enable(Extern1));

endmodule
