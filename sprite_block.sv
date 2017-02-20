module  sprite_block
(
		input [12:0] read_address, read_address2,
		input logic Clk,

		output logic [23:0] data_Out, data_Out2
);

logic [23:0] mem [0:3749]; 				// Frame buffer through the use of onchip memory

initial
begin
	 $readmemh("sprite_bytes/all_blocks.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
	data_Out2<= mem[read_address2];
end

endmodule