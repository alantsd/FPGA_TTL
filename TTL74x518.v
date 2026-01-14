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
	input  wire [WIDTH-1:0]	P,		// operand A
	input  wire [WIDTH-1:0]	Q,		// operand B
	input  wire				G_n,	// enable active low
 	output wire				EQ		// true when A == B
);

	wire [WIDTH-1:0] diff;
	assign diff = (P ^ Q);	

	assign EQ = &(~diff) & ~G_n;

endmodule

