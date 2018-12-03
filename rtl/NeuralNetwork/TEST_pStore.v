`include "GlobalVariables.v"

module test_pStore();

   reg clk, clr;
   reg [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] weightsIn;
   wire [`RELU_NODES*`LAYER_1_OUT_BIT_WIDTH-1:0] sumOut;

   pStore test1 ( .clk(clk), .weightsIn(weightsIn),.sumOut(sumOut));

   always begin
      #10
      clk = ~clk;
   end

   initial begin
        clk = 0;
	clr = 0;
        weightsIn = 8'b0;
	//dummy = 8'b0;
	#20
	//dummy = 8'b0110_1101;
	weightsIn = 8'b0101_1010;
	#20
	//dummy = 8'b0110_1101;
        weightsIn = 8'b1111_1001;
	#20
        $finish;
   end 

endmodule // testbench
