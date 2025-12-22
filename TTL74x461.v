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
	input  wire CLK,					// rising-edge clock
	input  wire OE,						// not supported
	input  wire [WIDTH-1:0] D,			// parallel data to load when PL_n is low
	input  wire CI_n					// carry in
	output wire [WIDTH-1:0] Q,			// parallel count outputs
	output wire CO_n					// ripple carry (low when count == MAX)
);
	localparam [WIDTH-1:0] MAX_COUNT = {WIDTH{1'b1}};

	// Internal register
	reg [WIDTH-1:0] count;
	
	wire CLR_n;
	assign CLR_n = (m1 || m0);
	
	wire PL; // synchronous parallel load
	assign PL = m1 && !m0;

	wire ci;
	assign ci = !CI_n && (m1 && m0);
	
	wire [WIDTH-1:0] next_count;
	assign next_count = count + {{(WIDTH-1){1'b0}}, ci};

	// Sequential: asynchronous clear; synchronous parallel load or count on rising CLK.
	always @(posedge CLK or negedge CLR_n)
	begin
		// design intent: immediate reset of all bits
		if (CLR_n)
			count <= {WIDTH{1'b0}};
		else
		// design intent: synchronous parallel load on PL_n low
		if (PL)
			count <= D;
		else
		// design intent: increment by CI
			count <= next_count;
		// else retain current count when not enabled
	end

	assign Q = count;
	// design intent: indicate terminal count for cascading
	assign CO_n = !(count == MAX_COUNT); 

endmodule
