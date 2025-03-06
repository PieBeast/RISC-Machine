module regfile_tb();
	reg[15:0] sim_data_in;
	reg[2:0] sim_writenum, sim_readnum;
	reg sim_write, sim_clk;
	wire [15:0] sim_data_out;
	reg err = 1'b0;
	regfile DUT (
		 .data_in(sim_data_in),
		 .data_out(sim_data_out),
         .writenum(sim_writenum),
         .readnum(sim_readnum),
		 .clk(sim_clk),
		 .write(sim_write)
	);

	initial begin
	//Testing MOV R3, #42
	sim_data_in = 16'b101010;
	sim_writenum = 3'b011;
	sim_write = 1'b1;
	sim_clk = 0;
	#5;
	sim_clk = 1'b1;
	#5
	sim_clk = 1'b0;
	sim_readnum = 3'b011;
	#5
	$display("R3 is %h, should be %h", sim_data_out, sim_data_in);
	if	(sim_data_out != sim_data_in) 
		err = 1'b1;

	//Testing MOV R0, #7
	sim_data_in = 16'b111;
	sim_writenum = 3'b000;
	sim_write = 1'b1;
	sim_clk = 0;
	#5;
	sim_clk = 1'b1;
	#5
	sim_clk = 1'b0;
	sim_readnum = 3'b000;
	#5
	$display("R0 is %h, should be %h", sim_data_out, sim_data_in);
	if	(sim_data_out != sim_data_in) 
		err = 1'b1;

	//Testing MOV R1, #2
	sim_data_in = 16'b010;
	sim_writenum = 3'b001;
	sim_write = 1'b1;
	sim_clk = 0;
	#5;
	sim_clk = 1'b1;
	#5
	sim_clk = 1'b0;
	sim_readnum = 3'b001;
	#5
	$display("R1 is %h, should be %h", sim_data_out, sim_data_in);
	if	(sim_data_out != sim_data_in) 
		err = 1'b1;



	$stop;
	end


endmodule