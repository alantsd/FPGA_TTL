// TTL74x42.v
// Purpose: RTL model for SNL74LS42 (4-line BCD to 10-line active-low output)
// Author: Alan Sing Teik
// Behavior: When A in 0..9, the corresponding Q_n bit is driven low.
//			 For all other cases (disabled or A outside 0..9) out = 10'h3FF (all inactive).
module TTL74x42
(
	input  wire [WIDTH-1:0] A,	  // BCD input
	output wire	[9:0]		Q_n	  // active-low outputs out[0] = decimal 0
);
	localparam WIDTH = 4;

	// Intent: use simple switch/case for clarity and direct mapping to truth table.
	reg out;
	always @(*)
	begin
		// decode case 0..9, 10..15 is invalid
		case (A)
			4'd0   : out = 10'b1111111110;
			4'd1   : out = 10'b1111111101;
			4'd2   : out = 10'b1111111011;
			4'd3   : out = 10'b1111110111;
			4'd4   : out = 10'b1111101111;
			4'd5   : out = 10'b1111011111;
			4'd6   : out = 10'b1110111111;
			4'd7   : out = 10'b1101111111;
			4'd8   : out = 10'b1011111111;
			4'd9   : out = 10'b0111111111;
			default: out = 10'b0111111111;
		endcase
	end

	assign Q_n = out;
endmodule
