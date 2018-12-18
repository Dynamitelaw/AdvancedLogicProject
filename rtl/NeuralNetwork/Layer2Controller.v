/*
 * This file describes the behaviour and IO of Layer 2. 
 * All modules needed for Layer 2 are instantiated here.
 */

`include "GlobalVariables.v"


module Layer2_Controller (
	//Inputs
		reset,
		//Timing
		clk, inputsReady, outputsRecieved,
		//Memory updating
		weightWriteEnable, biasWriteEnable, WriteAddressSelect, writeIn, 
		//Data
		layer2Input,

	//Outputs
		//Timing
		inputsRecieved, outputsReady,
		//Data
		predictionOutput
	);

	//Inputs
	input reset;
	input clk;
	input inputsReady;
	input outputsRecieved;

	input weightWriteEnable;
	input biasWriteEnable;
	input [`RELU_INDEX_WIDTH-1:0] WriteAddressSelect;
	input [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] writeIn; 
	
	input [`RELU_NODES*`LAYER_2_IN_BIT_WIDTH-1:0] layer2Input;

	//Outputs
	output inputsRecieved;
	reg inputsRecieved = `FALSE;
	
	output outputsReady;
	reg outputsReady = `FALSE;

	output [3:0] predictionOutput;
	reg [3:0] predictionOutput;  //buffer layer1Output to allow for async pipeline

	//Internal variables
	reg processFinished = `FALSE;
	reg idle = `TRUE;


	//--Instantiate modules--

	reg [`RELU_INDEX_WIDTH-1:0] nodeAddress;
	wire [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] weightStorageBus;
	Layer2WeightStorage weightStorage(
		//Inputs
		.writeEnable(weightWriteEnable), .NodeSelect(nodeAddress), .writeIn(writeIn), 
		//Outputs
		.readOut(weightStorageBus)
	);

	reg queueReset;
	reg dequeue;
	reg queueWriteEnable;
	wire [`RELU_INDEX_WIDTH-1:0] queueIndexOut;
	wire [`LAYER_2_IN_BIT_WIDTH-1:0] queueValueOut;
	wire queueEmpty;
	ReluNodeQueue queue(
	 	//Inputs
	 	.reset(queueReset), .ReluNodeValues(layer2Input), .dequeue(dequeue), .writeEnable(queueWriteEnable),
	 	//Outputs
	 	.indexOut(queueIndexOut), .NodeValueOut(queueValueOut), .queueEmpty(queueEmpty)
 	);
 	
 	reg mstoreReset;
 	wire [10*`LAYER_2_OUT_BIT_WIDTH-1:0] mstoreOutput;
 	multStore multStore(
		//Inputs
		.clk(clk), .clr(mstoreReset), .layer2In(queueValueOut), .weightsIn(weightStorageBus), //biasesIn,
		//Outputs
		.sumOut(mstoreOutput)
	);
	
	wire [3:0] softmaxOutput;
	softMax softMax(
		//Inputs
		.sumIn(mstoreOutput),
		//Outputs
		.result(softmaxOutput)
	);


	//--Controller behaviour--

	always @(posedge clk or posedge reset) begin : Layer2_proc
		//---------------------------------------
		// Async reset
		//---------------------------------------
		if (reset) begin
			inputsRecieved <= `FALSE;
			outputsReady <= `FALSE;
			processFinished <= `FALSE;
			idle <= `TRUE;
			queueWriteEnable <= `FALSE;
			mstoreReset <= `TRUE;
			queueReset <= `TRUE;
		end

		//---------------------------------------
		// Idle processing and wakeup
		//---------------------------------------

		else if (idle) begin
			//Wake up from idle if we have something we can process
			if ((clk) && (inputsReady == `TRUE) && (outputsReady == `FALSE)) begin
				//The input layer is ready, and outputs have been recieved. Ready to process
				processFinished <= `FALSE;
				idle <= `FALSE;
				queueReset <= `FALSE;
				queueWriteEnable <= `TRUE;
				//mstoreReset <= `FALSE;  //enable mstore
			end

			if ((outputsReady == `TRUE) && (outputsRecieved == `TRUE)) begin
				//The user has recieved our outputs
				outputsReady <= `FALSE;
			end
		end

		//---------------------------------------
		// Steady-state and near-end processes
		//---------------------------------------

		else begin
			queueWriteEnable <= `FALSE;
			mstoreReset <= `FALSE;  //enable mstore
			//Data ack handling
			if (inputsRecieved == `FALSE) begin
				inputsRecieved <= `TRUE;
			end
			else if ((inputsRecieved == `TRUE) && (inputsReady == `FALSE)) begin
				//Previous stage recieved our ACK. Reset inputsRecieved
				inputsRecieved <= `FALSE;
			end
			
			//End of job handling
			if (processFinished == `TRUE) begin
				//The layer has been processed by this stage

				predictionOutput <= softmaxOutput;  //Store output of RELU to output buffer 

				outputsReady <= `TRUE;  //Notify user
				mstoreReset <= `TRUE;  //reset mstre

				idle <= `TRUE;  //go into idle state
			end

			//Steady-state Positive clock edge events
			if (clk) begin
				if ((queueEmpty == `TRUE) && (processFinished == `FALSE)) begin
					//This is the relu node is being multiplied. Get ready to shut down this pipeline stage
					processFinished <= `TRUE;
				end
			end
		end
	end
	

	//---------------------------------------
	// Constant processes
	//---------------------------------------
	
	//Dequeue control
	always @(queueEmpty or clk or outputsReady or idle) begin : dequeue_proc
		dequeue = (~queueEmpty) && clk && (~mstoreReset) && (~idle);
	end
		
	//MUX for weightStorage address
	always @(weightWriteEnable or biasWriteEnable or queueIndexOut or WriteAddressSelect) begin : address_mux
		if ((weightWriteEnable) || (biasWriteEnable)) begin
			nodeAddress <= WriteAddressSelect;
		end
		else begin
			nodeAddress <= queueIndexOut;
		end
	end

endmodule
