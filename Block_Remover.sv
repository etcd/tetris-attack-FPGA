module  Block_Remover (
							input  logic 			Clk,
							input  logic 			Reset,
							input  logic [2:0]  	cursorX,
							input  logic [3:0] 	cursorY,
							// the union of the following signals tell when to check for block removal
							input  logic 			just_swapped, 	// when signal is active, player just swapped a block
							input  logic 			just_shifted, 	// when signal is active, then blocks just shifted up
							input  logic 			just_grav, 		// gravity recently stabilized again
							input  logic [5:0]	queryOut2, queryOut3, queryOut4, queryOut5, queryOut6, queryOut7, queryOut8, queryOut9, queryOut10,
							// the following signal fires when blocks need to be removed
							// the coordinates of the block to be removed
							output logic [2:0]  	removeX,
							output logic [3:0] 	removeY,
							output logic [2:0]   removeNum,
							output logic 			removeDir,
							output logic [2:0] 	queryX2, queryX3, queryX4, queryX5, queryX6, queryX7, queryX8, queryX9, queryX10,
							output logic [3:0]   queryY2, queryY3, queryY4, queryY5, queryY6, queryY7, queryY8, queryY9, queryY10,
							output logic [1:0] 	same_color [12:0][6:0]
						 );

	logic [2:0] x_counter;
	logic [3:0] y_counter;
	logic [5:0] curr_color;

	always_ff @ ( posedge Reset or posedge Clk ) begin
		if(Reset) begin
			x_counter <= 4'd0;
			y_counter <= 4'd0;
			curr_color <= 6'd0;
			same_color[0][0] <= 2'd0;
			same_color[0][1] <= 2'd0;
			same_color[0][2] <= 2'd0;
			same_color[0][3] <= 2'd0;
			same_color[0][4] <= 2'd0;
			same_color[0][5] <= 2'd0;
			same_color[0][6] <= 2'd0;
			same_color[1][0] <= 2'd0;
			same_color[1][1] <= 2'd0;
			same_color[1][2] <= 2'd0;
			same_color[1][3] <= 2'd0;
			same_color[1][4] <= 2'd0;
			same_color[1][5] <= 2'd0;
			same_color[1][6] <= 2'd0;
			same_color[2][0] <= 2'd0;
			same_color[2][1] <= 2'd0;
			same_color[2][2] <= 2'd0;
			same_color[2][3] <= 2'd0;
			same_color[2][4] <= 2'd0;
			same_color[2][5] <= 2'd0;
			same_color[2][6] <= 2'd0;
			same_color[3][0] <= 2'd0;
			same_color[3][1] <= 2'd0;
			same_color[3][2] <= 2'd0;
			same_color[3][3] <= 2'd0;
			same_color[3][4] <= 2'd0;
			same_color[3][5] <= 2'd0;
			same_color[3][6] <= 2'd0;
			same_color[4][0] <= 2'd0;
			same_color[4][1] <= 2'd0;
			same_color[4][2] <= 2'd0;
			same_color[4][3] <= 2'd0;
			same_color[4][4] <= 2'd0;
			same_color[4][5] <= 2'd0;
			same_color[4][6] <= 2'd0;
			same_color[5][0] <= 2'd0;
			same_color[5][1] <= 2'd0;
			same_color[5][2] <= 2'd0;
			same_color[5][3] <= 2'd0;
			same_color[5][4] <= 2'd0;
			same_color[5][5] <= 2'd0;
			same_color[5][6] <= 2'd0;
			same_color[6][0] <= 2'd0;
			same_color[6][1] <= 2'd0;
			same_color[6][2] <= 2'd0;
			same_color[6][3] <= 2'd0;
			same_color[6][4] <= 2'd0;
			same_color[6][5] <= 2'd0;
			same_color[6][6] <= 2'd0;
			same_color[7][0] <= 2'd0;
			same_color[7][1] <= 2'd0;
			same_color[7][2] <= 2'd0;
			same_color[7][3] <= 2'd0;
			same_color[7][4] <= 2'd0;
			same_color[7][5] <= 2'd0;
			same_color[7][6] <= 2'd0;
			same_color[8][0] <= 2'd0;
			same_color[8][1] <= 2'd0;
			same_color[8][2] <= 2'd0;
			same_color[8][3] <= 2'd0;
			same_color[8][4] <= 2'd0;
			same_color[8][5] <= 2'd0;
			same_color[8][6] <= 2'd0;
			same_color[9][0] <= 2'd0;
			same_color[9][1] <= 2'd0;
			same_color[9][2] <= 2'd0;
			same_color[9][3] <= 2'd0;
			same_color[9][4] <= 2'd0;
			same_color[9][5] <= 2'd0;
			same_color[9][6] <= 2'd0;
			same_color[10][0] <= 2'd0;
			same_color[10][1] <= 2'd0;
			same_color[10][2] <= 2'd0;
			same_color[10][3] <= 2'd0;
			same_color[10][4] <= 2'd0;
			same_color[10][5] <= 2'd0;
			same_color[10][6] <= 2'd0;
			same_color[11][0] <= 2'd0;
			same_color[11][1] <= 2'd0;
			same_color[11][2] <= 2'd0;
			same_color[11][3] <= 2'd0;
			same_color[11][4] <= 2'd0;
			same_color[11][5] <= 2'd0;
			same_color[11][6] <= 2'd0;
			same_color[12][0] <= 2'd0;
			same_color[12][1] <= 2'd0;
			same_color[12][2] <= 2'd0;
			same_color[12][3] <= 2'd0;
			same_color[12][4] <= 2'd0;
			same_color[12][5] <= 2'd0;
			same_color[12][6] <= 2'd0;
		end
		else if((just_shifted ==  1'b1) || (just_swapped == 1'b1) || (just_grav == 1'b1)) begin
			x_counter <= 3'd0;
			y_counter <= 4'd0;
		end
		else begin
			if(x_counter == 3'd5)begin
				x_counter <= 3'd0;
				if(y_counter == 4'd11) begin
					y_counter <= 4'd0;
				end
				else y_counter <= y_counter + 1'b1;
			end
			else x_counter <= x_counter + 1'b1;
		
			queryX2 <= x_counter;
			queryY2 <= y_counter;
			if(y_counter < 4'd10)begin
				
				queryX3 <= x_counter;
				queryY3 <= y_counter+4'd1;
				queryX4 <= x_counter;
				queryY4 <= y_counter+4'd2;
				queryX5 <= x_counter;
				queryY5 <= y_counter+4'd3;
				queryX6 <= x_counter;
				queryY6 <= y_counter+4'd4;
				
				if(queryOut2 == queryOut3 && queryOut2 == queryOut4 && queryOut2 == queryOut5 && queryOut2 == queryOut6 && queryOut2 != 6'd0) begin
					removeX <= x_counter;
					removeY <= y_counter;
					removeNum <= 3'd5;
					removeDir <= 1'd1;
				end
				else if(queryOut2 == queryOut3 && queryOut2 == queryOut4 && queryOut2 == queryOut5 && queryOut2 != 6'd0) begin
					removeX <= x_counter;
					removeY <= y_counter;
					removeNum <= 3'd4;
					removeDir <= 1'd1;
				end
				else if(queryOut2 == queryOut3 && queryOut2 == queryOut4 && queryOut2 != 6'd0) begin
					removeX <= x_counter;
					removeY <= y_counter;
					removeNum <= 3'd3;
					removeDir <= 1'd1;
				end
				else begin
					removeNum <= 3'd0;
				end
			end
			if(x_counter < 3'd4)begin
				queryX7 <= x_counter+3'd1;
				queryY7 <= y_counter;
				queryX8 <= x_counter+3'd2;
				queryY8 <= y_counter;
				queryX9 <= x_counter+3'd3;
				queryY9 <= y_counter;
				queryX10 <= x_counter+3'd4;
				queryY10 <= y_counter;
				
				if(queryOut2 == queryOut7 && queryOut2 == queryOut8 && queryOut2 == queryOut9 && queryOut2 == queryOut10 && queryOut2 != 6'd0) begin
					removeX <= x_counter;
					removeY <= y_counter;
					removeNum <= 3'd5;
					removeDir <= 1'd0;
				end
				else if(queryOut2 == queryOut7 && queryOut2 == queryOut8 && queryOut2 == queryOut9 && queryOut2 != 6'd0) begin
					removeX <= x_counter;
					removeY <= y_counter;
					removeNum <= 3'd4;
					removeDir <= 1'd0;
				end
				else if(queryOut2 == queryOut7 && queryOut2 == queryOut8 && queryOut2 != 6'd0) begin
					removeX <= x_counter;
					removeY <= y_counter;
					removeNum <= 3'd3;
					removeDir <= 1'd0;
				end
				else begin
					removeNum <= 3'd0;
				end
			end
		end
	
	end
						 
endmodule
