module  gamestate (	input  logic 			Clk,
							input  logic 			frame_clk,
							input  logic 			Reset,
							input  logic [15:0] 	keycode,
							input  logic [31:0]  rand_num,
							input  logic [2:0]   queryX1,
							input  logic [3:0]   queryY1,
							input  logic [2:0]   queryX2,
							input  logic [3:0]   queryY2,
							input  logic [2:0]   queryX3,
							input  logic [3:0]   queryY3,
							input  logic [2:0]   queryX4,
							input  logic [3:0]   queryY4,
							input  logic [2:0]   queryX5,
							input  logic [3:0]   queryY5,
							input  logic [2:0]   queryX6,
							input  logic [3:0]   queryY6,
							input  logic [2:0]   queryX7,
							input  logic [3:0]   queryY7,
							input  logic [2:0]   queryX8,
							input  logic [3:0]   queryY8,
							input  logic [2:0]   queryX9,
							input  logic [3:0]   queryY9,
							input  logic [2:0]   queryX10,
							input  logic [3:0]   queryY10,
							input  logic [2:0]   removeX,
							input  logic [3:0]   removeY,
							input  logic [2:0]	removeNum,
							input  logic 			removeDir,
							output logic [5:0]   queryOut1,
							output logic [5:0]   queryOut2,
							output logic [5:0]   queryOut3,
							output logic [5:0]   queryOut4,
							output logic [5:0]   queryOut5,
							output logic [5:0]   queryOut6,
							output logic [5:0]   queryOut7,
							output logic [5:0]   queryOut8,
							output logic [5:0]   queryOut9,
							output logic [5:0]   queryOut10,
//							output logic [5:0] 	grid [11:0][5:0],
							output logic [2:0]  	cursorX,
							output logic [3:0] 	cursorY,
							output logic  			just_swapped,
							output logic 			just_shifted,
							output logic			just_grav,
							output logic [5:0] 	next_row [5:0],
							output logic [15:0]	score
						 );

	logic [5:0] grid [11:0][5:0];
	logic [8:0] counter;
	logic pressed, pos;
	logic [5:0] temp; // for swapping
	logic space_hit; // one cycle before just_swapped
	logic [2:0] x_counter;
	logic [3:0] y_counter;
	enum logic [1:0]{lost, reseting, running} game_state;
	
	always_comb begin
		queryOut1 = grid[queryY1][queryX1];
		
		if(queryY2 < 4'd12 && queryX2 < 3'd6)begin
			queryOut2 = grid[queryY2][queryX2];
		end
		else queryOut2 = 6'd0;
		
		if(queryY3 < 4'd12 && queryX3 < 3'd6)begin
			queryOut3 = grid[queryY3][queryX3];
		end
		else queryOut3 = 6'd0;
		
		if(queryY4 < 4'd12 && queryX4 < 3'd6)begin
			queryOut4 = grid[queryY4][queryX4];
		end
		else queryOut4 = 6'd0;
		
		if(queryY5 < 4'd12 && queryX5 < 3'd6)begin
			queryOut5 = grid[queryY5][queryX5];
		end
		else queryOut5 = 6'd0;
		
		if(queryY6 < 4'd12 && queryX6 < 3'd6)begin
			queryOut6 = grid[queryY6][queryX6];
		end
		else queryOut6 = 6'd0;
		
		if(queryY7 < 4'd12 && queryX7 < 3'd6)begin
			queryOut7 = grid[queryY7][queryX7];
		end
		else queryOut7 = 6'd0;
		
		if(queryY8 < 4'd12 && queryX8 < 3'd6)begin
			queryOut8 = grid[queryY8][queryX8];
		end
		else queryOut8 = 6'd0;
		
		if(queryY9 < 4'd12 && queryX9 < 3'd6)begin
			queryOut9 = grid[queryY9][queryX9];
		end
		else queryOut9 = 6'd0;
		
		if(queryY10 < 4'd12 && queryX10 < 3'd6)begin
			queryOut10 = grid[queryY10][queryX10];
		end
		else queryOut10 = 6'd0;
	end
	
	
	always_ff @ (posedge Reset or posedge Clk ) begin
		
		if (Reset) begin
			pos = 1'b0;
			space_hit <= 1'b0;
			game_state <= running;
			score <= 16'd0;
		
			cursorX <= 3'd2;
			cursorY <= 4'd11;
			
			next_row[0][5:0] <= 6'd1;
			next_row[1][5:0] <= 6'd2;
			next_row[2][5:0] <= 6'd3;
			next_row[3][5:0] <= 6'd4;
			next_row[4][5:0] <= 6'd5;
			next_row[5][5:0] <= 6'd6;
			counter <= 9'd0;
		
////		Python:
//		for i in range(11,-1,-1):
//			for j in range(5,-1,-1):
//				print ("grid[" + str(i) + "][" + str(j) + "]\t= 6'b0;")

			grid[11][5] <= 6'b0;
			grid[11][4] <= 6'b0;
			grid[11][3] <= 6'b0;
			grid[11][2] <= 6'b0;
			grid[11][1] <= 6'b0;
			grid[11][0] <= 6'b0;
			grid[10][5] <= 6'b0;
			grid[10][4] <= 6'b0;
			grid[10][3] <= 6'b0;
			grid[10][2] <= 6'b0;
			grid[10][1] <= 6'b0;
			grid[10][0] <= 6'b0;
			grid[9][5] <= 6'b0;
			grid[9][4] <= 6'b0;
			grid[9][3] <= 6'b0;
			grid[9][2] <= 6'b0;
			grid[9][1] <= 6'b0;
			grid[9][0] <= 6'b0;
			grid[8][5] <= 6'b0;
			grid[8][4] <= 6'b0;
			grid[8][3] <= 6'b0;
			grid[8][2] <= 6'b0;
			grid[8][1] <= 6'b0;
			grid[8][0] <= 6'b0;
			grid[7][5] <= 6'b0;
			grid[7][4] <= 6'b0;
			grid[7][3] <= 6'b0;
			grid[7][2] <= 6'b0;
			grid[7][1] <= 6'b0;
			grid[7][0] <= 6'b0;
			grid[6][5] <= 6'b0;
			grid[6][4] <= 6'b0;
			grid[6][3] <= 6'b0;
			grid[6][2] <= 6'b0;
			grid[6][1] <= 6'b0;
			grid[6][0] <= 6'b0;
			grid[5][5] <= 6'b0;
			grid[5][4] <= 6'b0;
			grid[5][3] <= 6'b0;
			grid[5][2] <= 6'b0;
			grid[5][1] <= 6'b0;
			grid[5][0] <= 6'b0;
			grid[4][5] <= 6'b0;
			grid[4][4] <= 6'b0;
			grid[4][3] <= 6'b0;
			grid[4][2] <= 6'b0;
			grid[4][1] <= 6'b0;
			grid[4][0] <= 6'b0;
			grid[3][5] <= 6'b0;
			grid[3][4] <= 6'b0;
			grid[3][3] <= 6'b0;
			grid[3][2] <= 6'b0;
			grid[3][1] <= 6'b0;
			grid[3][0] <= 6'b0;
			grid[2][5] <= 6'b0;
			grid[2][4] <= 6'b0;
			grid[2][3] <= 6'b0;
			grid[2][2] <= 6'b0;
			grid[2][1] <= 6'b0;
			grid[2][0] <= 6'b0;
			grid[1][5] <= 6'b0;
			grid[1][4] <= 6'b0;
			grid[1][3] <= 6'b0;
			grid[1][2] <= 6'b0;
			grid[1][1] <= 6'b0;
			grid[1][0] <= 6'b0;
			grid[0][5] <= 6'b0;
			grid[0][4] <= 6'b0;
			grid[0][3] <= 6'b0;
			grid[0][2] <= 6'b0;
			grid[0][1] <= 6'b0;
			grid[0][0] <= 6'b0;

			grid[0][0][5:0] <= 6'd0;
			grid[0][1][5:0] <= 6'd1;
			grid[0][2][5:0] <= 6'd2;
			grid[0][3][5:0] <= 6'd3;
			grid[0][4][5:0] <= 6'd4;
			grid[0][5][5:0] <= 6'd5;
			grid[1][0][5:0] <= 6'd6;
		end
		else if(game_state == reseting) begin
			
			pos = 1'b0;
			space_hit <= 1'b0;
			game_state <= running;
			score <= 16'd0;
		
			cursorX <= 3'd2;
			cursorY <= 4'd11;
			
			next_row[0][5:0] <= 6'd1;
			next_row[1][5:0] <= 6'd2;
			next_row[2][5:0] <= 6'd3;
			next_row[3][5:0] <= 6'd4;
			next_row[4][5:0] <= 6'd5;
			next_row[5][5:0] <= 6'd6;
			counter <= 9'd0;
		
////		Python:
//		for i in range(11,-1,-1):
//			for j in range(5,-1,-1):
//				print ("grid[" + str(i) + "][" + str(j) + "]\t= 6'b0;")

			grid[11][5] <= 6'b0;
			grid[11][4] <= 6'b0;
			grid[11][3] <= 6'b0;
			grid[11][2] <= 6'b0;
			grid[11][1] <= 6'b0;
			grid[11][0] <= 6'b0;
			grid[10][5] <= 6'b0;
			grid[10][4] <= 6'b0;
			grid[10][3] <= 6'b0;
			grid[10][2] <= 6'b0;
			grid[10][1] <= 6'b0;
			grid[10][0] <= 6'b0;
			grid[9][5] <= 6'b0;
			grid[9][4] <= 6'b0;
			grid[9][3] <= 6'b0;
			grid[9][2] <= 6'b0;
			grid[9][1] <= 6'b0;
			grid[9][0] <= 6'b0;
			grid[8][5] <= 6'b0;
			grid[8][4] <= 6'b0;
			grid[8][3] <= 6'b0;
			grid[8][2] <= 6'b0;
			grid[8][1] <= 6'b0;
			grid[8][0] <= 6'b0;
			grid[7][5] <= 6'b0;
			grid[7][4] <= 6'b0;
			grid[7][3] <= 6'b0;
			grid[7][2] <= 6'b0;
			grid[7][1] <= 6'b0;
			grid[7][0] <= 6'b0;
			grid[6][5] <= 6'b0;
			grid[6][4] <= 6'b0;
			grid[6][3] <= 6'b0;
			grid[6][2] <= 6'b0;
			grid[6][1] <= 6'b0;
			grid[6][0] <= 6'b0;
			grid[5][5] <= 6'b0;
			grid[5][4] <= 6'b0;
			grid[5][3] <= 6'b0;
			grid[5][2] <= 6'b0;
			grid[5][1] <= 6'b0;
			grid[5][0] <= 6'b0;
			grid[4][5] <= 6'b0;
			grid[4][4] <= 6'b0;
			grid[4][3] <= 6'b0;
			grid[4][2] <= 6'b0;
			grid[4][1] <= 6'b0;
			grid[4][0] <= 6'b0;
			grid[3][5] <= 6'b0;
			grid[3][4] <= 6'b0;
			grid[3][3] <= 6'b0;
			grid[3][2] <= 6'b0;
			grid[3][1] <= 6'b0;
			grid[3][0] <= 6'b0;
			grid[2][5] <= 6'b0;
			grid[2][4] <= 6'b0;
			grid[2][3] <= 6'b0;
			grid[2][2] <= 6'b0;
			grid[2][1] <= 6'b0;
			grid[2][0] <= 6'b0;
			grid[1][5] <= 6'b0;
			grid[1][4] <= 6'b0;
			grid[1][3] <= 6'b0;
			grid[1][2] <= 6'b0;
			grid[1][1] <= 6'b0;
			grid[1][0] <= 6'b0;
			grid[0][5] <= 6'b0;
			grid[0][4] <= 6'b0;
			grid[0][3] <= 6'b0;
			grid[0][2] <= 6'b0;
			grid[0][1] <= 6'b0;
			grid[0][0] <= 6'b0;

			grid[0][0][5:0] <= 6'd0;
			grid[0][1][5:0] <= 6'd1;
			grid[0][2][5:0] <= 6'd2;
			grid[0][3][5:0] <= 6'd3;
			grid[0][4][5:0] <= 6'd4;
			grid[0][5][5:0] <= 6'd5;
			grid[1][0][5:0] <= 6'd6;
		end
		else if(game_state == running)begin
			if(frame_clk == 1'b1)begin
				if(pos == 1'b0)begin
					pos = 1'b1;
					if(counter == 9'd419) begin
						//determine loss
						if(grid[0][0] != 6'd0 || grid[0][1] != 6'd0 || grid[0][2] != 6'd0 || grid[0][3] != 6'd0 || grid[0][4] != 6'd0 || grid[0][5] != 6'd0) begin
							game_state = lost;
						end
					end
					if(counter == 9'd420) begin
						counter <= 9'd0;
						if(cursorY != 4'd0) begin
							cursorY--;
						end
						
						grid[0] = grid[1];
						grid[1] = grid[2];
						grid[2] = grid[3];
						grid[3] = grid[4];
						grid[4] = grid[5];
						grid[5] = grid[6];
						grid[6] = grid[7];
						grid[7] = grid[8];
						grid[8] = grid[9];
						grid[9] = grid[10];
						grid[10] = grid[11];
						grid[11] = next_row;
						next_row[5] = (rand_num[3:0]%5'd6) + 1;
						next_row[4] = (rand_num[7:4]%5'd6) + 1;
						next_row[3] = (rand_num[11:8]%5'd6) + 1;
						next_row[2] = (rand_num[15:12]%5'd6) + 1;
						next_row[1] = (rand_num[19:16]%5'd6) + 1;
						next_row[0] = (rand_num[23:20]%5'd6) + 1;

					end
					else begin // not reset
						if (counter == 9'b0) just_shifted = 1'b1;
						else just_shifted = 1'b0;
						
						if(just_grav == 1'b1) just_grav = 1'b0;
						
						// Pause counter when removing blocks
						
						counter <= counter + 1'b1;
							
						// Move cursor
						if(~pressed && keycode != 16'd0) begin
							pressed = 1'b1;
							case (keycode)
								16'h52: begin // up
												if(cursorY != 4'd0) cursorY--;
										  end
								16'h51: begin // down
												if(cursorY != 4'd11) cursorY++;
										  end
								16'h50: begin // left
												if(cursorX != 3'd00) cursorX--;
										  end
								16'h4f: begin // right
												if(cursorX != 3'd4) cursorX++;
										  end
								16'h2c: begin // space
												space_hit = 1'b1;
												// swap blocks
												temp = grid[cursorY][cursorX];
												grid[cursorY][cursorX] = grid[cursorY][cursorX+1];
												grid[cursorY][cursorX+1] = temp;
										  end
							endcase
						end
						else if (keycode == 16'd0) begin
							if (just_swapped) begin
								just_swapped = 1'b0;
							end
							if (space_hit) begin
								space_hit = 1'b0;
								just_swapped = 1'b1;
							end
							pressed = 1'b0;
						end
					end
				end
			
			end
			else if(frame_clk == 1'b0) begin
				pos = 1'b0;
			end
			
			//gravity counters
			if(x_counter == 3'd5) begin
				x_counter = 3'd0;
				if(y_counter == 4'd11) begin
					y_counter = 4'd0;
				end
				else y_counter = y_counter + 1;
			end
			else x_counter = x_counter + 1;
			
			//gravity mechanic
			if(y_counter != 4'd11) begin
				if(grid[y_counter][x_counter] != 6'd0 && grid[y_counter+1][x_counter] == 6'd0)begin
					grid[y_counter+1][x_counter] = grid[y_counter][x_counter];
					grid[y_counter][x_counter] = 6'd0;
					just_grav = 1'b1;
				end
			end
			
			//block removal mechanic
			if(just_grav == 1'b0)begin
				if(x_counter < 3'd2)begin
					if(grid[y_counter][x_counter] == grid[y_counter][x_counter+3'd1] && grid[y_counter][x_counter] == grid[y_counter][x_counter+3'd2] && grid[y_counter][x_counter] == grid[y_counter][x_counter+3'd3] 
					&& grid[y_counter][x_counter] == grid[y_counter][x_counter+3'd4] && grid[y_counter][x_counter] != 6'd0) begin
						grid[y_counter][x_counter] = 6'd0;
						grid[y_counter][x_counter+3'd1] = 6'd0;
						grid[y_counter][x_counter+3'd2] = 6'd0;
						grid[y_counter][x_counter+3'd3] = 6'd0;
						grid[y_counter][x_counter+3'd4] = 6'd0;
						if(score + 6'd50 < 16'd65535)
							score = score + 6'd50;
						else score = 16'd65535;
					end
					else if(grid[y_counter][x_counter] == grid[y_counter][x_counter+3'd1] && grid[y_counter][x_counter] == grid[y_counter][x_counter+3'd2] && grid[y_counter][x_counter] == grid[y_counter][x_counter+3'd3] 
					&& grid[y_counter][x_counter] != 6'd0) begin
						grid[y_counter][x_counter] = 6'd0;
						grid[y_counter][x_counter+3'd1] = 6'd0;
						grid[y_counter][x_counter+3'd2] = 6'd0;
						grid[y_counter][x_counter+3'd3] = 6'd0;
						if(score + 6'd25 < 16'd65535)
							score = score + 6'd25;
						else score = 16'd65535;
					end
					else if(grid[y_counter][x_counter] == grid[y_counter][x_counter+3'd1] && grid[y_counter][x_counter] == grid[y_counter][x_counter+3'd2]&& grid[y_counter][x_counter] != 6'd0) begin
						grid[y_counter][x_counter] = 6'd0;
						grid[y_counter][x_counter+3'd1] = 6'd0;
						grid[y_counter][x_counter+3'd2] = 6'd0;
						if(score + 6'd10 < 16'd65535)
							score = score + 6'd10;
						else score = 16'd65535;
					end
				end
				else if(x_counter < 3'd3) begin
					if(grid[y_counter][x_counter] == grid[y_counter][x_counter+3'd1] && grid[y_counter][x_counter] == grid[y_counter][x_counter+3'd2] && grid[y_counter][x_counter] == grid[y_counter][x_counter+3'd3] 
					&& grid[y_counter][x_counter] != 6'd0) begin
						grid[y_counter][x_counter] = 6'd0;
						grid[y_counter][x_counter+3'd1] = 6'd0;
						grid[y_counter][x_counter+3'd2] = 6'd0;
						grid[y_counter][x_counter+3'd3] = 6'd0;
						if(score + 6'd25 < 16'd65535)
							score = score + 6'd25;
						else score = 16'd65535;
					end
					else if(grid[y_counter][x_counter] == grid[y_counter][x_counter+3'd1] && grid[y_counter][x_counter] == grid[y_counter][x_counter+3'd2]&& grid[y_counter][x_counter] != 6'd0) begin
						grid[y_counter][x_counter] = 6'd0;
						grid[y_counter][x_counter+3'd1] = 6'd0;
						grid[y_counter][x_counter+3'd2] = 6'd0;
						if(score + 6'd10 < 16'd65535)
							score = score + 6'd10;
						else score = 16'd65535;
					end
				end
				else if(x_counter < 3'd4) begin
					if(grid[y_counter][x_counter] == grid[y_counter][x_counter+3'd1] && grid[y_counter][x_counter] == grid[y_counter][x_counter+3'd2]&& grid[y_counter][x_counter] != 6'd0) begin
						grid[y_counter][x_counter] = 6'd0;
						grid[y_counter][x_counter+3'd1] = 6'd0;
						grid[y_counter][x_counter+3'd2] = 6'd0;
						if(score + 6'd10 < 16'd65535)
							score = score + 6'd10;
						else score = 16'd65535;
					end
				end
				if(y_counter < 4'd8) begin
					if(grid[y_counter][x_counter] == grid[y_counter+3'd1][x_counter] && grid[y_counter][x_counter] == grid[y_counter+3'd2][x_counter] && grid[y_counter][x_counter] == grid[y_counter+3'd3][x_counter] 
					&& grid[y_counter][x_counter] == grid[y_counter+3'd4][x_counter] && grid[y_counter][x_counter] != 6'd0) begin
						grid[y_counter][x_counter] = 6'd0;
						grid[y_counter+3'd1][x_counter] = 6'd0;
						grid[y_counter+3'd2][x_counter] = 6'd0;
						grid[y_counter+3'd3][x_counter] = 6'd0;
						grid[y_counter+3'd4][x_counter] = 6'd0;
						if(score + 6'd50 < 16'd65535)
							score = score + 6'd50;
						else score = 16'd65535;
					end
					else if(grid[y_counter][x_counter] == grid[y_counter+3'd1][x_counter] && grid[y_counter][x_counter] == grid[y_counter+3'd2][x_counter] && grid[y_counter][x_counter] == grid[y_counter+3'd3][x_counter] 
					&& grid[y_counter][x_counter] != 6'd0) begin
						grid[y_counter][x_counter] = 6'd0;
						grid[y_counter+3'd1][x_counter] = 6'd0;
						grid[y_counter+3'd2][x_counter] = 6'd0;
						grid[y_counter+3'd3][x_counter] = 6'd0;
						if(score + 6'd25 < 16'd65535)
							score = score + 6'd25;
						else score = 16'd65535;
					end
					else if(grid[y_counter][x_counter] == grid[y_counter+3'd1][x_counter] && grid[y_counter][x_counter] == grid[y_counter+3'd2][x_counter]&& grid[y_counter][x_counter] != 6'd0) begin
						grid[y_counter][x_counter] = 6'd0;
						grid[y_counter+3'd1][x_counter] = 6'd0;
						grid[y_counter+3'd2][x_counter] = 6'd0;
						if(score + 6'd10 < 16'd65535)
							score = score + 6'd10;
						else score = 16'd65535;
					end
				end
				else if(y_counter < 4'd9) begin
					if(grid[y_counter][x_counter] == grid[y_counter+3'd1][x_counter] && grid[y_counter][x_counter] == grid[y_counter+3'd2][x_counter] && grid[y_counter][x_counter] == grid[y_counter+3'd3][x_counter] 
					&& grid[y_counter][x_counter] != 6'd0) begin
						grid[y_counter][x_counter] = 6'd0;
						grid[y_counter+3'd1][x_counter] = 6'd0;
						grid[y_counter+3'd2][x_counter] = 6'd0;
						grid[y_counter+3'd3][x_counter] = 6'd0;
						if(score + 6'd25 < 16'd65535)
							score = score + 6'd25;
						else score = 16'd65535;
					end
					else if(grid[y_counter][x_counter] == grid[y_counter+3'd1][x_counter] && grid[y_counter][x_counter] == grid[y_counter+3'd2][x_counter]&& grid[y_counter][x_counter] != 6'd0) begin
						grid[y_counter][x_counter] = 6'd0;
						grid[y_counter+3'd1][x_counter] = 6'd0;
						grid[y_counter+3'd2][x_counter] = 6'd0;
						if(score + 6'd10 < 16'd65535)
							score = score + 6'd10;
						else score = 16'd65535;
					end
				end
				else if(y_counter < 4'd10) begin
					if(grid[y_counter][x_counter] == grid[y_counter+3'd1][x_counter] && grid[y_counter][x_counter] == grid[y_counter+3'd2][x_counter]&& grid[y_counter][x_counter] != 6'd0) begin
						grid[y_counter][x_counter] = 6'd0;
						grid[y_counter+3'd1][x_counter] = 6'd0;
						grid[y_counter+3'd2][x_counter] = 6'd0;
						if(score + 6'd10 < 16'd65535)
							score = score + 6'd10;
						else score = 16'd65535;
					end
				end
			end
		end
		else begin
			if(keycode == 16'h28) game_state = reseting;
		end
	end
	
endmodule
