module FourBitRandomNumberGenerator(
    input clk,
    output reg [3:0] rand_4bit
);

// Seed for the random number generator
reg [15:0] seed = 16'hACE1; // Initial seed value

// Random number generator logic
always @(posedge clk) begin
			// XOR shift algorithm to generate pseudo-random numbers
		seed <= {seed[14:0], seed[0] ^ seed[2]}; // Shift left and XOR
		rand_4bit <= seed[3:0]; // Output the lower 4 bits
	  
end

endmodule
