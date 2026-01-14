// TTL74x460.v
// Purpose: RTL model for SN74LS460 (10-bit comparator)
// Author: Alan Sing Teik 
// Parameters:
//	 WIDTH : bit width of operands (default to 10).
// Ports:
//	 input	[WIDTH-1:0] A : operand A
//	 input	[WIDTH-1:0] B : operand B
//	 output				EQ : true when A == B
//	 output				NE : true when A != B
// Behavior: Purely combinational compare; outputs reflect A vs B continuously.

module cmpN_comb 
#(
	parameter WIDTH = 10
)
(
	input  wire [WIDTH-1:0] A,
	input  wire [WIDTH-1:0] B,
	output wire				EQ,
	output wire				NE
);

	assign NE = |(A ^ B);	// true if any bit differs
	assign EQ = ~NE;

endmodule

