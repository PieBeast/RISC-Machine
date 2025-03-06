//Define one-hot codes for regs
`define R0 8'b00000001
`define R1 8'b00000010
`define R2 8'b00000100
`define R3 8'b00001000
`define R4 8'b00010000
`define R5 8'b00100000
`define R6 8'b01000000
`define R7 8'b10000000


module regfile(data_in, writenum, write, readnum, clk, data_out);

	input[15:0] data_in;
	input[2:0] writenum, readnum;
	input write, clk;
	output reg [15:0] data_out;
	reg [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
	
	//3:8 decoder for read and write num
	wire[7:0] writenumdec = 1 << writenum;
	wire[7:0] readnumdec = 1 << readnum;
	
	//AND writenum with write
	wire[7:0] writenumAND = writenumdec & {8{write}};
	reg dump;
	
	
	//Move data into reg
	always_ff @(posedge clk) begin
		case(writenumAND)
			`R0: R0 <= data_in;
			`R1: R1 <= data_in;
			`R2: R2 <= data_in;
			`R3: R3 <= data_in;
			`R4: R4 <= data_in;
			`R5: R5 <= data_in;
			`R6: R6 <= data_in;
			`R7: R7 <= data_in;
			default: dump <= 1'b1;
		endcase 
	end
	//Read data out of reg
	always_comb begin
		case(readnumdec)
			`R0: data_out <= R0;
			`R1: data_out <= R1;
			`R2: data_out <= R2;
			`R3: data_out <= R3;
			`R4: data_out <= R4;
			`R5: data_out <= R5;
			`R6: data_out <= R6;
			`R7: data_out <= R7;
			default: data_out = 16'bxxxxxxxxxxxxxxxx;
		endcase
	end
endmodule