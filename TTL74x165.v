// TTL74LS165.v
// Author: Alan Sing Teik
// Purpose: Behavioral model of SN74LS165 (8-bit parallel-load, serial-out shift register)
// Parameters:
//	 WIDTH - number of parallel bits (default 8 to match SN74LS165).
// Behavior:
//	 - When PL_n is low, parallel inputs D[...] are loaded into the register asynchronously.
//	 - When PL_n is high, on rising CLK edges the register shifts toward MSB and DS is shifted in.
//	 - A clock-inhibit input (CLK_INH) prevents shifting when asserted.

module TTL74x165
#(
	parameter integer WIDTH = 8
)
(
	input  wire [WIDTH-1:0] D,	// parallel data inputs (D[0] -> QA ... D[WIDTH-1] -> QH)
	input  wire PL_n,			// active-low parallel load (low = load parallel inputs)
	input  wire CLK,			// rising-edge clock for shifting
	input  wire CLK_INH,		// clock inhibit (when high, shifting is inhibited)
	input  wire DS,				// serial data input (shift-in when PL_n is high)
	output wire [WIDTH-1:0] Q,	// parallel outputs reflecting internal register
	output wire QH				// serial output from MSB (useful for cascading)
);
	reg [WIDTH-1:0] reg_out;

	// Design intent: expose MSB as serial-out for cascading or observation.
	assign QH = reg_out[WIDTH-1];

	// Sequential: asynchronous parallel-load on PL_n low; 
	// otherwise shift in DS on rising CLK when not inhibited.
	always @(posedge CLK or negedge PL_n)
	begin
		// design intent: immediate parallel load when PL_n asserted low
		if (!PL_n)
			reg_out <= D;
		else
		// design intent: shift toward MSB; new LSB <= DS
		// if CLK_INH is asserted, retain current contents
		if (!CLK_INH)
			reg_out <= {reg_out[WIDTH-2:0], DS};
	end

	assign Q = reg_out;

endmodule
