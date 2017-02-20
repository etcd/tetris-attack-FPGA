module  color_mapper ( input        [9:0] DrawX, DrawY,
							  input  logic [2:0] cursorX,
							  input  logic [3:0] cursorY,
							  input  logic 		just_swapped, just_shifted, just_grav,
							  input  logic [5:0] queryOut1,
							  input  logic [5:0] next_row [5:0],
							  input  logic [23:0] 	sprite_block_data_out, sprite_block_data_out2,
							  	sprite_score_data_out,sprite_numbers_data_out1,
							  	sprite_numbers_data_out2,sprite_numbers_data_out3,
							  	sprite_numbers_data_out4,sprite_numbers_data_out5,
							  input  logic [15:0]	score,
							  output logic [12:0]   sprite_block_read_address, sprite_block_read_address2,
							  	sprite_numbers_read_address1, sprite_numbers_read_address2,
							  	sprite_numbers_read_address3, sprite_numbers_read_address4,
							  	sprite_numbers_read_address5,
							  output logic [11:0] 	sprite_score_read_address,
							  output logic [2:0] queryX1,
							  output logic [3:0] queryY1,
                       output logic [7:0] Red, Green, Blue );

	logic [9:0] size 			= 10'd25;	// side length of a block
	logic [2:0] block_margin 	= 3'd5; 	// Margin per block
	logic [7:0] grid_offset_X	= 8'd232; 	// X offset of grid from top of screen
	logic [6:0] grid_offset_Y	= 7'd45; 	// Y offset of grid from top of screen
	logic [2:0] cursor_width = 3'd5;
	logic [3:0] cursor_length = 4'd10;
	 
	logic [2:0] grid_X;
	logic [3:0] grid_Y;
	logic [4:0] block_pixel_X;
	logic [4:0] block_pixel_Y;
	logic [6:0] scoreX;
	logic [5:0] scoreY;
	logic [2:0] numberIndex;
	logic [4:0] numberX,numberY;
	logic [3:0] scoreDigit1,scoreDigit2,scoreDigit3,scoreDigit4,scoreDigit5;//5 is farthest left

	
	always_comb
	begin
			grid_X = (DrawX-grid_offset_X)/(size+block_margin);
			grid_Y = (DrawY-grid_offset_Y)/(size+block_margin);
			queryX1 = grid_X;
			queryY1 = grid_Y % 4'd12;
			// Draw grid
			block_pixel_X = (DrawX-grid_offset_X)%(size+block_margin);
			block_pixel_Y = (DrawY-grid_offset_Y)%(size+block_margin);
			sprite_block_read_address = ((block_pixel_X) + block_pixel_Y * 5'd25 + 10'd625 * (queryOut1 - 1'b1)) % 12'd3750;
			sprite_block_read_address2 = ((block_pixel_X) + block_pixel_Y * 5'd25 + 10'd625 * (next_row[grid_X] - 1'b1)) % 12'd3750;
			scoreX = (DrawX - 9'd456) % 7'd99;
			scoreY = (DrawY - 6'd51) % 6'd24;
			sprite_score_read_address = (scoreX + scoreY *7'd99) % 12'd2376;
			numberX = (DrawX - 9'd456) % 5'd25;
			numberY = (DrawY - 9'd76) % 5'd25;
			numberIndex = ((DrawX - 9'd456) / 5'd25) % 3'd5;
			scoreDigit5 = score % 4'd10;
			scoreDigit4 = (score/4'd10) % 4'd10;
			scoreDigit3 = (score/7'd100) % 4'd10;
			scoreDigit2 = (score/10'd1000) % 4'd10;
			scoreDigit1 = (score/14'd10000) % 4'd10;
			sprite_numbers_read_address5 = (numberX + numberY * 5'd25 + 10'd625 * scoreDigit5) % 13'd6250;
			sprite_numbers_read_address4 = (numberX + numberY * 5'd25 + 10'd625 * scoreDigit4) % 13'd6250;
			sprite_numbers_read_address3 = (numberX + numberY * 5'd25 + 10'd625 * scoreDigit3) % 13'd6250;
			sprite_numbers_read_address2 = (numberX + numberY * 5'd25 + 10'd625 * scoreDigit2) % 13'd6250;
			sprite_numbers_read_address1 = (numberX + numberY * 5'd25 + 10'd625 * scoreDigit1) % 13'd6250;
			
			
			if ( 	(DrawY > grid_offset_Y) && ((DrawY-grid_offset_Y)%(size+block_margin)<size) && ( DrawY < (grid_offset_Y + (size*13+block_margin*12)) )
			&& 	(DrawX > grid_offset_X) && ((DrawX-grid_offset_X)%(size+block_margin)<size) && ( DrawX < (grid_offset_X + (size*6+block_margin*5)) )
			) begin
				// Given the DrawX and DrawY coords, obtain grid coords
				
				// Draw cursor
				if ( 	(cursorX == grid_X || cursorX + 1 == grid_X) && cursorY == grid_Y
				&& 	(		((block_pixel_X < cursor_width) && (block_pixel_Y < cursor_length)) // UL |
							|| ((block_pixel_X < cursor_length) && (block_pixel_Y < cursor_width)) // UL -
							
							|| ((block_pixel_X > size - cursor_width) && (block_pixel_Y < cursor_length)) // UR |
							|| ((block_pixel_X > size - cursor_length) && (block_pixel_Y < cursor_width)) // UR -
							
							|| ((block_pixel_X < cursor_width) && (block_pixel_Y > size - cursor_length)) // BL |
							|| ((block_pixel_X < cursor_length) && (block_pixel_Y > size - cursor_width)) // BL -
							
							|| ((block_pixel_X > size - cursor_width) && (block_pixel_Y > size - cursor_length)) // BR |
							|| ((block_pixel_X > size - cursor_length) && (block_pixel_Y > size - cursor_width)) // BR -
						)
				) begin
					Red = 8'hff; Green = 8'hff; Blue = 8'hff;
				end
				else begin // Draw block
					if(grid_Y != 4'd12)begin
						case (queryOut1)
							6'd0:	begin Red = 8'h00; Green = 8'h00; Blue = 8'h00; end // blank
							6'd1:	begin Red = sprite_block_data_out[23:16]; Green = sprite_block_data_out[15:8]; Blue = sprite_block_data_out[7:0]; end // red
							6'd2:	begin Red = sprite_block_data_out[23:16]; Green = sprite_block_data_out[15:8]; Blue = sprite_block_data_out[7:0]; end // red
							6'd3:	begin Red = sprite_block_data_out[23:16]; Green = sprite_block_data_out[15:8]; Blue = sprite_block_data_out[7:0]; end // red
							6'd4:	begin Red = sprite_block_data_out[23:16]; Green = sprite_block_data_out[15:8]; Blue = sprite_block_data_out[7:0]; end // red
							6'd5:	begin Red = sprite_block_data_out[23:16]; Green = sprite_block_data_out[15:8]; Blue = sprite_block_data_out[7:0]; end // red
							6'd6:	begin Red = sprite_block_data_out[23:16]; Green = sprite_block_data_out[15:8]; Blue = sprite_block_data_out[7:0]; end // red
							default: begin Red = 8'hff; Green = 8'hff; Blue = 8'hff; end
						endcase
					end
					else begin
						case (next_row[grid_X])
							6'd0:	begin Red = 8'h80; Green = 8'h80; Blue = 8'h80; end // blank
							6'd1:	begin Red = sprite_block_data_out2[23:16]/2'd2; Green = sprite_block_data_out2[15:8]/2'd2; Blue = sprite_block_data_out2[7:0]/2'd2; end // red
							6'd2:	begin Red = sprite_block_data_out2[23:16]/2'd2; Green = sprite_block_data_out2[15:8]/2'd2; Blue = sprite_block_data_out2[7:0]/2'd2; end // red
							6'd3:	begin Red = sprite_block_data_out2[23:16]/2'd2; Green = sprite_block_data_out2[15:8]/2'd2; Blue = sprite_block_data_out2[7:0]/2'd2; end // red
							6'd4:	begin Red = sprite_block_data_out2[23:16]/2'd2; Green = sprite_block_data_out2[15:8]/2'd2; Blue = sprite_block_data_out2[7:0]/2'd2; end // red
							6'd5:	begin Red = sprite_block_data_out2[23:16]/2'd2; Green = sprite_block_data_out2[15:8]/2'd2; Blue = sprite_block_data_out2[7:0]/2'd2; end // red
							6'd6:	begin Red = sprite_block_data_out2[23:16]/2'd2; Green = sprite_block_data_out2[15:8]/2'd2; Blue = sprite_block_data_out2[7:0]/2'd2; end // red
							default: begin Red = 8'hff; Green = 8'hff; Blue = 8'hff; end
						endcase
					end
				end
			end
			else if(DrawX >9'd455 && DrawX <10'd556 && DrawY > 6'd50 && DrawY < 7'd76)begin
				Red = sprite_score_data_out[23:16]; Green = sprite_score_data_out[15:8]; Blue = sprite_score_data_out[7:0];
			end
			else if(DrawX > 9'd455 && DrawX < 10'd582 && DrawY > 7'd75 && DrawY < 7'd102) begin
				case(numberIndex)
					3'd0: begin Red = sprite_numbers_data_out1[23:16]; Green = sprite_numbers_data_out1[15:8]; Blue = sprite_numbers_data_out1[7:0]; end
					3'd1: begin Red = sprite_numbers_data_out2[23:16]; Green = sprite_numbers_data_out2[15:8]; Blue = sprite_numbers_data_out2[7:0]; end
					3'd2: begin Red = sprite_numbers_data_out3[23:16]; Green = sprite_numbers_data_out3[15:8]; Blue = sprite_numbers_data_out3[7:0]; end
					3'd3: begin Red = sprite_numbers_data_out4[23:16]; Green = sprite_numbers_data_out4[15:8]; Blue = sprite_numbers_data_out4[7:0]; end
					3'd4: begin Red = sprite_numbers_data_out5[23:16]; Green = sprite_numbers_data_out5[15:8]; Blue = sprite_numbers_data_out5[7:0]; end
					default: begin Red = 8'hff; Green = 8'hff; Blue = 8'hff; end
				endcase
			end
			
			// Default condition
			// if not over a block display background
			else begin		
				grid_X = 4'b0;
				grid_Y = 3'b0;

				Red = 8'h30; 
				Green = 8'h17;
				Blue = 8'h30;
			end
     end
    
endmodule











