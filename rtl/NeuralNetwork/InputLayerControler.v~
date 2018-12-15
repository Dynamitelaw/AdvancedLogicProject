/*
 * This file describes the behaviour and IO of the Input Layer. 
 * All modules needed for the layer are instantiated here.
 */
 
 `include "GlobalVariables.v"
 `include "InputQueueRegister.v"
 
 
 module InputLayerController (
 	//Inputs
 	reset, clk, pixelValue, dequeue,
 	//Outputs
 	readyForInputs, outputsReady, indexOut, queueEmpty
 );
 	//Inputs
 	input clk;
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
 	
 	always @(posedge clk or negedge clk or posedge reset) begin : InputLayerController_proc
 		//Async reset
 		if (reset) begin
 			readyForInputs <= `TRUE;
 			resetQueue <= `TRUE;
 			resetBuffer <= `TRUE; //<TODO> when to set this low????
 			outputsReady <= `FALSE;
 			virginBuffer <= `TRUE;
 		end
 		
 		//Positive-edge clock events
 		else if (clk) begin
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
 				resetQueue <= `TRUE;
 				queueBuffered <= `FALSE;
 				writeBuffer <= `FALSE;
 				readyForInputs <= `TRUE;
 			end
 			
 			if (readyForInputs) begin
 				resetBuffer <= `FALSE;
 			end
 			
 		end
 		
 		//Negative-edge clock events
 		else begin
 			//insert stuff here
 		end
 	end
 	
 endmodule
