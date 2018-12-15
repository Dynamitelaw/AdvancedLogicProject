/*
 * This file describes the behaviour and IO of Layer 1. 
 * All modules needed for Layer 1 are instantiated here.
 */

`include "GlobalVariables.v"


module Layer1_Controller (
	//Inputs
		reset,
		//Timing
		clk, inputsReady, queueEmpty, outputsRecieved,
		//Memory updating
		weightWriteEnable, biasWriteEnable, WriteAddressSelect, writeIn, 
		//Data
		queueOut,

	//Outputs
		//Timing
		outputsReady, dequeue,
		//Data
		layer1Output
	);

	//Inputs
	input reset;
	input clk;
	input inputsReady;
	input queueEmpty;
	input outputsRecieved;

	input weightWriteEnable;
	input biasWriteEnable;
	input [9:0] WriteAddressSelect;
	input [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] writeIn; 

	input [9:0] queueOut;

	//Outputs
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

	reg pstoreReset = `TRUE;
	reg [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] pstoreInput;
	wire [`RELU_NODES*`LAYER_1_OUT_BIT_WIDTH-1:0] pstoreOutput;
	pStore plusStore(
		//Inputs
		.clk(clk), .clr(pstoreReset), .weightsIn(pstoreInput), //.biasesIn(writeIn), .biasWriteEnable(biasWriteEnable)
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
			outputsReady <= `FALSE;
			dequeue <= 0;
			processFinished <= `FALSE;
			idle <= `TRUE;
			wBuffer_A_Write <= `FALSE;
			wBuffer_A_Select <= `FALSE;
			wBuffer_B_Write <= `FALSE;
			wBuffer_B_Select <= `FALSE;
			pstoreReset <= `TRUE;
			reluTrigger <= `FALSE;
		end

		//---------------------------------------
		// Idle processing and wakeup
		//---------------------------------------

		else if (idle) begin
			//Wake up from idle if we have something we can process
			if ((clk) && (inputsReady == `TRUE) && (queueEmpty == `FALSE) && (outputsReady == `FALSE)) begin
				//The input layer is ready, and the output buffer of layer1 is empty. Ready to process
				processFinished <= `FALSE;
				idle <= `FALSE;

				//Start off with wBuffer A
				wBuffer_A_Write <= `TRUE;
				wBuffer_B_Write <= `FALSE;

				wBuffer_A_Select <= `FALSE;
				wBuffer_B_Select <= `TRUE;

				pstoreReset <= `FALSE;  //enable pstore
				dequeue <= 1; //Pull first set into A
			end

			if ((outputsReady == `TRUE) && (outputsRecieved == `TRUE)) begin
				//The next stage has recieved our outputs
				outputsReady <= `FALSE;
			end
		end

		//---------------------------------------
		// Steady-state and near-end processes
		//---------------------------------------

		else begin
			//The input queue is empty. Near end of processing stage
			if (queueEmpty) begin
				//Turn off buffer writes. 
				wBuffer_A_Write <= `FALSE;
				wBuffer_B_Write <= `FALSE;

				if (processFinished == `TRUE) begin
					//The input image has been processed by this stage

					layer1Output <= reluOutput;  //Store output of RELU to output buffer
					reluTrigger <= `FALSE;  

					outputsReady <= `TRUE;  //Notify next pipeline stage

					wBuffer_A_Select <= `FALSE;  //Turn off MUX feeding pstore
					wBuffer_B_Select <= `FALSE;

					pstoreReset <= `TRUE;  //reset pstore

					idle <= `TRUE;  //go into idle state
				end
			end

			//Steady-state Positive clock edge events
			if (clk) begin
				if ((inputsReady == `TRUE) && (queueEmpty == `FALSE)) begin
					dequeue <= 1;  //dequeue the next index
				end

				else if ((inputsReady == `TRUE) && (queueEmpty == `TRUE)) begin
					//This is the last pixel to be added. Get ready to shut down this pipeline stage
					reluTrigger <= `TRUE;
					processFinished <= `TRUE;
				end
			end

			//Steady-state Negative clock edge events
			if (~clk) begin
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
		end
	end
	

	//---------------------------------------
	// Constant processes
	//---------------------------------------
	//MUX for pstore inputs
	always @(wBuffer_A_Select or wBuffer_B_Select) begin : pstore_mux
		if (wBuffer_A_Select) begin
			pstoreInput <= wBuffer_A_Out;
		end
		else if (wBuffer_B_Select) begin
			pstoreInput <= wBuffer_B_Out;
		end
	end
		
	//MUX for weightStorage address
	always @(weightWriteEnable or biasWriteEnable or queueOut) begin : address_mux
		if ((weightWriteEnable) || (biasWriteEnable)) begin
			nodeAddress <= WriteAddressSelect;
		end
		else begin
			nodeAddress <= queueOut;
		end
	end

endmodule
