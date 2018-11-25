/*
 * Test bench for Layer1WeightStorage
 */

`include "GlobalVariables.v"
`include "Layer1WeightStorage.v"


module TEST_Layer1WeightStorage ;
	reg writeEnable;
	reg [9:0] NodeSelect;
	reg [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] writeIn;
	wire [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] readOut;

	
	Layer1WeightStorage storage(
		.writeEnable(writeEnable), 
		.NodeSelect(NodeSelect), 
		.writeIn(writeIn),
		.readOut(readOut)
	);
	
	/*
	NodeWeightBank bankTest(
		.writeEnable(writeEnable),
		.writeIn(writeIn),
		.readOut(readOut)
	);
	*/
	initial
	begin
		assign writeEnable = `FALSE;
		assign NodeSelect = 0;
		assign writeIn = 38;
		#1
		assign writeEnable = `TRUE;
		#1
		assign writeIn = 602;
		#1
		assign writeEnable = `FALSE;
		#1
		assign writeIn = 52;
		assign NodeSelect = 1;
		#1
		assign writeEnable = `TRUE;
		#1
		assign writeEnable = `FALSE;
		#10
		assign NodeSelect = 0;
		#10
		assign NodeSelect = 1;
		//$finish;

	end
	

endmodule