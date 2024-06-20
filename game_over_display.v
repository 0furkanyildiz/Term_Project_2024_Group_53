module game_over_display (
    input wire clk,
	 input wire game_over,
	 input wire [4:0] points,
    input wire [9:0] h_count,
    input wire [9:0] v_count,
    output reg [7:0] red,
    output reg [7:0] green,
    output reg [7:0] blue
);
    // Simple 8x8 character ROM (For simplicity, we consider each character is 8x8 pixels)
    reg [7:0] font_rom[0:127][0:7]; // 128 characters, each 8 rows

	 
    initial begin
        // ASCII 'G'
        font_rom[71][0] = 8'b01111100;
        font_rom[71][1] = 8'b11000110;
        font_rom[71][2] = 8'b11000110;
        font_rom[71][3] = 8'b11000000;
        font_rom[71][4] = 8'b11011110;
        font_rom[71][5] = 8'b11000110;
        font_rom[71][6] = 8'b11000110;
        font_rom[71][7] = 8'b01111100;
        // ASCII 'A'
        font_rom[65][0] = 8'b01111100;
        font_rom[65][1] = 8'b11000110;
        font_rom[65][2] = 8'b11000110;
        font_rom[65][3] = 8'b11000110;
        font_rom[65][4] = 8'b11111110;
        font_rom[65][5] = 8'b11000110;
        font_rom[65][6] = 8'b11000110;
        font_rom[65][7] = 8'b11000110;
        // ASCII 'M'
        font_rom[77][0] = 8'b11000110;
        font_rom[77][1] = 8'b11101110;
        font_rom[77][2] = 8'b11111110;
        font_rom[77][3] = 8'b11010110;
        font_rom[77][4] = 8'b11000110;
        font_rom[77][5] = 8'b11000110;
        font_rom[77][6] = 8'b11000110;
        font_rom[77][7] = 8'b11000110;
        // ASCII 'E'
        font_rom[69][0] = 8'b11111110;
        font_rom[69][1] = 8'b11000000;
        font_rom[69][2] = 8'b11000000;
        font_rom[69][3] = 8'b11111100;
        font_rom[69][4] = 8'b11000000;
        font_rom[69][5] = 8'b11000000;
        font_rom[69][6] = 8'b11000000;
        font_rom[69][7] = 8'b11111110;
        // ASCII ' ' (space)
        font_rom[32][0] = 8'b00000000;
        font_rom[32][1] = 8'b00000000;
        font_rom[32][2] = 8'b00000000;
        font_rom[32][3] = 8'b00000000;
        font_rom[32][4] = 8'b00000000;
        font_rom[32][5] = 8'b00000000;
        font_rom[32][6] = 8'b00000000;
        font_rom[32][7] = 8'b00000000;
        // ASCII 'O'
        font_rom[79][0] = 8'b01111100;
        font_rom[79][1] = 8'b11000110;
        font_rom[79][2] = 8'b11000110;
        font_rom[79][3] = 8'b11000110;
        font_rom[79][4] = 8'b11000110;
        font_rom[79][5] = 8'b11000110;
        font_rom[79][6] = 8'b11000110;
        font_rom[79][7] = 8'b01111100;
        // ASCII 'V'
        font_rom[86][0] = 8'b11000110;
        font_rom[86][1] = 8'b11000110;
        font_rom[86][2] = 8'b11000110;
        font_rom[86][3] = 8'b11000110;
        font_rom[86][4] = 8'b11000110;
        font_rom[86][5] = 8'b11000110;
        font_rom[86][6] = 8'b01101100;
        font_rom[86][7] = 8'b00111000;
		  // ASCII 'E'
        font_rom[69][0] = 8'b11111110;
        font_rom[69][1] = 8'b11000000;
        font_rom[69][2] = 8'b11000000;
        font_rom[69][3] = 8'b11111100;
        font_rom[69][4] = 8'b11111100;
        font_rom[69][5] = 8'b11000000;
        font_rom[69][6] = 8'b11000000;
        font_rom[69][7] = 8'b11111110;
        // ASCII 'R'
        font_rom[82][0] = 8'b11111100;
        font_rom[82][1] = 8'b11000110;
        font_rom[82][2] = 8'b11000110;
        font_rom[82][3] = 8'b11111100;
        font_rom[82][4] = 8'b11101100;
        font_rom[82][5] = 8'b11001110;
        font_rom[82][6] = 8'b11000110;
        font_rom[82][7] = 8'b11000110;
		  // ASCII '0'
			font_rom[48][0] = 8'b01111100;
			font_rom[48][1] = 8'b11000110;
			font_rom[48][2] = 8'b11001110;
			font_rom[48][3] = 8'b11011110;
			font_rom[48][4] = 8'b11110110;
			font_rom[48][5] = 8'b11100110;
			font_rom[48][6] = 8'b11000110;
			font_rom[48][7] = 8'b01111100;

			// ASCII '1'
			font_rom[49][0] = 8'b00011000;
			font_rom[49][1] = 8'b00111000;
			font_rom[49][2] = 8'b01111000;
			font_rom[49][3] = 8'b00011000;
			font_rom[49][4] = 8'b00011000;
			font_rom[49][5] = 8'b00011000;
			font_rom[49][6] = 8'b00011000;
			font_rom[49][7] = 8'b01111110;

			// ASCII '2'
			font_rom[50][0] = 8'b01111100;
			font_rom[50][1] = 8'b11000110;
			font_rom[50][2] = 8'b00000110;
			font_rom[50][3] = 8'b00001100;
			font_rom[50][4] = 8'b00111000;
			font_rom[50][5] = 8'b01100000;
			font_rom[50][6] = 8'b11000000;
			font_rom[50][7] = 8'b11111110;

			// ASCII '3'
			font_rom[51][0] = 8'b01111100;
			font_rom[51][1] = 8'b11000110;
			font_rom[51][2] = 8'b00000110;
			font_rom[51][3] = 8'b00111100;
			font_rom[51][4] = 8'b00000110;
			font_rom[51][5] = 8'b00000110;
			font_rom[51][6] = 8'b11000110;
			font_rom[51][7] = 8'b01111100;

			// ASCII '4'
			font_rom[52][0] = 8'b00001100;
			font_rom[52][1] = 8'b00011100;
			font_rom[52][2] = 8'b00111100;
			font_rom[52][3] = 8'b01101100;
			font_rom[52][4] = 8'b11001100;
			font_rom[52][5] = 8'b11111110;
			font_rom[52][6] = 8'b00001100;
			font_rom[52][7] = 8'b00001100;

			// ASCII '5'
			font_rom[53][0] = 8'b11111110;
			font_rom[53][1] = 8'b11000000;
			font_rom[53][2] = 8'b11000000;
			font_rom[53][3] = 8'b11111100;
			font_rom[53][4] = 8'b00000110;
			font_rom[53][5] = 8'b00000110;
			font_rom[53][6] = 8'b11000110;
			font_rom[53][7] = 8'b01111100;

			// ASCII '6'
			font_rom[54][0] = 8'b01111100;
			font_rom[54][1] = 8'b11000110;
			font_rom[54][2] = 8'b11000000;
			font_rom[54][3] = 8'b11111100;
			font_rom[54][4] = 8'b11000110;
			font_rom[54][5] = 8'b11000110;
			font_rom[54][6] = 8'b11000110;
			font_rom[54][7] = 8'b01111100;

			// ASCII '7'
			font_rom[55][0] = 8'b11111110;
			font_rom[55][1] = 8'b11000110;
			font_rom[55][2] = 8'b00001100;
			font_rom[55][3] = 8'b00001100;
			font_rom[55][4] = 8'b00011000;
			font_rom[55][5] = 8'b00011000;
			font_rom[55][6] = 8'b00011000;
			font_rom[55][7] = 8'b00011000;

			// ASCII '8'
			font_rom[56][0] = 8'b01111100;
			font_rom[56][1] = 8'b11000110;
			font_rom[56][2] = 8'b11000110;
			font_rom[56][3] = 8'b01111100;
			font_rom[56][4] = 8'b11000110;
			font_rom[56][5] = 8'b11000110;
			font_rom[56][6] = 8'b11000110;
			font_rom[56][7] = 8'b01111100;

			// ASCII '9'
			font_rom[57][0] = 8'b01111100;
			font_rom[57][1] = 8'b11000110;
			font_rom[57][2] = 8'b11000110;
			font_rom[57][3] = 8'b01111110;
			font_rom[57][4] = 8'b00000110;
			font_rom[57][5] = 8'b00000110;
			font_rom[57][6] = 8'b11000110;
			font_rom[57][7] = 8'b01111100;
    end

    wire [7:0] char_rom_data;
    reg [10:0] char_rom_addr;
    assign char_rom_data = font_rom[char_rom_addr[10:3]][char_rom_addr[2:0]];

    reg [3:0] tens_digit;
reg [3:0] units_digit;

always @(*) begin
    if (points >= 10) begin
        tens_digit = points / 10;
        units_digit = points % 10;
    end else begin
        tens_digit = 4'b0; // Default to '0' when points < 10
        units_digit = points;
    end
end

always @(posedge clk) begin
    // "GAME OVER" display logic
    if (game_over) begin
        // Adjust these values to shift the display to the right
        if (h_count >= 400 && h_count < 584 && v_count >= 240 && v_count < 248) begin
            case ((h_count - 398) / 8)	//400
                0: char_rom_addr <= {7'b01000111, v_count[2:0]};  // 'G'
                1: char_rom_addr <= {7'b01000001, v_count[2:0]};  // 'A'
                2: char_rom_addr <= {7'b01001101, v_count[2:0]};  // 'M'
                3: char_rom_addr <= {7'b01000101, v_count[2:0]};  // 'E'
                4: char_rom_addr <= {7'b00100000, v_count[2:0]};  // ' '
                5: char_rom_addr <= {7'b01001111, v_count[2:0]};  // 'O'
                6: char_rom_addr <= {7'b01010110, v_count[2:0]};  // 'V'
                7: char_rom_addr <= {7'b01000101, v_count[2:0]};  // 'E'
                8: char_rom_addr <= {7'b01010010, v_count[2:0]};  // 'R'
                9: char_rom_addr <= {7'b00100000, v_count[2:0]};  // ' ' (space)
                10: begin
                    if (points < 10) begin
                        char_rom_addr <= {4'b0011, points[3:0], v_count[2:0]};  // Single digit '0' to '9'
                    end else begin
                        char_rom_addr <= {4'b0011, tens_digit, v_count[2:0]};  // Tens digit '0' to '9'
                    end
                end
                11: begin
                    if (points >= 10) begin
                        char_rom_addr <= {4'b0011, units_digit, v_count[2:0]};  // Units digit '0' to '9'
                    end else begin
                        char_rom_addr <= {7'b00100000, v_count[2:0]};  // Space
                    end
                end
                default: char_rom_addr <= {7'b00100000, v_count[2:0]};  // ' ' (default to space)
            endcase
        end else begin
            char_rom_addr <= {7'b00100000, v_count[2:0]}; // blank space
        end

        // Determine pixel color based on character bitmap
        if (char_rom_data[h_count % 8]) begin
            red <= 8'hFF;
            green <= 8'hE0;
            blue <= 8'h00;
        end else begin
            red <= 8'h00;
            green <= 8'h00;
            blue <= 8'h00;
        end
    end else begin
        char_rom_addr <= {7'b00100000, v_count[2:0]}; // blank space when game_over is not active
        red <= 8'h00;
        green <= 8'h00;
        blue <= 8'h00;
    end
end
endmodule