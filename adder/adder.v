module Add(
	input [31:0]a,
	input [31:0]b,
	output reg[31:0]sum
);
wire g1,g2;
wire p1,p2;
wire [31:0] res;
adder_16 add16_1 (
	.A(a[15:0]),
	.B(b[15:0]),
	.carry(1'b0),
	.F(res[15:0]),
	.P(p1),
	.G(g1)
);
wire Ca;
adder_16 add16_2 (
	.A(a[31:16]),
	.B(b[31:16]),
	.carry(Ca),
	.F(res[31:16]),
	.P(p2),
	.G(g2)
);
assign Ca=g1^(p1 & 0);
	always @(*) begin 
		sum <= res;
	end	
endmodule


module adder_16 (
	input [15:0]A,
	input [15:0]B,
	input carry,
	output [15:0]F,
	output P,
	output G
);

wire g1,g2,g3,g4;
wire p1,p2,p3,p4;
wire c1,c2,c3;

adder_4 a0(
	.x(A[3:0]),
	.y(B[3:0]),
	.c0(carry),
	.F(F[3:0]),
	.G(g1),
	.P(p1)
);

adder_4 a1(
	.x(A[7:4]),
	.y(B[7:4]),
	.c0(c1),
	.F(F[7:4]),
	.G(g2),
	.P(p2)
);

adder_4 a2(
	.x(A[11:8]),
	.y(B[11:8]),
	.c0(c2),
	.F(F[11:8]),
	.G(g3),
	.P(p3)
);

adder_4 a3(
	.x(A[15:12]),
	.y(B[15:12]),
	.c0(c3),
	.F(F[15:12]),
	.G(g4),
	.P(p4)
);

assign c1 = (g1) ^(p1&carry);
assign c2 = (g2)^(p2&g1) ^(p2&p1&carry);
assign c3 = (g3)^(p3&g2) ^(p3&p2&g1)^(p3&p2&p1&carry);

assign P = p1&p2&p3&p4;
assign G = g4 ^ (p4&g3) ^(p4&p3&g2) ^(p4&p3&p2&g1);

endmodule

module adder_4(
	input [3:0] x,
	input [3:0] y,
	input c0,
	output c4,G,P,
	output [3:0] F
) ;

wire p1,p2,p3,p4,g1,g2,g3,g4;
wire c1,c2,c3;

adder_1 a0 (
	.a(x[0]),
	.b(y[0]),
	.c(c0),
	.x(F[0])
);
		
adder_1 a1 (
	.a(x[1]),
	.b(y[1]),
	.c(c1),
	.x(F[1])
);
		
adder_1 a2 (
	.a(x[2]),
	.b(y[2]),
	.c(c2),
	.x(F[2])
);

adder_1 a3 (
	.a(x[3]),
	.b(y[3]),
	.c(c3),
	.x(F[3])
);
			
CLA cc (
	.c0(c0),
	.c1(c1),
	.c2(c2),
	.c3(c3),
	.c4(c4),
	.p1(p1),
	.p2(p2),
	.p3(p3),
	.p4(p4),
	.g1(g1),
	.g2(g2),
	.g3(g3),
	.g4(g4)
);

assign p1 = x[0]^y[0];
assign p2 = x[1]^y[1];
assign p3 = x[2]^y[2];
assign p4 = x[3]^y[3];
		

assign g1 = x[0]&y[0];
assign g2 = x[1]&y[1];
assign g3 = x[2]&y[2];
assign g4 = x[3]&y[3];

assign P = p1&p2&p3&p4;
assign G = g4^(p4&g3) ^(p4&p3&g2)^(p4&p3&p2&g1);

endmodule



module adder_1 (
	input a,
	input b,
	input c,
	output x
);

assign x=a^b^c;
assign y=(a^b) & c| a & b;

endmodule

module CLA(
	input c0,g1,g2,g3,g4,p1,p2,p3,p4,
	output c1,c2,c3,c4
);

assign c1 = g1^(p1 &c0);
assign c2 = g2^(p2&g1)^(p2&p1&c0);
assign c3 = g3^(p3&g2)^(p3&p2&g1)^(p3&p2&p1&c0);
assign c4 = g4^(p4&g3)^(p4&p3&g2)^(p4&p3&p2&g1)^(p4&p3&p2&p1&c0);

endmodule

