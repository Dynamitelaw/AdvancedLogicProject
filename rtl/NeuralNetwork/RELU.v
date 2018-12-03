// rectify and reduce precision
`include "GlobalVariables.v"

module RELU (
	//Inputs
	sumIn, trigger,
	//Outputs
	layer1Out);

	input trigger;
	input [`RELU_NODES*`LAYER_1_OUT_BIT_WIDTH-1:0] sumIn;
	output [`RELU_NODES*`LAYER_2_IN_BIT_WIDTH-1:0] layer1Out;
	genvar k;

	//passes value if it is positive and when trigger is high
	generate
		for(k = 0;k < `RELU_NODES;k = k + 1)
		begin:RnR
			RectAndReduce RnR(.trigger(trigger),
					  .X(sumIn[(k+1)*`LAYER_1_OUT_BIT_WIDTH - 1:k*`LAYER_1_OUT_BIT_WIDTH]),
				  	  .Y(layer1Out[(k+1)*`LAYER_2_IN_BIT_WIDTH - 1:k*`LAYER_2_IN_BIT_WIDTH]));
		end
	endgenerate
endmodule

module RectAndReduce(X,Y,trigger);
	input trigger;
	input [`LAYER_1_OUT_BIT_WIDTH-1:0] X;
	output reg [`LAYER_2_IN_BIT_WIDTH-1:0] Y;

	always @(X,trigger)
		if (~X[`LAYER_1_OUT_BIT_WIDTH - 1] & trigger)
		Y = X[`LAYER_1_OUT_BIT_WIDTH-1:`LAYER_1_OUT_BIT_WIDTH-`LAYER_2_IN_BIT_WIDTH];
		else
		Y = 'b0;
endmodule

