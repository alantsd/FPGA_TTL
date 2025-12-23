//------------------------------------------------------------
// Module: TTL74x201
// Purpose: RTL model of SN74S201 (256x1-bit static RAM)
// Author: Alan Sing Teik
// Parameters:
//	 ADDR_WIDTH - number of address bits (default 8 for 256 words)
//	 DATA_WIDTH - width of each word (default 1 bit)
// Behavior:
//	 - Write: when CE=0, WE=0, data_in is stored at address
//	 - Read:  when CE=0, OE=0, data_out drives stored value
//	 - Tri-state: when OE=1 or CE=1, data_out is high-Z (not supported)
//------------------------------------------------------------
module TTL74x201 
#(
	parameter ADDR_WIDTH = 8,
	parameter DATA_WIDTH = 1
)
(
	input  wire					 R_W,		// Read == 1, Write enable (active low)
	input  wire					 S1_n,		// select 1
	input  wire					 S2_n,		// select 2
	input  wire					 S3_n,		// select 3
	input  wire [ADDR_WIDTH-1:0] A,			// Address input
	input  wire [DATA_WIDTH-1:0] D,			// Data input
	output wire [DATA_WIDTH-1:0] Q_n		// Data output (tri-state)
);
	reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

	wire select_n;
	assign select_n = S1_n & S2_n & S_n;

	wire clk;
	assign clk = !select_n && !R_W;

	always @(posedge clk)
		mem[A] <= D; // Write operation

	// no support for tri-state output, always read 
	assign Q_n = ~mem[A];

endmodule
