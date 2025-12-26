// TTL74x139
// Purpose: Behavioral, Parameterized model of SN74LS139 (dual 2 to 4 decoder, active-low output)
// Parameters:
//	 INPUT_WIDTH  : width of select inputs (default 2)
//	 OUTPUT_WIDTH : number of outputs (default 4)
// Behavior:
//	 - Outputs Y[A] are active-low (selected output driven low when enabled).
module TTL74x139
#(
	parameter WIDTH = 4
)
(
	input  wire						E1_n,		// active-high enable
	input  wire [INPUT_WIDTH-1:0]	A1,			// select inputs
	output wire [WIDTH-1:0]			Y1			// active-low outputs
	input  wire [INPUT_WIDTH-1:0]	A2,			// select inputs
	input  wire						E2_n,		// active-high enable
	output wire [WIDTH-1:0]			Y2			// active-low outputs
);
	localparam INPUT_WIDTH	= $clog2(WIDTH);

	reg [WIDTH-1:0] out1;

	always@(*)
	begin
		// Drive the selected output low; others remain high.
		out1 = {WIDTH{1'b1}};
		if (!E1_n) 
		begin
			// drive selected output low
			out1[A1] = 1'b0;
		end
	end

	assign Y1 = out1;

	reg [WIDTH-1:0] out2;

	always@(*)
	begin
		// Drive the selected output low; others remain high.
		out2 = {WIDTH{1'b1}};
		if (!E2_n) 
		begin
			// drive selected output low
			out2[A2] = 1'b0;
		end
	end

	assign Y2 = out2;

endmodule
