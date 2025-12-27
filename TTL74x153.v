// TTL74x153.v
// Purpose: RTL model of SN74LS153 (Dual 4-to-1 multiplexer)
// Author: Alan Sing Teik
// Features:
// - Two independent 4-to-1 multiplexers
// - Common select inputs (A, B)
// - Individual enable inputs (active LOW)
// - Non-inverting outputs

module TTL74x153
#(
    parameter WIDTH = 4
)
(
	input  wire [SEL_WIDTH-1:0] A_B,	// select inputs for both MUX
	input  wire [WIDTH-1:0] C1,			// input 1
	input  wire [WIDTH-1:0] C2,			// input 2
	input  wire G1_n,					// Enable for MUX A (active LOW)
	input  wire G2_n,					// Enable for MUX B (active LOW)
	output wire	Y1,						// Output of MUX A
	output wire	Y2						// Output of MUX B
);
	localparam SEL_WIDTH = $clog2(WIDTH);

	reg out1;
	always@(*)
		// MUX A
		if (!G1_n)
			out1 = C1[A_B];
		else
			out1 = 1'b0; // Disabled output

	reg out2;
	always@(*)
		// MUX B
		if (!G2_n)
			out2 = C2[A_B];
		else
			out2 = 1'b0; // Disabled output

	assign Y1 = out1;
	assign Y2 = out2;

endmodule

