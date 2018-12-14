`include "GlobalVariables.v"

module multStore (
	//Inputs
	clk, clr, layer2In, weightsIn, //biasesIn,
	//Outputs
	sumOut
);

        input clk, clr;
        input [`LAYER_2_IN_BIT_WIDTH-1:0] layer2In;
	input [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] weightsIn;
        output [10*`LAYER_2_OUT_BIT_WIDTH-1:0] sumOut;

	genvar m;
	generate
		for(m = 0; m<10; m=m+1)
		begin
			MAC mac(.clr(clr),
				.clk(clk),
				.X(weightsIn[m*`LAYER_2_WEIGHTS_BIT_WIDTH + `LAYER_2_WEIGHTS_BIT_WIDTH - 1:m*`LAYER_2_WEIGHTS_BIT_WIDTH]),
				.M(layer2In),
				.S(sumOut[m*`LAYER_2_OUT_BIT_WIDTH + `LAYER_2_OUT_BIT_WIDTH - 1:m*`LAYER_2_OUT_BIT_WIDTH]));
		end
	endgenerate

	
endmodule  //end pStore

module MAC (clr, clk, X, M, S);
	input clk, clr;
	input [`LAYER_2_WEIGHTS_BIT_WIDTH - 1:0] X;
	input [`LAYER_2_IN_BIT_WIDTH - 1:0] M;
	output reg [`LAYER_2_OUT_BIT_WIDTH - 1:0] S = 'b0; // initialize sumOut
	reg [`LAYER_2_OUT_BIT_WIDTH - 1:0] s;
	reg [`LAYER_2_OUT_BIT_WIDTH - 1:0] X2;
	integer k;
	
	// Pad input with 1s or 0s according to its sign
	always @(X)
	begin
		X2[`LAYER_2_WEIGHTS_BIT_WIDTH - 1:0] = X;
		for(k = `LAYER_2_WEIGHTS_BIT_WIDTH;k < `LAYER_2_OUT_BIT_WIDTH;k = k+1)
			if (X[`LAYER_2_WEIGHTS_BIT_WIDTH - 1])
				X2[k] = 1;
			else
				X2[k] = 0;
	end
	
	// Add and store padded weights
	always @(negedge clr, posedge clk)
	begin
		if (clr == 1) S <= 'b0;
		else S <= s;
	end
	
	always @(*)
		s <= S + X2*M;
		// make overflow detection
	
endmodule
