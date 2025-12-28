//-----------------------------------------------------------------------------
// Module: TTL74x148
// Author: Alan Sing Teik
// Purpose: RTL model of SN74LS148, 8-to-3 priority encoder (active-low inputs, active-low outputs)
//	 - Inputs: 8 active-low request lines (I0 lowest priority, I7 highest priority)
//	 - Outputs: 3-bit binary code of highest-priority active-low input
//	 - GS (Group Select) and EO (Enable Output) signals included
// Parameters:
//	 - N: number of inputs (default 8)
//-----------------------------------------------------------------------------

module TTL74x148 
(
	input  wire [WIDTH-1:0]		I_n,	// active-low inputs
	input  wire					EI_n,	// active-low inhibit in
	output wire [OUT_WIDTH-1:0]	A,		// active-low outputs (binary code)
	output wire					GS_n,	// active-low group select
	output wire					EO_n	// active-low enable out
);
	localparam WIDTH		= 8;
	localparam OUT_WIDTH	= 3;

	reg [OUT_WIDTH-1:0] out;
	always@(*)
		if (!EI_n) 
			// priority encoder: highest index wins
			case (1'b0)
				I_n[7]:		out = OUT_WIDTH'(7);
				I_n[6]:		out = OUT_WIDTH'(6);
				I_n[5]:		out = OUT_WIDTH'(5);
				I_n[4]:		out = OUT_WIDTH'(4);
				I_n[3]:		out = OUT_WIDTH'(3);
				I_n[2]:		out = OUT_WIDTH'(2);
				I_n[1]:		out = OUT_WIDTH'(1);
				I_n[0]:		out = OUT_WIDTH'(0);
				default:	out = OUT_WIDTH'(0); // no input active
			endcase

	assign A = ~out;
	assign GS_n =  (&I_n) | EI_n;
	assign EO_n = ~(&I_n) | EI_n;

endmodule
