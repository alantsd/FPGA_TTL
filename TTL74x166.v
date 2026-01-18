// TTL74x166.v
// Author: Alan Sing Teik
// Purpose: Behavioral model of SN74LS166 (8-bit parallel-load, serial-out shift register, async clear)
// Parameters:
//	 WIDTH - number of parallel bits (default 8 to match SN74LS166).
// Behavior:
//	 - When SH_LD is low, parallel inputs A are loaded into the register synchronously.
//	 - When SH_LD is high, on rising CLK edges the register shifts toward MSB and SER is shifted in.
//	 - A clock-inhibit input (CLK_INH) prevents data change when asserted.
//     implemented as gating the data, instead of true clock gating
// Notes: 74x166's async clear feature prevents SRL inference. It will synthesize to regular flip-flops

module TTL74x166
#(
	parameter WIDTH = 8
)
(
	input  wire				clk,		// Clock input
	input  wire				CLK_INH,	// Clock input inhibit
	input  wire				CLR_n,		// asynchronous clear
	input  wire				SH_LD,		// shift == 1, parallel load == 0
	input  wire				SER,		// Serial input
	input  wire [WIDTH-1:0]	A,			// Parallel data inputs
	output wire				QH			// Serial output (MSB)
);
	reg [WIDTH-1:0] d;

	wire [WIDTH-1:0] d_next;
	assign d_next = {d[WIDTH-2:0], SER};
	
	always @(posedge clk or negedge CLR_n)
		if (!CLR_n)
			d <= {WIDTH{1'b0}};
		else
		if (!CLK_INH)
			if (!SH_LD)
				d <= A;
			else
				d <= d_next;

	assign QH = d[WIDTH-1];

endmodule

