`include "GlobalVariables.v"


module ReluNodeQueue (
 	//Inputs
 	resetQueue, ReluNodeValues, dequeue, writeEnable
 	//Outputs
 	indexOut, NodeValueOut, queueEmpty
 );
 
 	//Inputs
 	input resetQueue;
 	input [`RELU_NODES*`LAYER_2_IN_BIT_WIDTH-1:0] ReluNodeValues;
 	input dequeue
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
	integer i;
	for (i=0; i<`RELU_NODES; i=i+1) begin
		assign local_2D_Bus[i] = ReluNodeValues[`LAYER_2_IN_BIT_WIDTH*i+`LAYER_2_IN_BIT_WIDTH-1:`LAYER_2_IN_BIT_WIDTH*i];
	end
 	
 	reg [`LAYER_2_IN_BIT_WIDTH-1:0] ReluQueueRegister [`RELU_NODES-1:0];  //register array to store RELU node values
 	reg [`RELU_INDEX_WIDTH - 1:0] frontPointer;
 	
 	//--ModuleBehaviour--
 	
 	//Write to the queue when writeEnable is set high
 	integer j;
 	always @(writeEnable) begin : write_proc 		
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
 		if ((reset) || (writeEnable)) begin
 			frontPointer <= 0;
 		end
 		
 		else if (~dequeue) begin
 			frontPointer <= frontPointer + 1;
 		end
 	end
 	
 	//Find out when queue is empty
 	always @(frontPointer) begin : empty_proc
 		if (frontPointer == `RELU_NODES) begin
 			queueEmpty <= `TRUE;
 		end
 	end
 	
 endmodule
 	
