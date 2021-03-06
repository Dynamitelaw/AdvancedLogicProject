/*
 * Test bench for NN controller
 *
 * Tested using 
	`define QUEUE_MAX_SIZE 7  //Available storage elements in the input queue

	`define INPUT_LAYER_NODES 6 //784

	//`define LAYER_1_CLK_DIVIDER 1
	`define LAYER_1_BIT_WIDTH 4
	`define LAYER_1_OUT_BIT_WIDTH 6
	`define RELU_NODES 4

	//`define LAYER_2_CLK_DIVIDER 1
	`define LAYER_2_IN_BIT_WIDTH 6
	`define LAYER_2_WEIGHTS_BIT_WIDTH 4
	`define LAYER_2_OUT_BIT_WIDTH 10
	`define RELU_INDEX_WIDTH 3

	`define SOFTMAX_IN_BIT_WIDTH 10

	`define WRITE_IN_BIT_WIDTH 64  //must be greater than or equal to both L1 and L2 write ports
 */

`include "GlobalVariables.v"


module TEST_NNController ;
	//Instantiate modules
	reg reset = 0;
	reg clk;
	reg inputsInbound = 0;
	reg predictionRecieved = 0;
	reg inputPixel;
	reg weightWriteEnable;
	reg biasWriteEnable;
	reg LayerWriteSelect;
	reg [9:0] WriteAddressSelect;
	reg [`WRITE_IN_BIT_WIDTH-1:0] writeIn;
	
	wire predictionReady;
	wire readyForInputs;
	wire [3:0] predictionOut;
	NN_Controler controller(
		//Inputs
	 	.reset(reset), 
	 	.masterClk(clk), 
	 	.inputsInbound(inputsInbound), 
	 	.predictionRecieved(predictionRecieved),
	 	.inputPixel(inputPixel), 
	 	.weightWriteEnable(weightWriteEnable), 
	 	.biasWriteEnable(biasWriteEnable), 
	 	.LayerWriteSelect(LayerWriteSelect), 
	 	.WriteAddressSelect(WriteAddressSelect), 
	 	.writeIn(writeIn),
		//Outputs
	 	.predictionReady(predictionReady), 
	 	.readyForInputs(readyForInputs),
	 	.predictionOut(predictionOut)
	);

	initial
	begin
		clk = 0;
		#1

		//--Load in weights--
		
		//----------------------------------
		//Layer1 Weights
		#1
		LayerWriteSelect = 0;
		#1
		
		WriteAddressSelect = 10'b0000000000;  //node0
		weightWriteEnable <= 1;
		#1
		writeIn <= 24'b0101_0101_0110_0101;  // [5, 5, 6, 5]
		//#1
		//weightWriteEnable <= 0;

		#2
		WriteAddressSelect = 10'b0000000001;  //node1
		weightWriteEnable <= 1;
		#1
		writeIn <= 24'b0100_0111_0000_0101;  // [4, 7, 0, 5]
		//#1
		//weightWriteEnable <= 0;

		#2
		WriteAddressSelect = 10'b0000000010;  //node2
		weightWriteEnable <= 1;
		#1
		writeIn <= 24'b0010_0111_0001_0000;  // [2, 7, 1, 0]
		//#1
		//weightWriteEnable <= 0;
		
		#2
		WriteAddressSelect = 10'b0000000011;  //node3
		weightWriteEnable <= 1;
		#1
		writeIn <= 24'b0001_0010_0110_0011;  // [1, 2, 6, 3]
		//#1
		//weightWriteEnable <= 0;
		
		#2
		WriteAddressSelect = 10'b0000000100;  //node4
		weightWriteEnable <= 1;
		#1
		writeIn <= 24'b0010_0111_0000_0111;  // [2, 7, 0, 7]
		//#1
		//weightWriteEnable <= 0;

		#2
		WriteAddressSelect = 10'b0000000101;  //node5
		weightWriteEnable <= 1;
		#1
		writeIn <= 24'b0011_0000_0011_0101;  // [3, 0, 3, 5]
		#1
		weightWriteEnable <= 0;
		
		#2
		biasWriteEnable <= 1;
		#1
		writeIn <= 24'b0011_0111_0001_0010;  // [3, 7, 1, 2]
		#1
		biasWriteEnable <= 0;
		
		//-----------------------------------------
		//Layer2 Weights
		#1
		LayerWriteSelect = 1;
		#1
		
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
		
		#2
		biasWriteEnable <= 1;
		#1
		writeIn <= 40'b0000_0110_0010_0001_0011_0011_0100_0010_0000_0001;
		#1
		biasWriteEnable <= 0;

		//--------------------------------------
		//Reset network
		#2
		reset <= 1;
		#2
		reset <= 0;
		
		//Load in pixels
		#2
		inputsInbound <= 1;

		//Input pixel values
		inputPixel <= 0;  //index 0
		#2
		inputPixel <= 1;  //index 1
		#2
		inputPixel <= 1;  //index 2
		#2
		inputPixel <= 0;  //index 3
		#2
		inputPixel <= 1;  //index 4
		#2
		inputPixel <= 0;  //index 5
		#2
		inputsInbound <= 0;
		


		
		
	end

	//Clock toggling
	always begin
		#1  //2-step period
		clk <= ~clk;
	end
	

endmodule
