/*
 *Tested with 
	RELU_NODES 3
	LAYER_2_IN_BIT_WIDTH 4
	LAYER_2_WEIGHTS_BIT_WIDTH 4
 */
 
 
`include "GlobalVariables.v"


module TEST_ReluNodeQueue;
	//Inputs
	reg reset;
	reg [`RELU_NODES*`LAYER_2_IN_BIT_WIDTH-1:0] ReluNodeValues;
 	reg dequeue = 0;
 	reg writeEnable;
 	
 	//Outputs
 	wire [`RELU_INDEX_WIDTH - 1:0] indexOut; 	
 	wire [`LAYER_2_IN_BIT_WIDTH-1:0] NodeValueOut;
 	wire queueEmpty;
 	
 	ReluNodeQueue queue(
	 	.reset(reset), 
	 	.ReluNodeValues(ReluNodeValues), 
	 	.dequeue(dequeue), 
	 	.writeEnable(writeEnable),
	 	.indexOut(indexOut), 
	 	.NodeValueOut(NodeValueOut), 
	 	.queueEmpty(queueEmpty)
 	);
 	
 	initial
	begin
		#1
		
		#2
		reset <= `TRUE;
		#1
		reset <= `FALSE;
		#1
		
		ReluNodeValues <= 12'b0110_0111_0011; //(6, 7, 3)
		writeEnable <= `TRUE;
		#2
		writeEnable <= `FALSE;
		
		#4
		
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
		//#1
		
		//Expected outputs:
		// NodeValueOut = 6,7,3
		// IndexOut = 0, 1, 2
		
		//#10		
	end
 endmodule
