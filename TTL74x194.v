// Module: TTL7x194_shift_register
// Author: Alan Sing Teik
// Purpose: Behavioral model of SN74LS194 (4-bit bidirectional universal shift register)
// Parameters:
//	 DATA_WIDTH	  - width of the register (default 4 bits)
// Behavior:
//	 - Supports synchronous parallel load, shift left, shift right, and hold
//	 - Asynchronous clear resets register to 0
//	 - Mode control (S1, S0):
//		 00 -> Hold (no change)
//		 01 -> Shift Right
//		 10 -> Shift Left
//		 11 -> Parallel Load
//------------------------------------------------------------
module TTl7x194
#(
	parameter DATA_WIDTH = 4
)
(
	input  wire					 CP,	// Clock input
	input  wire					 MR_n,	// Active-low asynchronous reset
	input  wire					 S0,	// Mode select
	input  wire					 S1,	// Mode select
	input  wire					 Dsr,	// Serial (Shift Right) Data Input
	input  wire					 Dsl,	// Serial (Shift Left) Data Input
	input  wire [DATA_WIDTH-1:0] P,		// Parallel load value
	output wire [DATA_WIDTH-1:0] Q		// Register output
);
	reg	 [DATA_WIDTH-1:0] d;

	wire load;
	wire right;
	wire left;
	
	assign load		=  S1  &&  S0;
	assign right	= !S1  &&  S0;
	assign left		=  S1  && !S0;

	wire [DATA_WIDTH-1:0] next_d_right;
	assign next_d_right = {Dsr, d[DATA_WIDTH-1:1]};

	wire [DATA_WIDTH-1:0] next_d_left;
	assign next_d_left = {d[DATA_WIDTH-2:0], Dsl};

	always @(posedge CP or negedge MR_n)
		if (!MR_n)
			d <= {DATA_WIDTH{1'b0}};
		else
		if (load)
			d <= P;
		else
		if (right)
			d <= next_d_right;
		else
		if (left)
			d <= next_d_left;

		assign Q = d;
	
endmodule
