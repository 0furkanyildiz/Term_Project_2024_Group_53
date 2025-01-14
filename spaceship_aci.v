module spaceship_aci(
	input wire clk,			// oyun kaç mhz'de çalışıyorsa o kadar
	input wire turn_cw,		// buton 1
	input wire turn_ccw,		// buton 2
	output reg [3:0] angle	// geminin anlık açısını bildiren sayı
	/*
	angle :
	0 -> 0 derece
	1 -> 22.5 derece
	2 -> 45 derece
	...
	15 -> 360-22.5 derece
	*/
);

initial begin
	angle = 4'b0000; // başlangıçta yukarı doğru bakacak
end

// Registers to store previous states of the buttons for edge detection
reg turn_cw_prev;
reg turn_ccw_prev;

initial begin 
	turn_cw_prev = 0;
	turn_ccw_prev = 0;
end

always @(posedge clk) begin
	
	if (!turn_cw_prev && turn_cw) begin
		if (angle == 4'b1111) begin
			angle <= 4'b0000;  // Handle overflow
		end else begin
			angle <= angle + 1;
		end
	end
	
	else if (!turn_ccw_prev && turn_ccw) begin
		if (angle == 4'b0000) begin
			angle <= 4'b1111;  // Handle underflow
		end else begin
			angle <= angle - 1;
		end
	end
	
	turn_cw_prev <= turn_cw;
	turn_ccw_prev <= turn_ccw;
end
endmodule