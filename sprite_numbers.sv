module  sprite_numbers
(
		input [12:0] read_address1, read_address2, read_address3, read_address4, read_address5,
		input logic Clk,

		output logic [23:0] data_Out1, data_Out2, data_Out3, data_Out4, data_Out5
);

logic [23:0] mem [0:6249]; 				// Frame buffer through the use of onchip memory

initial
begin
	 $readmemh("sprite_bytes/numbers.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out1<= mem[read_address1];
	data_Out2<= mem[read_address2];
	data_Out3<= mem[read_address3];
	data_Out4<= mem[read_address4];
	data_Out5<= mem[read_address5];
end

endmodule