/*
 * Test bench for Layer1Controller
 *
 * Tested using INPUT_LAYER_NODES = 10
 */

`include "InputLayerControler.v"
`include "Layer1Controller.v"


module TEST_Layer1Controller ;
	//Instantiate modules
	reg reset = 0;
	reg clk;
	reg inputsInbound = 0;
	reg inputPixel;
	wire dequeue;

	wire readyForInputs;
	wire L1InputsReady;
	wire [9:0] indexOut;
	wire queueEmpty;

	InputLayerController InputLayer(
		//Inputs
 	 	.reset(reset), 
 	 	.clk(clk), 
 	 	.inputsInbound(inputsInbound), 
 	 	.pixelValue(inputPixel), 
 	 	.dequeue(dequeue),
 	 	.readyForInputs(readyForInputs), 
 	 	//Outputs
 	 	.outputsReady(L1InputsReady), 
 	 	.indexOut(indexOut), 
 	 	.queueEmpty(queueEmpty)
 	);


	reg outputsRecieved = `FALSE;
	reg weightWriteEnable = `FALSE;
	reg biasWriteEnable = `FALSE;
	reg [9:0] WriteAddressSelect;
	reg [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] writeIn;

	wire outputsReady;
	wire [`RELU_NODES*`LAYER_2_IN_BIT_WIDTH-1:0] layer1Output;
 	Layer1_Controller Layer1(
 		//Inputs
		.reset(reset),
		.clk(clk), 
		.inputsReady(L1InputsReady), 
		.queueEmpty(queueEmpty), 
		.outputsRecieved(outputsRecieved),
		.weightWriteEnable(weightWriteEnable), 
		.biasWriteEnable(biasWriteEnable), 
		.WriteAddressSelect(WriteAddressSelect), 
		.writeIn(writeIn),
		.queueOut(indexOut),
		//Outputs
		.outputsReady(outputsReady), 
		.dequeue(dequeue),
		.layer1Output(layer1Output)
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
		WriteAddressSelect = 10'b0000000000;  //node 
		weightWriteEnable <= 1;
		writeIn <= 8'b00110000;  //(3,0)
		#1
		weightWriteEnable <= 0;

		#2
		WriteAddressSelect = 10'b0000000001;  //node1
		weightWriteEnable <= 1;
		writeIn <= 8'b01010110;  //(5,6)
		#1
		weightWriteEnable <= 0;

		#2
		WriteAddressSelect = 10'b0000000010;  //node2
		weightWriteEnable <= 1;
		writeIn <= 8'b00011001;  //(1,-7)
		#1
		weightWriteEnable <= 0;

		#2
		WriteAddressSelect = 10'b0000000011;  //node3
		weightWriteEnable <= 1;
		writeIn <= 8'b01010010;  //(5,2)
		#1
		weightWriteEnable <= 0;

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
		inputsInbound <= 0;


		//Check Layer1Output
		#50
		if (layer1Output == 8'b01100000) begin  //(6,0)
			success <= `TRUE;
		end

	end

	//Clock toggling
	always begin
		#1  //2-step period
		clk <= ~clk;
	end
	

endmodule
