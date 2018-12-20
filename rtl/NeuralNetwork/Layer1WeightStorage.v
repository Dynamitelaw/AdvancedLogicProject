/*
This file contains all the modules needed to store the weights
and biases for the first layer of the NN
*/

`include "GlobalVariables.v"


/*
 * Stores the set of weights for a single input node
 */
module NodeWeightBank (
	//Inputs
	writeEnable, writeIn, 
	//Outputs
	readOut
);
	input writeEnable;
	input [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] writeIn;
	output [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] readOut;

	reg [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] readOut;

	always @(writeEnable, writeIn) begin
		if (writeEnable == `TRUE)
			readOut <= writeIn;  //Functions as a latch rather than a flip-flop to halve area cost of weight storage
	end

endmodule  //end NodeWeightBank


/*
 * Stores the weights for all input nodes
 */
module Layer1WeightStorage (
	//Inputs
	writeEnable, NodeSelect, writeIn, 
	//Outputs
	readOut
);
	input writeEnable;
	input [9:0] NodeSelect;
	input [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] writeIn;
	output [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] readOut;

	reg [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] readOut;

	//Define internal buses
	reg [`INPUT_LAYER_NODES-1:0] writeEnableBus;  //One-hot bus for writeEnables of NodeWeightBanks
	wire [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] readOutBus[`INPUT_LAYER_NODES-1:0];  //Output bus for reading

	//Instantiate all 784 instances of NodeWeightBank
	genvar i;
	generate
	    for (i=0; i<`INPUT_LAYER_NODES; i=i+1) begin : Generate_Node_Banks
		    NodeWeightBank NB (
		    	//Instance inputs
		        .writeEnable(writeEnableBus[i]), .writeIn(writeIn),
		        //Instance outputs
		        .readOut(readOutBus[i])
		    );
		end 
	endgenerate

	//Module behavior
	always @(writeEnable, NodeSelect) begin
		writeEnableBus = (writeEnable) ? (1 << NodeSelect) : `INPUT_LAYER_NODES 'b0 ;  //Decode NodeSelect onto the one-hot writeEnable bus
		readOut = readOutBus[NodeSelect];  //Mux for read output
	end

endmodule  //end Layer1WeightStorage
