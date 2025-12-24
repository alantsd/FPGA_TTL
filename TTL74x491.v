//------------------------------------------------------------
// Module: TTL74x491.v
// Author: Alan Sing Teik
// Purpose: Behavioral, Parameterized model of the 74LS491 (10-bit bidirectional binary counter)
// Author: Alan Sing Teik
// Parameters:
//	 DATA_WIDTH	  - width of the counter (default 10 bits)
// Behavior:
//	 - Supports synchronous SET, LOAD, COUNT, and HOLD operations
//	 - SET overrides LOAD, COUNT, and HOLD
//	 - LOAD overrides COUNT
//	 - COUNT occurs only when CNT_n=1, otherwise HOLD
//	 - Outputs are tri-stated when OC_n=1 (not supported)
//------------------------------------------------------------
module TTL74x491
#(
	parameter DATA_WIDTH = 10
)
(
	input  wire					 clk,		// Clock input
	input  wire					 SET,		// Synchronous set
	input  wire					 LD_n,		// Synchronous load
	input  wire					 CNT_n,		// Count enable
	input  wire					 UP_n,		// Count direction (0=up, 1=down)
	input  wire					 OC_n,		// tristate output not supported
	input  wire [DATA_WIDTH-1:0] D,			// Value to load
	output wire [DATA_WIDTH-1:0] Q			// Counter output
);

	reg [DATA_WIDTH-1:0] count;

	wire [DATA_WIDTH-1:0] next_count_up;
	assign next_count_up = d + {{(DATA_WIDTH-1){1'b0}}, 1'b1};
	
	wire [DATA_WIDTH-1:0] next_count_dn;
	assign next_count_dn = d - {{(DATA_WIDTH-1){1'b0}}, 1'b1};

	always @(posedge clk)
		// Set all bits high
		if (SET)
			count <= {DATA_WIDTH{1'b1}};
		else
		// Synchronously load parallel data
		if (!LD_n)
			count <= D;
		else
		// Update count depending on direction (Increment or decrement)
		if (!CNT_n && !UP_n)
			count <= next_count_up;
		else
		if (!CNT_n && UP_n)
			count <= next_count_dn;
		// else hold (no assignment)

	assign Q = count;

endmodule
