/*
 * Test bench for InputLayerController
 *
 * Tested using INPUT_LAYER_NODES = 10
 */

`include "InputLayerControler.v"


module TEST_InputLayerController ;
	reg reset = 0;
	reg clk;
	reg inputsInbound = 0;
	reg inputPixel;
	reg dequeue;

	wire readyForInputs;
	wire outputsReady;
	wire [9:0] indexOut;
	wire queueEmpty;

	InputLayerController controller(
 	 	.reset(reset), 
 	 	.clk(clk), 
 	 	.inputsInbound(inputsInbound), 
 	 	.pixelValue(inputPixel), 
 	 	.dequeue(dequeue),
 	 	.readyForInputs(readyForInputs), 
 	 	.outputsReady(outputsReady), 
 	 	.indexOut(indexOut), 
 	 	.queueEmpty(queueEmpty)
 	);
		

	reg error = `FALSE;

	initial
	begin
		clk = 0;
		dequeue <= 0;

		//--First Batch--
		#1
		reset <= 1;
		#3
		reset <= 0;
		#1
		
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
		#2
		inputsInbound <= 0;

		// //Empty queue
		// /*
		//  * Expected output: 2, 4, 5, 7, 9, EMPTY
		//  */
		// #6
		// dequeue <= 1;
		// #1
		// dequeue <= 0;
		// #1
		// dequeue <= 1;
		// #1
		// dequeue <= 0;
		// #1
		// dequeue <= 0;
		// #1
		// dequeue <= 1;
		// #1
		// dequeue <= 0;
		// #1
		// dequeue <= 1;
		// #1
		// dequeue <= 0;
		// #1
		// dequeue <= 1;
		// #1
		// dequeue <= 0;
		// #1
		// dequeue <= 1;
		// #1
		// dequeue <= 0;
		// #1
		// dequeue <= 1;
		// #1
		// dequeue <= 0;

		//--Second Batch--
		#4
		inputsInbound <= 1;

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
		#2
		inputsInbound <= 0;

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


	end

	//Clock toggling
	always begin
		#1  //2-step period
		clk <= ~clk;
	end
	

endmodule
