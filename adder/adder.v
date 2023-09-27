/* ACM Class System (I) Fall Assignment 1 
 *
 *
 * Implement your naive adder here
 * 
 * GUIDE:
 *   1. Create a RTL project in Vivado
 *   2. Put this file into `Sources'
 *   3. Put `test_adder.v' into `Simulation Sources'
 *   4. Run Behavioral Simulation
 *   5. Make sure to run at least 100 steps during the simulation (usually 100ns)
 *   6. You can see the results in `Tcl console'
 *
 */
module adder_1 (
	input a,
	input b,
	input c,
	output x,
	output y,
	output z
);

assign x=a^b^c;
assign y=a&b;
assign z=a|b;
endmodule


module ALUC (
	input [3:0]A,
	input [3:0]B,
	input c,
	output [4:1]ca,
	output G,
	output P
);

assign ca[1]=B[0]|A[0]&c;
assign ca[2]=B[1]|A[1]&B[0]|A[1]&A[0]&c;
assign ca[3]=B[2]|A[2]&B[1]|A[2]&A[1]&B[0]|A[2]&A[1]&A[0]&c;
assign ca[4]=B[3]|A[3]&B[2]|A[3]&A[2]&B[1]|A[3]&A[2]&A[1]&B[0]|A[3]&A[2]&A[1]&A[0]&c;

assign G=B[3]|A[3]&B[2]|A[3]&A[2]&B[1]|A[3]&A[2]&A[1]&B[0];
assign P=A[3]&A[2]&A[1]&A[0];

endmodule

module adder_4 (
	input [3:0]A,
	input [3:0]B,
	input c,
	output [3:0]ca,
	output G,
	output P
);
wire [3:0]g;
wire [3:0]p;
wire [4:1]cc;

adder_1 a0 (
	.a(A[0]),
	.b(B[0]),
	.c(c),
	.x(ca[0]),
	.y(g[0]),
	.z(p[0])
);

adder_1 a1 (
	.a(A[1]),
	.b(B[1]),
	.c(cc[1]),
	.x(ca[1]),
	.y(g[1]),
	.z(p[1])
);

adder_1 a2 (
	.a(A[2]),
	.b(B[2]),
	.c(cc[2]),
	.x(ca[2]),
	.y(g[2]),
	.z(p[2])
);

adder_1 a3 (
	.a(A[3]),
	.b(B[3]),
	.c(cc[3]),
	.x(ca[3]),
	.y(g[3]),
	.z(p[3])
);

ALUC aa (
	.A(A),
	.B(B),
	.c(c),
	.ca(cc),
	.G(G),
	.P(P)
);

endmodule

module adder_16 (
	input [15:0]A,
	input [15:0]B,
	input carry,
	output [15:0]F,
	output G,
	output P,
	output ou
);

wire [3:0]G1;
wire [3:0]P1;
wire [4:1]C1;

adder_4 a0(
	.A(A[3:0]),
	.B(B[3:0]),
	.c(carry),
	.ca(F[3:0]),
	.G(G1[0]),
	.P(P1[0])
);

adder_4 a1(
	.A(A[7:4]),
	.B(B[7:4]),
	.c(C1[1]),
	.ca(F[7:4]),
	.G(G1[1]),
	.P(P1[1])
);

adder_4 a2(
	.A(A[11:8]),
	.B(B[11:8]),
	.c(C1[2]),
	.ca(F[11:8]),
	.G(G1[2]),
	.P(P1[2])
);

adder_4 a3(
	.A(A[15:12]),
	.B(B[15:12]),
	.c(C1[3]),
	.ca(F[15:12]),
	.G(G1[3]),
	.P(P1[3])
);

ALUC aa (
	.A(P1),
	.B(G1),
	.c(carry),
	.ca(C1),
	.G(G),
	.P(P)
);

assign ou = C1[4];

endmodule


module adder(
	input [31:0]A,
	input [31:0]B,
	output [31:0]answer,
	output Carry
);
wire[1:0]G;
wire[1:0]P;

adder_16 add16_1 (
	.A(A[15:0]),
	.B(B[15:0]),
	.carry(1'b0),
	.F(answer[15:0]),
	.G(G[0]),
	.P(P[0])
);
wire Ca;
adder_16 add16_2 (
	.A(A[31:16]),
	.B(B[31:16]),
	.carry(Ca),
	.F(answer[31:16]),
	.G(G[1]),
	.P(P[1])
);
assign Ca=G[0]|P[0]&1'b0;
assign Carry=G[1]|P[1]&G[0]|P[1]&P[0]&1'b0;
	
endmodule
