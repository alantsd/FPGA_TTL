// TTL74x161a.v
// Author: Alan Sing Teik
// Purpose: RTL model of SN74LS161A (4-bit binary counter (mod-16), Asynchronous Reset)
// Parameters:
//	 WIDTH		- internal register width (default 4)
//	 MODULUS	- counting modulus (default 10 for BCD decade)
// Behavior:
//	 - Asynchronous active-low master clear (rst_n) clears the counter immediately.
//	 - Synchronous parallel load when PE_n is asserted low on rising clock edge.
//	 - Counts on rising clock when both CEP and CET are high and not loading.
//	 - Terminal count (TC) asserted when count == MODULUS-1 and CET is true.

module TTL74x161a
(
	input  wire				clk,	// rising-edge clock
	input  wire				MR_n,	// asynchronous active-low master clear
	input  wire				PE_n,	// active-low parallel load (synchronous)
	input  wire				CEP,	// count enable parallel
	input  wire				CET,	// count enable trickle
	input  wire [WIDTH-1:0]	P,		// parallel data to load
	output wire [WIDTH-1:0]	Q,		// current count
	output wire				TC		// terminal count
);
	localparam WIDTH		= 4;
	localparam [WIDTH-1:0] MAX_COUNT	= {WIDTH{1'b1}};

	reg [WIDTH-1:0] d;

	wire [WIDTH-1:0] d_next;
	assign d_next = d + {{(WIDTH-1){1'b0}}, 1'b1};

	always @(posedge clk or negedge MR_n)
		if (!MR_n)
			d <= {WIDTH{1'b0}};
		else
		if (!PE_n)
			d <= P;
		else
		if (CEP && CET && PE_n)
		begin
			// Increment with modulus wrap-around
			if (d == MAX_COUNT)
				d <= {WIDTH{1'b0}};
			else
				d <= d_next;
		end

	assign TC = (d == MAX_COUNT) && CET;

	assign Q = d[WIDTH-1:0];

endmodule
