module cpu_tb();

reg sim_clk, sim_reset, sim_s, sim_load;
reg [15:0] sim_in;
wire [15:0] sim_out;
wire sim_N, sim_V, sim_Z, sim_w;

cpu DUT(
    .clk(sim_clk),
    .reset(sim_reset),
    .s(sim_s),
    .load(sim_load),
    .in(sim_in),
    .out(sim_out),
    .N(sim_N),
    .V(sim_V),
    .Z(sim_Z),
    .w(sim_w)
);
initial begin
    sim_clk = 0; #5;
    forever begin
        sim_clk = 1; #5;
        sim_clk = 0; #5;
    end
end
initial begin
//MOV R0, #10
    sim_reset = 1;
    sim_s = 0; 
    sim_load = 0; 
    sim_in = 16'b0;
    #10;
    sim_reset = 0; 
    #10;

    sim_in = 16'b1101000000001010;
    sim_load = 1;
    #10;
    sim_load = 0;
    sim_s = 1;
    #10
    sim_s = 0;
    @(posedge sim_w);
    #10;
    $display("Expected %d, actual %d", 10, cpu_tb.DUT.DP.REGFILE.R0);
//MOV R1, #3
    @(negedge sim_clk);
    sim_in = 16'b1101000100000011;
    sim_load = 1;
    #10;
    sim_load = 0;
    sim_s = 1;
    #10
    sim_s = 0;
    @(posedge sim_w);
    #10;
    $display("Expected %d, actual %d", 3, cpu_tb.DUT.DP.REGFILE.R1);
//MOV R2, R1
    @(negedge sim_clk);
    sim_in = 16'b1100000001000001;
    sim_load = 1;
    #10;
    sim_load = 0;
    sim_s = 1;
    #10
    sim_s = 0;
    @(posedge sim_w);
    #10;
    $display("Expected %d, actual %d", 3, cpu_tb.DUT.DP.REGFILE.R2);
//ADD R4, R1, R0, LSL#1
    @(negedge sim_clk);
    sim_in = 16'b1010000110001000;
    sim_load = 1;
    #10;
    sim_load = 0;
    sim_s = 1;
    #10
    sim_s = 0;
    @(posedge sim_w);
    #10;
    $display("Expected %d, actual %d", 23, cpu_tb.DUT.DP.REGFILE.R4);
//CMP R1, R0
    @(negedge sim_clk);
    sim_in = 16'b1010100100000000;
    sim_load = 1;
    #10;
    sim_load = 0;
    sim_s = 1;
    #10
    sim_s = 0;
    @(posedge sim_w);
    #10;
    $display("Expected %d, actual %d", 0, sim_Z);
//AND R5, R1, R0
    @(negedge sim_clk);
    sim_in = 16'b1011000110100000;
    sim_load = 1;
    #10;
    sim_load = 0;
    sim_s = 1;
    #10
    sim_s = 0;
    @(posedge sim_w);
    #10;
    $display("Expected %d, actual %d", 2, cpu_tb.DUT.DP.REGFILE.R5);    
//MVN R6, R0
    @(negedge sim_clk);
    sim_in = 16'b1011100011000000;
    sim_load = 1;
    #10;
    sim_load = 0;
    sim_s = 1;
    #10
    sim_s = 0;
    @(posedge sim_w);
    #10;
    $display("Expected %d, actual %d", 16'b1111111111110101, cpu_tb.DUT.DP.REGFILE.R6);
    $stop; 
end

endmodule