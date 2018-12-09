/*
 * This file describes the behaviour and IO of Layer 1. 
 * All modules needed for Layer 1 are instantiated here.
 */

`include "GlobalVariables.v"


module Layer1_Controller (
	//Inputs
		//Timing
		clk, queueFinished, queueEmpty, outputsRecieved
		//Memory updating
		weightWriteEnable, biasWriteEnable, WriteAddressSelect, writeIn, 
		//Data
		queueOut,

	//Outputs
		//Timing
		inputsRecieved, outputsReady, dequeue,
		//Data
		layer1Output
	);

	//Inputs
	input clk, input queueFinished, input queueEmpty, input outputsRecieved;

	input weightWriteEnable, input biasWriteEnable;
	input [9:0] WriteAddressSelect;
	input [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] writeIn; 

	input [9:0] queueOut;

	//Outputs
	output inputsRecieved;
	reg inputsRecieved = `FALSE;
	output outputsReady;
	reg outputsReady = `FALSE;

	output dequeue;
	reg dequeue = 0;

	output [`RELU_NODES*`LAYER_2_IN_BIT_WIDTH-1:0] layer1Output;
	reg [`RELU_NODES*`LAYER_2_IN_BIT_WIDTH-1:0] layer1Output;  //buffer layer1Output to allow for async pipeline

	//Internal variables
	reg processFinished = `FALSE;
	reg idle = `TRUE;


	//--Instantiate modules--

	reg [9:0] nodeAddress;
	wire [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] weightStorageBus;
	Layer1WeightStorage weightStorage(
		//Inputs
		.writeEnable(weightWriteEnable), .NodeSelect(nodeAddress), .writeIn(writeIn), 
		//Outputs
		.readOut(weightStorageBus)
	);

	reg wBuffer_A_Write = `FALSE;
	reg wBuffer_A_Select = `FALSE;
	wire [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] wBuffer_A_Out;
	NodeWeightBank weightBuffer_A(
		//Inputs
		.writeEnable(wBuffer_A_Write), .writeIn(weightStorageBus), 
		//Outputs
		.readOut(wBuffer_A_Out)
	);

	reg wBuffer_B_Write = `FALSE;
	reg wBuffer_B_Select = `FALSE;
	wire [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] wBuffer_B_Out;
	NodeWeightBank weightBuffer_B(
		//Inputs
		.writeEnable(wBuffer_B_Write), .writeIn(weightStorageBus), 
		//Outputs
		.readOut(wBuffer_B_Out)
	);

	reg pstoreReset = `FALSE;
	wire [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] pstoreInput;
	wire [`RELU_NODES*`LAYER_1_OUT_BIT_WIDTH-1:0] pstoreOutput;
	pStore plusStore(
		//Inputs
		.clk(moduleClk), .clr(pstoreReset), .weightsIn(pstoreInput), //.biasesIn(writeIn), .biasWriteEnable(biasWriteEnable)
		//Outputs
		.sumOut(pstoreOutput)
	);

	reg reluTrigger = `FALSE;
	wire [`RELU_NODES*`LAYER_2_IN_BIT_WIDTH-1:0] reluOutput;
	RELU relu(
		//Inputs
		.sumIn(pstoreOutput), .trigger(reluTrigger),
		//Outputs
		.layer1Out(reluOutput)
	);


	//--Controller behaviour--

	always @(posedge clk or negedge clk or posedge reset or posedge queueEmpty or weightWriteEnable or biasWriteEnable) begin : Layer1_proc
		//---------------------------------------
		// Async reset
		//---------------------------------------
		if (reset) begin
			//reset layer 1
		end

		//---------------------------------------
		// Idle processing and wakeup
		//---------------------------------------

		else if (idle) begin
			//Wake up from idle if we have something we can process
		end

		//---------------------------------------
		// Steady-state and near-end processes
		//---------------------------------------

		//The input queue is empty. Near end of processing stage
		else if (queueEmpty) begin
			//Turn off buffer writes. 
			wBuffer_A_Write <= `FALSE;
			wBuffer_B_Write <= `FALSE;

			if (processFinished == `TRUE) begin
				//The input image has been processed by this stage

				layer1Output <= reluOutput;  //Store output of RELU to output buffer
				reluTrigger <= `FALSE;  

				outputsReady <= `TRUE;  //Notify next pipeline stage
				inputsRecieved <= `TRUE;  //Notify previous pipeline stage

				wBuffer_A_Select <= `FALSE;  //Turn off MUX feeding pstore
				wBuffer_B_Select <= `FALSE;

				pstoreReset <= `TRUE;  //reset pstore

				idle <= `TRUE;  //go into idle state
			end
		end

		//Steady-state Positive clock edge events
		else if (clk) begin
			if ((queueFinished == `TRUE) && (queueEmpty == `FALSE)) begin
				dequeue <= 1;  //dequeue the next index
			end

			else if ((queueFinished == `TRUE) && (queueEmpty == `TRUE)) begin
				//This is the last pixel to be added. Get ready to shut down this pipeline stage
				reluTrigger <= `TRUE;
				processFinished <= `TRUE;
			end
		end

		//Steady-state Negative clock edge events
		else if (~clk) begin
			dequeue <= 0;

			//Switch between weight buffers writing
			if (queueEmpty == `FALSE) begin
				wBuffer_A_Write <= ~wBuffer_A_Write;
				wBuffer_B_Write <= ~wBuffer_B_Write;
			end

			//Switch between bufferOutputs to pStore
			wBuffer_A_Select <= ~wBuffer_A_Select;
			wBuffer_B_Select <= ~wBuffer_B_Select;
		end

		//---------------------------------------
		// Constant processes
		//---------------------------------------

		//MUX for pstore inputs
		if (wBuffer_A_Select) begin
			pstoreInput <= wBuffer_A_Out;
		end
		else if (wBuffer_B_Select) begin
			pstoreInput <= wBuffer_B_Out;
		end
		
		//MUX for weightStorage address
		if (weightWriteEnable or biasWriteEnable) begin
			nodeAddress <= WriteAddressSelect;
		end
		else begin
			nodeAddress <= queueOut;
		end
	end

endmodule