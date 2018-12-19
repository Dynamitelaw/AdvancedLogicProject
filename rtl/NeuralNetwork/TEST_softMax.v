`include "GlobalVariables.v"

module TEST_softMax ();
	reg [10*`SOFTMAX_IN_BIT_WIDTH-1:0] sumIn;
	wire [3:0] result;
	
	softMax test1(.sumIn(sumIn),.result(result));

initial begin
sumIn = 40'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0001;
#20
sumIn = 40'b0001_0010_0000_0000_0000_0000_0000_0000_0000_0000;
#20
sumIn = 40'b0001_0010_0100_0011_1111_0100_0011_0000_1011_1000;
#20

$finish;
end



endmodule
