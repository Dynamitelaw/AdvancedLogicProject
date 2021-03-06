`include "GlobalVariables.v"

module TEST_multStore();

reg clk,clr,biasWriteEnable;
reg [10*`LAYER_2_WEIGHTS_BIT_WIDTH - 1:0] X;
reg [`LAYER_2_IN_BIT_WIDTH - 1:0] M;
reg [10*`LAYER_2_WEIGHTS_BIT_WIDTH-1:0] biasesIn;
wire [10*`LAYER_2_OUT_BIT_WIDTH - 1:0] S;

multStore test1(.clk(clk),.layer2In(M),.weightsIn(X),.sumOut(S),.biasWriteEnable(biasWriteEnable),.biasesIn(biasesIn),.clr(clr));

always begin
      #10
      clk = ~clk;
end

initial begin
        clk = 0;
	clr = 0;
	biasWriteEnable = 0;
	biasesIn = 30'b011_111_011_111_011_111_011_111_011_111;
	M = 	   3'b001;
	X = 	   30'b011_111_011_111_011_111_011_111_011_111;
	#20
	biasWriteEnable = 1;
	clr = 1;
	#20
	clr = 0;
	biasWriteEnable = 0;
	#20
	//#20
	//biasWriteEnable = 1;
	//#20
	//clr = 0;
	M = 	   3'b001;
	X = 	   30'b011_111_011_111_011_111_011_111_011_111;
	#20
	M = 	   3'b010;
	X = 	   30'b011_111_011_111_011_111_011_111_011_111;
	#20

$finish;
end


endmodule
