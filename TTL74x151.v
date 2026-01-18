// TTL74x151.v
// Author: Alan Sing Teik
// Purpose: Behavioral model of SN74LS151 (8 to 1 Multiplexer with Enable and Complement Output)
// Parameters:
//	 WIDTH			- Number of data inputs (default = 8)
//	 SEL_WIDTH		- Number of select lines, automatically computed as
//					  $clog2(WIDTH)
// notes: likely uses 1x LUT4, 1x INV
module TTL74x151
#(
	parameter WIDTH = 8,
	parameter SEL_WIDTH = $clog2(WIDTH)
)
(
	input  wire [WIDTH-1:0] 	D,			// Data inputs
	input  wire [SEL_WIDTH-1:0]	S,			// Select lines
	input  wire					G_n,		// Active-low enable
	output wire					Y,			// Normal output
	output wire					W			// Complement output
);
	reg out;
	always @(*)
		if (!G_n)
			out = D[S];
		else
			out = 1'b0;

	assign Y =  out;
	assign W = ~out;

endmodule

