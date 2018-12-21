//GlobalVariables
`define TRUE 1
`define FALSE 0

`define QUEUE_MAX_SIZE 784  //Available storage elements in the input queue

`define INPUT_LAYER_NODES 784 //784

//`define LAYER_1_CLK_DIVIDER 1
`define LAYER_1_BIT_WIDTH 5
`define LAYER_1_OUT_BIT_WIDTH 7
`define RELU_NODES 32

//`define LAYER_2_CLK_DIVIDER 1
`define LAYER_2_IN_BIT_WIDTH 7
`define LAYER_2_WEIGHTS_BIT_WIDTH 6
`define LAYER_2_OUT_BIT_WIDTH 16
`define RELU_INDEX_WIDTH 6

`define SOFTMAX_IN_BIT_WIDTH 16

`define WRITE_IN_BIT_WIDTH 160  //must be greater than or equal to both L1 and L2 write ports


// Primary controller

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
	wire L2_InputsRecieved;
	reg L1_WeightWriteEnable;
	reg L1_BiasWriteEnable;
	wire [9:0] L1_WriteAddressSelect;
	wire [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] L1_WriteIn;
	wire L2_InputsReady;
	wire [`RELU_NODES*`LAYER_2_IN_BIT_WIDTH-1:0] L2_Input;
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



// Secondary controllers

 
 module InputLayerController (
 	//Inputs
 	reset, clk, inputsInbound, pixelValue, dequeue,
 	//Outputs
 	readyForInputs, outputsReady, indexOut, queueEmpty
 );
 	//Inputs
 	input reset;
 	input clk;
 	input inputsInbound;  //Outside world telling us that the pixelValue port is currently streaming pixel data
 	input pixelValue;
 	input dequeue;
 	
 	//Outputs
 	output readyForInputs;
 	reg readyForInputs = `TRUE;
 	
 	output outputsReady;
 	reg outputsReady = `FALSE;
 	
 	output indexOut;
 	wire [9:0] indexOut;
 	
 	output queueEmpty;
 	wire queueEmpty;
 	
 	
 	//Instantiate modules
 	reg resetQueue = `FALSE;
 	reg resetBuffer = `FALSE;
 	reg writeBuffer = `FALSE;
 	reg virginBuffer = `TRUE;  //State variable that indicates that the buffer has never been written to
 	reg queueBuffered = `FALSE;  //State variable that indicates if the queue has been recently buffered
 	wire inputQueueFull;
 	
 	InputQueueRegister queue(
		.clk(clk), 
		.resetInputQueue(resetQueue), 
		.resetBuffer(resetBuffer),
		.pixelValue(pixelValue),
		.dequeue(dequeue),
		.writeBufferEnable(writeBuffer),
		.finished(inputQueueFull),
		.indexOut(indexOut), 
		.queueEmpty(queueEmpty)
	);
 	
 	//--Module Behaviour--
 	always @(reset or inputsInbound or readyForInputs) begin : queueReset_proc
 		if (clk)
 			resetQueue <= reset || ((~inputsInbound) && (readyForInputs));
 	end


 	always @(posedge clk or posedge reset) begin : InputLayerController_proc
 		//Async reset
 		if (reset) begin
 			readyForInputs <= `TRUE;
 			resetBuffer <= `TRUE;
 			outputsReady <= `FALSE;
 			virginBuffer <= `TRUE;
 		end
 		
 		//Positive-edge clock events
 		else begin
 			//Buffer write handling
 			if (inputQueueFull) begin
 				//Input queue is full
 				readyForInputs <= `FALSE;
 				//Check to see if we can overwrite buffer
 				if ((queueEmpty) || (virginBuffer)) begin
 					writeBuffer <= `TRUE;
 					virginBuffer <= `FALSE;
 					queueBuffered <= `TRUE;
 					outputsReady <= `TRUE;
 				end
 			end
 			
 			//Queue reset handling
 			if (queueBuffered) begin
 				queueBuffered <= `FALSE;
 				writeBuffer <= `FALSE;
 				readyForInputs <= `TRUE;
 			end
 			
 			if (readyForInputs) begin
 				resetBuffer <= `FALSE;
 			end
 			
 		end

 	end
 	 	
 endmodule



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
	wire [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] wBuffer_A_Out;
	NodeWeightBank weightBuffer_A(
		//Inputs
		.writeEnable(wBuffer_A_Write), .writeIn(weightStorageBus), 
		//Outputs
		.readOut(wBuffer_A_Out)
	);

	reg pstoreReset = `TRUE;
	wire [`RELU_NODES*`LAYER_1_OUT_BIT_WIDTH-1:0] pstoreOutput;
	pStore plusStore(
		//Inputs
		.clk(clk), .clr(pstoreReset), .weightsIn(wBuffer_A_Out), .biasesIn(writeIn), .biasWriteEnable(biasWriteEnable),
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

	always @(posedge clk or posedge reset) begin : Layer1_proc
		//---------------------------------------
		// Async reset
		//---------------------------------------
		if (reset) begin
			outputsReady <= `FALSE;
			processFinished <= `FALSE;
			idle <= `TRUE;
			wBuffer_A_Write <= `FALSE;
			pstoreReset <= `TRUE;
			reluTrigger <= `FALSE;
		end

		else begin
			//---------------------------------------
			// Idle processing and wakeup
			//---------------------------------------
			if (idle) begin
				//Wake up from idle if we have something we can process
				if ((inputsReady == `TRUE) && (queueEmpty == `FALSE) && (outputsReady == `FALSE)) begin
					//The input layer is ready, and the output buffer of layer1 is empty. Ready to process
					processFinished <= `FALSE;
					idle <= `FALSE;
					wBuffer_A_Write <= `TRUE;
					pstoreReset <= `FALSE;  //enable pstore
					//reluTrigger <= `FALSE;
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
				//Steady-state Positive clock edge events
				if ((queueEmpty == `TRUE) && (processFinished == `FALSE)) begin
					//This is the last pixel to be added. Get ready to shut down this pipeline stage
					reluTrigger <= `TRUE;
					processFinished <= `TRUE;
				end
				
				//The input image has been processed by this stage
				if (processFinished == `TRUE) begin
					layer1Output <= reluOutput;  //Store output of RELU to output buffer
					reluTrigger <= `FALSE;  

					outputsReady <= `TRUE;  //Notify next pipeline stage
					pstoreReset <= `TRUE;  //reset pstore

					idle <= `TRUE;  //go into idle state
				end
			end
		end
	end
	

	//---------------------------------------
	// Constant processes
	//---------------------------------------

	//Dequeue control
	always @(inputsReady or queueEmpty or clk) begin : dequeue_proc
		dequeue = inputsReady && (~queueEmpty) && clk && (~outputsReady);
	end
		
	//MUX for weightStorage address
	always @(weightWriteEnable or biasWriteEnable or queueOut or WriteAddressSelect) begin : address_mux
		if ((weightWriteEnable) || (biasWriteEnable)) begin
			nodeAddress <= WriteAddressSelect;
		end
		else begin
			nodeAddress <= queueOut;
		end
	end

endmodule



/*
//The input queue is empty. Near end of processing stage
				if (queueEmpty) begin
					//Turn off buffer writes. 
					wBuffer_A_Write <= `FALSE;
					// wBuffer_B_Write <= `FALSE;
					*/



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
		.clk(clk), .clr(mstoreReset), .layer2In(queueValueOut), .weightsIn(weightStorageBus), .biasesIn(writeIn), .biasWriteEnable(biasWriteEnable),
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
			if ((inputsReady == `TRUE) && (outputsReady == `FALSE)) begin
				//The input layer is ready, and outputs have been recieved. Ready to process
				processFinished <= `FALSE;
				idle <= `FALSE;
				queueReset <= `FALSE;
				queueWriteEnable <= `TRUE;
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
				mstoreReset <= `TRUE;  //reset mstore

				idle <= `TRUE;  //go into idle state
			end

			//Steady-state Positive clock edge events
			if ((queueEmpty == `TRUE) && (processFinished == `FALSE)) begin
				//This is the relu node is being multiplied. Get ready to shut down this pipeline stage
				processFinished <= `TRUE;
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


// Weight Storage


module NodeWeightBank (
	//Inputs
	writeEnable, writeIn, 
	//Outputs
	readOut
);
	input writeEnable;
	input [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] writeIn;
	output [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] readOut;

	reg [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] readOut;

	always @(writeEnable, writeIn) begin
		if (writeEnable == `TRUE)
			readOut <= writeIn;  //Functions as a latch rather than a flip-flop to halve area cost of weight storage
	end

endmodule  //end NodeWeightBank


/*
 * Stores the weights for all input nodes
 */
module Layer1WeightStorage (
	//Inputs
	writeEnable, NodeSelect, writeIn, 
	//Outputs
	readOut
);
	input writeEnable;
	input [9:0] NodeSelect;
	input [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] writeIn;
	output [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] readOut;

	reg [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] readOut;

	//Define internal buses
	reg [`INPUT_LAYER_NODES-1:0] writeEnableBus;  //One-hot bus for writeEnables of NodeWeightBanks
	wire [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] readOutBus[`INPUT_LAYER_NODES-1:0];  //Output bus for reading

	//Instantiate all 784 instances of NodeWeightBank
	genvar i;
	generate
	    for (i=0; i<`INPUT_LAYER_NODES; i=i+1) begin : Generate_Node_Banks
		    NodeWeightBank NB (
		    	//Instance inputs
		        .writeEnable(writeEnableBus[i]), .writeIn(writeIn),
		        //Instance outputs
		        .readOut(readOutBus[i])
		    );
		end 
	endgenerate

	//Module behavior
	always @(writeEnable, NodeSelect) begin
		writeEnableBus = (writeEnable) ? (1 << NodeSelect) : `INPUT_LAYER_NODES 'b0 ;  //Decode NodeSelect onto the one-hot writeEnable bus
		readOut = readOutBus[NodeSelect];  //Mux for read output
	end

endmodule  //end Layer1WeightStorage

module ReluWeightBank (
	//Inputs
	writeEnable, writeIn, 
	//Outputs
	readOut
);
	input writeEnable;
	input [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] writeIn;
	output [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] readOut;

	reg [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] readOut;

	always @(writeEnable, writeIn) begin
		if (writeEnable == `TRUE)
			readOut <= writeIn;  //Functions as a latch rather than a flip-flop to halve area cost of weight storage
	end

endmodule  //end ReluWeightBank


/*
 * Stores the weights for all RELU nodes
 */
module Layer2WeightStorage (
	//Inputs
	writeEnable, NodeSelect, writeIn, 
	//Outputs
	readOut
);
	input writeEnable;
	input [`RELU_INDEX_WIDTH -1:0] NodeSelect;
	input [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] writeIn;
	output [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] readOut;

	reg [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] readOut;

	//Define internal buses
	reg [`RELU_NODES-1:0] writeEnableBus;  //One-hot bus for writeEnables of RelueWeightBanks
	wire [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] readOutBus[`RELU_NODES-1:0];  //Output bus for reading

	//Instantiate all instances of NodeWeightBank
	genvar i;
	generate
	    for (i=0; i<`RELU_NODES; i=i+1) begin : Generate_Node_Banks
		    ReluWeightBank NB (
		    	//Instance inputs
		        .writeEnable(writeEnableBus[i]), .writeIn(writeIn),
		        //Instance outputs
		        .readOut(readOutBus[i])
		    );
		end 
	endgenerate

	//Module behavior
	always @(writeEnable, NodeSelect) begin
		writeEnableBus = (writeEnable) ? (1 << NodeSelect) : `RELU_NODES 'b0 ;  //Decode NodeSelect onto the one-hot writeEnable bus
		readOut = readOutBus[NodeSelect];  //Mux for read output
	end

endmodule  //end Layer2WeightStorage




// Input queues


module InputQueueRegister (
 	//Inputs
 	clk, resetInputQueue, resetBuffer, pixelValue, dequeue, writeBufferEnable, 
 	//Outputs
 	finished, indexOut, queueEmpty
 );

 	input clk;    // Clock
 	input resetInputQueue;  // Asynchronous reset active high
 	input resetBuffer;
 	input pixelValue;
 	input dequeue;
 	input writeBufferEnable;

 	output finished;
 	reg finished = `FALSE;  //Flipped to TRUE when the last input pixel is read
 	
 	output [9:0] indexOut;  //The next index in the queue
 	reg [9:0] indexOut = 10'b0;
 	
 	output queueEmpty;  //Tells the controller when the queue has been emptied
 	reg queueEmpty = `FALSE;
 	
 	reg [9:0] indexCounter = 10'b0;  //counter that stores the index of the current input pixel
 	reg [9:0] queueEndPointer = 10'b0;  //index that points to the next available slot in the queue
 	reg [9:0] queueRegister[`QUEUE_MAX_SIZE-1:0];  //Array of registers to store the queue in
 	
 	reg [9:0] queueEndPointerBuffer = `QUEUE_MAX_SIZE;  //index that points to end of the queue buffer
 	reg [9:0] queueFrontPointerBuffer = 10'b0;  //index that points to the front of the queue buffer
 	reg [9:0] queueRegisterBuffer [`QUEUE_MAX_SIZE-1:0];  //Buffer the output queue


 	//--Module behavior--
 	
 	//Output buffering
 	integer i;
 	always @(posedge writeBufferEnable) begin : buffer_proc
		//Buffer input queue
		queueEndPointerBuffer <= queueEndPointer;
		for (i=0; i<`QUEUE_MAX_SIZE; i=i+1) begin
			queueRegisterBuffer[i] <= queueRegister[i];
		end
 	end
 	
 	//Input queueing
 	always @(posedge clk or posedge resetInputQueue) begin : proc_
 		//Async reset
 		if (resetInputQueue == `TRUE) begin
 			queueEndPointer <= 10'b0;	
 		end  			
 		
 		//Queue indexes on positive clock edges
 		else begin
 			if (finished == `FALSE) begin
		 		if (pixelValue == 1) begin
		 			queueRegister[queueEndPointer] = indexCounter;  //Store index of current pixel at the back of the queue. Intentionally blocking statement
		 			queueEndPointer <= queueEndPointer + 1;  //Increment queueEndPointer
		 		end
		 	end
 		end
 	end

	always @(negedge clk or posedge resetInputQueue) begin : proc_2
		if (resetInputQueue == `TRUE) begin
 			indexCounter <= 10'b0;	
 		end  
 		
 		//Increment indexCounter on negative clock edges
 		else begin
 			if (finished == `FALSE) begin
	 			indexCounter <= indexCounter + 1;
	 		end
 		end
 	end
 	
 	//Check for when last pixel has been passed
 	always @(indexCounter or resetInputQueue) begin : finished_proc
 		//Async reset
 		if (resetInputQueue == `TRUE) begin
 			finished <= `FALSE;
 		end

 		else if (indexCounter == `INPUT_LAYER_NODES) begin
 			finished <= `TRUE;
 		end
 	end
 	
 	//Dequeue handling
 	always @(posedge dequeue or posedge resetBuffer) begin : dequeue_pro_a
 		//Async reset
 		if (resetBuffer == `TRUE) begin
 			indexOut <= 10'b0;
 		end
 		else begin
 			indexOut <= queueRegisterBuffer[queueFrontPointerBuffer];
 		end
 	end

 	always @(negedge dequeue or posedge resetBuffer or posedge writeBufferEnable) begin : dequeue_pro_b
 		//Async reset
 		if (resetBuffer == `TRUE) begin
 			queueFrontPointerBuffer <= 10'b0;
 		end
 		
 		//Buffer queue
 		else if (writeBufferEnable) begin
 			queueFrontPointerBuffer <= 10'b0;
 		end

 		else begin
	 		if (queueEmpty == `FALSE) begin
	 			queueFrontPointerBuffer <= queueFrontPointerBuffer + 1;  //Increment queueFrontPointer on falling edge of dequeue
	 		end
	 	end
 	end
 
 	always @(queueFrontPointerBuffer or resetBuffer or writeBufferEnable) begin : dequeue_proc_c
 		//Async reset
 		if ((resetBuffer == `TRUE) || (writeBufferEnable)) begin
 			queueEmpty <= `FALSE;
 		end

 		else begin
			if (queueFrontPointerBuffer == queueEndPointerBuffer) begin
				queueEmpty <= `TRUE;  //Notify controller that the queue has been emptied
			end
		end
 	end
endmodule


module ReluNodeQueue (
 	//Inputs
 	reset, ReluNodeValues, dequeue, writeEnable,
 	//Outputs
 	indexOut, NodeValueOut, queueEmpty
 );
 
 	//Inputs
 	input reset;
 	input [`RELU_NODES*`LAYER_2_IN_BIT_WIDTH-1:0] ReluNodeValues;
 	input dequeue;
 	input writeEnable;
 	
 	//Outputs
 	output [`RELU_INDEX_WIDTH - 1:0] indexOut;
 	reg  [`RELU_INDEX_WIDTH - 1:0] indexOut = 0;
 	
 	output [`LAYER_2_IN_BIT_WIDTH-1:0] NodeValueOut;
 	reg [`LAYER_2_IN_BIT_WIDTH-1:0] NodeValueOut;
 	
 	output queueEmpty;
 	reg queueEmpty;
 	
 	//Convert 1D array input port ReluNodeValues to 2D internal bus
 	wire [`LAYER_2_IN_BIT_WIDTH-1:0] local_2D_Bus[`RELU_NODES-1:0];
	genvar i;
	for (i=0; i<`RELU_NODES; i=i+1) begin
		assign local_2D_Bus[`RELU_NODES-1-i] = ReluNodeValues[`LAYER_2_IN_BIT_WIDTH*i+`LAYER_2_IN_BIT_WIDTH-1:`LAYER_2_IN_BIT_WIDTH*i];
	end
 	
 	reg [`LAYER_2_IN_BIT_WIDTH-1:0] ReluQueueRegister [`RELU_NODES-1:0];  //register array to store RELU node values
 	reg [`RELU_INDEX_WIDTH - 1:0] frontPointer;
 	
 	//--ModuleBehaviour--
 	
 	//Write to the queue when writeEnable is set high
 	integer j;
 	always @(writeEnable or ReluNodeValues) begin : write_proc 		
 		//Write to the queue
 		if (writeEnable) begin
			//Buffer inputs
			for (j=0; j<`RELU_NODES; j=j+1) begin
				ReluQueueRegister[j] <= local_2D_Bus[j];
			end
		end
 	end
 	
 	//Dequeue node at posedge of dequeue
 	always @(posedge reset or posedge dequeue) begin : dequeue_proc
 		if (reset) begin
 			indexOut <= 0;
 			NodeValueOut <= 0;
 		end
 		
 		else begin
 			indexOut <= frontPointer;
 			NodeValueOut <= ReluQueueRegister[frontPointer];
 		end
 	end
 	
 	//Update frontPointer
 	always @(posedge reset or posedge writeEnable or negedge dequeue) begin : pointerShift_proc
 		if (reset) begin
 			frontPointer <= 0;
 		end
 		
 		else if (writeEnable) begin
 			frontPointer <= 0;
 		end
 		
 		else begin
 			frontPointer <= frontPointer + 1;
 		end
 	end
 	
 	//Find out when queue is empty
 	always @(frontPointer) begin : empty_proc
 		queueEmpty <= frontPointer == `RELU_NODES;
 	end
 	
 endmodule


// Arithmetic


module pStore (
	//Inputs
	clk, clr, weightsIn, biasesIn, biasWriteEnable,
	//Outputs
	sumOut
);

    input clk, clr, biasWriteEnable;
    input [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] weightsIn;
    input [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] biasesIn;
    output [`RELU_NODES*`LAYER_1_OUT_BIT_WIDTH-1:0] sumOut;

	genvar m;
	generate
		for(m = 0; m<`RELU_NODES; m=m+1)
		begin:addWeight
			stored_addern add(.clr(clr),
					  .clk(clk),
					  .X(weightsIn[m*`LAYER_1_BIT_WIDTH + `LAYER_1_BIT_WIDTH - 1:m*`LAYER_1_BIT_WIDTH]),
					  .B(biasesIn[m*`LAYER_1_BIT_WIDTH + `LAYER_1_BIT_WIDTH - 1:m*`LAYER_1_BIT_WIDTH]),
					  .S(sumOut[m*`LAYER_1_OUT_BIT_WIDTH + `LAYER_1_OUT_BIT_WIDTH - 1:m*`LAYER_1_OUT_BIT_WIDTH]),
					  .biasWriteEnable(biasWriteEnable)
						);
		end
	endgenerate

	
endmodule  //end pStore

module stored_addern (clr, clk, X, S, B, biasWriteEnable);
	input clk, clr, biasWriteEnable;
	input [`LAYER_1_BIT_WIDTH - 1:0] X;
	input [`LAYER_1_BIT_WIDTH - 1:0] B;
	output reg [`LAYER_1_OUT_BIT_WIDTH - 1:0] S = 'b0; // initialize sumOut
	reg [`LAYER_1_OUT_BIT_WIDTH - 1:0] s;
	reg [`LAYER_1_OUT_BIT_WIDTH - 1:0] X2;
	reg [`LAYER_1_OUT_BIT_WIDTH - 1:0] biasesStored = 'b0;
	integer k;
	integer j;
	
	// Store biases locally and sign extend
	always @(biasWriteEnable or B)
	begin
		if (biasWriteEnable) begin
			biasesStored[`LAYER_1_BIT_WIDTH - 1:0] <= B;
			for(j = `LAYER_1_BIT_WIDTH;j < `LAYER_1_OUT_BIT_WIDTH;j = j+1)
				if (B[`LAYER_1_BIT_WIDTH - 1])
					biasesStored[j] <= 1;
				else
					biasesStored[j] <= 0;
		end
	end

	// Pad input with 1s or 0s according to its sign (sign extension)
	always @(X)
	begin
		X2[`LAYER_1_BIT_WIDTH - 1:0] <= X;
		for(k = `LAYER_1_BIT_WIDTH;k < `LAYER_1_OUT_BIT_WIDTH;k = k+1)
			if (X[`LAYER_1_BIT_WIDTH - 1])
				X2[k] <= 1;
			else
				X2[k] <= 0;
	end
	
	// Add and store padded weights
	always @(posedge clr, posedge clk)
	begin
		if (clr == 1) S <= biasesStored;
		else S <= s;
	end
	always @(*)
		s <= S + X2;
		// make overflow detection
	
endmodule


module RELU (
	//Inputs
	sumIn, trigger,
	//Outputs
	layer1Out);

	input trigger;
	input [`RELU_NODES*`LAYER_1_OUT_BIT_WIDTH-1:0] sumIn;
	output [`RELU_NODES*`LAYER_2_IN_BIT_WIDTH-1:0] layer1Out;
	genvar k;

	//passes value if it is positive and when trigger is high
	generate
		for(k = 0;k < `RELU_NODES;k = k + 1)
		begin:RnR
			RectAndReduce RnR(.trigger(trigger),
					  .X(sumIn[(k+1)*`LAYER_1_OUT_BIT_WIDTH - 1:k*`LAYER_1_OUT_BIT_WIDTH]),
				  	  .Y(layer1Out[(k+1)*`LAYER_2_IN_BIT_WIDTH - 1:k*`LAYER_2_IN_BIT_WIDTH]));
		end
	endgenerate
endmodule

module RectAndReduce(X,Y,trigger);
	input trigger;
	input [`LAYER_1_OUT_BIT_WIDTH-1:0] X;
	output reg [`LAYER_2_IN_BIT_WIDTH-1:0] Y;

	always @(X,trigger)
		if (~X[`LAYER_1_OUT_BIT_WIDTH - 1] & trigger)
		Y = X[`LAYER_1_OUT_BIT_WIDTH-1:`LAYER_1_OUT_BIT_WIDTH-`LAYER_2_IN_BIT_WIDTH];
		else
		Y = 'b0;
endmodule


module multStore (
	//Inputs
	clk, clr, layer2In, weightsIn, biasesIn, biasWriteEnable,
	//Outputs
	sumOut
);

        input clk, clr, biasWriteEnable;
        input [`LAYER_2_IN_BIT_WIDTH-1:0] layer2In;
	input [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] weightsIn;
	input [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] biasesIn;
        output [10*`LAYER_2_OUT_BIT_WIDTH-1:0] sumOut;

	genvar m;
	generate
		for(m = 0; m<10; m=m+1)
		begin
			MAC mac(.clr(clr),
				.clk(clk),
				.X(weightsIn[m*`LAYER_2_WEIGHTS_BIT_WIDTH + `LAYER_2_WEIGHTS_BIT_WIDTH - 1:m*`LAYER_2_WEIGHTS_BIT_WIDTH]),
				.M(layer2In),
				.B(biasesIn[m*`LAYER_2_WEIGHTS_BIT_WIDTH + `LAYER_2_WEIGHTS_BIT_WIDTH - 1:m*`LAYER_2_WEIGHTS_BIT_WIDTH]),
				.S(sumOut[m*`LAYER_2_OUT_BIT_WIDTH + `LAYER_2_OUT_BIT_WIDTH - 1:m*`LAYER_2_OUT_BIT_WIDTH]),
				.biasWriteEnable(biasWriteEnable)
			);
		end
	endgenerate

	
endmodule

module MAC (clr, clk, X, M, S, B, biasWriteEnable);
	input clk, clr, biasWriteEnable;
	input [`LAYER_2_WEIGHTS_BIT_WIDTH - 1:0] X;
	input [`LAYER_2_IN_BIT_WIDTH - 1:0] M;
	input [`LAYER_2_WEIGHTS_BIT_WIDTH - 1:0] B;
	output reg [`LAYER_2_OUT_BIT_WIDTH - 1:0] S = 'b0; // initialize sumOut
	reg [`LAYER_2_OUT_BIT_WIDTH - 1:0] s;
	reg [`LAYER_2_OUT_BIT_WIDTH - 1:0] X2;
	reg [`LAYER_2_OUT_BIT_WIDTH - 1:0] biasesStored = 'b0;
	integer k;
	
	// Store biases locally
	always @(biasWriteEnable or B)
	begin
		if (biasWriteEnable) begin
			biasesStored[`LAYER_2_WEIGHTS_BIT_WIDTH - 1:0] <= B;
			for(k = `LAYER_2_WEIGHTS_BIT_WIDTH;k < `LAYER_2_OUT_BIT_WIDTH;k = k+1)
				if (B[`LAYER_2_WEIGHTS_BIT_WIDTH - 1])
					biasesStored[k] <= 1;
				else
					biasesStored[k] <= 0;
		end
	end

	// Pad input with 1s or 0s according to its sign
	always @(X)
	begin
		X2[`LAYER_2_WEIGHTS_BIT_WIDTH - 1:0] = X;
		for(k = `LAYER_2_WEIGHTS_BIT_WIDTH;k < `LAYER_2_OUT_BIT_WIDTH;k = k+1)
			if (X[`LAYER_2_WEIGHTS_BIT_WIDTH - 1])
				X2[k] = 1;
			else
				X2[k] = 0;
	end
	
	// Add and store padded weights
	always @(posedge clr, posedge clk)
	begin
		if (clr == 1) S <= biasesStored;
		else S <= s;
	end
	
	always @(*)
		s <= S + X2*M;
		// make overflow detection
	
endmodule


module softMax (
	//Inputs
	sumIn,
	//Outputs
	result
);
	input [10*`SOFTMAX_IN_BIT_WIDTH-1:0] sumIn;
	output [3:0] result;
	//output [`SOFTMAX_IN_BIT_WIDTH-1+4:0] result;
	wire [`SOFTMAX_IN_BIT_WIDTH-1 +4:0] A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,C0,C1,D0,E0;

	assign A0 = {4'b0000,sumIn[10*`SOFTMAX_IN_BIT_WIDTH-1:9*`SOFTMAX_IN_BIT_WIDTH]};
	assign A1 = {4'b0001,sumIn[9*`SOFTMAX_IN_BIT_WIDTH-1:8*`SOFTMAX_IN_BIT_WIDTH]};
	assign A2 = {4'b0010,sumIn[8*`SOFTMAX_IN_BIT_WIDTH-1:7*`SOFTMAX_IN_BIT_WIDTH]};
	assign A3 = {4'b0011,sumIn[7*`SOFTMAX_IN_BIT_WIDTH-1:6*`SOFTMAX_IN_BIT_WIDTH]};
	assign A4 = {4'b0100,sumIn[6*`SOFTMAX_IN_BIT_WIDTH-1:5*`SOFTMAX_IN_BIT_WIDTH]};
	assign A5 = {4'b0101,sumIn[5*`SOFTMAX_IN_BIT_WIDTH-1:4*`SOFTMAX_IN_BIT_WIDTH]};
	assign A6 = {4'b0110,sumIn[4*`SOFTMAX_IN_BIT_WIDTH-1:3*`SOFTMAX_IN_BIT_WIDTH]};
	assign A7 = {4'b0111,sumIn[3*`SOFTMAX_IN_BIT_WIDTH-1:2*`SOFTMAX_IN_BIT_WIDTH]};
	assign A8 = {4'b1000,sumIn[2*`SOFTMAX_IN_BIT_WIDTH-1:1*`SOFTMAX_IN_BIT_WIDTH]};
	assign A9 = {4'b1001,sumIn[`SOFTMAX_IN_BIT_WIDTH-1:0]};

	// Compare first vector (neighbors)
	compare comp1(.X(A0),.Y(A1),.Out(B0));
	compare comp2(.X(A2),.Y(A3),.Out(B1));
	compare comp3(.X(A4),.Y(A5),.Out(B2));
	compare comp4(.X(A6),.Y(A7),.Out(B3));
	compare comp5(.X(A8),.Y(A9),.Out(B4));

	// Compare second vector
	compare comp6(.X(B0),.Y(B1),.Out(C0));
	compare comp7(.X(B2),.Y(B3),.Out(C1));
	
	// Compare third and carry from first compare
	compare comp8(.X(C0),.Y(C1),.Out(D0));
	compare comp9(.X(B4),.Y(D0),.Out(E0));

	assign result = E0[`SOFTMAX_IN_BIT_WIDTH-1 +4:`SOFTMAX_IN_BIT_WIDTH];
	//assign result = E0;//[`SOFTMAX_IN_BIT_WIDTH-1 +4:`SOFTMAX_IN_BIT_WIDTH];

endmodule

module compare(X,Y,Out);
	input [`SOFTMAX_IN_BIT_WIDTH-1+4:0] X,Y;
	output reg [`SOFTMAX_IN_BIT_WIDTH-1+4:0] Out;

	always @(X,Y)
		//X is negative and Y is positive
		if ((X[`SOFTMAX_IN_BIT_WIDTH - 1] == 1) && ((Y[`SOFTMAX_IN_BIT_WIDTH - 1] == 0))) begin
			Out <= Y;
		end
		//X is positive and Y is negative
		else if ((X[`SOFTMAX_IN_BIT_WIDTH - 1] == 0) && ((Y[`SOFTMAX_IN_BIT_WIDTH - 1] == 1))) begin
			Out <= X;
		end
		//X and Y have same sign -> regular comparison can be used
		else begin
			if (X[`SOFTMAX_IN_BIT_WIDTH-1:0] >= Y[`SOFTMAX_IN_BIT_WIDTH-1:0])
				Out <= X;
			else
				Out <= Y;	
		end
endmodule
