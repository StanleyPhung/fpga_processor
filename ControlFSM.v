module ControlFSM (
    input clk,
    input rst,
    input [15:0] instr, 
    input zero_flag, 

    output  [15:0] data,
    output reg Ain, Gin, Gout,
    output reg [2:0] ALUop,
    output reg Extern, Extern1,
    output reg [7:0] Rin, Rout,
    output reg done ,
    output reg [5:0] state, next_state,
    output reg JMP,
    output [7:0] RAM_addr,
    output reg we, push, pop, load
);

    // FSM state definition
parameter FETCH = 6'd0,
          DECODE = 6'd1,
          LDR1 = 6'd2,
          LDR2 = 6'd3,
          MOV1 = 6'd4,
          ADD1 = 6'd5, ADD2 = 6'd6, ADD3 = 6'd7,
          SUB1 = 6'd8, SUB2 = 6'd9, SUB3 = 6'd10,
          XOR1 = 6'd11, XOR2 = 6'd12, XOR3 = 6'd13, jmp=6'd14,
	  addi1=6'd15, addi2=6'd16, addi3=6'd17,
	  cmp1 =6'd18, cmp2 =6'd19,
	  brne =6'd20,
	  SUBI1=6'd21, SUBI2=6'd22, SUBI3=6'd23,
	  LSL1=6'd24, LSL2=6'd25, LSL3=6'd26,
	  LSR1=6'd27, LSR2=6'd28, LSR3=6'd29,
	  PUSH=6'd30, POP1=6'd31, POP2=6'd32,
 	  str=6'd33, load1=6'd34, load2=6'd35
;




reg [3:0] opcode;
reg [3:0] reg1, reg2;


wire [3:0] opcode_next = instr[15:12];
wire [3:0] reg1_next = instr[11:8];
wire [3:0] reg2_next = instr[7:4];

assign data = instr;
assign RAM_addr =  instr[7:0];


// when decoding, store reg1, reg2, opcode, current state
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= FETCH;
        opcode <= 0;
        reg1 <= 0;
        reg2 <= 0;
    end else begin
        state <= next_state;
        if (state == FETCH) begin
            opcode <= opcode_next;
            reg1 <= reg1_next;
            reg2 <= reg2_next;
        end
    end
end


    // default control signals
    always @(*) begin
        Ain=0; Gin=0; Gout=0;
        ALUop=3'b111;
        Extern=0;Extern1=0;
        Rin=0; Rout=0; done=0;JMP=0; we=0; push=0; pop=0;load=0;
	/*	if ((state == LSL2) || (state == LSR2))
			data = {12'b0, instr[4:0]};  // shift count from lower 4 bits
		else
			data = instr; */

        // state transitions and control signals
        case (state)
            FETCH: begin
				Ain=0; Gin=0; Gout=0;
				ALUop=3'b111;
				Extern=0;
				Extern1=0;
				Rin=0;
				Rout=0; 
				done=0;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = DECODE;
            end

            DECODE: begin
                case (opcode)
                    4'b0000: begin next_state = LDR1;  end  // LDR
                    4'b0001: begin next_state = MOV1;  end  // MOV
                    4'b0010: begin next_state = ADD1;  end  // ADD
                    4'b0011: begin next_state = SUB1;  end  // SUB
                    4'b0100: begin next_state = XOR1;  end  // XOR
                    4'b0101: begin next_state = jmp;  end  // JMP
                    4'b0110: begin next_state = addi1;  end  // addi1
                    4'b0111: begin next_state = cmp1;  end  // cmp1
                    4'b1000: begin next_state = brne;  end  // brne
					4'b1001: begin next_state = SUBI1;  end  // SUBI1
					4'b1010: begin next_state = LSL1;  end  // LSL1
					4'b1011: begin next_state = LSR1;  end  // LSR1
                    4'b1100: begin next_state = PUSH;  end  // PUSH
                    4'b1101: begin next_state = POP1;  end  // POP
                    4'b1110: begin next_state = str;  end  // str
                    4'b1111: begin next_state = load1;  end  // load
                    default: next_state = FETCH;
                endcase
            end

            // ---- LDR ----
            LDR1: begin
                Ain=0; Gin=0; Gout=0;
                ALUop=3'b111;
                Extern=0;Extern1=0;
                Rin=0;Rout=0;
				done=1;
				JMP=0;
		we=0; push=0; pop=0;
                next_state = LDR2;  //LDR1:use a signal like DecodeFinished to tell PC to increment
            end
            LDR2: begin
				Ain=0; Gin=0; Gout=0;
				ALUop=3'b111;
				Extern=1;Extern1=0;
				Rin = 8'b00000001 << reg1;
				Rout=0; 
				done=1;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = FETCH;
            end

            // ---- MOV Rx, Ry ----
            MOV1: begin
				Ain=0; Gin=0; Gout=0;
				ALUop=3'b111;
				Extern=0;Extern1=0;
				Rin = 8'b00000001 << reg1;
				Rout = 8'b00000001 << reg2;
				done=1;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = FETCH;
            end

            // ---- ADD Rx, Ry ----
            ADD1: begin
				Ain=1; Gin=0; Gout=0;
				ALUop=3'b111;
				Extern=0;Extern1=0;
				Rin=0; 
				Rout = 8'b00000001 << reg1;
				done=0;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = ADD2;
            end
            ADD2: begin
				Ain=0; Gin=1; Gout=0;
				ALUop=3'b000;
				Extern=0;Extern1=0;
				Rin=0; 
				Rout = 8'b00000001 << reg2;
				done=0;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = ADD3;
            end
            ADD3: begin
				Ain=0; Gin=0; Gout=1;
				ALUop=3'b111;
				Extern=0;Extern1=0;
				Rin = 8'b00000001 << reg1;
				Rout=0; 
				done=1;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = FETCH;
            end

            // ---- SUB Rx, Ry ----
            SUB1: begin
				Ain=1; Gin=0; Gout=0;
				ALUop=3'b111;
				Extern=0;Extern1=0;
				Rin=0; 
				Rout = 8'b00000001 << reg1;
				done=0;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = SUB2;
            end
            SUB2: begin
				Ain=0; Gin=1; Gout=0;
				ALUop=3'b001;
				Extern=0;Extern1=0;
				Rin=0; 
				Rout = 8'b00000001 << reg2;
				done=0;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = SUB3;
            end
            SUB3: begin
				Ain=0; Gin=0; Gout=1;
				ALUop=3'b111;
				Extern=0;Extern1=0;
				Rin = 8'b00000001 << reg1;
				Rout=0; 
				done=1;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = FETCH;
            end

            // ---- XOR Rx, Ry ----
            XOR1: begin
				Ain=1; Gin=0; Gout=0;
				ALUop=3'b111;
				Extern=0;Extern1=0;
				Rin=0; 
				Rout = 8'b00000001 << reg1;
				done=1;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = XOR2;  
            end
            XOR2: begin
				Ain=0; Gin=1; Gout=0;
				ALUop=3'b010;
				Extern=1;Extern1=0;
				Rin = 0;
				Rout=0; 
				done=0;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = XOR3;
            end

            XOR3: begin
				Ain=0; Gin=0; Gout=1;
				ALUop=3'b111;
				Extern=0;Extern1=0;
				Rin = 8'b00000001 << reg1;
				Rout=0; 
				done=1;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = FETCH;
            end

           // ---- jmp address ----
            jmp: begin
				Ain=0; Gin=0; Gout=0;
				ALUop=3'b111;
				Extern=0;Extern1=0;
				Rin = 0;
				Rout = 0;
				done=0;
				JMP=1;
				we=0; push=0; pop=0;load=0;
                next_state = FETCH;
            end

           // ---- addi Rx, data ----
            addi1: begin
				Ain=1; Gin=0; Gout=0;
				ALUop=3'b111;
				Extern=0;Extern1=0;
				Rin=0;
				Rout = 8'b00000001 << reg1;
				done=1;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = addi2;
            end
            addi2: begin
				Ain=0; Gin=1; Gout=0;
				ALUop=3'b000;
				Extern=1;Extern1=0;
				Rin=0; 
				Rout = 0;
				done=0;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = addi3;
            end
            addi3: begin
				Ain=0; Gin=0; Gout=1;
				ALUop=3'b111;
				Extern=0;Extern1=0;
				Rin = 8'b00000001 << reg1;
				Rout=0; 
				done=1;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = FETCH;
            end
			// ---- SUBI Rx, data ----
            SUBI1: begin
				Ain=1; Gin=0; Gout=0;
				ALUop=3'b111;
				Extern=0;Extern1=0;
				Rin=0;
				Rout = 8'b00000001 << reg1;
				done=1;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = SUBI2;
            end
            SUBI2: begin
				Ain=0; Gin=1; Gout=0;
				ALUop=3'b001;
				Extern=1;Extern1=0;
				Rin=0;
				Rout = 0;
				done=0;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = SUBI3;
            end
            SUBI3: begin
				Ain=0; Gin=0; Gout=1;
				ALUop=3'b111;
				Extern=0;Extern1=0;
				Rin = 8'b00000001 << reg1;
				Rout=0; 
				done=1;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = FETCH;
            end
			// ---- LSL Rx, num bits shift ----
			// For LSL, the key states become:
			LSL1: begin
				Ain = 1; Gin = 0; Gout = 0;
				ALUop = 3'b111;
				Extern = 0;Extern1=0;
				Rin = 0;
				Rout = 8'b00000001 << reg1;
				done = 0;
				JMP = 0;
				we=0; push=0; pop=0;load=0;
				next_state = LSL2;
			end
			LSL2: begin
				Ain = 0; Gin = 1; Gout = 0;
				ALUop = 3'b100;   // LSL op
				Extern = 1;Extern1=0;       // drive immediate shift count onto bus
				Rin = 0;
				Rout = 0;
				done = 0;
				JMP = 0;
				we=0; push=0; pop=0;load=0;
				next_state = LSL3;
			end
			LSL3: begin
				Ain = 0; Gin = 0; Gout = 1;
				ALUop = 3'b111;
				Extern = 0;Extern1=0;
				Rin = 8'b00000001 << reg1;
				Rout = 0;
				done = 1;
				JMP = 0;
				we=0; push=0; pop=0;load=0;
				next_state = FETCH;
			end

			// Similarly for LSR:
        LSR1: begin
            Ain = 1; Gin = 0; Gout = 0;
            ALUop = 3'b111;
            Extern = 0;Extern1=0;
            Rin = 0;
            Rout = 8'b00000001 << reg1;
            done = 0;
            JMP = 0;
	    we=0; push=0; pop=0;load=0;
            next_state = LSR2;
        end
        LSR2: begin
            Ain = 0; Gin = 1; Gout = 0;
            ALUop = 3'b101;   // LSR op
            Extern = 1;Extern1=0;
            Rin = 0;
            Rout = 0;
            done = 0;
            JMP = 0;
	    we=0; push=0; pop=0;load=0;
            next_state = LSR3;
        end
        LSR3: begin
            Ain = 0; Gin = 0; Gout = 1;
            ALUop = 3'b111;
            Extern = 0;Extern1=0;
            Rin = 8'b00000001 << reg1;
            Rout = 0;
            done = 1;
            JMP = 0;
	    we=0; push=0; pop=0;load=0;
            next_state = FETCH;
        end

            // ---- cmp Rx, data ----
            cmp1: begin
				Ain=1; Gin=0; Gout=0;
				ALUop=3'b111;
				Extern=0;Extern1=0;
				Rin=0;
				Rout = 8'b00000001 << reg1;
				done=1;
				JMP=0;
	    			we=0; push=0; pop=0;load=0;
                next_state = cmp2;
            end
            cmp2: begin
				Ain=0; Gin=0; Gout=0;
				ALUop=3'b011;
				Extern=1;Extern1=0;
				Rin = 0;
				Rout=0; 
				done=1;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = FETCH;
            end

           // ---- brne address ----
	   brne: begin
    	     begin
        	if (zero_flag!=1) begin
            	   Ain = 0; Gin = 0; Gout = 0;
            	   ALUop = 3'b111;
            	   Extern = 0;Extern1=0;
            	   Rin = 0;
            	   Rout = 0;
            	   done = 0;
            	   JMP = 1;
		   we=0; push=0; pop=0;load=0;
            	   next_state = FETCH;
        	end else begin
            	   Ain = 0; Gin = 0; Gout = 0;
            	   ALUop = 3'b111;
            	   Extern = 0;Extern1=0;
            	   Rin = 0;
            	   Rout = 0;
            	   done = 1;
            	   JMP = 0;
		   we=0; push=0; pop=0;load=0;
            	   next_state = FETCH;
        	end
    	    end
	  end

            // ---- PUSH Rx ----
            PUSH: begin
				Ain=0; Gin=0; Gout=0;
				ALUop=3'b111;
				Extern=0;Extern1=0;
				Rin =0;
				Rout = 8'b00000001 << reg1;
				done=1;
				JMP=0;
				we=0; push=1; pop=0;load=0;
                next_state = FETCH;
            end

            // ---- POP Rx ----
            POP1: begin
				Ain=0; Gin=0; Gout=0;
				ALUop=3'b111;
				Extern=0;Extern1=0;
				Rin =0;
				Rout = 0;
				done=0;
				JMP=0;
				we=0; push=0; pop=1;load=0;
                next_state = POP2;
            end

            POP2: begin
				Ain=0; Gin=0; Gout=0;
				ALUop=3'b111;
				Extern=0;Extern1=1;
				Rin =8'b00000001 << reg1;
				Rout = 0;
				done=1;
				JMP=0;
				we=0; push=0; pop=0; load=0;
                next_state = FETCH;
            end

           // ---- str Rx, RAM_addr ----
            str: begin
				Ain=0; Gin=0; Gout=0;
				ALUop=3'b111;
				Extern=0;Extern1=0;
				Rin=0;
				Rout = 8'b00000001 << reg1;
				done=1;
				JMP=0;
				we=1; push=0; pop=0;load=0;
                next_state = FETCH;
            end

            // ---- load Rx, RAM_addr ----
            load1: begin
				Ain=0; Gin=0; Gout=0;
				ALUop=3'b111;
				Extern=0;Extern1=0;
				Rin =0;
				Rout = 0;
				done=0;
				JMP=0;
				we=0; push=0; pop=0;load=1;
                next_state = load2;
            end

            load2: begin
				Ain=0; Gin=0; Gout=0;
				ALUop=3'b111;
				Extern=0;Extern1=1;
				Rin =8'b00000001 << reg1;
				Rout = 0;
				done=1;
				JMP=0;
				we=0; push=0; pop=0;load=0;
                next_state = FETCH;
            end

            default: next_state = FETCH;
        endcase
    end
endmodule
