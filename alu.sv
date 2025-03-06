`define IN1 2'b00
`define IN2 2'b01
`define IN3 2'b10
`define IN4 2'b11

module ALU(Ain,Bin,ALUop,out,Z,N,V);
input signed [15:0]  Ain, Bin;
input [1:0] ALUop;
output reg signed [15:0] out;
output reg Z,N,V;

always_comb begin //may reinstate the V, not sure how to implement yet
    case(ALUop)
        `IN1: out = Ain + Bin;
        `IN2: begin
				  out = Ain - Bin;
				  V = (~Ain[15] & ~Bin[15] & out[15]) | (Ain[15] & Bin[15] & ~out[15]);
          N = out < 0;
			  end
        `IN3: out = Ain & Bin;

        `IN4: out = ~Bin;
        default: out = 16'bxxxxxxxxxxxxxxxx;
    endcase
    if(out == 0)
    Z = 1'b1;
    else
    Z = 1'b0;
end
endmodule
