module enemy(
//    input wire [9:0] h_count,
//    input wire [9:0] v_count,
	 input wire [3:0] spawn_angle, //rand_4bit ver
	 //input wire [3:0] enemy_type, //rand_2bit ver
	 output reg [10:0] spawn_x,
	 output reg [10:0] spawn_y
);

	// Define initial position based on spawn angle
	always @* begin
		 case (spawn_angle)
			  4'd0:   begin spawn_x = 320; spawn_y = 0; end
			  4'd1:   begin spawn_x = 385; spawn_y = 48; end
			  4'd2:   begin spawn_x = 448; spawn_y = 117; end
			  4'd3:   begin spawn_x = 495; spawn_y = 200; end
			  4'd4:   begin spawn_x = 521; spawn_y = 295; end
			  4'd5:   begin spawn_x = 521; spawn_y = 385; end
			  4'd6:   begin spawn_x = 495; spawn_y = 480; end
			  4'd7:   begin spawn_x = 448; spawn_y = 563; end
			  4'd8:   begin spawn_x = 385; spawn_y = 632; end
			  4'd9:   begin spawn_x = 320; spawn_y = 680; end
			  4'd10:  begin spawn_x = 255; spawn_y = 632; end
			  4'd11:  begin spawn_x = 192; spawn_y = 563; end
			  4'd12:  begin spawn_x = 145; spawn_y = 480; end
			  4'd13:  begin spawn_x = 119; spawn_y = 385; end
			  4'd14:  begin spawn_x = 119; spawn_y = 295; end
			  4'd15:  begin spawn_x = 145; spawn_y = 200; end
			  default: begin spawn_x = 320; spawn_y = 0; end
		 endcase
	end
	
//	always @* begin
//		 case (enemy_type)
//			  4'd0:
//			  4'd1:
//			  4'd2:

endmodule
