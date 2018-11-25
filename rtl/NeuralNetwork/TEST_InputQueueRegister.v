/*
 * Test bench for InputQueueRegister
 */

`include "GlobalVariables.v"
`include "InputQueueRegister.v"


module TEST_InputQueueRegister ;
	reg clk;
	reg inputPixel;
	reg reset;
	reg dequeue;
	
	wire [9:0] indexOut;
	wire queueEmpty;

	InputQueueRegister queue(
		.clk(clk), 
		.reset(reset), 
		.pixelValue(inputPixel), 
		.dequeue(dequeue), 
		.indexOut(indexOut), 
		.queueEmpty(queueEmpty)
	);


	initial
	begin
		clk = 0;
		reset <= 0;
		dequeue <= 0;

		//--First Batch--
		#4
		reset <= 1;
		#1
		reset <= 0;

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

		//Empty queue
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


		//--Second Batch--
		#3
		reset <= 1;
		#1
		reset <= 0;

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

		//Empty queue
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

	end

	//Clock toggling
	always begin
		#1  //2-step period
		clk <= ~clk;
	end
	

endmodule