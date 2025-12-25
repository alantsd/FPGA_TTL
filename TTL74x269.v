// TTL74x269.v
// Purpose: Behavioral, Parameterized model of the MC74F269 (8-bit bidirectional binary counter)
// Author: Alan Sing Teik
// Parameters:
//	 DATA_WIDTH - width of the counter (default 8).
// Behavior:
//	 - Synchronous parallel load when PE_n is asserted on rising clk.
//	 - When enabled (CEP_n == 1 or CET_n == 1) the counter increments if U_D == 1, decrements if U_D == 0.

module TTL74x269
#(
	parameter DATA_WIDTH = 8
)
(
	input  wire						clk,	// system clock
	input  wire						PE_n,	// synchronous parallel load when low
	input  wire						U_D,	// 1 = count up, 0 = count down
	input  wire						CEP_n,	// count enable parallel
	input  wire						CET_n,	// count enable trickle
	input  wire [DATA_WIDTH-1:0]	P,		// parallel data input
	output wire	[DATA_WIDTH-1:0]	Q,		// counter output register
	output wire						TC_n	//terminal count detection. 
);
	reg [DATA_WIDTH-1:0] d;

	wire en;
	assign en = PE_n && (!CEP_n && !CET_n);

	wire [DATA_WIDTH-1:0] next_d_up;
	assign next_d_up = d + {{(DATA_WIDTH-1){1'b0}}, 1'b1};

	wire [DATA_WIDTH-1:0] next_d_dn;
	assign next_d_dn = d - {{(DATA_WIDTH-1){1'b0}}, 1'b1};

	always @(posedge clk)
		// Synchronously load parallel data when requested.
		if (!PE_n)
			d <= P;
		else
		if (en)
		begin
			// Update count depending on direction (Increment or decrement)
			if(U_D)
				d <= next_d_up;
			else
				d <= next_d_dn;
		end

	assign Q = d;
	
	wire TC_up =  U_D && (&d);
	wire TC_dn = !U_D && !(|d);

	assign TC_n = !(TC_up || TC_dn);

endmodule
