module datapath_tb();
    reg[7:0] sim_datapath_in; //sximm8
	reg[15:0] mdata;
	reg[2:0] sim_writenum, sim_readnum;
	reg[1:0] sim_shift, sim_ALUop;
	reg [1:0] sim_vsel;
	reg sim_write, sim_clk, sim_asel, sim_bsel, sim_loada, sim_loadb, sim_loadc, sim_loads;
	wire [2:0] sim_status;
	wire [15:0] sim_datapath_out;
	reg err = 1'b0;

	datapath DUT (
	     // Input + clk
		 .sximm8(sim_datapath_in),
		 .mdata(mdata),
		 .clk(sim_clk),

		 // Read and Writing to regfile
         .writenum(sim_writenum),
         .readnum(sim_readnum),
		 .write(sim_write),
		 .loada(sim_loada),
		 .loadb(sim_loadb),
		 .vsel(sim_vsel),


		 // Shifting and ALU operations
		 .shift(sim_shift),
		 .ALUop(sim_ALUop),
		 .asel(sim_asel),
		 .bsel(sim_bsel),
		 .loadc(sim_loadc),
		 .loads(sim_loads),

         // Outputs
		 .status_out(sim_status),
		 .datapath_out(sim_datapath_out),

		 .PC(8'b0)
	);

	initial begin
	//initializing load and sel values to block passthrough except vsel
	sim_asel = 1'b1;
	sim_bsel = 1'b1;
	sim_loada = 1'b0;
	sim_loadb = 1'b0;
	sim_loadc = 1'b0;
	sim_loads = 1'b0;

	/* Test 1
	    MOV R0, #7
	    MOV R1, #2
	    ADD R2, R1, R0 LSL #1
	*/
	//MOV R0, #7
		sim_vsel = 2'b01;
    	sim_datapath_in = 8'b111;
    	sim_writenum = 3'b000;
    	sim_write = 1'b1;
    	sim_clk = 0;
    	#5;
    	sim_clk = 1'b1;
    	#5
    	if (DUT.REGFILE.R0 != 7) err = 1;
    	$display("reg0 should be %d, it is %d", 7, DUT.REGFILE.R0);
    //MOV R1, #2 and load R0 into loadb
    	sim_datapath_in = 8'b010;
    	sim_writenum = 3'b001;
    	sim_write = 1'b1;
    	sim_clk = 0;
    	sim_loadb = 1;
    	sim_readnum = 3'b000;
    	#5;
    	sim_clk = 1'b1;
    	#5;
    	if (DUT.REGFILE.R1 != 2) err = 1;
    	$display("loadb should be %d, it is %d", 2, DUT.REGFILE.R1);
    //Read R1 to loada and shift loadb
        sim_write = 1'b0;
        sim_readnum = 3'b001;
        sim_loadb = 0;
        sim_loada = 1;
        sim_shift = 2'b01;
        sim_clk = 0;
        #5;
        sim_clk = 1;
        #5;
    // ADD reg a and reg b together in ALU
        sim_loada = 0;
        sim_shift = 2'b01;
        sim_clk = 0;
        sim_asel = 0;
        sim_bsel = 0;
        sim_ALUop = 2'b00;
        sim_loadc = 1;
        #5;
        sim_clk = 1;
        #5;
    //Write output to R2
        sim_write = 1;
        sim_writenum = 3'b010;
        sim_asel = 1;
        sim_bsel = 1;
        sim_loadc = 0;
        sim_vsel = 2'b11;
        sim_clk = 0;
        #5;
        sim_clk = 1;
        #5;
    	if (DUT.REGFILE.R2 != 16) err = 1;
    	$display("reg2 should be %d, it is %d", 16, DUT.REGFILE.R2);
        #5;

        /* Test 2
    	MOV R5, #55
    	SUB R6, R5, R2 LSR #1 */

 	    //MOV R5, #55 and Load R2 to loadb
     	sim_datapath_in = 8'b01010101;
     	sim_vsel = 2'b01;
     	sim_writenum = 3'b101;
     	sim_readnum = 3'b010;
     	sim_write = 1;
     	sim_loadb = 1;
     	sim_clk = 0;
     	#5;
     	sim_clk = 1'b1;
     	#5
     	if (DUT.REGFILE.R5 != 85) err = 1;
     	$display("loadb should be %d, it is %d", 85, DUT.REGFILE.R5);

     	//Read R5 to loada and right shift loadb
        sim_write = 1'b0;
        sim_readnum = 3'b101;
        sim_loadb = 0;
        sim_loada = 1;
        sim_shift = 2'b10;
        sim_clk = 0;
        #5;
        sim_clk = 1;
        #5;


        //R5 subtract R2(shifted)
        sim_loada = 0;
        sim_ALUop = 2'b01;
        sim_loadc = 1;
        sim_asel = 0;
        sim_bsel = 0;
        sim_clk = 0;
        #5;
        sim_clk = 1;
        #5;
        if (sim_datapath_out != 77) err = 1;
        $display("loadb should be %d, it is %d", 77, sim_datapath_out);

        //Write output to R6
        sim_loadc = 0;
        sim_write = 1;
      	sim_writenum = 3'b110;
        sim_vsel = 2'b11;
        sim_asel = 1;
        sim_bsel = 1;
        sim_clk = 0;
        #5;
        sim_clk = 1;
        #5;
    	if (DUT.REGFILE.R6 != 77) err = 1;
    	$display("loadb should be %d, it is %d", 77, DUT.REGFILE.R6);

	end

endmodule