// TTL74x518.v
// Purpose: RTL model for SN74ALS518 (8-bit comparator with Enable)
// Author: Alan Sing Teik 
// Parameters:
//	 WIDTH : bit width of operands (default to 8).
// Behavior: Purely combinational compare; outputs reflect A vs B continuously.

module cmpN_comb 
#(
	parameter WIDTH = 8
)
(
	input  wire [WIDTH-1:0]	A,		// operand A
	input  wire [WIDTH-1:0]	B,		// operand B
	input  wire				G_n,	// enable active low
 	output wire				P		// true when A == B
);

	wire [WIDTH-1:0] diff;
	assign diff = (A ^ B);			// true if any bit differ

	assign P = &(~diff) & ~G_n;

endmodule

