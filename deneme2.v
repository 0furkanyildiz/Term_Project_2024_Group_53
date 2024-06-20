module deneme2(
    //////////// CLOCK //////////
    input               CLOCK2_50,
    input               CLOCK3_50,
    input               CLOCK4_50,
    input               CLOCK_50,

    //////////// SEG7 //////////
    output        [6:0] HEX0,
    output        [6:0] HEX1,
    output        [6:0] HEX2,
    output        [6:0] HEX3,
    output        [6:0] HEX4,
    output        [6:0] HEX5,

    //////////// KEY //////////
    input         [3:0] KEY,

    //////////// LED //////////
    output        [9:0] LEDR,

    //////////// SW //////////
    input         [9:0] SW,

    //////////// VGA //////////
    output              VGA_BLANK_N,
    output              VGA_CLK,
    output              VGA_HS,
    output        [7:0] VGA_R,
    output        [7:0] VGA_G,
    output        [7:0] VGA_B,
    output              VGA_SYNC_N,
    output              VGA_VS
);

	assign	HEX2 = 7'b1111111;
	assign	HEX3 = 7'b1111111;
	assign	HEX4 = 7'b1111111;
	
	// Instantiate the top module
    top top_inst (
        .clock50(CLOCK_50),
		  .xKEY0(KEY[0]),
		  .xKEY1(KEY[1]),
		  .xKEY2(KEY[2]),
		  .xHEX0(HEX0),
		  .xHEX1(HEX1),
		  .xHEX5(HEX5),		  
		  .xLEDR(LEDR[2:0]),
		  .xSW(SW[1:0]),
        .xVGA_BLANK_N(VGA_BLANK_N),
        .xVGA_CLK(VGA_CLK),
        .xVGA_HS(VGA_HS),
        .xVGA_R(VGA_R),
        .xVGA_G(VGA_G),
        .xVGA_B(VGA_B),
        .xVGA_SYNC_N(VGA_SYNC_N),
        .xVGA_VS(VGA_VS)
   );

endmodule
