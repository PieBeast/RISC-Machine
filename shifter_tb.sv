`define IN1 2'b00
`define IN2 2'b01
`define IN3 2'b10
`define IN4 2'b11

module shifter_tb();
reg [15:0] sim_in;
reg [1:0] sim_shift;
reg [15:0] sim_sout;
reg err = 0;
reg [15:0] temp;
reg [15:0] outCompare;
shifter DUT(
    .in(sim_in),
    .shift(sim_shift),
    .sout(sim_sout)
);//Instatiate shifter with simulation input/output

initial begin

//Checks that nothing is done
sim_in = 16'b1111000011001111;
sim_shift = `IN1;
#20;
if(sim_sout != sim_in)
    err = 1;
$display("Output is %h, should be %h", sim_sout, sim_in);

//Checks that input was shifted left by 1, and lsf is 0
sim_in = 16'b1111000011001111;
sim_shift = `IN2;
#20;
if(sim_sout != sim_in << 1)
    err = 1;
$display("Output is %h, should be %h", sim_sout, sim_in << 1);

//Checks that input was shifted right by 1, and msf is 0
sim_in = 16'b1111000011001111;
sim_shift = `IN3;
#20;
if(sim_sout != sim_in >> 1)
    err = 1;
$display("Output is %h, should be %h", sim_sout, sim_in >> 1);

//Checks that input was shifted right by 1, and msf is in[15].
sim_in = 16'b1111000011001111;
sim_shift = `IN4;
#20;
temp = sim_in >> 1;
outCompare = {sim_in[15], temp[14:0]};
if(sim_sout != outCompare)
    err = 1;
$display("Output is %h, should be %h", sim_sout, outCompare);

//Checks that input is the same with a different input
sim_in = 16'b0111000011001101;
sim_shift = `IN1;
#20;
if(sim_sout != sim_in)
    err = 1;
$display("Output is %h, should be %h", sim_sout, sim_in);

//Checks for a left shift by 1 with a different input wiht lsf 0
sim_in = 16'b0111000011001101;
sim_shift = `IN2;
#20;
if(sim_sout != sim_in << 1)
    err = 1;
$display("Output is %h, should be %h", sim_sout, sim_in << 1);

//Checks for a right shift 1 with msf 0
sim_in = 16'b0111000011001101;
sim_shift = `IN3;   
#20;
if(sim_sout != sim_in >> 1)
    err = 1;
$display("Output is %h, should be %h", sim_sout, sim_in >> 1);

//Checks for a right shift by 1 msf of in[15]
sim_in = 16'b0111000011001101;
sim_shift = `IN4;
#20;
temp = sim_in >> 1;
outCompare = {sim_in[15], temp[14:0]};
if(sim_sout != outCompare)
    err = 1;
$display("Output is %h, should be %h", sim_sout, outCompare);
end

endmodule