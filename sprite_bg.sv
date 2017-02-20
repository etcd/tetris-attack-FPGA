module  sprite_bg
(
		input [18:0] read_address,
		input logic Clk,

		output logic [23:0] data_Out
);

logic [23:0] mem [0:307199]; 				// Frame buffer through the use of onchip memory

initial
begin
	 $readmemh("sprite_bytes/background.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
