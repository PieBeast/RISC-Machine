module ALU_tb();
reg [15:0] sim_Ain, sim_Bin;
reg [1:0] sim_ALUop;
reg [15:0] sim_out;
reg sim_Z;
reg err = 0;

ALU DUT(
    .Ain(sim_Ain),
    .Bin(sim_Bin),
    .ALUop(sim_ALUop),
    .out(sim_out),
    .Z(sim_Z)
); // Instantiate the ALU module with the simulation regs
initial begin
    //Test Ain + Bin
    sim_Ain = 16'b0000111110000000;
    sim_Bin = 16'b0000000001111111;
    sim_ALUop = 2'b00; //Addition
    #20;
    if(sim_out != sim_Ain + sim_Bin) //Ensures the output is correct, otherwise sets signal of err to 1
        err = 1;
    $display("Output is %h, should be %h", sim_out, sim_Ain + sim_Bin);
    //Test Ain - Bin, and test Z is 0
    sim_Ain = 16'b0000111110000000;
    sim_Bin = 16'b0000111110000000;
    sim_ALUop = 2'b01; //Subtraction
    #20;
    if(sim_out != sim_Ain - sim_Bin)
        err = 1;
    $display("Output is %h, should be %h", sim_out, sim_Ain - sim_Bin);
    //Test Ain & Bin
    sim_Ain = 16'b0000111110100100;
    sim_Bin = 16'b0000111110010000;
    sim_ALUop = 2'b10; //Logical AND
    #20;
    if(sim_out != sim_Ain & sim_Bin)
        err = 1;
    $display("Output is %h, should be %h", sim_out, sim_Ain & sim_Bin);
    //Test ~Bin
    sim_Ain = 16'b0000111110100100;
    sim_Bin = 16'b0000111110010000;
    sim_ALUop = 2'b11; //Logical NOT
    #20;
    if(sim_out != ~sim_Bin)
        err = 1;
    $display("Output is %h, should be %h", sim_out, ~sim_Bin);
    //Test A + B with 0
    sim_Ain = 16'b0000000000000000;
    sim_Bin = 16'b0000000000000000;
    sim_ALUop = 2'b00; //Addition
    #20;
    if(sim_out != sim_Ain + sim_Bin) //Ensures the output is correct, otherwise sets signal of err to 1
        err = 1;
    $display("Output is %h, should be %h", sim_out, sim_Ain + sim_Bin);
    //Test A - B with 0
    sim_Ain = 16'b0000000000000000;
    sim_Bin = 16'b0000000000000000;
    sim_ALUop = 2'b01; //Subtraction
    #20;
    if(sim_out != sim_Ain - sim_Bin)
        err = 1;
    $display("Output is %h, should be %h", sim_out, sim_Ain - sim_Bin);
    //Test A & B with 0
    sim_Ain = 16'b0000000000000000;
    sim_Bin = 16'b0000000000000000;
    sim_ALUop = 2'b10; //Logical AND
    #20;
    if(sim_out != sim_Ain & sim_Bin)
        err = 1;
    $display("Output is %h, should be %h", sim_out, sim_Ain & sim_Bin);
    //Test  ~B with 0
    sim_Ain = 16'b0000000000000000;
    sim_Bin = 16'b0000000000000000;
    sim_ALUop = 2'b11; //Logical NOT
    #20;
    if(sim_out != ~sim_Bin)
        err = 1;
    $display("Output is %h, should be %h", sim_out, ~sim_Bin);
end

endmodule