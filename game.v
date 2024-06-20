module game(
	 input wire clk_25MHz,
    input wire [9:0] h_count,
    input wire [9:0] v_count,
	 input wire [3:0] aci,
	 
	 input wire [10:0] spawn_x,
	 input wire [10:0] spawn_y,
	 
	 input wire [1:0] shoot_modes, // 00->tekli vuruş, 01->45 derece vuruş, 10->90 derece vuruş, 11->her şeye tek atan ulti
	 
    output reg [7:0] red,
    output reg [7:0] green,
    output reg [7:0] blue,
	 
	 input wire [3:0] rand4_bit,
	 input wire clk_60Hz,
	 input wire shoot,
	 
	 output reg [5:0] points,
	 output reg game_over,
	 
	 output reg [2:0] anlik_dusman_sayisi			// max 8 olabiliyor, LED ile gösterilecek
);

initial begin game_over = 0; end
initial begin points = 0; end
initial begin anlik_dusman_sayisi = 0; end

reg point0 = 0;
reg point1 = 0;
reg point2 = 0;
reg point3 = 0;
reg point4 = 0;
reg point5 = 0;
reg point6 = 0;
reg point7 = 0;
reg point8 = 0;
reg point9 = 0;
reg point10 = 0;
reg point11 = 0;
reg point12 = 0;
reg point13 = 0;
reg point14 = 0;
reg point15 = 0;


// enemy0 parameters
reg [1:0] enemy0_can = 2'b00; //0
localparam enemy0_SIZE = 20; // Adjust square size as needed
integer enemy0_X = 455;   
integer enemy0_Y = 10;  

// enemy1 parameters (22.5 derece, 1 sola 2 aşağı gelecek)
reg [1:0] enemy1_can = 2'b00; //0
integer enemy1_X = 575;   	// yeni
integer enemy1_Y = 10;  

// enemy2 parameters (45 derece, 1 sola 1 aşağı gelecek)
reg [1:0] enemy2_can = 2'b00; //0
integer enemy2_X = 695;   
integer enemy2_Y = 20;  

// enemy3 parameters (67,5 derece, 2 sola 1 aşağı gelecek)
reg [1:0] enemy3_can = 2'b00; //0
integer enemy3_X = 720;   
integer enemy3_Y = 120;  

//enemy4 parameters (90 derece, 1 sola)
reg [1:0] enemy4_can = 2'b00; //0
integer enemy4_X = 900;
integer enemy4_Y = 262;

// enemy5 parameters (90+22,5 derece, 2 sola 1 yukarı gelecek)
reg [1:0] enemy5_can = 2'b00; //0
integer enemy5_X = 720;   
integer enemy5_Y = 390;  

// enemy6 parameters (90+45 derece, 1 sola 1 yukarı gelecek)
reg [1:0] enemy6_can = 2'b00; //0
integer enemy6_X = 695;   
integer enemy6_Y = 490;  

// enemy7 parameters (90+67,5 derece, 1 sola 2 yukarı gelecek)
reg [1:0] enemy7_can = 2'b00; //0
integer enemy7_X = 575;   
integer enemy7_Y = 500;  

// enemy8 parameters (180 yukarı, 1 yukarı gidiyor)
reg [1:0] enemy8_can = 2'b00; //0
integer enemy8_X = 455;
integer enemy8_Y = 524;

// enemy9 parameters (180+22,5 derece, 1 sağa 2 yukarı gelecek)
reg [1:0] enemy9_can = 2'b00; //0
integer enemy9_X = 455;   
integer enemy9_Y = 10;  

// enemy10 parameters (180+45 derece, 1 sağa 1 yukarı gelecek)
reg [1:0] enemy10_can = 2'b00; //0
integer enemy10_X = 455;   
integer enemy10_Y = 10; 
 
// enemy11 parameters (180+67,5 derece, 2 sağa 1 yukarı gidiyor)
reg [1:0] enemy11_can = 2'b00; //0
integer enemy11_X = 0; // Start at bottom-left corner
integer enemy11_Y = 480; // Start at bottom-left corner
 
//enemy12 parameters (270 derece, soldan gelen)
reg [1:0] enemy12_can = 2'b00; //0
integer enemy12_X_START = 10;
integer enemy12_X_END = 20;
integer enemy12_Y_START = 250;
integer enemy12_Y_END = 270;

// enemy13 parameters (270+22,5 derece, 2 sağa 1 aşağı gelecek)
reg [1:0] enemy13_can = 2'b00; //0
integer enemy13_X = 455;
integer enemy13_Y = 524;

// enemy14 parameters (270+45 derece, 1 sağa 1 aşağı gelecek)
reg [1:0] enemy14_can = 2'b00; //
integer enemy14_X = 455;   
integer enemy14_Y = 10;  

// enemy15 parameters (270+67,5 derece, 1 sağa 2 aşağı gelecek)
reg [1:0] enemy15_can = 2'b00; //0
integer enemy15_X = 455;   
integer enemy15_Y = 10; 

localparam H_SYNC_CYC = 96;       // Horizontal sync pulse width
localparam H_BACK_PORCH = 48;     // Horizontal back porch

localparam V_SYNC_CYC = 2;        // Vertical sync pulse width
localparam V_BACK_PORCH = 33;     // Vertical back porch

// Square parameters
integer CIRCLE_RADIUS = 20; // Adjust square size as needed
integer CIRCLE_CENTER_X = 460;   
integer CIRCLE_CENTER_Y = 262;  
 
integer TARRET_RADIUS = 5;
integer TARRET_X = 460;
integer TARRET_Y = 240;

integer count_enemy_0 = 0;
integer count_enemy_1 = 0;
integer count_enemy_2 = 0;
integer count_enemy_3 = 0;
integer count_enemy_4 = 0;
integer count_enemy_5 = 0;
integer count_enemy_6 = 0;
integer count_enemy_7 = 0;
integer count_enemy_8 = 0;
integer count_enemy_9 = 0;
integer count_enemy_10 = 0;
integer count_enemy_11 = 0;
integer count_enemy_12 = 0;
integer count_enemy_13 = 0;
integer count_enemy_14 = 0;
integer count_enemy_15 = 0;

reg shoot_previous_state;

always @(posedge clk_60Hz) begin

	if (!game_over) begin

	shoot_previous_state <= shoot;
	
	count_enemy_0  <= (count_enemy_0  + 1) % (30 * 5);			// her bir düşmanın öldükten sonra kaç sn sonrasında geleceği (vurduktan 15 sn sonra geliyor)
	count_enemy_1  <= (count_enemy_1  + 1) % (30 * 5);
	count_enemy_2  <= (count_enemy_2  + 1) % (30 * 5);
	count_enemy_3  <= (count_enemy_3  + 1) % (30 * 5);
	count_enemy_4  <= (count_enemy_4  + 1) % (30 * 5); 			// 6 sn sonra spawn
	count_enemy_5  <= (count_enemy_5  + 1) % (30 * 5);
	count_enemy_6  <= (count_enemy_6  + 1) % (30 * 5);
	count_enemy_7  <= (count_enemy_7  + 1) % (30 * 5);	
	count_enemy_8  <= (count_enemy_8  + 1) % (30 * 5);
	count_enemy_9  <= (count_enemy_9  + 1) % (30 * 5);
	count_enemy_10 <= (count_enemy_10 + 1) % (30 * 5);
	count_enemy_11 <= (count_enemy_11 + 1) % (30 * 5); 		   // Update counter for enemy1_2
	count_enemy_12 <= (count_enemy_12 + 1) % (30 * 5);			   // 2 sn sonra spawn
	count_enemy_13 <= (count_enemy_13 + 1) % (30 * 5);
	count_enemy_14 <= (count_enemy_14 + 1) % (30 * 5);
	count_enemy_15 <= (count_enemy_15 + 1) % (30 * 5);
	
	// BURAYI HALLEDİCEZ -> min 2 yapmaca
	/*
	if ((enemy0_can + enemy1_can + enemy4_can + enemy8_can + enemy11_can + enemy12_can) < 3) begin
	
		if (enemy0_can == 0) begin
			enemy0_can <= 1;
			enemy0_Y <= 10;
			count_enemy_0 <= 0;
			anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
		end
		
		if (enemy1_can == 0) begin
			enemy1_can <= 1;
			enemy1_X <= 575;
			enemy1_Y <= 10;
			count_enemy_1 <= 0;
			anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
		end
		
		if (enemy4_can == 0) begin
			enemy4_can <= 3;
			enemy4_X <= 890;
			count_enemy_4 <= 0;
			anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
		end
		
		if (enemy8_can == 0) begin
			enemy8_can <= 3;
			enemy8_Y <= 524; // reset
			enemy8_can <= 3;
			count_enemy_8 <= 0;
			anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
		end
		
		if (enemy11_can == 0) begin
			enemy11_can <= 1;
			enemy11_X <= 10;
			enemy11_Y <= 480;
			count_enemy_11 <= 0;
			anlik_dusman_sayisi <= anlik_dusman_sayisi +1; 		// YENİ
		end
		
		if (enemy12_can == 0) begin
			enemy12_can <= 2;
			enemy12_X_START <= 10;
			enemy12_X_END <= 20;
			count_enemy_12 <= 0;
			anlik_dusman_sayisi <= anlik_dusman_sayisi +1; 		// YENİ
		end		
	end	*/
	
	/* 0 -> single
		1 -> 45
		2 -> 90
		3 -> ulti
	*/
		
	if (!shoot && shoot_previous_state && ((shoot_modes==2'b00 && aci == 4'b0000)||(shoot_modes==2'b01 && (aci == 4'b0000 || aci == 4'b0001 || aci == 4'b1111)||(shoot_modes==2'b10 && (aci == 4'b0000 || aci == 4'b0001 || aci == 4'b1111 || aci == 4'b1110 || aci == 4'b0010))||(shoot_modes==2'b11)))) begin
	
		if (enemy0_can > 0 && enemy0_Y > 10) begin								//canı sıfırdan büyükse ve belirli bir mesafedeyse
			enemy0_can <= enemy0_can - 1;							// canı 1 azalt
		end
		
		if (enemy0_can == 1 && enemy0_Y > 10) begin			// canı 1 ise ve mesafedeyse
			points = points + 1;
			count_enemy_0 <= 0;
			enemy0_Y <= 10;
			enemy0_can <= 0;			// YENİ EKLENDİ
			anlik_dusman_sayisi <= anlik_dusman_sayisi -1; 		// YENİ
		end
	end
	
	// enemy0 counter ile yeniden spawnlanma kısmı
	if (anlik_dusman_sayisi < 8 && count_enemy_0 == 100 && enemy0_can == 0) begin
		enemy0_can <= 1;
		enemy0_Y <= 10;
		count_enemy_0 <= 0;
		anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
	end
	// enemy0 hareket kısmı
	if ((enemy0_can > 0) && (enemy0_Y < 262)) begin
		enemy0_X <= 455;
		if (points > 15) begin
			enemy0_Y <= enemy0_Y+2;
		end
		else 
			enemy0_Y <= enemy0_Y+1;
		end
	end
	
	


	//enemy1 vurulma kısmı
	if (!shoot && shoot_previous_state && ((shoot_modes==2'b00 && aci == 4'b0001)||(shoot_modes==2'b01 && (aci == 4'b0000 || aci == 4'b0001 || aci == 4'b0010)||(shoot_modes==2'b10 && (aci == 4'b0000 || aci == 4'b0001 || aci == 4'b1111 || aci == 4'b0010 || aci == 4'b0011))||(shoot_modes==2'b11)))) begin

		if (enemy1_can > 0 && enemy1_Y > 10) begin								//canı sıfırdan büyükse ve belirli bir mesafedeyse
			enemy1_can <= enemy1_can - 1;							// canı 1 azalt
		end
		
		if (enemy1_can == 1 && enemy1_Y > 10) begin			// canı 1 ise ve mesafedeyse
			points = points + 1;
			count_enemy_1 <= 0;
			enemy1_Y <= 10;
			enemy1_can <= 0;			// YENİ EKLENDİ
			anlik_dusman_sayisi <= anlik_dusman_sayisi -1; 		// YENİ
		end
	end
	// enemy1 counter ile yeniden spawnlanma kısmı
	if (anlik_dusman_sayisi < 8 && count_enemy_1 == 150 && enemy1_can == 0) begin
		enemy1_can <= 1;
		enemy1_X <= 575;
		enemy1_Y <= 10;		
		count_enemy_1 <= 0;
		anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
	end
	// enemy1 hareket kısmı
	if ((enemy1_can > 0) && (enemy1_Y < 262)) begin
		if (points<15) begin 
		enemy1_X <= enemy1_X - 1;
		enemy1_Y <= enemy1_Y + 2; // 1 sola 2 aşağı
	end else begin
		enemy1_X <= enemy1_X - 2;
		enemy1_Y <= enemy1_Y + 4; // 1 sola 2 aşağı
		end
	end
	
	
	//enemy2 vurulma kısmı
	if (!shoot && shoot_previous_state && ((shoot_modes==2'b00 && aci == 4'b0010)||(shoot_modes==2'b01 && (aci == 4'b0001 || aci == 4'b0010 || aci == 4'b0011)||(shoot_modes==2'b10 && (aci == 4'b0000 || aci == 4'b0001 || aci == 4'b0010 || aci == 4'b0011 || aci == 4'b0100))||(shoot_modes==2'b11)))) begin

		if (enemy2_can > 0 && enemy2_X < 690) begin								//canı sıfırdan büyükse ve belirli bir mesafedeyse
			enemy2_can <= enemy2_can - 1;							// canı 1 azalt
		end
		
		if (enemy2_can == 1 && enemy2_X < 690) begin			// canı 1 ise ve mesafedeyse
			points = points + 1;
			count_enemy_2 <= 0;
			enemy2_X <= 695;
			enemy2_Y <= 20;
			enemy2_can <= 0;			// YENİ EKLENDİ
			anlik_dusman_sayisi <= anlik_dusman_sayisi -1; 		// YENİ
		end
	end
	// enemy2 counter ile yeniden spawnlanma kısmı
	if (anlik_dusman_sayisi < 8 && count_enemy_2 == 125 && enemy2_can == 0) begin
		enemy2_can <= 1;
		enemy2_X <= 695;
		enemy2_Y <= 20;		
		count_enemy_2 <= 0;
		anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
	end
	// enemy2 hareket kısmı
	if ((enemy2_can > 0) && (enemy2_X > 0)) begin
		enemy2_X <= enemy2_X - 1;
		enemy2_Y <= enemy2_Y + 1; // 1 sola 1 aşağı
	end
	

	//enemy3 vurulma kısmı
   if (!shoot && shoot_previous_state && ((shoot_modes==2'b00 && aci == 4'b0011)||(shoot_modes==2'b01 && (aci == 4'b0010 || aci == 4'b0011 || aci == 4'b0100)||(shoot_modes==2'b10 && (aci == 4'b0001 || aci == 4'b0010 || aci == 4'b0011 || aci == 4'b0100 || aci == 4'b0101))||(shoot_modes==2'b11)))) begin

		if (enemy3_can > 0 && enemy3_X < 720) begin								//canı sıfırdan büyükse ve belirli bir mesafedeyse
			enemy3_can <= enemy3_can - 1;							// canı 1 azalt
		end
		
		if (enemy3_can == 1 && enemy3_X < 720) begin			// canı 1 ise ve mesafedeyse
			points = points + 1;
			count_enemy_3 <= 0;
			enemy3_X <= 720;
			enemy3_Y <= 120;
			enemy3_can <= 0;			// YENİ EKLENDİ
			anlik_dusman_sayisi <= anlik_dusman_sayisi -1; 		// YENİ
		end
	end
	// enemy3 counter ile yeniden spawnlanma kısmı
	if (anlik_dusman_sayisi < 8 && count_enemy_3 == 180 && enemy3_can == 0) begin
		enemy3_can <= 1;
		enemy3_X <= 720;
		enemy3_Y <= 120;		
		count_enemy_3 <= 0;
		anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
	end
	// enemy3 hareket kısmı
	if ((enemy3_can > 0) && (enemy3_X > 0)) begin
		enemy3_X <= enemy3_X - 2;
		enemy3_Y <= enemy3_Y + 1; // 2 sola 1 aşağı
	end
	
	
	// enemy 4, sagdaki yuvarlak
	if (!shoot && shoot_previous_state && ((shoot_modes==2'b00 && aci == 4'b0100)||(shoot_modes==2'b01 && (aci == 4'b0011 || aci == 4'b0100 || aci == 4'b0101)||(shoot_modes==2'b10 && (aci == 4'b0010 || aci == 4'b0011 || aci == 4'b0100 || aci == 4'b0101 || aci == 4'b0110))||(shoot_modes==2'b11)))) begin
		if (enemy4_can > 0 && enemy4_X < 890) begin					// canı sıfırdan büyükse 1 azalt
			enemy4_can <= enemy4_can - 1;
		end
		if (enemy4_can == 1 && enemy4_X < 890) begin					// canı 1se 1 puan ekle, counter sıfırla
			points = points + 1;
			count_enemy_4 <= 0;
			enemy4_X <= 890;
			enemy4_can <= 0;													// YENİ EKLENDİ
			anlik_dusman_sayisi <= anlik_dusman_sayisi - 1; 		// YENİ
		end
	end
	// enemy4 spawn
	if (anlik_dusman_sayisi < 8 && count_enemy_4 == 140 && enemy4_can == 0) begin
		enemy4_can <= 3;
		enemy4_X <= 890;
		count_enemy_4 <= 0;
		anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
	end
	// enemy4 hareket kısmı
	if ((enemy4_can > 0) && (enemy4_X > 460)) begin
		enemy4_Y <= 262;
		if (points<15) begin 
		enemy4_X <= enemy4_X - 1;
		end else begin
		enemy4_X <= enemy4_X - 2;
		end
	end
	
	
	
	//enemy5 vurulma kısmı
	if (!shoot && shoot_previous_state && ((shoot_modes==2'b00 && aci == 4'b0101)||(shoot_modes==2'b01 && (aci == 4'b0100 || aci == 4'b0101 || aci == 4'b0110)||(shoot_modes==2'b10 && (aci == 4'b0011 || aci == 4'b0100 || aci == 4'b0101 || aci == 4'b0110 || aci == 4'b0111))||(shoot_modes==2'b11)))) begin
		if (enemy5_can > 0 && enemy5_X < 720) begin								//canı sıfırdan büyükse ve belirli bir mesafedeyse
			enemy5_can <= enemy5_can - 1;							// canı 1 azalt
		end
		
		if (enemy5_can == 1 && enemy5_X < 720) begin			// canı 1 ise ve mesafedeyse
			points = points + 1;
			count_enemy_5 <= 0;
			enemy5_X <= 720;
			enemy5_Y <= 390;
			enemy5_can <= 0;			// YENİ EKLENDİ
			anlik_dusman_sayisi <= anlik_dusman_sayisi -1; 		// YENİ
		end
	end
	// enemy5 counter ile yeniden spawnlanma kısmı
	if (anlik_dusman_sayisi < 8 && count_enemy_5 == 90 && enemy5_can == 0) begin
		enemy5_can <= 1;
		enemy5_X <= 720;
		enemy5_Y <= 390;		
		count_enemy_5 <= 0;
		anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
	end
	// enemy5 hareket kısmı
	if ((enemy5_can > 0) && (enemy5_X > 0)) begin
		enemy5_X <= enemy5_X - 2;
		enemy5_Y <= enemy5_Y - 1; // 2 sola 1 yukarı
	end
	
	
	//enemy6 vurulma kısmı
   if (!shoot && shoot_previous_state && ((shoot_modes==2'b00 && aci == 4'b0110)||(shoot_modes==2'b01 && (aci == 4'b0110 || aci == 4'b0111 || aci == 4'b0101)||(shoot_modes==2'b10 && (aci == 4'b0110 || aci == 4'b0111 || aci == 4'b0101 || aci == 4'b1000 || aci == 4'b0100))||(shoot_modes==2'b11)))) begin
		if (enemy6_can > 0 && enemy6_X < 690) begin								//canı sıfırdan büyükse ve belirli bir mesafedeyse
			enemy6_can <= enemy6_can - 1;							// canı 1 azalt
		end
		
		if (enemy6_can == 1 && enemy6_X < 690) begin			// canı 1 ise ve mesafedeyse
			points = points + 1;
			count_enemy_6 <= 0;
			enemy6_X <= 695;
			enemy6_Y <= 490;
			enemy2_can <= 0;			// YENİ EKLENDİ
			anlik_dusman_sayisi <= anlik_dusman_sayisi - 1; 		// YENİ
		end
	end
	// enemy6counter ile yeniden spawnlanma kısmı
	if (anlik_dusman_sayisi < 8 && count_enemy_6 == 160 && enemy6_can == 0) begin
		enemy6_can <= 1;
		enemy6_X <= 695;
		enemy6_Y <= 490;		
		count_enemy_6 <= 0;
		anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
	end
	// enemy6 hareket kısmı
	if ((enemy6_can > 0) && (enemy6_X > 0)) begin
		enemy6_X <= enemy6_X - 1;
		enemy6_Y <= enemy6_Y - 1; // 1 sola 1 yukarı
	end
	
	
	
	//enemy7 vurulma kısmı
   if (!shoot && shoot_previous_state && ((shoot_modes==2'b00 && aci == 4'b0111)||(shoot_modes==2'b01 && (aci == 4'b0111 || aci == 4'b1000 || aci == 4'b0110)||(shoot_modes==2'b10 && (aci == 4'b0111 || aci == 4'b1000 || aci == 4'b0110 || aci == 4'b1001 || aci == 4'b0101))||(shoot_modes==2'b11)))) begin
		if (enemy7_can > 0 && enemy7_X < 575) begin								//canı sıfırdan büyükse ve belirli bir mesafedeyse
			enemy7_can <= enemy7_can - 1;							// canı 1 azalt
		end
		
		if (enemy7_can == 1 && enemy7_X < 575) begin			// canı 1 ise ve mesafedeyse
			points = points + 1;
			count_enemy_7 <= 0;
			enemy7_X <= 575;
			enemy7_Y <= 500; // degis
			enemy7_can <= 0;			// YENİ EKLENDİ
			anlik_dusman_sayisi <= anlik_dusman_sayisi - 1; 		// YENİ
		end
	end
	// enemy7 counter ile yeniden spawnlanma kısmı
	if (anlik_dusman_sayisi < 8 && count_enemy_7 == 130 && enemy7_can == 0) begin
		enemy7_can <= 1;
		enemy7_X <= 575;
		enemy7_Y <= 500;		
		count_enemy_7 <= 0;
		anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
	end
	// enemy7 hareket kısmı
	if ((enemy7_can > 0) && (enemy7_X > 0)) begin
		enemy7_X <= enemy7_X - 1;
		enemy7_Y <= enemy7_Y - 2; // 1 sola 2 yukarı
	end	
	
	
	
	// enemy8 (new enemy moving up)
   if (!shoot && shoot_previous_state && ((shoot_modes==2'b00 && aci == 4'b1000)||(shoot_modes==2'b01 && (aci == 4'b1000 || aci == 4'b1001 || aci == 4'b0111)||(shoot_modes==2'b10 && (aci == 4'b1000 || aci == 4'b1001 || aci == 4'b0111 || aci == 4'b1010 || aci == 4'b0110))||(shoot_modes==2'b11)))) begin
       if (enemy8_can > 0 && enemy8_Y < 514) begin
           enemy8_can <= enemy8_can - 1;
       end
    
       if (enemy8_can == 1 && enemy8_Y < 514) begin
           points = points + 1;
           count_enemy_8 <= 0;
           enemy8_Y <= 514;
			  anlik_dusman_sayisi <= anlik_dusman_sayisi - 1; 		// YENİ
			  enemy8_can <= 0;
       end
   end
	 // enemy8 counter ile yeniden spawnlanma kısmı
	if (anlik_dusman_sayisi < 8 && count_enemy_8 == 80 && enemy8_can == 0) begin
		enemy8_can <= 3;
		enemy8_Y <= 524; // reset
      enemy8_can <= 3;
		count_enemy_8 <= 0;
		anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
	end
   // enemy8 hareket kısmı
   if ((enemy8_can > 0) && (enemy8_Y > 262)) begin
	     enemy8_X <= 455;
		if (points<15) begin 
       enemy8_Y <= enemy8_Y - 1; // move up
		 end else begin
       enemy8_Y <= enemy8_Y - 2; // move up		 
		 end
   end
	
	
	
	//enemy9 vurulma kısmı
   if (!shoot && shoot_previous_state && ((shoot_modes==2'b00 && aci == 4'b1001)||(shoot_modes==2'b01 && (aci == 4'b1001 || aci == 4'b1000 || aci == 4'b1010)||(shoot_modes==2'b10 && (aci == 4'b1001 || aci == 4'b1000 || aci == 4'b1010 || aci == 4'b0111 || aci == 4'b1011))||(shoot_modes==2'b11)))) begin
		if (enemy9_can > 0 && enemy9_X > 0) begin								//canı sıfırdan büyükse ve belirli bir mesafedeyse
			enemy9_can <= enemy9_can - 1;							// canı 1 azalt
		end
		
		if (enemy9_can == 1 && enemy9_X > 0) begin			// canı 1 ise ve mesafedeyse
			points = points + 1;
			count_enemy_9 <= 0;
			enemy9_X <= 345;
			enemy9_Y <= 500;
			enemy9_can <= 0;			// YENİ EKLENDİ
			anlik_dusman_sayisi <= anlik_dusman_sayisi -1; 		// YENİ
		end
	end
	// enemy9 counter ile yeniden spawnlanma kısmı
	if (anlik_dusman_sayisi < 8 && count_enemy_9 == 150 && enemy9_can == 0) begin
		enemy9_can <= 1;
		enemy9_X <= 345;
		enemy9_Y <= 500;		
		count_enemy_9 <= 0;
		anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
	end
	// enemy9 hareket kısmı
	if ((enemy9_can > 0) && (enemy9_X > 0)) begin
		enemy9_X <= enemy9_X + 1;
		enemy9_Y <= enemy9_Y - 2; // 1 sola 2 aşağı
	end
	
	
	
	
		//enemy10 vurulma kısmı
   if (!shoot && shoot_previous_state && ((shoot_modes==2'b00 && aci == 4'b1010)||(shoot_modes==2'b01 && (aci == 4'b1010 || aci == 4'b1011 || aci == 4'b1001)||(shoot_modes==2'b10 && (aci == 4'b1010 || aci == 4'b1011 || aci == 4'b1001 || aci == 4'b1000 || aci == 4'b1100))||(shoot_modes==2'b11)))) begin
		if (enemy10_can > 0 && enemy10_X > 0) begin								//canı sıfırdan büyükse ve belirli bir mesafedeyse
			enemy10_can <= enemy10_can - 1;							// canı 1 azalt
		end
		
		if (enemy10_can == 1 && enemy10_X > 0) begin			// canı 1 ise ve mesafedeyse
			points = points + 1;
			count_enemy_10 <= 0;
			enemy10_X <= 230;
			enemy10_Y <= 490;
			enemy10_can <= 0;			// YENİ EKLENDİ
			anlik_dusman_sayisi <= anlik_dusman_sayisi -1; 		// YENİ
		end
	end
	// enemy10 counter ile yeniden spawnlanma kısmı
	if (anlik_dusman_sayisi < 8 && count_enemy_10 == 170 && enemy10_can == 0) begin
		enemy10_can <= 1;
		enemy10_X <= 230;
		enemy10_Y <= 490;		
		count_enemy_10 <= 0;
		anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
	end
	// enemy10 hareket kısmı
	if ((enemy10_can > 0) && (enemy10_X > 0)) begin
		enemy10_X <= enemy10_X + 1;
		enemy10_Y <= enemy10_Y - 1; // 2 sola 1 yukarı
	end
	
	
	// yeni kare (enemy11) derece 11 (1 yukarı 2 sağa)
   if (!shoot && shoot_previous_state && ((shoot_modes==2'b00 && aci == 4'b1011)||(shoot_modes==2'b01 && (aci == 4'b1011 || aci == 4'b1100 || aci == 4'b1010)||(shoot_modes==2'b10 && (aci == 4'b1011 || aci == 4'b1100 || aci == 4'b1010 || aci == 4'b1101 || aci == 4'b1001))||(shoot_modes==2'b11)))) begin

      if (enemy11_can > 0 && enemy11_X > 10) begin
          enemy11_can <= enemy11_can - 1;
      end
        
      if (enemy11_can == 1 && enemy11_X > 10) begin
           points = points + 1;
           count_enemy_11 <= 0;
           enemy11_X <= 10;
           enemy11_Y <= 480;
			  anlik_dusman_sayisi <= anlik_dusman_sayisi -1; 		// YENİ	
			  enemy11_can <= 0;											// YENİ EKLENDİ
      end
   end
	 // enemy11 counter ile yeniden spawnlanma kısmı
	if (anlik_dusman_sayisi < 8 && count_enemy_11 == 135 && enemy11_can == 0) begin
		enemy11_can <= 1;
		enemy11_X <= 10;
      enemy11_Y <= 480;
		count_enemy_11 <= 0;
		anlik_dusman_sayisi <= anlik_dusman_sayisi +1; 		// YENİ
	end
    // enemy11 movement
   if ((enemy11_can > 0) && (enemy11_X < 460)) begin
       enemy11_X <= enemy11_X + 2; // move right
       enemy11_Y <= enemy11_Y - 1; // move up
   end
	 
		
	//enemy12 soldaki dikdörtgen
if (!shoot && shoot_previous_state && ((shoot_modes==2'b00 && aci == 4'b1100)||(shoot_modes==2'b01 && (aci == 4'b1100 || aci == 4'b1011 || aci == 4'b1101)||(shoot_modes==2'b10 && (aci == 4'b1100 || aci == 4'b1101 || aci == 4'b1011 || aci == 4'b1110 || aci == 4'b1010))||(shoot_modes==2'b11)))) begin		if (enemy12_can > 0 && enemy12_X_START > 10) begin
			enemy12_can <= enemy12_can - 1;
		end
		
		if (enemy12_can == 1 && enemy12_X_START > 10) begin
			points = points + 1;
			count_enemy_12 <= 0;	
			enemy12_X_START <= 10;
			enemy12_X_END <= 20;
			anlik_dusman_sayisi <= anlik_dusman_sayisi -1; 		// YENİ	
			enemy12_can <= 0;			// YENİ EKLENDİ
		end
	end
	// enemy12 counter ile yeniden spawnlanma kısmı
	if (anlik_dusman_sayisi < 8 && count_enemy_12 == 140 && enemy12_can == 0) begin
		enemy12_can <= 2;
		enemy12_X_START <= 10;
		enemy12_X_END <= 20;
		count_enemy_12 <= 0;
		anlik_dusman_sayisi <= anlik_dusman_sayisi +1; 		// YENİ
	end
	// enemy12 hareket kısmı
	if ((enemy12_can > 0) && (enemy12_X_END < 460)) begin
		enemy12_Y_END <= 282;
		if (points<15) begin 
			enemy12_X_END <= enemy12_X_END +1;                 
			enemy12_X_START <= enemy12_X_START +1;	
		end else begin
			enemy12_X_END <= enemy12_X_END +2;                 
			enemy12_X_START <= enemy12_X_START +2;	
		end
	end
	
	//enemy13 vurulma kısmı
   if (!shoot && shoot_previous_state && ((shoot_modes==2'b00 && aci == 4'b1101)||(shoot_modes==2'b01 && (aci == 4'b1101 || aci == 4'b1100 || aci == 4'b1110)||(shoot_modes==2'b10 && (aci == 4'b1101 || aci == 4'b1110 || aci == 4'b1100 || aci == 4'b1111 || aci == 4'b1011))||(shoot_modes==2'b11)))) begin
		if (enemy13_can > 0 && enemy13_X > 200) begin								//canı sıfırdan büyükse ve belirli bir mesafedeyse
			enemy13_can <= enemy13_can - 1;							// canı 1 azalt
		end
		
		if (enemy13_can == 1 && enemy13_X > 200) begin			// canı 1 ise ve mesafedeyse
			points = points + 1;
			count_enemy_13 <= 0;
			enemy13_X <= 200;
			enemy13_Y <= 120;
			enemy13_can <= 0;			// YENİ EKLENDİ
			anlik_dusman_sayisi <= anlik_dusman_sayisi -1; 		// YENİ
		end
	end
	// enemy13 counter ile yeniden spawnlanma kısmı
	if (anlik_dusman_sayisi < 8 && count_enemy_13 == 110 && enemy13_can == 0) begin
		enemy13_can <= 1;
		enemy13_X <= 200;
		enemy13_Y <= 120;		
		count_enemy_13 <= 0;
		anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
	end
	// enemy13 hareket kısmı
	if ((enemy13_can > 0) && (enemy13_X > 0)) begin
		enemy13_X <= enemy13_X + 2;
		enemy13_Y <= enemy13_Y + 1; // 2 sağa 1 aşağı
	end
		
	
	//enemy14 vurulma kısmı
   if (!shoot && shoot_previous_state && ((shoot_modes==2'b00 && aci == 4'b1110)||(shoot_modes==2'b01 && (aci == 4'b1110 || aci == 4'b1101 || aci == 4'b1111)||(shoot_modes==2'b10 && (aci == 4'b1110 || aci == 4'b1101 || aci == 4'b1111 || aci == 4'b1100 || aci == 4'b0000))||(shoot_modes==2'b11)))) begin
		if (enemy14_can > 0 && enemy14_X > 225) begin								//canı sıfırdan büyükse ve belirli bir mesafedeyse
			enemy14_can <= enemy14_can - 1;							// canı 1 azalt
		end
		
		if (enemy14_can == 1 && enemy14_X > 225) begin			// canı 1 ise ve mesafedeyse
			points = points + 1;
			count_enemy_14 <= 0;
			enemy14_X <= 225;
			enemy14_Y <= 20;
			enemy14_can <= 0;			// YENİ EKLENDİ
			anlik_dusman_sayisi <= anlik_dusman_sayisi -1; 		// YENİ
		end
	end
	// enemy14 counter ile yeniden spawnlanma kısmı
	if (anlik_dusman_sayisi < 8 && count_enemy_14 == 80 && enemy14_can == 0) begin
		enemy14_can <= 1;
		enemy14_X <= 225;
		enemy14_Y <= 20;		
		count_enemy_14 <= 0;
		anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
	end
	// enemy14 hareket kısmı
	if ((enemy14_can > 0) && (enemy14_X > 0)) begin
		enemy14_X <= enemy14_X + 1;
		enemy14_Y <= enemy14_Y + 1; // 1 sağa 1 aşağı
	end
	
	
	//enemy15 vurulma kısmı
   if (!shoot && shoot_previous_state && ((shoot_modes==2'b00 && aci == 4'b1111)||(shoot_modes==2'b01 && (aci == 4'b1111 || aci == 4'b1110 || aci == 4'b0000)||(shoot_modes==2'b10 && (aci == 4'b1111 || aci == 4'b1110 || aci == 4'b0000 || aci == 4'b1101 || aci == 4'b0001))||(shoot_modes==2'b11)))) begin
		if (enemy15_can > 0 && enemy15_X > 345) begin								//canı sıfırdan büyükse ve belirli bir mesafedeyse
			enemy15_can <= enemy15_can - 1;							// canı 1 azalt
		end
		
		if (enemy15_can == 1 && enemy15_X > 345) begin			// canı 1 ise ve mesafedeyse
			points = points + 1;
			count_enemy_15 <= 0;
			enemy15_X <= 345;
			enemy15_Y <= 10;
			enemy15_can <= 0;			// YENİ EKLENDİ
			anlik_dusman_sayisi <= anlik_dusman_sayisi -1; 		// YENİ
		end
	end
	// enemy15 counter ile yeniden spawnlanma kısmı
	if (anlik_dusman_sayisi < 8 && count_enemy_15 == 160 && enemy15_can == 0) begin
		enemy15_can <= 1;
		enemy15_X <= 345;
		enemy15_Y <= 20;		
		count_enemy_15 <= 0;
		anlik_dusman_sayisi <= anlik_dusman_sayisi + 1;			// YENİ
	end
	// enemy15 hareket kısmı
	if ((enemy15_can > 0) && (enemy15_X > 0)) begin
		enemy15_X <= enemy15_X + 1;
		enemy15_Y <= enemy15_Y + 2; // 1 sağa 2 aşağı
	end
	
	
	// oyunun bitmesinin kontrolü, içerdeki sayılar boundary konumlardan 1 eksiği
	if (enemy9_X == 460 || enemy10_X == 460 || enemy13_X == 460 || enemy14_X == 460 || enemy15_X == 460 || enemy4_X <= 460 || enemy0_Y >= 260 || enemy12_X_END >= 459 || enemy8_Y <= 262 || enemy11_X == 460 || enemy1_X == 461 || enemy2_X == 461 || enemy3_X == 460 || enemy5_X == 460 || enemy6_X == 460 || enemy7_X == 460) begin
      game_over <= 1;
   end
end

always @(posedge clk_25MHz) begin
	
	// for small circle, that is namlu
	case (aci)
        4'b0000: begin TARRET_X <= 460;
							  TARRET_Y <= 240;
					  end
		  4'b0001: begin TARRET_X <= 467;
							  TARRET_Y <= 242;
					  end
		  4'b0010: begin TARRET_X <= 474;
							  TARRET_Y <= 246;
					  end
		  4'b0011: begin TARRET_X <= 478;
							  TARRET_Y <= 253;
					  end
		  4'b0100: begin TARRET_X <= 480;
							  TARRET_Y <= 260;
					  end
		  4'b0101: begin TARRET_X <= 480;
							  TARRET_Y <= 268;
					  end
		  4'b0110: begin TARRET_X <= 476;
							  TARRET_Y <= 276;
					  end
		  4'b0111: begin TARRET_X <= 467;
							  TARRET_Y <= 282;
					  end
		  4'b1000: begin TARRET_X <= 460;
							  TARRET_Y <= 284;
					  end
		  4'b1001: begin TARRET_X <= 453;
							  TARRET_Y <= 282;
					  end
		  4'b1010: begin TARRET_X <= 446;
							  TARRET_Y <= 276;
					  end
		  4'b1011: begin TARRET_X <= 442;
							  TARRET_Y <= 268;
					  end
		  4'b1100: begin TARRET_X <= 440;
							  TARRET_Y <= 260;
					  end
		  4'b1101: begin TARRET_X <= 442;
							  TARRET_Y <= 253;
					  end
		  4'b1110: begin TARRET_X <= 446;
							  TARRET_Y <= 246;
					  end
		  4'b1111: begin TARRET_X <= 453;
							  TARRET_Y <= 242;
					  end
    endcase
 
	if (!game_over) begin
     if (h_count >= H_SYNC_CYC + H_BACK_PORCH && v_count >= V_SYNC_CYC + V_BACK_PORCH) begin
        if ((h_count - CIRCLE_CENTER_X)**2 + (v_count - CIRCLE_CENTER_Y)**2 <= CIRCLE_RADIUS**2) begin
            red <= 8'hFF;
            green <= 8'hFF;
            blue <= 8'hFF;
        end else begin
            if ((h_count - TARRET_X)**2 + (v_count - TARRET_Y)**2 <= TARRET_RADIUS**2) begin
                red <= 8'hFF;
                green <= 8'hFF;
                blue <= 8'hFF;
            end else begin    
                if ((enemy4_can > 0) && ((h_count - enemy4_X)**2 + (v_count - enemy4_Y)**2 <= TARRET_RADIUS**2)) begin
                    if (enemy4_can == 3) begin
                        red <= 8'h00;
                        green <= 8'hFF;
                        blue <= 8'h00;
                    end else if (enemy4_can == 2) begin
                        red <= 8'hFF;
                        green <= 8'hFF;
                        blue <= 8'h00;
                    end else if (enemy4_can == 1) begin
                        red <= 8'hFF;
                        green <= 8'h00;
                        blue <= 8'h00;
                    end
                end else if ((enemy8_can > 0) && ((h_count - enemy8_X)**2 + (v_count - enemy8_Y)**2 <= TARRET_RADIUS**2)) begin
                    if (enemy8_can == 3) begin
                        red <= 8'h00;
                        green <= 8'hFF;
                        blue <= 8'h00;
                    end else if (enemy8_can == 2) begin
                        red <= 8'hFF;
                        green <= 8'hFF;
                        blue <= 8'h00;
                    end else if (enemy8_can == 1) begin
                        red <= 8'hFF;
                        green <= 8'h00;
                        blue <= 8'h00;
                    end
						  
                end else if ((enemy0_can > 0) && (h_count >= enemy0_X && h_count < enemy0_X + enemy0_SIZE && v_count >= enemy0_Y && v_count < enemy0_Y + enemy0_SIZE)) begin            
                    red <= 8'hFF;
                    green <= 8'h00;
                    blue <= 8'h00;
					 end else if ((enemy1_can > 0) && (h_count >= enemy1_X && h_count < enemy1_X + enemy0_SIZE && v_count >= enemy1_Y && v_count < enemy1_Y + enemy0_SIZE)) begin            
                    red <= 8'hFF;
                    green <= 8'h00;
                    blue <= 8'h00;
					end else if ((enemy2_can > 0) && (h_count >= enemy2_X && h_count < enemy2_X + enemy0_SIZE && v_count >= enemy2_Y && v_count < enemy2_Y + enemy0_SIZE)) begin            
                    red <= 8'hFF;
                    green <= 8'h00;
                    blue <= 8'h00;
					end else if ((enemy3_can > 0) && (h_count >= enemy3_X && h_count < enemy3_X + enemy0_SIZE && v_count >= enemy3_Y && v_count < enemy3_Y + enemy0_SIZE)) begin            
                    red <= 8'hFF;
                    green <= 8'h00;
                    blue <= 8'h00;
					end else if ((enemy5_can > 0) && (h_count >= enemy5_X && h_count < enemy5_X + enemy0_SIZE && v_count >= enemy5_Y && v_count < enemy5_Y + enemy0_SIZE)) begin            
                    red <= 8'hFF;
                    green <= 8'h00;
                    blue <= 8'h00;
					end else if ((enemy6_can > 0) && ((h_count - enemy6_X)**2 + (v_count - enemy6_Y)**2 <= TARRET_RADIUS**2)) begin
                    red <= 8'hFF;
                    green <= 8'h00;
                    blue <= 8'h00;
					end else if ((enemy7_can > 0) && (h_count >= enemy7_X && h_count < enemy7_X + enemy0_SIZE && v_count >= enemy7_Y && v_count < enemy7_Y + enemy0_SIZE)) begin            
                    red <= 8'hFF;
                    green <= 8'h00;
                    blue <= 8'h00;
					end else if ((enemy9_can > 0) && (h_count >= enemy9_X && h_count < enemy9_X + enemy0_SIZE && v_count >= enemy9_Y && v_count < enemy9_Y + enemy0_SIZE)) begin            
                    red <= 8'hFF;
                    green <= 8'h00;
                    blue <= 8'h00;
					end else if ((enemy10_can > 0) && ((h_count - enemy10_X)**2 + (v_count - enemy10_Y)**2 <= TARRET_RADIUS**2)) begin
						  red <= 8'hFF;
                    green <= 8'h00;
                    blue <= 8'h00;  
                end else if ((enemy11_can > 0) && (h_count >= enemy11_X && h_count < enemy11_X + enemy0_SIZE && v_count >= enemy11_Y && v_count < enemy11_Y + enemy0_SIZE)) begin
                    red <= 8'hFF;
                    green <= 8'h00;
                    blue <= 8'h00;
					end else if ((enemy13_can > 0) && (h_count >= enemy13_X && h_count < enemy13_X + enemy0_SIZE && v_count >= enemy13_Y && v_count < enemy13_Y + enemy0_SIZE)) begin
                    red <= 8'hFF;
                    green <= 8'h00;
                    blue <= 8'h00;
					end else if ((enemy14_can > 0) && (h_count >= enemy14_X && h_count < enemy14_X + enemy0_SIZE && v_count >= enemy14_Y && v_count < enemy14_Y + enemy0_SIZE)) begin
                    red <= 8'hFF;
                    green <= 8'h00;
                    blue <= 8'h00;
					end else if ((enemy15_can > 0) && (h_count >= enemy15_X && h_count < enemy15_X + enemy0_SIZE && v_count >= enemy15_Y && v_count < enemy15_Y + enemy0_SIZE)) begin
                    red <= 8'hFF;
                    green <= 8'h00;
                    blue <= 8'h00;
                end else if ((enemy12_can > 0) && ((h_count >= enemy12_X_START && h_count < enemy12_X_END) && (v_count >= enemy12_Y_START && v_count < enemy12_Y_END))) begin
                    if (enemy12_can == 2) begin
                        red <= 8'hFF;
                        green <= 8'hFF;
                        blue <= 8'h00;
                    end else if (enemy12_can == 1) begin
                        red <= 8'hFF;
                        green <= 8'h00;
                        blue <= 8'h00;
                    end                
                end else begin
                    red <= 8'h00;
                    green <= 8'h00;
                    blue <= 8'h00;
                end
            end    
        end
    end
end
end
endmodule