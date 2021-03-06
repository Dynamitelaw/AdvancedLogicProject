/*
 * Test bench for Layer1Controller
 *
 * Tested using 
	LAYER_1_OUT_BIT_WIDTH 4

	RELU_NODES 4
	LAYER_2_IN_BIT_WIDTH 4
	LAYER_2_WEIGHTS_BIT_WIDTH 4
	LAYER_2_OUT_BIT_WIDTH 7
	RELU_INDEX_WIDTH 3

	SOFTMAX_IN_BIT_WIDTH 7
 */

`include "Layer2Controller.v"


module TEST_Layer2Controller ;
	//Instantiate modules
	reg reset = 0;
	reg clk = 0;
	reg inputsReady = `FALSE;
	reg outputsRecieved = `FALSE;
	reg weightWriteEnable = `FALSE;
	reg biasWriteEnable = `FALSE;
	reg [`RELU_INDEX_WIDTH-1:0] WriteAddressSelect;
	reg [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] writeIn;
	reg [`RELU_NODES*`LAYER_2_IN_BIT_WIDTH-1:0] layer2Input;
	
	wire inputsRecieved;
	wire outputsReady;
	wire [3:0] predictionOutput;
	
	Layer2_Controller Layer2(
		//Inputs
		.reset(reset),
		.clk(clk), 
		.inputsReady(inputsReady), 
		.outputsRecieved(outputsRecieved),
		.weightWriteEnable(weightWriteEnable), 
		.biasWriteEnable(biasWriteEnable), 
		.WriteAddressSelect(WriteAddressSelect), 
		.writeIn(writeIn), 
		.layer2Input(layer2Input),
		//Outputs
		.inputsRecieved(inputsRecieved), 
		.outputsReady(outputsReady),
		.predictionOutput(predictionOutput)
	);

 	reg success = `FALSE;

	initial
	begin
		clk = 0;
		#1

		//Reset modules
		#2
		reset <= 1;
		#2
		reset <= 0;

		//Load in weights
		#2
		WriteAddressSelect = 2'b00;  //node0
		weightWriteEnable <= 1;
		#1
		writeIn <= 40'b0011_1100_0111_1001_0110_1110_0000_0110_1111_0101;  //(3, -4, 7, -7, 6, -2, 0, 6, -1, 5)
		//#1
		//weightWriteEnable <= 0;

		#2
		WriteAddressSelect = 2'b01;  //node1
		weightWriteEnable <= 1;
		#1
		writeIn <= 40'b1000_0011_0101_1011_1010_1111_1001_0010_0110_1101;  //(-8, 3, 5, -5, -6, -1, -7, 2, 6, -3)
		//#1
		//weightWriteEnable <= 0;

		#2
		WriteAddressSelect = 2'b10;  //node2
		weightWriteEnable <= 1;
		#1
		writeIn <= 40'b0001_1101_0101_1000_0110_0011_1011_0100_1110_1100;  //(1, -3, 5, -8, 6, 3, -5, 4, -2, -4)
		//#1
		//weightWriteEnable <= 0;

		#2
		WriteAddressSelect = 2'b11;  //node3
		weightWriteEnable <= 1;
		#1
		writeIn <= 40'b0111_0010_1111_1010_1001_0011_1101_1000_0101_0000;  //(7, 2, -1, -6, -7, 3, -3, -8, 5, 0)
		#1
		weightWriteEnable <= 0;

		//Load in RELU inputs
		#3
		inputsReady <= 1;

		layer2Input <= 16'b0100_0011_0000_0110;  //(4,3,0,6)

		
		#10
		outputsRecieved <= `TRUE;
		#1
		outputsRecieved <= `FALSE;


		
		
	end

	//Clock toggling
	always begin
		#1  //2-step period
		clk <= ~clk;
	end
	

endmodule
