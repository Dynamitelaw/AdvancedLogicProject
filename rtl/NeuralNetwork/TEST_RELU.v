
`include "GlobalVariables.v"

module test_RELU();

	reg trigger;
	reg [`RELU_NODES*`LAYER_1_OUT_BIT_WIDTH-1:0] sumIn;
	wire [`RELU_NODES*`LAYER_2_IN_BIT_WIDTH-1:0] layer1Out;

	RELU test1 (.sumIn(sumIn),.trigger(trigger),.layer1Out(layer1Out));

	initial begin
		trigger = 0;
		sumIn = 16'b1010_0111_1000_1111;
		#20
		trigger = 1;
		#20
		sumIn = 16'b0010_0011_1011_0110;
		#20

		$finish;
	end

endmodule
