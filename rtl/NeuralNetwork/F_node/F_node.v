module F_node (clk, write_enable, IN,
		write_in_1, write_in_2, write_in_3, write_in_4, 
		write_in_5, write_in_6, write_in_7, write_in_8,
		write_in_9, write_in_10, write_in_11, write_in_12, 
		write_in_13, write_in_14, write_in_15, write_in_16,
		OUT_1, OUT_2, OUT_3, OUT_4, OUT_5, OUT_6, OUT_7, OUT_8,
		OUT_9, OUT_10, OUT_11, OUT_12, OUT_13, OUT_14, OUT_15, OUT_16);

	parameter n = 5;	
	
        input clk, write_enable, IN;
        input [n - 1:0] write_in_1, write_in_2, write_in_3, write_in_4, 
		write_in_5, write_in_6, write_in_7, write_in_8,
		write_in_9, write_in_10, write_in_11, write_in_12, 
		write_in_13, write_in_14, write_in_15, write_in_16;
        output reg [n - 1:0] OUT_1, OUT_2, OUT_3, OUT_4, OUT_5, OUT_6, OUT_7, OUT_8,
		OUT_9, OUT_10, OUT_11, OUT_12, OUT_13, OUT_14, OUT_15, OUT_16;


        always @(posedge clk)
        begin
            if (write_enable)				      // Enable passing values when write_enable = 1, remains prevous value if write_in = 0
                begin
			if (IN)
				begin
                        		OUT_1 <= write_in_1;  // If IN (pixel value) = 1, pass write_in
					OUT_2 <= write_in_2;
					OUT_3 <= write_in_3;
					OUT_4 <= write_in_4;
					OUT_5 <= write_in_5;
					OUT_6 <= write_in_6;
					OUT_7 <= write_in_7;
					OUT_8 <= write_in_8;
					OUT_9 <= write_in_9;
					OUT_10 <= write_in_10;
					OUT_11 <= write_in_11;
					OUT_12 <= write_in_12;
					OUT_13 <= write_in_13;
					OUT_14 <= write_in_14;
					OUT_15 <= write_in_15;
					OUT_16 <= write_in_16;	
				end
			else
				begin
					OUT_1 <= 'b0;	      // If IN (pixel value) = 0, pass n bit wide zero
					OUT_2 <= 'b0;
					OUT_3 <= 'b0;
					OUT_4 <= 'b0;
					OUT_5 <= 'b0;
					OUT_6 <= 'b0;
					OUT_7 <= 'b0;
					OUT_8 <= 'b0;
					OUT_9 <= 'b0;
					OUT_10 <= 'b0;
					OUT_11 <= 'b0;
					OUT_12 <= 'b0;
					OUT_13 <= 'b0;
					OUT_14 <= 'b0;
					OUT_15 <= 'b0;
					OUT_16 <= 'b0;
				end
                end
        end
endmodule

