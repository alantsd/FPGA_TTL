// TTL74x190.v
// Purpose: Behavioral, Parameterized model of the SN74LS190 (4-bit bidirectional decade counter, asynchronous parallel load)
// Author: Alan Sing Teik
// Parameters:
//	 WIDTH - width of the counter (default ).
// Behavior:
//	 - asynchronous parallel load when PE_n == 0
//	 - When enabled (CE_n == 0) the counter increments if U_D == 0, decrements if U_D == 1.

module TTL74x190
(
	input  wire						clk,	// system clock
	input  wire						PL_n,	// asynchronous parallel load when low
	input  wire						U_D,	// 0 = count up, 1 = count down
	input  wire						CE_n,	// count enable
	input  wire [WIDTH-1:0]	P,		// parallel data input
	output wire	[WIDTH-1:0]	Q,		// counter output register
	output wire						TC,		// terminal count detection (combinational)
	output wire 					RC_n	// active-low ripple clock output (combinational)
);
	localparam WIDTH = 4;

	reg [WIDTH-1:0] d;

	wire en;
	assign en = PL_n && (!CE_n);

	wire [WIDTH-1:0] next_d_up;
	assign next_d_up = d + {{(WIDTH-1){1'b0}}, 1'b1};

	wire [WIDTH-1:0] next_d_dn;
	assign next_d_dn = d - {{(WIDTH-1){1'b0}}, 1'b1};

	// state 0, 11, 13, 15 is error
	wire error_0;
	assign error_0 = !(|d);

	wire error_11; 
	assign error_11 = d[3] && d[1] && d[0];

	wire error_13;
	assign error_13 = d[3] && d[2] && d[0];

	wire error_15;
	assign error_15 = &d;

	always @(posedge clk or negedge PL_n)
		// asynchronously load parallel data when requested.
		if (!PL_n)
			d <= P;
		else
		if (en)
		begin
			// Increment
			if(!U_D)
				if (error_11)
					d <= WIDTH'(6);
				else
				if (error_13)
					d <= WIDTH'(4);
				else
				if (error_15)
					d <= WIDTH'(2);
				else
					d <= next_d_up;
			// decrement
			else 
				if (error_0)
					d <= WIDTH'(9);
				else
					d <= next_d_dn;
		end

	assign Q = d;
	
	wire TC_up = !U_D && (d == WIDTH'(9));
	wire TC_dn =  U_D && !(|d);

	assign TC = (TC_up || TC_dn);

	assign RC_n = !(!clk && !CE_n && TC);

endmodule
