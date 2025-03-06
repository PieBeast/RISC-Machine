`define S0 5'b00000 //wait
`define S1 5'b00001 //Decode
`define S2 5'b00010 //MOV
`define S3 5'b00011 //ALU
`define S4 5'b00100 //MOV with constant
`define S5 5'b00101 //MOV with another register: load reg
`define S6 5'b00110 //MOV with another register: shift
`define S7 5'b00111 //MOV with another register: move into reg
`define S8 5'b01000 //ADD: GetA 
`define S9 5'b01001 //ADD: GetB 
`define S10 5'b01010 //ADD: Add
`define S11 5'b01011 //ADD: Store 
`define S12 5'b01100 //CMP: GetA
`define S13 5'b01101 //CMP: GetB
`define S14 5'b01110 //CMP: Shift, subtract
`define S15 5'b01111 //AND: GetA
`define S16 5'b10000 //AND: GetB
`define S17 5'b10001 //AND: And
`define S18 5'b10010 //AND: Store
`define S19 5'b10011 //NOT: GetB
`define S20 5'b10100 //NOT: Not
`define S21 5'b10101 //NOT: Store
`define S22 5'b10110 //TEST


module stateMachine(in, s, clk, reset, loada, loadb, loadc, loads, shift, ALUop, asel, bsel, vsel, write, nsel, w, im8);
    input s, clk, reset;
	input [15:0] in;
    wire [2:0] opcode = in[15:13];
    wire [1:0] op = in[12:11];

	output reg [2:0] nsel; // 001 Rn, 010 Rd, 100 Rm one hot encoding
    output reg loada, loadb, loadc, loads, write, w, asel, bsel;
    output reg [1:0] shift, ALUop, vsel;
	output reg [7:0] im8;

	reg [4:0] presentState;

    always_ff @(posedge clk) begin	 
		if(reset) begin
			presentState <= `S0;
		end
		else begin
			case(presentState)
		
			`S0: presentState <= s ? `S1 : `S0;
			`S1: begin 
				 case(opcode)
					3'b110: presentState <= `S2;
					3'b101: presentState <= `S3;
					default: presentState <= `S1;
				 endcase
			end
			`S2: begin
				 case(op)
					2'b10: presentState <= `S4;
					2'b00: presentState <= `S5;
					default: presentState <= presentState;
				 endcase
			end
			`S3: begin
				 case(op)
					2'b00: presentState <= `S8;
					2'b01: presentState <= `S12;
					2'b10: presentState <= `S15; 
					2'b11: presentState <= `S19; 
				 endcase
			end
			`S4: presentState <= `S0;
			`S5: presentState <= `S6;
			`S6: presentState <= `S7;
			`S7: presentState <= `S0;
			`S8: presentState <= `S9;
			`S9: presentState <= `S10;
			`S10: presentState <= `S11;
			`S11: presentState <= `S0;
			`S12: presentState <= `S13;
			`S13: presentState <= `S14; 
			`S14: presentState <= `S0; 
			`S15: presentState <= `S16;
			`S16: presentState <= `S17;
			`S17: presentState <= `S18;
			`S18: presentState <= `S19; 
			`S19: presentState <= `S20; 
			`S20: presentState <= `S21; 
			`S21: presentState <= `S0;  

			default: presentState <= presentState;
			endcase	
		end
	end
	
	always_comb begin
		case(presentState) //TODO: Decide what to do with this
			/* Since these first few don't do anything to the datapath,
			send out null values. This will also help us catch inferred latches
			*/
			`S0: begin //Wait
				 vsel = 2'bxx;
				 asel = 1'bx;
				 bsel = 1'bx;
				 write = 1'b0;
				 nsel = 3'bx;
				 loada = 1'b0;
				 loadb = 1'b0;
				 loadc = 1'b0;
				 loads = 1'b0;
				 ALUop = 2'bxx;
				 shift = 2'bxx;
				 w = 1'b1;
				 im8 = 8'bx;
			end
			`S1: begin //Decode
				 vsel = 2'bxx;
				 asel = 1'bx;
				 bsel = 1'bx;
				 write = 1'bx;
				 nsel = 3'bx;
				 loada = 1'b0;
				 loadb = 1'b0;
				 loadc = 1'b0;
				 loads = 1'b0;
				 ALUop = 2'bxx;
				 shift = 2'bxx;
				 w = 1'b0;
				 im8 = 8'bx;
			end
			`S2: begin //MOV
				 vsel = 2'bxx;
				 asel = 1'bx;
				 bsel = 1'bx;
				 write = 1'bx;
				 nsel = 3'bx;
				 loada = 1'b0;
				 loadb = 1'b0;
				 loadc = 1'b0;
				 loads = 1'b0;
				 ALUop = 2'bxx;
				 shift = 2'bxx;
				 im8 = 8'bx;
				 w = 1'b0;
				 
			end 
			`S3: begin //ALU
				 vsel = 2'bxx;
				 asel = 1'bx;
				 bsel = 1'bx;
				 write = 1'bx;
				 nsel = 3'bx;
				 loada = 1'b0;
				 loadb = 1'b0;
				 loadc = 1'b0;
				 loads = 1'b0;
				 ALUop = 2'bxx;
				 shift = 2'bxx;
				 im8 = 8'bx;
				 w = 1'b0;
			end 
			`S4: begin //MOV with constant
				 vsel = 2'b01;
				 asel = 1'bx;
				 bsel = 1'bx;
				 write = 1'b1;
				 nsel = 3'b001;
				 loada = 0;
				 loadb = 0;
				 loadc = 0;
				 loads = 1'b0;
				 ALUop = 2'bxx;
				 shift = 2'bxx;
				 im8 = in[7:0];
				 w = 1'b0;
			end
			`S5: begin //Mov with another reg
				 vsel = 2'bxx;
				 asel = 1'bx;
				 bsel = 1'bx;
				 write = 1'b0;
				 nsel = 3'b100;
				 loada = 0;
				 loadb = 1;
				 loadc = 0;
				 loads = 1'b0;
				 ALUop = 2'bxx;
				 shift = 2'bxx;
				 im8 = 8'bx;
				 w = 1'b0;

			end 
			`S6: begin //MOV with another register: shift
				 vsel = 2'bxx;
				 asel = 1'b1;
				 bsel = 1'b0;
				 write = 1'b0;
				 nsel = 3'b000;
				 loada = 0;
				 loadb = 0;
				 loadc = 1;
				 loads = 1'b0;
				 ALUop = 2'b00;
				 shift = in[4:3];
				 im8 = 8'bx;
				 w = 1'b0;
			end 
			`S7: begin //MOV with another register: move into reg
				 vsel = 2'b11;
				 asel = 1'bx;
				 bsel = 1'bx;
				 write = 1'b1;
				 nsel = 3'b010;
				 loada = 0;
				 loadb = 0;
				 loadc = 0;
				 loads = 1'b0;
				 ALUop = 2'bxx;
				 shift = 2'bxx;
				 im8 = 8'bx;
				 w = 1'b0;
			end 
			`S8: begin //ADD: GetA 
				 vsel = 2'bxx;
				 asel = 1'bx;
				 bsel = 1'bx;
				 write = 1'b0;
				 nsel = 3'b001;
				 loada = 1;
				 loadb = 0;
				 loadc = 0;
				 loads = 1'b0;
				 ALUop = 2'bxx;
				 shift = 2'bxx;
				 im8 = 8'bx;
				 w = 1'b0;
			end 
			`S9: begin //ADD: GetB 
				 vsel = 2'bxx;
				 asel = 1'bx;
				 bsel = 1'bx;
				 write = 1'b0;
				 nsel = 3'b100;
				 loada = 0;
				 loadb = 1;
				 loadc = 0;
				 loads = 1'b0;
				 ALUop = 2'bxx;
				 shift = 2'bxx;
				 im8 = 8'bx;
				 w = 1'b0;
			end 
			`S10: begin //ADD: Add
				 vsel = 2'bxx;
				 asel = 1'b0;
				 bsel = 1'b0;
				 write = 1'b0;
				 nsel = 3'b000;
				 loada = 0;
				 loadb = 0;
				 loadc = 1;
				 loads = 1'b0;
				 ALUop = 2'b00;
				 shift = in[4:3];
				 im8 = 8'bx;
				 w = 1'b0;
			end 
			`S11: begin //ADD: Store 
				 vsel = 2'b11;
				 asel = 1'bx;
				 bsel = 1'bx;
				 write = 1'b1;
				 nsel = 3'b010;
				 loada = 0;
				 loadb = 0;
				 loadc = 0;
				 loads = 1'b0;
				 ALUop = 2'b00;
				 shift = 2'bxx;
				 im8 = 8'bx;
				 w = 1'b0;
			end 
			`S12: begin //CMP: GetA
				 vsel = 2'bxx;
				 asel = 1'bx;
				 bsel = 1'bx;
				 write = 1'b0;
				 nsel = 3'b001;
				 loada = 1;
				 loadb = 0;
				 loadc = 0;
				 loads = 1'b0;
				 ALUop = 2'bxx;
				 shift = 2'bxx;
				 im8 = 8'bx;
				 w = 1'b0;
			end 
			`S13: begin //CMP: GetB
				 vsel = 2'bxx;
				 asel = 1'bx;
				 bsel = 1'bx;
				 write = 1'b0;
				 nsel = 3'b100;
				 loada = 0;
				 loadb = 1;
				 loadc = 0;
				 loads = 1'b0;
				 ALUop = 2'bxx;
				 shift = 2'bxx;
				 im8 = 8'bx;
				 w = 1'b0;
			end 
			`S14: begin //CMP: Shift, subtract
				 vsel = 2'bxx;
				 asel = 1'b0;
				 bsel = 1'b0;
				 write = 1'b0;
				 nsel = 3'b000;
				 loada = 0;
				 loadb = 0;
				 loadc = 0;
				 loads = 1'b1;
				 ALUop = 2'b01;
				 shift = in[4:3];
				 im8 = 8'bx;
				 w = 1'b0;
			end 
			`S15: begin //AND: GetA
				 vsel = 2'bxx;
				 asel = 1'bx;
				 bsel = 1'bx;
				 write = 1'b0;
				 nsel = 3'b001;
				 loada = 1;
				 loadb = 0;
				 loadc = 0;
				 loads = 1'b0;
				 ALUop = 2'bxx;
				 shift = 2'bxx;
				 im8 = 8'bx;
				 w = 1'b0;
			end 
			`S16: begin //AND: GetB
				 vsel = 2'bxx;
				 asel = 1'bx;
				 bsel = 1'bx;
				 write = 1'b0;
				 nsel = 3'b100;
				 loada = 0;
				 loadb = 1;
				 loadc = 0;
				 loads = 1'b0;
				 ALUop = 2'bxx;
				 shift = 2'bxx;
				 im8 = 8'bx;
				 w = 1'b0;
			end 
			`S17: begin //AND: And
				 vsel = 2'bxx;
				 asel = 1'b0;
				 bsel = 1'b0;
				 write = 1'b0;
				 nsel = 3'b000;
				 loada = 0;
				 loadb = 0;
				 loadc = 1;
				 loads = 1'b0;
				 ALUop = 2'b10;
				 shift = in[4:3];
				 im8 = 8'bx;
				 w = 1'b0;
			end 
			`S18: begin //AND: Store
				 vsel = 2'b11;
				 asel = 1'bx;
				 bsel = 1'bx;
				 write = 1'b1;
				 nsel = 3'b010;
				 loada = 0;
				 loadb = 0;
				 loadc = 0;
				 loads = 1'b0;
				 ALUop = 2'b00;
				 shift = 2'bxx;
				 im8 = 8'bx;
				 w = 1'b0;
			end 
			`S19: begin //NOT: GetB
				 vsel = 2'bxx;
				 asel = 1'b0;
				 bsel = 1'b0;
				 write = 1'b1;
				 nsel = 3'b001;
				 loada = 0;
				 loadb = 1;
				 loadc = 0;
				 loads = 1'b0;
				 ALUop = 2'bxx;
				 shift = 2'b0;
				 im8 = 8'bx;
				 w = 1'b0;
			end 
			`S20: begin//NOT: Not
				 vsel = 2'bxx;
				 asel = 1'b1;
				 bsel = 1'b0;
				 write = 1'b0;
				 nsel = 3'b001;
				 loada = 0;
				 loadb = 0;
				 loadc = 1;
				 loads = 1'b0;
				 ALUop = 2'b11;
				 shift = in[4:3];
				 im8 = 8'bx;
				 w = 1'b0;
			end 
			`S21: begin //NOT: Store
				 vsel = 2'b11;
				 asel = 1'bx;
				 bsel = 1'bx;
				 write = 1'b1;
				 nsel = 3'b010;
				 loada = 0;
				 loadb = 0;
				 loadc = 0;
				 loads = 1'b0;
				 ALUop = 2'b00;
				 shift = 2'bxx;
				 im8 = 8'bx;
				 w = 1'b0;
			end 
			default: begin
				 vsel = 2'bxx;
				 asel = 1'bx;
				 bsel = 1'bx;
				 write = 1'b0;
				 nsel = 3'bx;
				 loada = 1'b0;
				 loadb = 1'b0;
				 loadc = 1'b0;
				 loads = 1'b0;
				 ALUop = 2'bxx;
				 shift = 2'bxx;
				 w = 1'b0;
				 im8 = 8'bx;
			end 
		endcase
	end


endmodule