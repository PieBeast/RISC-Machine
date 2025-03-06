module cpu(clk, reset, s, load, in, out, N, V, Z, w);
	input clk, reset, s, load;
	input [15:0] in;
	output [15:0] out;
	output N, V, Z, w;

	reg [15:0] instr;
		  
	wire [15:0] next_instr, datapath_out; 
	wire loada, loadb, loadc, write, loads, asel, bsel;
	wire [1:0] shift, ALUop, vsel;
	wire [2:0] nsel, status; 
	wire [7:0] im8;
	reg [2:0] rwnum;

	assign next_instr = load ? in : next_instr;
	
	assign V = status[2]; //assign CMP status
	assign N = status[1];
	assign Z = status[0];


	stateMachine state ( //instatiate FSM
		.in(instr), 
		.s(s),
		.clk(clk), 
		.reset(reset), 
		.loada(loada),
		.loadb(loadb),
		.loadc(loadc),
		.loads(loads),
		.shift(shift),
		.ALUop(ALUop),
		.asel(asel),
		.bsel(bsel),
		.vsel(vsel),
		.write(write),
		.nsel(nsel),
		.w(w),
		.im8(im8)
	);

	always_comb begin
		case(nsel) // 001 Rn, 010 Rd, 100 Rm one hot encoding
			3'b001: rwnum = in[10:8];
			3'b010: rwnum = in[7:5];
			3'b100: rwnum = in[2:0];
			default: rwnum = 3'bx; 
		endcase
	end

	datapath DP ( //instantiate datapath
		.asel(asel), 
		.bsel(bsel), 
		.vsel(vsel), 
		.shift(shift), 
		.loada(loada), 
		.loadb(loadb), 
		.loadc(loadc), 
		.ALUop(ALUop), 
		.writenum(rwnum), 
		.write(write), 
		.readnum(rwnum),
		.clk(clk), 
		.loads(loads), 
		.datapath_out(datapath_out), 
		.status_out(status), 
		.mdata(16'bx), 
		.PC(8'bx), 
		.sximm8(im8)
	);

	always_ff @(posedge clk) begin
		instr <= next_instr;
	end
 
	 


	
endmodule