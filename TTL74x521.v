// TTL74x521 8-bit identity comparator (combinational)
// Purpose: Behavioral, Parameterized model of SN74ALS521 (8-bit identity comparator)
// Author: Alan Sing Teik
// Parameters:
//	 WIDTH	- default 8

module TTL74x521
#(
	parameter integer WIDTH	= 8,
)
(
	input  wire [WIDTH-1:0] P,
	input  wire [WIDTH-1:0] Q,
	input  wire				G_n,	// enable (ACTIVE_LOW)
	output wire				P_n		// low when P == Q and G_n == low
);

	// XOR each-bit
	wire [WIDTH-1:0] diff;
	assign diff = (P ^ Q);

	// Reduce per-bit equality to a single signal: low when all bits match
	wire neq;
	assign neq = (|diff);

	assign P_n = neq | G_n;

endmodule
