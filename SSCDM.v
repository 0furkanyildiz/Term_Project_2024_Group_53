//2 BİTLİK DİSPLAY AYARLAYICI, 32 'ye kadar
module SSCDM(
 input wire clk,
 input wire [4:0] number,
 output reg [6:0] display1,
 output reg [6:0] display0,
 
 input wire [2:0] shoot_mode,
 output reg [6:0] display5
);

always @(posedge clk) 
begin

  case (shoot_mode)
		2'b00: display5 <= 7'b1000000; // 0
		2'b01: display5 <= 7'b1111001; // 1
		2'b10: display5 <= 7'b0100100; // 2
		2'b11: display5 <= 7'b0110000; // 3
  endcase
  
  if (number > 59) begin // 39'dan büyükse		16 + 8 + 4 + 1
		display1 <= 7'b0000010; // 6
  
  case(number-60)
     4'b0000: display0 <= 7'b1000000; // 0
	  4'b0001: display0 <= 7'b1111001; // 1
	  4'b0010: display0 <= 7'b0100100; // 2
	  4'b0011: display0 <= 7'b0110000; // 3
	  4'b0100: display0 <= 7'b0011001; // 4
	  4'b0101: display0 <= 7'b0010010; // 5
	  4'b0110: display0 <= 7'b0000010; // 6
	  4'b0111: display0 <= 7'b1111000; // 7
	  4'b1000: display0 <= 7'b0000000; // 8
	  4'b1001: display0 <= 7'b0011000; // 9
   endcase
 end
  
  else if (number > 49) begin // 39'dan büyükse		16 + 8 + 4 + 1
		display1 <= 7'b0010010; // 5
  
  case(number-50)
     4'b0000: display0 <= 7'b1000000; // 0
	  4'b0001: display0 <= 7'b1111001; // 1
	  4'b0010: display0 <= 7'b0100100; // 2
	  4'b0011: display0 <= 7'b0110000; // 3
	  4'b0100: display0 <= 7'b0011001; // 4
	  4'b0101: display0 <= 7'b0010010; // 5
	  4'b0110: display0 <= 7'b0000010; // 6
	  4'b0111: display0 <= 7'b1111000; // 7
	  4'b1000: display0 <= 7'b0000000; // 8
	  4'b1001: display0 <= 7'b0011000; // 9
   endcase
 end
  
  else if (number > 39) begin // 39'dan büyükse		16 + 8 + 4 + 1
		display1 <= 7'b0011001; // 4
  
  case(number-40)
     4'b0000: display0 <= 7'b1000000; // 0
	  4'b0001: display0 <= 7'b1111001; // 1
	  4'b0010: display0 <= 7'b0100100; // 2
	  4'b0011: display0 <= 7'b0110000; // 3
	  4'b0100: display0 <= 7'b0011001; // 4
	  4'b0101: display0 <= 7'b0010010; // 5
	  4'b0110: display0 <= 7'b0000010; // 6
	  4'b0111: display0 <= 7'b1111000; // 7
	  4'b1000: display0 <= 7'b0000000; // 8
	  4'b1001: display0 <= 7'b0011000; // 9
   endcase
 end
   
  else if (number > 29) begin // 29'dan büyükse		16 + 8 + 4 + 1
  display1 <= 7'b0110000; // 1.bite 3 ver
  
  case(number-30)
     4'b0000: display0 <= 7'b1000000; // 0
	  4'b0001: display0 <= 7'b1111001; // 1
	  4'b0010: display0 <= 7'b0100100; // 2
	  4'b0011: display0 <= 7'b0110000; // 3
	  4'b0100: display0 <= 7'b0011001; // 4
	  4'b0101: display0 <= 7'b0010010; // 5
	  4'b0110: display0 <= 7'b0000010; // 6
	  4'b0111: display0 <= 7'b1111000; // 7
	  4'b1000: display0 <= 7'b0000000; // 8
	  4'b1001: display0 <= 7'b0011000; // 9
   endcase
 end
 
 else if (number > 19)begin 	//	 19'dan büyükse 		16 + 2 + 1
  display1 <= 7'b0100100; // 1. bite 2 ver
  
  case(number-20)
        4'b0000: display0 <= 7'b1000000; // 0
        4'b0001: display0 <= 7'b1111001; // 1
        4'b0010: display0 <= 7'b0100100; // 2
        4'b0011: display0 <= 7'b0110000; // 3
        4'b0100: display0 <= 7'b0011001; // 4
        4'b0101: display0 <= 7'b0010010; // 5
        4'b0110: display0 <= 7'b0000010; // 6
        4'b0111: display0 <= 7'b1111000; // 7
        4'b1000: display0 <= 7'b0000000; // 8
        4'b1001: display0 <= 7'b0011000; // 9
    endcase
 end

 else if (number > 9)begin 	//	 9'dan büyükse 		16 + 2 + 1
  display1 <= 7'b1111001; // 1. bite 1 ver
  
  case(number-10)
        4'b0000: display0 <= 7'b1000000; // 0
        4'b0001: display0 <= 7'b1111001; // 1
        4'b0010: display0 <= 7'b0100100; // 2
        4'b0011: display0 <= 7'b0110000; // 3
        4'b0100: display0 <= 7'b0011001; // 4
        4'b0101: display0 <= 7'b0010010; // 5
        4'b0110: display0 <= 7'b0000010; // 6
        4'b0111: display0 <= 7'b1111000; // 7
        4'b1000: display0 <= 7'b0000000; // 8
        4'b1001: display0 <= 7'b0011000; // 9
    endcase
 end
 else begin
 
	display1 <= 7'b1000000; // 1. bite 0 ver 
	case(number)
	  4'b0000: display0 <= 7'b1000000; // 0
	  4'b0001: display0 <= 7'b1111001; // 1
	  4'b0010: display0 <= 7'b0100100; // 2
	  4'b0011: display0 <= 7'b0110000; // 3
	  4'b0100: display0 <= 7'b0011001; // 4
	  4'b0101: display0 <= 7'b0010010; // 5
	  4'b0110: display0 <= 7'b0000010; // 6
	  4'b0111: display0 <= 7'b1111000; // 7
	  4'b1000: display0 <= 7'b0000000; // 8
	  4'b1001: display0 <= 7'b0011000; // 9
	endcase
end
end
endmodule