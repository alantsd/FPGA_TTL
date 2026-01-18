// TTL74x164.v
// author: Alan Sing Teik
// Purpose: Behavioral model of SN74LS164 (8-bit serial-in, parallel-out shift register, async clear).
// Parameters:
//	 WIDTH - number of shift stages (default 8 to match SN74LS164).
// Behavior:
//	 - Serial data enters on rising edge of clk when both A and B are high (gated inputs).
//	 - Asynchronous active-low clear (CLR_n) clears all stages immediately.
//	 - Outputs present the parallel contents of the shift register.
// notes: 74x164's async clear feature prevents SRL inference. It will synthesize to regular flip-flops

module TTL74x164
#(
	parameter integer WIDTH = 8	 // standard SN74164 is 8 bits, must be >= 1
)
(
	input  wire clk,			// rising-edge clock
	input  wire A,				// gated serial input A
	input  wire B,				// gated serial input B
	input  wire CLR_n,			// asynchronous active-low clear (low = clear)
	output wire [WIDTH-1:0] Q	// parallel outputs, Q[0] is first stage (LSB)
);
	// design intent: gated serial input. If either A or B is low, new data is low.
	wire serial_in;
	assign serial_in = A & B;

	reg [WIDTH-1:0] d;

	always @(posedge clk or negedge CLR_n)
	begin
		// design intent: asynchronous clear resets all stages
		if (!CLR_n)
			d <= {WIDTH{1'b0}};
		// design intent: shift previous stages toward MSB, LSB <= serial_in
		else
			d <= {d[WIDTH-2:0], serial_in};
	end

	assign Q = d; 

endmodule
