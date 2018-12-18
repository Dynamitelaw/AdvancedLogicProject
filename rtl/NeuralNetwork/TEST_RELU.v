
`include "GlobalVariables.v"

module test_RELU();

	reg trigger;
	reg [`RELU_NODES*`LAYER_1_OUT_BIT_WIDTH-1:0] sumIn;
	wire [`RELU_NODES*`LAYER_2_IN_BIT_WIDTH-1:0] layer1Out;

	RELU test1 (.sumIn(sumIn),.trigger(trigger),.layer1Out(layer1Out));

	initial begin
		trigger = 0;
		sumIn = 18'b10000111;
		#20
		trigger = 1;
		#20
		sumIn = 16'b10110110;
		#20
		sumIn = 16'b10001111;

		//$finish;
	end

endmodule
