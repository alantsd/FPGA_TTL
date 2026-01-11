// TTL74x182.v
// Purpose: RTL model of the DM74S182 (4-bit carry lookahead generator).
// Author: Alan Sing Teik
// Description:
//	 Computes carry outputs C1–C3 and group propagate/generate signals
//	 from individual propagate (P) and generate (G) inputs.
//	 C0 is CIN, thus no need to output it again.
//
// Usage as carry lookahead Adder:
// P = A BITWISE-XOR B
// G = A BITWISE-AND B
// XOR and AND gates is external to TTL74x182
//
// external XOR gate is needed to generate SUM:
// SUM = A BITWISE-XOR B BITWISE-XOR C, since P = A BITWISE-XOR B
// thus
// SUM = ~P_n BITWISE-XOR {COUT, CIN}

// Canonical equation is:
// COUT0 = CIN
// COUTi = Gi | Pi & Ci-1
//
// Group generate (G) 
// — a single bit that is 1 when the 4-bit block will produce a carry out regardless of CIN
//
// Block propagate (P) 
// — 1 only if all four bit‑propagates are 1, meaning the block will pass an CIN through to its output

module TTL74x182 
(
	input  wire [3:0]	P_n,		// Propagate bits
	input  wire [3:0]	G_n,		// Generate bits
	input  wire			CIN,		// Carry-in, CN pin
	output wire [2:0]	COUT,		// Carry outputs x, y, z (active high)
	output wire			POUT_n,		// Group propagate (active low)
	output wire			GOUT_n		// Group generate  (active low)
);

	//--------------------------------------------------------------------------
	// Carry Lookahead Equations for C1, C2, C3, C0 = CIN
	//--------------------------------------------------------------------------

	assign COUT[0] = !G_n[0] | (!P_n[0] & CIN);
	assign COUT[1] = !G_n[1] | (!P_n[1] & !G_n[0]) | (!P_n[1] & !P_n[0] & CIN);
	assign COUT[2] = !G_n[2] | (!P_n[2] & !G_n[1]) | (!P_n[2] & !P_n[1] & !G_n[0]) | (!P_n[2] & !P_n[1] & !P_n[0] & CIN);

	//--------------------------------------------------------------------------
	// Group Propagate / Generate
	//--------------------------------------------------------------------------
	assign POUT_n = !P_n[3] &  !P_n[2] & !P_n[1]  &  !P_n[0];
	assign GOUT_n = (!G_n[3]) & (!P_n[3] | !G_n[2]) & (!P_n[3] | !P_n[2] | !G_n[1]) & (!P_n[3] | !P_n[2] | !P_n[1] | !G_n[0]);

endmodule
