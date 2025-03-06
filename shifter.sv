`define IN1 2'b00
`define IN2 2'b01
`define IN3 2'b10
`define IN4 2'b11

module shifter(in,shift,sout);
input [15:0] in;
input [1:0] shift;
output reg [15:0] sout;

always_comb begin
    case(shift)
    `IN1: sout = in;
    `IN2: sout = in << 1;
    `IN3: sout = in >> 1;
    `IN4: begin sout = in >> 1;
          sout = {in[15], sout[14:0]};
    end
    default: sout = 16'bxxxxxxxxxxxxxxxx;
    endcase
end

endmodule