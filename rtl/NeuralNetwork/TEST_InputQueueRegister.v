/*
 * Test bench for InputQueueRegister
 *
 * Tested using INPUT_LAYER_NODES = 10
 */

`include "GlobalVariables.v"
`include "InputQueueRegister.v"


module TEST_InputQueueRegister ;
	reg clk;
	reg inputPixel;
	reg resetQueue;

	wire finished;
	wire [9:0] queueFrontPointer;
	wire [9:0] queueEndPointer;
	wire [10*`QUEUE_MAX_SIZE-1:0]  queueRegisterOut;

	InputQueueRegister queue(
		.clk(clk), 
		.reset(resetQueue), 
		.pixelValue(inputPixel),
		.finished(finished),
		.queueFrontPointer(queueFrontPointer), 
		.queueEndPointer(queueEndPointer), 
		.queueRegisterOut(queueRegisterOut)
	);

	reg resetBuffer;
	reg dequeue;
	reg writeEnable = `FALSE;
	wire [9:0] indexOut;
	wire queueEmpty;	

	QueueBuffer buffer(
		.reset(resetBuffer),
		.dequeue(dequeue), 
		.writeEnable(writeEnable), 
		.queueFrontPointerIn(queueFrontPointer), 
		.queueEndPointerIn(queueEndPointer), 
		.queueRegisterIn(queueRegisterOut),
		.indexOut(indexOut), 
		.queueEmpty(queueEmpty)
	);
		

	reg error = `FALSE;

	initial
	begin
		clk = 0;
		resetQueue <= 0;
		dequeue <= 0;

		//--First Batch--
		#4
		resetQueue <= 1;
		#1
		resetQueue <= 0;

		//Load into queue
		inputPixel <= 0;  //index 0
		#2
		inputPixel <= 0;  //index 1
		#2
		inputPixel <= 1;  //index 2
		#2
		inputPixel <= 0;  //index 3
		#2
		inputPixel <= 1;  //index 4
		#2
		inputPixel <= 1;  //index 5
		#2
		inputPixel <= 0;  //index 6
		#2
		inputPixel <= 1;  //index 7
		#2
		inputPixel <= 0;  //index 8
		#2
		inputPixel <= 1;  //index 9
		#2
		inputPixel <= 0;  //index 9

		if (finished == `TRUE) begin
			writeEnable <= `TRUE;
			#2
			writeEnable <= `FALSE;
		end
		else begin
			error <= `TRUE;
		end

		//Empty queue
		/*
		 * Expected output: 2, 4, 5, 7, 9, EMPTY
		 */
		#6
		dequeue <= 1;
		#1
		dequeue <= 0;
		#1
		dequeue <= 1;
		#1
		dequeue <= 0;
		#1
		dequeue <= 0;
		#1
		dequeue <= 1;
		#1
		dequeue <= 0;
		#1
		dequeue <= 1;
		#1
		dequeue <= 0;
		#1
		dequeue <= 1;
		#1
		dequeue <= 0;
		#1
		dequeue <= 1;
		#1
		dequeue <= 0;
		#1
		dequeue <= 1;
		#1
		dequeue <= 0;

		if (queueEmpty == `FALSE) begin
			error <= `TRUE;
		end

		//--Second Batch--
		#3
		resetQueue <= 1;
		#1
		resetQueue <= 0;

		//Load into queue
		inputPixel <= 1;  //index 0
		#2
		inputPixel <= 1;  //index 1
		#2
		inputPixel <= 0;  //index 2
		#2
		inputPixel <= 1;  //index 3
		#2
		inputPixel <= 1;  //index 4
		#2
		inputPixel <= 0;  //index 5
		#2
		inputPixel <= 1;  //index 6
		#2
		inputPixel <= 1;  //index 7
		#2
		inputPixel <= 0;  //index 8
		#2
		inputPixel <= 0;  //index 9

		if (finished == `TRUE) begin
			writeEnable <= `TRUE;
			#2
			writeEnable <= `FALSE;
		end
		else begin
			error <= `TRUE;
		end

		//Empty queue
		/*
		 * Expected output: 0, 1, 3, 4, 6, 7, EMPTY
		 */
		#6
		dequeue <= 1;
		#1
		dequeue <= 0;
		#1
		dequeue <= 1;
		#1
		dequeue <= 0;
		#1
		dequeue <= 0;
		#1
		dequeue <= 1;
		#1
		dequeue <= 0;
		#1
		dequeue <= 1;
		#1
		dequeue <= 0;
		#1
		dequeue <= 1;
		#1
		dequeue <= 0;
		#1
		dequeue <= 1;
		#1
		dequeue <= 0;
		#1
		dequeue <= 1;
		#1
		dequeue <= 0;
		#1
		dequeue <= 1;
		#1
		dequeue <= 0;
		#1
		dequeue <= 1;

		if (queueEmpty == `FALSE) begin
			error <= `TRUE;
		end

	end

	//Clock toggling
	always begin
		#1  //2-step period
		clk <= ~clk;
	end
	

endmodule