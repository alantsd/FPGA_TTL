// TTL74x138 3-to-8 decoder
// Purpose: Behavioral, Parameterized model of SN74LS138 (3 to 8 decoder, active-low output)
// Parameters:
//	 INPUT_WIDTH  : width of select inputs (default 3)
//	 OUTPUT_WIDTH : number of outputs (default 8)
// Behavior:
//	 - G1 is active-high enable.
//	 - G2A and G2B are active-low enables.
//	 - Outputs Y[7:0] are active-low (selected output driven low when enabled).
module TTL74x138
#(
	parameter WIDTH = 8
)
(
	input  wire [INPUT_WIDTH-1:0]	A,		// select inputs
	input  wire						G1,		// active-high enable
	input  wire						G2A,	// active-low enable
	input  wire						G2B,	// active-low enable
	output wire [WIDTH-1:0]			Y		// active-low outputs
);
	localparam INPUT_WIDTH	= $clog2(WIDTH);

	// Global enable: all enables must be asserted for outputs to be driven.
	wire en;
	assign en = G1 && (!G2A || !G2B);

	reg [WIDTH-1:0] out;

	always@(*)
	begin
		// Drive the selected output low; others remain high.
		out = {WIDTH{1'b1}};
		if (en) 
		begin
			// drive selected output low
			out[A] = 1'b0;
		end
	end

	assign Y = out;

endmodule
