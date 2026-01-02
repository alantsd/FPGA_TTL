// TTL74x461.v
// Purpose: Behavioral, parameterized model of SN74LS461 (8-bit presettable binary counter).
// Author: Alan Sing Teik
// Parameters:
//	 WIDTH - number of counter bits (default 8 to match SN74LS461).
// Behavior:
//	 - CLR_n resets the counter asynchronously.
//	 - PL Synchronous parallel load when PL_n is low at rising CLK edge.
//	 - CO_n (ripple carry out) asserts (low) when counter reaches terminal count (all ones).

module TT74x461
#(
	parameter integer WIDTH = 8
)
(
	input  wire clk,					// rising-edge clock
	input  wire OE,						// not supported
	input  wire I0,						// mode[0]
	input  wire I1,						// mode[1]
	input  wire [WIDTH-1:0] D,			// parallel data to load when PL is high
	input  wire CI_n					// carry in
	output wire [WIDTH-1:0] Q,			// parallel count outputs
	output wire CO_n					// ripple carry (low when count == MAX)
);
	localparam [WIDTH-1:0] MAX_COUNT = {WIDTH{1'b1}};

	wire CLR;
	assign CLR = !I1 && !I0;

	wire PL;
	assign PL = I1 && !I0;

	wire ci;
	assign ci = !CI_n && (I1 && I0);

	reg [WIDTH-1:0] count;

	wire [WIDTH-1:0] next_count;
	assign next_count = count + {{(WIDTH-1){1'b0}}, ci};

	always @(posedge clk)
		// design intent: synchronous clear
		if (CLR)
			count <= {WIDTH{1'b0}};
		else
		// design intent: synchronous parallel load
		if (PL)
			count <= D;
		else
			count <= next_count;

	assign Q = count;
	// design intent: indicate terminal count for cascading
	assign CO_n = !(count == MAX_COUNT); 

endmodule
