// TTL74x283.v
// Purpose: RTL model for SN74LS283 (4-bit Binary Full Adder, Ripple-Carry)
// Author: Alan Sing Teik
// Parameters: - WIDTH (default = 4)
//
// Functionality:
//	 Computes the sum of two unsigned vectors A and B with an input carry Cin,
//	 producing a result Sum and a final carry-out Cout.
//
//	 Bit-level equations per stage i:
//	   sum_i   = A[i] ^ B[i] ^ carry_i
//	   carry_(i+1) = (A[i] & B[i]) | (A[i] & carry_i) | (B[i] & carry_i)
//
// Notes:
//	 - Implements classic ripple-carry for transparency and SN74LS283 fidelity.
//	 - Fully synthesizable; uses generate-for construct for parameterization.
//	 - For purely behavioral synthesis, {Cout, Sum} = A + B + Cin is acceptable,
//	   but this RTL keeps explicit carry logic for clarity.
//==============================================================================

module TTL74x283
#(
	parameter integer WIDTH = 4
)
(
	input  wire [WIDTH-1:0]		A,
	input  wire [WIDTH-1:0]		B,
	input  wire					C0,
	output wire [WIDTH-1:0]		SUM,
	output wire					C4
);

	// Internal carry chain
	wire [WIDTH:0] carry;
	assign carry[0] = C0;

	genvar i;
	generate
		for (i = 0; i < WIDTH; i++)
		begin : gen_carry
			assign carry[i+1] = (A[i] & B[i]) |
								(A[i] & carry[i]) |
								(B[i] & carry[i]);
		end
	endgenerate

	generate
		for (i = 0; i < WIDTH; i++)
		begin : gen_fulladder
			assign SUM[i] = A[i] ^ B[i] ^ carry[i];
		end
	endgenerate	

	assign C4	= carry[WIDTH];

endmodule

