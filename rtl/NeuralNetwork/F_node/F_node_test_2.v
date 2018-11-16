module F_node_test;
	reg clk, write_enable, IN;
	reg [4:0] write_in_1, write_in_2, write_in_3, write_in_4, 
		write_in_5, write_in_6, write_in_7, write_in_8,
		write_in_9, write_in_10, write_in_11, write_in_12, 
		write_in_13, write_in_14, write_in_15, write_in_16;
	wire [4:0] OUT_1, OUT_2, OUT_3, OUT_4, OUT_5, OUT_6, OUT_7, OUT_8,
		OUT_9, OUT_10, OUT_11, OUT_12, OUT_13, OUT_14, OUT_15, OUT_16;

	F_node F_node_1(.clk(clk),.write_enable(write_enable),.IN(IN),
			.write_in_1(write_in_1),
			.write_in_2(write_in_2),
			.write_in_3(write_in_3),
			.write_in_4(write_in_4),
			.write_in_5(write_in_5),
			.write_in_6(write_in_6),
			.write_in_7(write_in_7),
			.write_in_8(write_in_8),
			.write_in_9(write_in_9),
			.write_in_10(write_in_10),
			.write_in_11(write_in_11),
			.write_in_12(write_in_12),
			.write_in_13(write_in_13),
			.write_in_14(write_in_14),
			.write_in_15(write_in_15),
			.write_in_16(write_in_16),
			.OUT_1(OUT_1),
			.OUT_2(OUT_2),
			.OUT_3(OUT_3),
			.OUT_4(OUT_4),
			.OUT_5(OUT_5),
			.OUT_6(OUT_6),
			.OUT_7(OUT_7),
			.OUT_8(OUT_8),
			.OUT_9(OUT_9),
			.OUT_10(OUT_10),
			.OUT_11(OUT_11),
			.OUT_12(OUT_12),
			.OUT_13(OUT_13),
			.OUT_14(OUT_14),
			.OUT_15(OUT_15),
			.OUT_16(OUT_16)
			);
	
	initial begin
		clk = 0;
		
	end

	always begin
		#20
		clk = ~clk;
	end

endmodule


