// TTL74x269.v
// Purpose: Behavioral, Parameterized model of the MC74F269 (8-bit bidirectional binary counter)
// Author: Alan Sing Teik
// Parameters:
//	 DATA_WIDTH - width of the counter (default 8).
// Behavior:
//	 - Synchronous parallel load when PE_n is asserted on rising clk.
//	 - When enabled (CEP_n == 1 or CET_n == 1) the counter increments if U_D == 1, decrements if U_D == 0.

module MC74F269 
#(
	parameter DATA_WIDTH = 8
)
(
	input  wire						clk,	// system clock
	input  wire						PE_n,	// synchronous parallel load when low
	input  wire						U_D,	// 1 = count up, 0 = count down
	input  wire						CEP_n,
	input  wire						CET_n,
	input  wire [DATA_WIDTH-1:0]	P,		// parallel data input
	output wire	[DATA_WIDTH-1:0]	Q,		// counter output register
	output wire						TC,		//terminal count detection (combinational). 
);
	reg [DATA_WIDTH-1:0] d;

	wire en;
	assign en = (!CEP_n && !CET_n);

	always @(posedge clk)
		// Synchronously load parallel data when requested.
		if (!PE_n)
			Q <= P;
		else
		if (en)
		begin
			// Update count depending on direction (Increment or decrement)
			d <= d + {{(DATA_WIDTH-1){1'b0}}, U_D};
		end

	assign Q = d;

	assign TC = (U_D && (&d)) || (!U_D && !(|d));
endmodule
