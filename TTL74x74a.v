// TTL74x74a.v
// Purpose: RTL model SN74LS74A (Dual D flip-flops, positive-edge-triggered, asynchronous active-low preset and clear)
// Author: Alan Sing Teik
// Notes:
//	 - PRE_n and CLR_n are asynchronous and have priority over the clocked update.
//	 - Simultaneous PRE_n=0 and CLR_n=0 is undefined for the real device; this RTL
//	   documents that condition and implements PRE_n priority (chosen for determinism).
module TTL74x74a
(
	input  wire D1,
	input  wire CLK1,
	input  wire PRE1_n,		// active-low asynchronous preset for FF1
	input  wire CLR1_n,		// active-low asynchronous clear for FF1
	output wire Q1,
	output wire Q1_n,		// complementary output for FF1

	input  wire D2,
	input  wire CLK2,
	input  wire PRE2_n,		// active-low asynchronous preset for FF2
	input  wire CLR2_n,		// active-low asynchronous clear for FF2
	output wire	Q2,
	output wire Q2_n		// complementary output for FF2
);

	// Flip-flop 1
	// Priority: asynchronous preset (PRE1_n==0) takes precedence over clear when both asserted.
	reg q1;
	always @(posedge CLK1 or negedge PRE1_n or negedge CLR1_n)
	begin
		if (!PRE1_n)
			q1 <= 1'b1;		// Intent: force q1=1 immediately on PRE_n asserted
		else
		if (!CLR1_n)
			q1 <= 1'b0;		// Intent: force q1=0 immediately on CLR_n asserted
		else 
			q1 <= D1;		// Intent: sample D1 on rising clock when async inputs inactive
	end

	// Flip-flop 2
	reg q2;
	always @(posedge CLK2 or negedge PRE2_n or negedge CLR2_n)
	begin
		if (!PRE2_n)
			q2 <= 1'b1;		// Intent: force q2=1 immediately on PRE_n asserted
		else
		if (!CLR2_n) 
			q2 <= 1'b0;		// Intent: force q2=0 immediately on CLR_n asserted
		else
			q2 <= D2;		// Intent: sample D2 on rising clock when async inputs inactive
	end

	// Complementary outputs are simple combinational inversions
	assign Q1   =  q1;
	assign Q1_n = ~q1;
	assign Q2   =  q2;
	assign Q2_n = ~q2;

endmodule
