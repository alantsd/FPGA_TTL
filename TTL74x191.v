// TTL74x191.v
// Purpose: Behavioral, Parameterized model of the SN74LS191 (4-bit bidirectional binary counter)
// Author: Alan Sing Teik
// Parameters:
//	 WIDTH - width of the counter (default 4)
// Behavior:
//	 - asynchronous parallel load when PE_n == 0
//	 - When enabled (CE_n == 0) the counter increments if U_D == 0, decrements if U_D == 1.

module TTL74x191
#(
	parameter WIDTH = 4
)
(
	input  wire						clk,	// system clock
	input  wire						PL_n,	// asynchronous parallel load when low
	input  wire						U_D,	// 0 = count up, 1 = count down
	input  wire						CE_n,	// count enable
	input  wire [WIDTH-1:0]			P,		// parallel data input
	output wire	[WIDTH-1:0]			Q,		// counter output register
	output wire						TC,		// terminal count detection (combinational)
	output wire 					RC_n	// active-low ripple clock output (combinational)
);
	reg [WIDTH-1:0] d;

	wire en;
	assign en = PL_n && (!CE_n);

	wire [WIDTH-1:0] next_d_up;
	assign next_d_up = d + {{(WIDTH-1){1'b0}}, 1'b1};

	wire [WIDTH-1:0] next_d_dn;
	assign next_d_dn = d - {{(WIDTH-1){1'b0}}, 1'b1};

	always @(posedge clk or negedge PL_n)
		// asynchronously load parallel data when requested.
		if (!PL_n)
			d <= P;
		else
		if (en)
		begin
			// Update count depending on direction (Increment or decrement)
			if(!U_D)
				d <= next_d_up;
			else
				d <= next_d_dn;
		end

	assign Q = d;
	
	wire TC_up = !U_D && (&d);
	wire TC_dn =  U_D && !(|d);

	assign TC = (TC_up || TC_dn);

	assign RC_n = !(!clk && !CE_n && TC);

endmodule
