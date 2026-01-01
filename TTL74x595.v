//	TTL74x595.v
//	Purpose : RTL model of the 74HC595 (8-bit serial-in, parallel-out shift register with output latches)
//	Author	: Alan Sing Teik
// Parameters:
//	 WIDTH - default to 8
//	Notes	:
//	- MR_n clears both shift and latch registers.

module TTL74x595
#(
	parameter WIDTH = 8
)
(
	input  wire				SHCP,			// Shift register clock
	input  wire				STCP,			// Latch clock
	input  wire				DS,				// Serial data input (DS)
	input  wire				OE_n,			// Output enable, active low (not supported)
	input  wire				MR_n,			// Master reset, active low
	output reg [WIDTH-1:0]	Q,				// Parallel outputs
	output wire				Q7S				// Serial output for cascading
);

	// Internal shift register
	reg [WIDTH-1:0] shift_reg;
	always @(posedge SHCP or negedge MR_n)
		if (!MR_n)
			shift_reg <= {WIDTH{1'b0}};
		else
			shift_reg <= {shift_reg[WIDTH-2:0], DS};

	// Output latch
	reg [WIDTH-1:0] latch_reg;
	always @(posedge STCP or negedge MR_n)
		if (!MR_n)
			latch_reg <= {WIDTH{1'b0}};
		else
			latch_reg <= shift_reg;

	assign Q	= latch_reg;
	assign Q7S	= shift_reg[WIDTH-1];

endmodule
