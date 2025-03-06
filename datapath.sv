module datapath(asel, bsel, vsel, shift, loada, loadb, loadc, ALUop, writenum, write, readnum, clk, loads, datapath_out, status_out, mdata, PC, sximm8);
	input [15:0] mdata;
	input asel, bsel, loada, loadb, loadc, write, clk, loads;
	input [1:0] shift, ALUop, vsel;
	input [2:0] writenum, readnum;
	input [7:0] sximm8, PC;
	
	output reg [2:0] status_out; //2:Z, 1:N, 0:w
	output reg [15:0] datapath_out;
	
	wire[15:0] next_loadAOut, next_loadBOut, next_status_out, next_datapath_out;
	reg [15:0] read_out, write_in, Ain, Bin, loadBOut, loadAOut, shiftOut, ALUout, sximm5;
	reg [2:0] status;
	
	//Instantiate regfile
	regfile REGFILE (
		.data_in(write_in),
		.writenum (writenum),
		.readnum (readnum),
		.write (write),
		.clk (clk),
		.data_out(read_out)
	
	);
	
	//Instantiate shifter
	shifter Shifter (
		.in(loadBOut),
		.shift(shift),
		.sout(shiftOut)
	);
	
	//Instantiate ALU
	ALU ALU (
		.Ain(Ain),
		.Bin(Bin),
		.ALUop(ALUop),
		.out(ALUout),
		.Z(status[2]),
		.N(status[1]),
		.V(status[0])
		
	);
	
	
	//Determine whether to take data input or data from output of path
	always_comb begin
		case(vsel)
			2'b00: write_in = mdata;
			2'b01: write_in = { {8{sximm8[7]}}, sximm8};
			2'b10: write_in = {8'b0, PC};
			2'b11: write_in = datapath_out;
			default: write_in = 16'bx;
		endcase
	end

	
	//Assign load registers to the next value based on given loads
	assign next_loadAOut = loada ? read_out : loadAOut;
	assign next_loadBOut = loadb ? read_out : loadBOut;
	assign next_status_out = loads ? status : status_out;
	assign next_datapath_out = loadc ? ALUout : datapath_out;
	
	//Move load registers to new value at clock posedge
	always_ff @(posedge clk) begin
		loadAOut <= next_loadAOut;
		loadBOut <= next_loadBOut;
		status_out <= next_status_out;
		datapath_out <= next_datapath_out;
	end
	
	
	//Determine input values for ALU
	always_comb begin
		case(asel)
			1'b0: Ain = loadAOut;
			1'b1: Ain = 16'd0;
			default: Ain = 16'bx;
		endcase
		case(bsel)
			1'b0: Bin = shiftOut;
			1'b1: Bin = sximm5;
			default: Bin = 16'bx;
			
		endcase
	end
	

endmodule