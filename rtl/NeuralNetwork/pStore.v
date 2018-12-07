/*
LAYER 1
This file contains the "pStore" module to add stored weights in "FNode" to previously stored values
*/

`include "GlobalVariables.v"

module pStore (
	//Inputs
	clk, clr, weightsIn, //biasesIn, biasWriteEnable,
	//Outputs
	sumOut
);

    input clk, clr;
    input [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] weightsIn;
	//input [`RELU_NODES*`LAYER_1_OUT_BIT_WIDTH-1:0] biasesIn;
	//input biasWriteEnable;
    output [`RELU_NODES*`LAYER_1_OUT_BIT_WIDTH-1:0] sumOut;

	genvar m;
	generate
		for(m = 0; m<`RELU_NODES; m=m+1)
		begin:addWeight
			stored_addern add(.clr(clr),
					  .clk(clk),
					  .X(weightsIn[m*`LAYER_1_BIT_WIDTH + `LAYER_1_BIT_WIDTH - 1:m*`LAYER_1_BIT_WIDTH]),
					  //.B(biasesIn[m*`LAYER_1_OUT_BIT_WIDTH + `LAYER_1_OUT_BIT_WIDTH - 1:m*`LAYER_1_OUT_BIT_WIDTH]),
					  .S(sumOut[m*`LAYER_1_OUT_BIT_WIDTH + `LAYER_1_OUT_BIT_WIDTH - 1:m*`LAYER_1_OUT_BIT_WIDTH]));
		end
	endgenerate

	
endmodule  //end pStore

module stored_addern (clr, clk, X, S);
	input clk, clr;
	input [`LAYER_1_BIT_WIDTH - 1:0] X;
	//input [`LAYER_1_OUT_BIT_WIDTH - 1:0] B;
	output reg [`LAYER_1_OUT_BIT_WIDTH - 1:0] S = 'b0; // initialize sumOut
	reg [`LAYER_1_OUT_BIT_WIDTH - 1:0] s;
	reg [`LAYER_1_OUT_BIT_WIDTH - 1:0] X2;
	integer k;
	
	// Pad input with 1s or 0s according to its sign
	always @(X)
	begin
		X2[`LAYER_1_BIT_WIDTH - 1:0] = X;
		for(k = `LAYER_1_BIT_WIDTH;k < `LAYER_1_OUT_BIT_WIDTH - 1;k = k+1)
			if (X[`LAYER_1_BIT_WIDTH - 1])
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
		s = S + X2;
		// make overflow detection
	
endmodule

