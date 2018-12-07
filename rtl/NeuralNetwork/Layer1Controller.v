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

	reg moduleClk; //internal clock variable used for clock gating
	reg clockEnable = `FALSE;

	reg readyForInputs = `TRUE;


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
	wire [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] wBuffer_A_Out;
	NodeWeightBank weightBuffer_A(
		//Inputs
		.writeEnable(wBuffer_A_Write), .writeIn(weightStorageBus), 
		//Outputs
		.readOut(wBuffer_A_Out)
	);

	reg wBuffer_B_Write = `FALSE;
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


	//--Module Behaviour--

	//Clock gating
	always begin : clockGate_proc
		assign moduleClk = clk & clockEnable;
	end

	//Controller behaviour
	always @(posedge clk or negedge clk or posedge reset or weightWriteEnable or biasWriteEnable) begin : proc_
		//Async reset
		if (reset) begin
			//reset layer 1
		end 

		//Positive clock edge events
		else if (clk) begin
			if (readyForInputs == `TRUE) begin
				if ((queueFinished == `TRUE) && (queueEmpty == `FALSE)) begin
					dequeue <= 1;
				end
			end
		end

		//Negative clock edge events
		else begin
			dequeue <= 0;
			//Switch between weight buffers
			wBuffer_A_Write <= ~wBuffer_B_Write;
			wBuffer_B_Write <= ~wBuffer_B_Write;

		end

		//MUX for pstore inputs
		if (wBuffer_A_Write) begin
			pstoreInput <= wBuffer_B_Out;
		end
		else if (wBuffer_B_Write) begin
			pstoreInput <= wBuffer_A_Out;
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