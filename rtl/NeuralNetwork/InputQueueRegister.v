/*
 * The input queue register will take in an input pixel value at every rising clock edge.
 * If it is 1, it will add the index of the pixel to the back of the queue.
 * Once all input pixels have been read, the queue will stop accepting inputs values until it is reset.
 *
 * The queue register will dequeue an index to the output every rising edge of the <dequeue> signal. It will set <queueEmpty> to 1 when the queue has been emptied.
 *
 * The queue has a clock-based counter for counting up the pixel indexes. Indexes start at 0. Index will increment regardless of the input pixel value.
 */

`include "GlobalVariables.v"


module InputQueueRegister (
 	//Inputs
 	clk, reset, pixelValue, dequeue,
 	//Outputs
 	indexOut, queueEmpty, finished
 );

	parameter QUEUE_MAX_SIZE = `INPUT_LAYER_NODES;  //Available storage elements in the queue

 	input clk;    // Clock
 	input reset;  // Asynchronous reset active high
 	input pixelValue;  //Input pixel value
 	input dequeue;  //At positive edge of dequeue, the queue will output the next index in the queue

 	output [9:0] indexOut = 10'b0;  //The next index in the queue
 	reg [9:0] indexOut;

 	output queueEmpty;  //Tells the controller when the queue has been emptied
 	reg queueEmpty = `FALSE;

 	reg [9:0] indexCounter = 10'b0;  //counter that stores the index of the current input pixel

 	reg [9:0] queueRegister[QUEUE_MAX_SIZE-1:0];  //Array of registers to store the queue in
 	reg [9:0] queueEndPointer = 10'b0;  //index that points to the next available slot in the queue
 	reg [9:0] queueFrontPointer = 10'b0;  //index that points to the front of the queue

 	output finished;
 	reg finished = `FALSE;  //Flipped to TRUE when the last input pixel is read


 	//--Module behavior--

 	//Asynchronous reset
 	always @(reset) begin : reset_proc
 		if (reset == `TRUE) begin
 			indexCounter <= 10'b0;
 			queueEndPointer <= 10'b0;
 			queueFrontPointer <= 10'b0;
 			indexOut <= 10'b0;
 			queueEmpty <= `FALSE;
 			finished <= `FALSE;
 		end
 	end
 	
 	//Increment indexCounter on negative clock edges
 	always @(negedge clk) begin : counter_proc
 		if (reset == `FALSE) begin
	 		if (finished == `FALSE) begin
	 			indexCounter <= indexCounter + 1;
	 		end
	 	end
 	end

 	//Check for when last pixel has been passed
 	always @(indexCounter) begin : finished_proc
 		if (indexCounter == `INPUT_LAYER_NODES) begin
 			finished <= `TRUE;
 		end
 	end

 	//Queue indexes on positive clock edges
 	always @(posedge clk) begin : queue_proc
 		if (reset == `FALSE) begin
	 		if (finished == `FALSE) begin
		 		if (pixelValue == 1) begin
		 			queueRegister[queueEndPointer] = indexCounter;  //Store index of current pixel at the back of the queue. Intentionally blocking statement
		 			queueEndPointer <= queueEndPointer + 1;  //Increment queueEndPointer
		 		end
		 	end
		end
 	end

 	//Dequeue handling
 	always @(posedge dequeue) begin : dequeue_pro_a
 		indexOut <= queueRegister[queueFrontPointer];
 	end

 	always @(negedge dequeue) begin : dequeue_pro_b
 		if ((finished == `TRUE) && (queueEmpty == `FALSE)) begin
 			queueFrontPointer <= queueFrontPointer + 1;  //Increment queueFrontPointer on falling edge of dequeue
 		end
 	end
 
 	always @(queueFrontPointer) begin : dequeue_proc_c
		if ((finished == `TRUE) && (queueFrontPointer == queueEndPointer)) begin
			queueEmpty <= `TRUE;  //Notify controller that the queue has been emptied
		end
 	end
endmodule