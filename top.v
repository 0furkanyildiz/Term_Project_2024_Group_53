module top (
    input wire clock50,
	 input wire xKEY0,
	 input wire xKEY1,
	 input wire xKEY2,
	 input wire [1:0] xSW,
 	 output     [6:0] xHEX0,
	 output     [6:0] xHEX1,
	 output     [6:0] xHEX5,
	 output     [2:0] xLEDR,
    output              xVGA_BLANK_N,
    output              xVGA_CLK,
    output              xVGA_HS,
    output     reg   [7:0] xVGA_R,
    output     reg   [7:0] xVGA_G,
    output     reg   [7:0] xVGA_B,
    output              xVGA_SYNC_N,
    output              xVGA_VS
);

    wire clk_25MHz;
    wire [9:0] h_count, v_count;
    wire [7:0] red, green, blue;
	 wire [3:0] angle;
	 
	 wire [15:0] rand_4bit;
	 wire [3:0] rand_2bit;
	 wire [10:0] spawn_x;
    wire [10:0] spawn_y;
	 
	 wire [5:0] points;
	 
	 wire clk_60Hz;
	 wire game_over;
	
	 clock_60Hz clock_60Hz_ins(
			.clock50(clock50),
			.clk_60Hz(clk_60Hz)
			);	 

    // Clock divider to generate 25 MHz clock from 50 MHz input clock
    reg clk_div;
    always @(posedge clock50) begin
        clk_div <= ~clk_div;
    end
    assign clk_25MHz = clk_div;
	 
	 FourBitRandomNumberGenerator twobit(
		.clk(clk_60Hz),
		.rand_4bit(rand_4bit)
	 );
	 
	 enemy enemy1(
		.spawn_angle(rand_4bit),
		.spawn_x(spawn_x),
		.spawn_y(spawn_y)
	 );

    // Instantiate vga_sync module
    vga_sync vga_sync_inst(
        .clk(clk_25MHz),
        .hsync(xVGA_HS),
        .vsync(xVGA_VS),
        .h_count(h_count),
        .v_count(v_count)
    );

    // Instantiate game module
    game square_inst(
		  .clk_25MHz(clk_25MHz),
        .h_count(h_count),
        .v_count(v_count),
		  .aci(angle),
		  .spawn_x(spawn_x),
		  .spawn_y(spawn_y),
		  .shoot_modes(xSW),
        .red(red),
        .green(green),
        .blue(blue),
		  .rand4_bit(rand4_bit),
		  .clk_60Hz(clk_60Hz),
		  .shoot(xKEY2),
		  .points(points),
		  .game_over(game_over),
		  .anlik_dusman_sayisi(xLEDR)
    );
	 
	 spaceship_aci aci(
		.clk(clk_25MHz),
		.turn_cw(xKEY0),
		.turn_ccw(xKEY1),
		.angle(angle)
	 );
	 
	 SSCDM display(
		.clk(clk_25MHz),
		.number(points),
		.display1(xHEX1),
		.display0(xHEX0),
		.shoot_mode(xSW),
		.display5(xHEX5)
	 );
	 
	 // Instantiate game_over_display module (always enabled)
    wire [7:0] game_over_red, game_over_green, game_over_blue;
    game_over_display game_over_inst(
        .clk(clk_25MHz),
		  .game_over(game_over),
		  .points(points),
        .h_count(h_count),
        .v_count(v_count),
        .red(game_over_red),
        .green(game_over_green),
        .blue(game_over_blue)
    );
	 	
    // Other VGA signals
    assign xVGA_BLANK_N = 1'b1;  // VGA blanking is active low
    assign xVGA_SYNC_N = 1'b0;   // VGA sync is active low
    assign xVGA_CLK = clk_25MHz;

    // Output the color based on the current pixel position
	 
	 always @ (posedge clk_25MHz) begin
		 if (!game_over) begin
		 
			 xVGA_R <= red;
			 xVGA_G <= green;
			 xVGA_B <= blue;
		 end
		 else begin
			  xVGA_R <= game_over_red;
			  xVGA_G <= game_over_green;
			  xVGA_B <= game_over_blue;
		 end 
	 end
	 
	 
endmodule
