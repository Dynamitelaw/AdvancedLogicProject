/*
 * Controller for the entire Neural Network.
 */
 
`include "GlobalVariables.v"


module NN_Controler(
	//Inputs
	 	reset, 
	 	//Timing
	 	masterClk, inputsInbound, predictionRecieved,
	 	//Data
	 	inputPixel, weightWriteEnable, biasWriteEnable, LayerWriteSelect, WriteAddressSelect, writeIn,
	 //Outputs
	 	//Timing
	 	predictionReady, readyForInputs,
	 	//Data
	 	predictionOut
);

	//Inputs
 	input reset; 
 	input masterClk;
 	
 	input inputsInbound; 
 	input predictionRecieved;
 	
 	input inputPixel; 
 	input weightWriteEnable; 
 	input biasWriteEnable; 
 	input LayerWriteSelect;
 	input [9:0] WriteAddressSelect;
 	input [`WRITE_IN_BIT_WIDTH-1:0] writeIn;
	 
	//Outputs
 	output predictionReady;
 	wire predictionReady;
 	
 	output readyForInputs;
 	wire readyForInputs;
 	
 	output [3:0] predictionOut;
 	wire [3:0] predictionOut;
	
		
	//--Instantiate modules--
	
	//Input layer
	wire dequeue;
	wire L1_InputsReady;
	wire [9:0] indexOut;
	wire queueEmpty;
	InputLayerController InputLayer(
		//Inputs
 	 	.reset(reset), 
 	 	.clk(masterClk), 
 	 	.inputsInbound(inputsInbound), 
 	 	.pixelValue(inputPixel), 
 	 	.dequeue(dequeue),
 	 	.readyForInputs(readyForInputs), 
 	 	//Outputs
 	 	.outputsReady(L1_InputsReady), 
 	 	.indexOut(indexOut), 
 	 	.queueEmpty(queueEmpty)
 	);
 	
 	//Layer1
 	wire Layer1CLK;  //change to reg if doing clock division
 	wire L1_OutputsReady;
	wire [`RELU_NODES*`LAYER_2_IN_BIT_WIDTH-1:0] layer1Output;
	wire L2_InputsRecieved;
	reg L1_WeightWriteEnable;
	reg L1_BiasWriteEnable;
	wire [9:0] L1_WriteAddressSelect;
	wire [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] L1_WriteIn;
	wire L2_InputsReady;
	wire L2_Input;
 	Layer1_Controller Layer1(
 		//Inputs
		.reset(reset),
		.clk(Layer1CLK), 
		.inputsReady(L1_InputsReady), 
		.queueEmpty(queueEmpty), 
		.outputsRecieved(L2_InputsRecieved),
		.weightWriteEnable(L1_WeightWriteEnable), 
		.biasWriteEnable(L1_BiasWriteEnable), 
		.WriteAddressSelect(L1_WriteAddressSelect), 
		.writeIn(L1_WriteIn),
		.queueOut(indexOut),
		//Outputs
		.outputsReady(L2_InputsReady), 
		.dequeue(dequeue),
		.layer1Output(L2_Input)
	);
	
	//Layer2/Output
	wire Layer2CLK;
	reg L2_WeightWriteEnable;
	reg L2_BiasWriteEnable;
	wire [`RELU_INDEX_WIDTH-1:0] L2_WriteAddressSelect;
	wire [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] L2_WriteIn;
	Layer2_Controller Layer2(
		//Inputs
		.reset(reset),
		.clk(Layer2CLK), 
		.inputsReady(L2_InputsReady), 
		.outputsRecieved(predictionRecieved),
		.weightWriteEnable(L2_WeightWriteEnable), 
		.biasWriteEnable(L2_BiasWriteEnable), 
		.WriteAddressSelect(L2_WriteAddressSelect), 
		.writeIn(L2_WriteIn), 
		.layer2Input(L2_Input),
		//Outputs
		.inputsRecieved(L2_InputsRecieved), 
		.outputsReady(predictionReady),
		.predictionOutput(predictionOut)
	);
		
	
	//--Module Behaviour--
	
	//Clock control
	assign Layer1CLK = masterClk;
	assign Layer2CLK = masterClk;
	//<TODO> Impliment this if we have time
	//	Step down master clock frequency for slower modules
	
	//Write control
	assign L1_WriteIn = writeIn[`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0];
	assign L1_WriteAddressSelect = WriteAddressSelect;
	
	assign L2_WriteIn = writeIn[10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0];
	assign L2_WriteAddressSelect = WriteAddressSelect[`RELU_INDEX_WIDTH-1:0];
	
	always @(weightWriteEnable or biasWriteEnable or LayerWriteSelect) begin : write_control
		//Layer 1 has been selected
		if (LayerWriteSelect == 0) begin
			L1_WeightWriteEnable <= weightWriteEnable;
			L1_BiasWriteEnable <= biasWriteEnable;
			
			L2_WeightWriteEnable <= `FALSE;
			L2_BiasWriteEnable <= `FALSE;
		end
		
		//Layer 2 has been selected
		else if (LayerWriteSelect == 1) begin
			L1_WeightWriteEnable <= `FALSE;
			L1_BiasWriteEnable <= `FALSE;
			
			L2_WeightWriteEnable <= weightWriteEnable;
			L2_BiasWriteEnable <= biasWriteEnable;
		end
	end
	
	
endmodule
