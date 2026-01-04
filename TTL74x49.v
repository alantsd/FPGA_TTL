// TTL74x49.v
// Purpose: RTL model for SN74LS49 (BCD to 7 segment decoder, active high outputs)
// Author: Alan Sing Teik
// Notes:
//	- Outputs are active-high (1 = segment on). Real device outputs are open-collector.
 //		connect hex inveter with open collector ouput such as SN74LS16 to drive LED
//	- Inputs 0..9 produce decimal digits; 10..15 produce hex A..F patterns.
//	- BL_n (active-low blank) forces all segments off when asserted.

module TTL74x49
(
	input  wire [SEL_WIDTH-1:0]		A,		// 4-bit input (0..15 valid)
	input  wire						BL_n,	// active-low blanking input (0 = blank all segments)
	output wire	[SEGMENT_WIDTH-1:0] SEG		// active-high segment outputs {a,b,c,d,e,f,g}
);
	localparam SEGMENT_WIDTH	= 7;
	localparam SEL_WIDTH		= 4;

	reg [SEGMENT_WIDTH-1:0] out;
	always @(*)
		// Intent: BL_n overrides decode.
		if (!BL_n)
			out = 7'b000_0000; // blanking asserted: keep segments off
		else
			case (A)
				// Decimal 0..9 (active-low patterns)
				4'd0   : out = 7'b111_1110; // 0
				4'd1   : out = 7'b011_0000; // 1
				4'd2   : out = 7'b110_1101; // 2
				4'd3   : out = 7'b111_1001; // 3
				4'd4   : out = 7'b011_0011; // 4
				4'd5   : out = 7'b101_1011; // 5
				4'd6   : out = 7'b001_1111; // 6
				4'd7   : out = 7'b111_0000; // 7
				4'd8   : out = 7'b111_1111; // 8
				4'd9   : out = 7'b111_0011; // 9
				// Hex A..F (10..15)
				4'd10  : out = 7'b000_1101; // A
				4'd11  : out = 7'b001_1001; // b (lowercase b)
				4'd12  : out = 7'b010_0011; // C
				4'd13  : out = 7'b100_1011; // d (lowercase d)
				4'd14  : out = 7'b000_1111; // E
				4'd15  : out = 7'b000_0000; // F (blank)
				default: out = 7'b000_0000;
			endcase

	assign SEG = out;

endmodule
