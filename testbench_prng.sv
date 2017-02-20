module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;


//module PRNG(	input logic 	Clk,
//					input logic 	Reset,
//					input logic 	[31:0] load,
//					output logic 	[31:0] seed);

// inputs
logic          Clk;
logic 			Reset;
logic 	[49:0] load;

// outputs
logic 	[49:0] seed;

// Instantiating the DUT
PRNG 		dut(.*);

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
	Reset = 1;

	load = 50'h66; // Load the PRNG with a random seed to test output

	#4 Reset = 0; // let go of reset signal, beginning PRNG state evolution

end
endmodule
