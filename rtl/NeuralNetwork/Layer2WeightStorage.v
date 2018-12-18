/*
This file contains all the modules needed to store the weights
for the second layer of the NN
*/

`include "GlobalVariables.v"


/*
 * Stores the set of weights for a single RELU node
 */
module ReluWeightBank (
	//Inputs
	writeEnable, writeIn, 
	//Outputs
	readOut
);
	input writeEnable;
	input [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] writeIn;
	output [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] readOut;

	reg [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] readOut;

	always @(writeEnable, writeIn) begin
		if (writeEnable == `TRUE)
			readOut <= writeIn;  //Functions as a latch rather than a flip-flop to halve area cost of weight storage
	end

endmodule  //end ReluWeightBank


/*
 * Stores the weights for all RELU nodes
 */
module Layer2WeightStorage (
	//Inputs
	writeEnable, NodeSelect, writeIn, 
	//Outputs
	readOut
);
	input writeEnable;
	input [3:0] NodeSelect;  //2^4 = 32 RELU nodes
	input [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] writeIn;
	output [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] readOut;

	reg [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] readOut;

	//Define internal buses
	reg [`RELU_NODES-1:0] writeEnableBus;  //One-hot bus for writeEnables of RelueWeightBanks
	wire [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] readOutBus[`RELU_NODES-1:0];  //Output bus for reading

	//Instantiate all instances of NodeWeightBank
	genvar i;
	generate
	    for (i=0; i<`RELU_NODES; i=i+1) begin : Generate_Node_Banks
		    ReluWeightBank NB (
		    	//Instance inputs
		        .writeEnable(writeEnableBus[i]), .writeIn(writeIn),
		        //Instance outputs
		        .readOut(readOutBus[i])
		    );
		end 
	endgenerate

	//Module behavior
	always @(writeEnable, NodeSelect) begin
		assign writeEnableBus = (writeEnable) ? (1 << NodeSelect) : `RELU_NODES 'b0 ;  //Decode NodeSelect onto the one-hot writeEnable bus
		assign readOut = readOutBus[NodeSelect];  //Mux for read output
	end

endmodule  //end Layer2WeightStorage
