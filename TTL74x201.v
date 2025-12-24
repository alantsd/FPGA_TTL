//------------------------------------------------------------
// Module: TTL74x201
// Purpose: RTL model of SN74S201 (256x1-bit static RAM)
// Author: Alan Sing Teik
// Parameters:
//	 ADDR_WIDTH - number of address bits (default 8 for 256 words)
//	 DATA_WIDTH - width of each word (default 1 bit)
// Behavior:
//	 - Write: when select_n low and R_W low,  data_in is stored at address
//	 - Read:  when select_n low and R_W high, Q_n drives compliment of stored value
//	 - Tri-state: when OE=1 or CE=1, data_out is high-Z (not supported)
//------------------------------------------------------------
module TTL74x201 
#(
	parameter ADDR_WIDTH = 8,
	parameter DATA_WIDTH = 1
)
(
	input  wire					 clk,		// added clock for FPGA needs
	input  wire					 R_W,		// Read == 1, Write == 0
	input  wire					 S1_n,		// select 1
	input  wire					 S2_n,		// select 2
	input  wire					 S3_n,		// select 3
	input  wire [ADDR_WIDTH-1:0] A,			// Address input
	input  wire [DATA_WIDTH-1:0] D,			// Data input
	output wire [DATA_WIDTH-1:0] Q_n		// Data output (tri-state not supported)
);
	wire select_n;
	assign select_n = S1_n | S2_n | S3_n;

	reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

	always @(posedge clk)
		if(!select_n && !R_W)
			mem[A] <= D; // Write operation

	reg [DATA_WIDTH-1:0] out;

	always @(posedge clk)
		if(!select_n && R_W)
			out <= ~mem[A]; // Read operation

	// no support for tri-state output, always read 
	assign Q_n = out;

endmodule
