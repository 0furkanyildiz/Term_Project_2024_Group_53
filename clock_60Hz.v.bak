module clock_60Hz(
    input wire clock50,      // 50 MHz input clock
    output reg clk_60Hz      // 60 Hz output clock
);

 reg [19:0] counter = 20'd0; // 20-bit counter to count up to 833333 (needs 20 bits)

 always @(posedge clock50) begin
	  if (counter >= 833332) begin // 833333 counts for 60 Hz
			counter <= 20'd0;       // Reset counter
			clk_60Hz <= ~clk_60Hz;  // Toggle output clock
	  end else begin
			counter <= counter + 1; // Increment counter
	  end
 end

endmodule