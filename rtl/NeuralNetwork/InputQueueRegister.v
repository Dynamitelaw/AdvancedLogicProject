/*
 * InputQueueRegister will take in an input pixel value at every rising clock edge.
 * If it is 1, it will add the index of the pixel to the back of the queue.
 * Once all input pixels have been read, the queue will stop accepting inputs values until it is reset.
 *
 * The InputQueueRegister has a clock-based counter for counting up the pixel indexes. Indexes start at 0. Index will increment regardless of the input pixel value.
 *
 * InputQueueRegister will set <finished> to true when all input pixels have been processed.
 * 
 * InputQueueRegister will dequeue an index to the output every rising edge of the <dequeue> signal. It will set <queueEmpty> to 1 when the queue has been emptied.
 */

`include "GlobalVariables.v"


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
 		else if (clk) begin
 			if (finished == `FALSE) begin
		 		if (pixelValue == 1) begin
		 			queueRegister[queueEndPointer] = indexCounter;  //Store index of current pixel at the back of the queue. Intentionally blocking statement
		 			queueEndPointer <= queueEndPointer + 1;  //Increment queueEndPointer
		 		end
		 	end
 		end

	always @(negedge clk or posedge resetInputQueue) begin
		if (resetInputQueue == `TRUE) begin
 			indexCounter <= 10'b0;	
 		end  
 		
 		//Increment indexCounter on negative clock edges
 		else if (~clk) begin
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
