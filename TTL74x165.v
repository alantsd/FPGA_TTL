// TTL74x165.v
// Author: Alan Sing Teik
// Purpose: Behavioral model of SN74LS165 (8-bit async parallel-load, serial-out shift register)
// Parameters:
//	 WIDTH - number of parallel bits (default 8 to match SN74LS165).
// Behavior:
//	 - When SH_LD is low, parallel inputs A are loaded into the register asynchronously.
//	 - When SH_LD is high, on rising CLK edges the register shifts toward MSB and SER is shifted in.
//	 - A clock-inhibit input (CLK_INH) prevents data change when asserted.
//     implemented as gating the data, instead of true clock gating

module TTL74x165
#(
	parameter WIDTH = 8
)
(
	input  wire				clk,		// Clock input
	input  wire				CLK_INH,	// Clock input inhibit
	input  wire				SH_LD,		// shift == 1, parallel load == 0
	input  wire				SER,		// Serial input
	input  wire [WIDTH-1:0]	A,			// Parallel data inputs
	output wire				QH,			// Serial output (MSB)
	output wire				QH_n		// Serial output (~MSB)
);
	reg [WIDTH-1:0] d;

	wire [WIDTH-1:0] d_next;
	assign d_next = {d[WIDTH-2:0], SER};
	
	always @(posedge clk or negedge SH_LD)
		if (!SH_LD)
			d <= A;
		if (!CLK_INH)
			d <= d_next;

	assign QH	=  d[WIDTH-1];
	assign QH_n	= ~d[WIDTH-1];

endmodule
