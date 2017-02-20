module  sprite_score
(
		input [11:0] read_address,
		input logic Clk,

		output logic [23:0] data_Out
);

logic [23:0] mem [0:2375]; 				// Frame buffer through the use of onchip memory

initial
begin
	 $readmemh("sprite_bytes/score.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule