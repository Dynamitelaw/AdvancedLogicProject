`include "GlobalVariables.v"


module softMax (
	//Inputs
	sumIn,
	//Outputs
	result
);
	input [10*`SOFTMAX_IN_BIT_WIDTH-1:0] sumIn;
	output [3:0] result;
	//output [`SOFTMAX_IN_BIT_WIDTH-1+4:0] result;
	wire [`SOFTMAX_IN_BIT_WIDTH-1 +4:0] A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,C0,C1,D0,E0;

	assign A0 = {4'b0000,sumIn[10*`SOFTMAX_IN_BIT_WIDTH-1:9*`SOFTMAX_IN_BIT_WIDTH]};
	assign A1 = {4'b0001,sumIn[9*`SOFTMAX_IN_BIT_WIDTH-1:8*`SOFTMAX_IN_BIT_WIDTH]};
	assign A2 = {4'b0010,sumIn[8*`SOFTMAX_IN_BIT_WIDTH-1:7*`SOFTMAX_IN_BIT_WIDTH]};
	assign A3 = {4'b0011,sumIn[7*`SOFTMAX_IN_BIT_WIDTH-1:6*`SOFTMAX_IN_BIT_WIDTH]};
	assign A4 = {4'b0100,sumIn[6*`SOFTMAX_IN_BIT_WIDTH-1:5*`SOFTMAX_IN_BIT_WIDTH]};
	assign A5 = {4'b0101,sumIn[5*`SOFTMAX_IN_BIT_WIDTH-1:4*`SOFTMAX_IN_BIT_WIDTH]};
	assign A6 = {4'b0110,sumIn[4*`SOFTMAX_IN_BIT_WIDTH-1:3*`SOFTMAX_IN_BIT_WIDTH]};
	assign A7 = {4'b0111,sumIn[3*`SOFTMAX_IN_BIT_WIDTH-1:2*`SOFTMAX_IN_BIT_WIDTH]};
	assign A8 = {4'b1000,sumIn[2*`SOFTMAX_IN_BIT_WIDTH-1:1*`SOFTMAX_IN_BIT_WIDTH]};
	assign A9 = {4'b1001,sumIn[`SOFTMAX_IN_BIT_WIDTH-1:0]};

	// Compare first vector (neighbors)
	compare comp1(.X(A0),.Y(A1),.Out(B0));
	compare comp2(.X(A2),.Y(A3),.Out(B1));
	compare comp3(.X(A4),.Y(A5),.Out(B2));
	compare comp4(.X(A6),.Y(A7),.Out(B3));
	compare comp5(.X(A8),.Y(A9),.Out(B4));

	// Compare second vector
	compare comp6(.X(B0),.Y(B1),.Out(C0));
	compare comp7(.X(B2),.Y(B3),.Out(C1));
	
	// Compare third and carry from first compare
	compare comp8(.X(C0),.Y(C1),.Out(D0));
	compare comp9(.X(B4),.Y(D0),.Out(E0));

	assign result = E0[`SOFTMAX_IN_BIT_WIDTH-1 +4:`SOFTMAX_IN_BIT_WIDTH];
	//assign result = E0;//[`SOFTMAX_IN_BIT_WIDTH-1 +4:`SOFTMAX_IN_BIT_WIDTH];

endmodule

module compare(X,Y,Out);
	input [`SOFTMAX_IN_BIT_WIDTH-1+4:0] X,Y;
	output reg [`SOFTMAX_IN_BIT_WIDTH-1+4:0] Out;

	always @(X,Y)
		//X is negative and Y is positive
		if ((X[`SOFTMAX_IN_BIT_WIDTH - 1] == 1) && ((Y[`SOFTMAX_IN_BIT_WIDTH - 1] == 0))) begin
			Out <= Y;
		end
		//X is positive and Y is negative
		else if ((X[`SOFTMAX_IN_BIT_WIDTH - 1] == 0) && ((Y[`SOFTMAX_IN_BIT_WIDTH - 1] == 1))) begin
			Out <= X;
		end
		//X and Y have same sign -> regular comparison can be used
		else begin
			if (X[`SOFTMAX_IN_BIT_WIDTH-1:0] >= Y[`SOFTMAX_IN_BIT_WIDTH-1:0])
				Out <= X;
			else
				Out <= Y;	
		end
endmodule


/*

Old softmax


module softMax (
	//Inputs
	sumIn,
	//Outputs
	result
);
	input [10*`SOFTMAX_IN_BIT_WIDTH-1:0] sumIn;
	output [3:0] result;
	//output [`SOFTMAX_IN_BIT_WIDTH-1+4:0] result;
	wire [10*`SOFTMAX_IN_BIT_WIDTH-1:0] sumIn_magnitude;
	wire [`SOFTMAX_IN_BIT_WIDTH-1 +4:0] A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,C0,C1,D0,E0;
	
	// Take absolute value of sumIn
	genvar m;
	generate 
		for(m=0;m<10;m=m+1)
		begin
			ABS abs(.in(sumIn[(m+1)*`SOFTMAX_IN_BIT_WIDTH - 1:`SOFTMAX_IN_BIT_WIDTH*m]),
				.out(sumIn_magnitude[(m+1)*`SOFTMAX_IN_BIT_WIDTH - 1:`SOFTMAX_IN_BIT_WIDTH*m]));
		end
	endgenerate

	assign A0 = {4'b0000,sumIn_magnitude[10*`SOFTMAX_IN_BIT_WIDTH-1:9*`SOFTMAX_IN_BIT_WIDTH]};
	assign A1 = {4'b0001,sumIn_magnitude[9*`SOFTMAX_IN_BIT_WIDTH-1:8*`SOFTMAX_IN_BIT_WIDTH]};
	assign A2 = {4'b0010,sumIn_magnitude[8*`SOFTMAX_IN_BIT_WIDTH-1:7*`SOFTMAX_IN_BIT_WIDTH]};
	assign A3 = {4'b0011,sumIn_magnitude[7*`SOFTMAX_IN_BIT_WIDTH-1:6*`SOFTMAX_IN_BIT_WIDTH]};
	assign A4 = {4'b0100,sumIn_magnitude[6*`SOFTMAX_IN_BIT_WIDTH-1:5*`SOFTMAX_IN_BIT_WIDTH]};
	assign A5 = {4'b0101,sumIn_magnitude[5*`SOFTMAX_IN_BIT_WIDTH-1:4*`SOFTMAX_IN_BIT_WIDTH]};
	assign A6 = {4'b0110,sumIn_magnitude[4*`SOFTMAX_IN_BIT_WIDTH-1:3*`SOFTMAX_IN_BIT_WIDTH]};
	assign A7 = {4'b0111,sumIn_magnitude[3*`SOFTMAX_IN_BIT_WIDTH-1:2*`SOFTMAX_IN_BIT_WIDTH]};
	assign A8 = {4'b1000,sumIn_magnitude[2*`SOFTMAX_IN_BIT_WIDTH-1:1*`SOFTMAX_IN_BIT_WIDTH]};
	assign A9 = {4'b1001,sumIn_magnitude[`SOFTMAX_IN_BIT_WIDTH-1:0]};

	// Compare first vector (neighbors)
	compare comp1(.X(A0),.Y(A1),.Out(B0));
	compare comp2(.X(A2),.Y(A3),.Out(B1));
	compare comp3(.X(A4),.Y(A5),.Out(B2));
	compare comp4(.X(A6),.Y(A7),.Out(B3));
	compare comp5(.X(A8),.Y(A9),.Out(B4));

	// Compare second vector
	compare comp6(.X(B0),.Y(B1),.Out(C0));
	compare comp7(.X(B2),.Y(B3),.Out(C1));
	
	// Compare third and carry from first compare
	compare comp8(.X(C0),.Y(C1),.Out(D0));
	compare comp9(.X(B4),.Y(D0),.Out(E0));

	assign result = E0[`SOFTMAX_IN_BIT_WIDTH-1 +4:`SOFTMAX_IN_BIT_WIDTH];
	//assign result = E0;//[`SOFTMAX_IN_BIT_WIDTH-1 +4:`SOFTMAX_IN_BIT_WIDTH];

endmodule

module compare(X,Y,Out);
	input [`SOFTMAX_IN_BIT_WIDTH-1+4:0] X,Y;
	output reg [`SOFTMAX_IN_BIT_WIDTH-1+4:0] Out;

	always @(X,Y)
		if (X[`SOFTMAX_IN_BIT_WIDTH-1:0] >= Y[`SOFTMAX_IN_BIT_WIDTH-1:0])
			Out <= X;
		else
			Out <= Y;
endmodule

module ABS(in,out);
	input [`SOFTMAX_IN_BIT_WIDTH - 1:0] in;
	output reg [`SOFTMAX_IN_BIT_WIDTH - 1:0] out;
	reg [`SOFTMAX_IN_BIT_WIDTH - 1:0] zeros = 'b0;

	always @(in)
	begin
		if (in[`SOFTMAX_IN_BIT_WIDTH - 1])
		begin
			out <= {1'b1,zeros} - in;
		end
		else out <= in;
	end
endmodule
*/
