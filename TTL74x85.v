// TTL74x85.v
// Purpose: Parameterized RTL model of SN74LS85 (4-bit magnitude comparator)
// Author: Alan Sing Teik
// Parameters:
//	 WIDTH - bit width of the words compared (default 4).
// Behavior:
//	 - Combinational comparator producing GT (A>B), EQ (A==B), LT (A<B).
//	 - Supports cascading via expand inputs I_GT, I_EQ, I_LT.

module TTL74x85 
#(
	parameter WIDTH = 4
)
(
	input  wire	[WIDTH-1:0]	A,
	input  wire	[WIDTH-1:0]	B,
	input  wire				I_GT,
	input  wire				I_EQ,
	input  wire				I_LT,
	output wire				GT,
	output wire				EQ,
	output wire				LT
);

	wire A_GT_B;
	assign A_GT_B = (A > B);

	wire A_LT_B;
	assign A_LT_B = (A < B);

	reg lt;
	always @(*)
		if (A_GT_B)
			lt = 1'b0;
		else
		if (A_LT_B)
			lt = 1'b1;
		else
			// simplify from datasheet LT = (!I_GT && !I_LT && !I_EQ) || (!I_GT &&  I_LT &&  !I_EQ);
			lt = !I_GT && !I_EQ;

	reg gt;
	always @(*)
		if (A_GT_B)
			gt = 1'b1;
		else
		if (A_LT_B)
			gt = 1'b0;
		else
			// simplify from datasheet GT = (!I_GT && !I_LT && !I_EQ) || ( I_GT && !I_LT && !I_EQ); 
			gt = !I_LT && !I_EQ;

	reg eq;
	always @(*)
		if (A_GT_B)
			eq = 1'b0;
		else
		if (A_LT_B)
			eq = 1'b0;
		else
			eq = I_EQ;

	assign LT = lt;
	assign EQ = eq;
	assign GT = gt;

endmodule

