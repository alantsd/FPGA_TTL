// TTL74x280.v
// Purpose: Behavioral, parameterized model of a SN54LS280 (9-bit odd/even parity generator/checker)
// Author: Alan Sing Teik
// Parameters:
//	 DATA_WIDTH - width of the data word (default 9 to match SN54LS280).

module TTL74x280 
#(
	parameter DATA_WIDTH = 9
)
(
	input  wire [DATA_WIDTH-1:0] D,			// DATA_WIDTH-bit parallel data inputs
	output wire					 ODD,		// parity bit produced in generator mode
	output wire					 EVEN,		// parity bit produced in generator mode
);
	assign ODD	= ^ D; // XOR reduction: 1 if odd number of '1's in data
	assign EVEN	= & D;
endmodule
