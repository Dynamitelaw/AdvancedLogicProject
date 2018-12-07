/*
 * The input queue register will take in an input pixel value at every rising clock edge.
 * If it is 1, it will add the index of the pixel to the back of the queue.
 * Once all input pixels have been read, the queue will stop accepting inputs values until it is reset.
 *
 * The queue will set <finished> to true when all input pixels have been processed.
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

 	always @(posedge clk or negedge clk or posedge reset) begin : proc_
 		//Async reset
 		if (reset == `TRUE) begin
 			indexCounter <= 10'b0;
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

 		//Increment indexCounter on negative clock edges
 		else begin
 			if (finished == `FALSE) begin
	 			indexCounter <= indexCounter + 1;
	 		end
 		end
 	end
 	
 	//Check for when last pixel has been passed
 	always @(indexCounter or posedge reset) begin : finished_proc
 		//Async reset
 		if (reset == `TRUE) begin
 			finished <= `FALSE;
 		end

 		else if (indexCounter == `INPUT_LAYER_NODES) begin
 			finished <= `TRUE;
 		end
 	end

 	//Dequeue handling
 	always @(posedge dequeue or posedge reset) begin : dequeue_pro_a
 		//Async reset
 		if (reset == `TRUE) begin
 			indexOut <= 10'b0;
 		end
 		else begin
 			indexOut <= queueRegister[queueFrontPointer];
 		end
 	end

 	always @(negedge dequeue or posedge reset) begin : dequeue_pro_b
 		//Async reset
 		if (reset == `TRUE) begin
 			queueFrontPointer <= 10'b0;
 		end

 		else begin
	 		if ((finished == `TRUE) && (queueEmpty == `FALSE)) begin
	 			queueFrontPointer <= queueFrontPointer + 1;  //Increment queueFrontPointer on falling edge of dequeue
	 		end
	 	end
 	end
 
 	always @(queueFrontPointer or posedge reset) begin : dequeue_proc_c
 		//Async reset
 		if (reset == `TRUE) begin
 			queueEmpty <= `FALSE;
 		end

 		else begin
			if ((finished == `TRUE) && (queueFrontPointer == queueEndPointer)) begin
				queueEmpty <= `TRUE;  //Notify controller that the queue has been emptied
			end
		end
 	end

endmodule