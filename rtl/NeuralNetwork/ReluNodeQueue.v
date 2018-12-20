/*
 * This module buffers the output of Layer1, and fuctions as a queue to feed the multStore module.
 * Queue also serves indexes to Layer2WeightStorage
 *
 * Will dequeue an index to the output every rising edge of the <dequeue> signal. It will set <queueEmpty> to 1 when the queue has been emptied.
 */
 
 
`include "GlobalVariables.v"


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
 	
