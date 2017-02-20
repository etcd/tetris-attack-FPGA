module PRNG(	input logic 	Clk,
					input logic 	Reset,
					input logic 	[49:0] load,
					output logic 	[49:0] seed);
	
	// https://en.wikipedia.org/wiki/Linear_congruential_generator
	// We are using the same constants as used in:
	// 	* java.util.Random
	// 	* POSIX [ln]rand48
	// 	* glibc [ln]rand48[_r]
	
	logic [49:0] 	a = 50'd25214903917;
	logic [49:0] 	c = 50'd11;
	logic	[49:0]	m = {1'b1, 48'b0};
	
	logic [49:0] out;
	
	always_ff @ ( posedge Reset or posedge Clk ) begin
		if (Reset) begin
			seed 	<= load;
		end
		else begin
			out <= (a*seed + c) % m;
			seed <= {18'b0, out[47:16]};
		end
	end

endmodule

