// TTL74x147.v
// Author: Alan Sing Teik
// Purpose: RTL model of SN74LS147, (9-Line to 4-Line BCD)
// encoders feature priority decoding of the inputs
// Ports:
//	 I		- inputs, I[8] highest priority
//	 O		- enable input (active-low to enable device)

module TTL74x147
(
	input  wire [WIDTH-1:0]		I_n,
	output wire	[OUT_WIDTH:0]	O
);
	localparam  WIDTH		= 9;
	localparam  OUT_WIDTH	= 4;

	reg out;
	always @(*)
		case (1'b0)
				I_n[8]:	out = OUT_WIDTH'(9);
				I_n[7]:	out = OUT_WIDTH'(8);
				I_n[6]:	out = OUT_WIDTH'(7);
				I_n[5]:	out = OUT_WIDTH'(6);
				I_n[4]:	out = OUT_WIDTH'(5);
				I_n[3]:	out = OUT_WIDTH'(4);
				I_n[2]:	out = OUT_WIDTH'(3);
				I_n[1]:	out = OUT_WIDTH'(2);
				I_n[0]:	out = OUT_WIDTH'(15);
			default :	out = OUT_WIDTH'(0);
		endcase

	assign O = ~out;

endmodule
