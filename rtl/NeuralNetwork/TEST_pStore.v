`include "GlobalVariables.v"

module test_pStore();

    reg clk, clr;
    reg [`RELU_NODES*`LAYER_1_BIT_WIDTH-1:0] weightsIn;
    reg [`RELU_NODES*`LAYER_1_OUT_BIT_WIDTH-1:0] biasesIn;
    reg biasWriteEnable;
    wire [`RELU_NODES*`LAYER_1_OUT_BIT_WIDTH-1:0] sumOut;

   pStore test1 ( .clk(clk), .weightsIn(weightsIn),.sumOut(sumOut),.biasesIn(biasesIn),.biasWriteEnable(biasWriteEnable),.clr(clr));

   always begin
      #10
      clk = ~clk;
   end

   initial begin
        clk = 0;
	clr = 1;
	biasWriteEnable = 0;
        weightsIn = 8'b0;
	biasesIn = 10'b11111_01010;
	#20
	clr = 0;
	biasWriteEnable = 1;
	#20
	clr = 1;
	biasWriteEnable = 0;
	#20
	clr = 0;
	weightsIn = 8'b0101_1010;
	#20
        weightsIn = 8'b1111_1001;
	#20
        $finish;
   end 

endmodule // testbench
