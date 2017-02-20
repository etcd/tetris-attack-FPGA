module  tetris_attack  ( input         CLOCK_50,
                       input[3:0]    KEY, //bit 0 is set up as Reset
							  output [6:0]  HEX0, HEX1, HEX2, HEX3, //HEX4, HEX5, HEX6, HEX7,
							  // VGA Interface 
                       output [7:0]  VGA_R,					//VGA Red
							                VGA_G,					//VGA Green
												 VGA_B,					//VGA Blue
							  output        VGA_CLK,				//VGA Clock
							                VGA_SYNC_N,			//VGA Sync signal
												 VGA_BLANK_N,			//VGA Blank signal
												 VGA_VS,					//VGA virtical sync signal	
												 VGA_HS,					//VGA horizontal sync signal
							  // CY7C67200 Interface
							  inout [15:0]  OTG_DATA,						//	CY7C67200 Data bus 16 Bits
							  output [1:0]  OTG_ADDR,						//	CY7C67200 Address 2 Bits
							  output        OTG_CS_N,						//	CY7C67200 Chip Select
												 OTG_RD_N,						//	CY7C67200 Write
												 OTG_WR_N,						//	CY7C67200 Read
												 OTG_RST_N,						//	CY7C67200 Reset
							  input			 OTG_INT,						//	CY7C67200 Interrupt
							  // SDRAM Interface for Nios II Software
							  output [12:0] DRAM_ADDR,				// SDRAM Address 13 Bits
							  inout [31:0]  DRAM_DQ,				// SDRAM Data 32 Bits
							  output [1:0]  DRAM_BA,				// SDRAM Bank Address 2 Bits
							  output [3:0]  DRAM_DQM,				// SDRAM Data Mast 4 Bits
							  output			 DRAM_RAS_N,			// SDRAM Row Address Strobe
							  output			 DRAM_CAS_N,			// SDRAM Column Address Strobe
							  output			 DRAM_CKE,				// SDRAM Clock Enable
							  output			 DRAM_WE_N,				// SDRAM Write Enable
							  output			 DRAM_CS_N,				// SDRAM Chip Select
							  output			 DRAM_CLK,				// SDRAM Clock
							  output [15:0] LEDR
											);
    
    logic Reset_h, Reset_game, vssig, Clk;
    logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig;
	 logic [15:0] keycode;
    
	 assign Clk = CLOCK_50;
    assign {Reset_h}=~ (KEY[0]);  // The push buttons are active low
    assign {Reset_game}=~ (KEY[1]);  // The push buttons are active low
	
	 
	 wire [1:0] hpi_addr;
	 wire [15:0] hpi_data_in, hpi_data_out;
	 wire hpi_r, hpi_w,hpi_cs;
	 
	 hpi_io_intf hpi_io_inst(   .from_sw_address(hpi_addr),
										 .from_sw_data_in(hpi_data_in),
										 .from_sw_data_out(hpi_data_out),
										 .from_sw_r(hpi_r),
										 .from_sw_w(hpi_w),
										 .from_sw_cs(hpi_cs),
		 								 .OTG_DATA(OTG_DATA),    
										 .OTG_ADDR(OTG_ADDR),    
										 .OTG_RD_N(OTG_RD_N),    
										 .OTG_WR_N(OTG_WR_N),    
										 .OTG_CS_N(OTG_CS_N),    
										 .OTG_RST_N(OTG_RST_N),   
										 .OTG_INT(OTG_INT),
										 .Clk(Clk),
										 .Reset(Reset_h)
	 );
	 
	 //The connections for nios_system might be named different depending on how you set up Qsys
	 nios_system nios_system(
										 .clk_clk(Clk),         
										 .reset_reset_n(KEY[0]),   
										 .sdram_wire_addr(DRAM_ADDR), 
										 .sdram_wire_ba(DRAM_BA),   
										 .sdram_wire_cas_n(DRAM_CAS_N),
										 .sdram_wire_cke(DRAM_CKE),  
										 .sdram_wire_cs_n(DRAM_CS_N), 
										 .sdram_wire_dq(DRAM_DQ),   
										 .sdram_wire_dqm(DRAM_DQM),  
										 .sdram_wire_ras_n(DRAM_RAS_N),
										 .sdram_wire_we_n(DRAM_WE_N), 
										 .sdram_out_clk(DRAM_CLK),
										 .keycode_export(keycode),  
										 .otg_hpi_address_export(hpi_addr),
										 .otg_hpi_data_in_port(hpi_data_in),
										 .otg_hpi_data_out_port(hpi_data_out),
										 .otg_hpi_cs_export(hpi_cs),
										 .otg_hpi_r_export(hpi_r),
										 .otg_hpi_w_export(hpi_w));

    vga_controller vgasync_instance(.Clk /*50 MHz clock*/, .Reset(Reset_h), .hs(VGA_HS) /*horizontal sync; active low*/, .vs(VGA_VS) /*vertical sync; active low*/,
												.pixel_clk(VGA_CLK) /*25 MHz pixel clock*/,
												.blank(VGA_BLANK_N) /*Blanking interval indicator; active low*/,
												.sync(VGA_SYNC_N) /*Composite sync signal; active low; not used in this lab, but video DAC on DE2 board requires it*/,
												.DrawX(drawxsig) /*horizontal coordinate*/, .DrawY(drawysig) /*vertical coordinate*/);

	logic [2:0]  	cursorX, queryX1, queryX2, queryX3, queryX4, queryX5, queryX6, queryX7, queryX8, queryX9, queryX10, removeX, removeNum;
	logic [3:0] 	cursorY, queryY1, queryY2, queryY3, queryY4, queryY5, queryY6, queryY7, queryY8, queryY9, queryY10, removeY;
	logic 			just_swapped, just_shifted, just_grav, removeDir;
	logic [5:0]    queryOut1, queryOut2, queryOut3, queryOut4, queryOut5, queryOut6, queryOut7, queryOut8, queryOut9, queryOut10;
	logic 			sig_removing_blocks;
	logic [5:0] 	next_row [5:0];
	logic [11:0]   sprite_score_read_address;
	logic [12:0]   sprite_block_read_address, sprite_block_read_address2, sprite_numbers_read_address1, sprite_numbers_read_address2, sprite_numbers_read_address3, sprite_numbers_read_address4, sprite_numbers_read_address5;
	logic [23:0]	sprite_block_data_out, sprite_block_data_out2, sprite_score_data_out, sprite_numbers_data_out1, sprite_numbers_data_out2, sprite_numbers_data_out3, sprite_numbers_data_out4, sprite_numbers_data_out5;
	logic [15:0] 	score;
	assign LEDR = score;
	
	gamestate gamestate_instance(.Clk, .frame_clk(VGA_VS), .Reset(Reset_game), .keycode, .rand_num, .queryX1, .queryY1, .queryX2, .queryY2, .queryY3, .queryY4, .queryY5, .queryY6, .queryY7, .queryY8, .queryY9, 
											.queryY10, .queryX3, .queryX4, .queryX5, .queryX6, .queryX7, .queryX8, .queryX9, .queryX10, .queryOut1, .queryOut2, .queryOut3, .queryOut4, .queryOut5, .queryOut6, .queryOut7, 
											.queryOut8, .queryOut9, .queryOut10, .score, .cursorX, .cursorY, .removeX, .removeY, .removeNum, .removeDir, .just_grav,.just_swapped, .just_shifted, .next_row);
	
	color_mapper color_instance( .DrawX(drawxsig), .DrawY(drawysig), .sprite_numbers_data_out1, .sprite_numbers_read_address1,.sprite_numbers_data_out2, 
										.sprite_numbers_read_address2,.sprite_numbers_data_out3, .sprite_numbers_read_address3,.sprite_numbers_data_out4, 
										.sprite_numbers_read_address4,.sprite_numbers_data_out5, .sprite_numbers_read_address5, .score,
										.cursorX, .cursorY, .just_swapped, .just_shifted, .just_grav,.sprite_score_data_out, .sprite_score_read_address,
										.queryOut1, .queryX1, .queryY1, .sprite_block_read_address, .sprite_block_read_address2, .sprite_block_data_out, .sprite_block_data_out2,
										.Red(VGA_R), .Green(VGA_G), .Blue(VGA_B),.next_row);
				
	logic [31:0] rand_num;
	PRNG prng0(.Clk(Clk), .Reset(Reset_game), .load(50'h66), .seed(rand_num));
	
	sprite_block sprite_block0(.Clk, .read_address(sprite_block_read_address), .read_address2(sprite_block_read_address2), .data_Out(sprite_block_data_out), .data_Out2(sprite_block_data_out2));

	sprite_score sprite_score0(.Clk, .read_address(sprite_score_read_address), .data_Out(sprite_score_data_out));
	
	sprite_numbers sprite_numbers0(.Clk, .read_address1(sprite_numbers_read_address1), .data_Out1(sprite_numbers_data_out1), .read_address2(sprite_numbers_read_address2), 
										.data_Out2(sprite_numbers_data_out2), .read_address3(sprite_numbers_read_address3), .data_Out3(sprite_numbers_data_out3), 
										.read_address4(sprite_numbers_read_address4), .data_Out4(sprite_numbers_data_out4), .read_address5(sprite_numbers_read_address5), 
										.data_Out5(sprite_numbers_data_out5));



	HexDriver hex_inst_0 (keycode[3:0], HEX0);
	HexDriver hex_inst_1 (keycode[7:4], HEX1);
	HexDriver hex_inst_2 (keycode[11:8], HEX2);
	HexDriver hex_inst_3 (keycode[15:12], HEX3);

endmodule
