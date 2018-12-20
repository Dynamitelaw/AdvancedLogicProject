`define W1_FILE "../../MLP-MATLAB-master/W1.results"
`define W2_FILE "../../MLP-MATLAB-master/W2.results"
`define B1_FILE "../../MLP-MATLAB-master/B1.results"
`define B2_FILE "../../MLP-MATLAB-master/B2.results"


module testbench();

integer w1,w2,b1,b2;
integer i,W1_read, W2_read, B1_read, B2_read, W1_out_file, W2_out_file, B1_out_file, B2_out_file;

initial begin
	//File IO
	W1_out_file = $fopen(`W1_FILE,"r");
	W2_out_file = $fopen(`W2_FILE,"r");
	B1_out_file = $fopen(`B1_FILE,"r");
	B2_out_file = $fopen(`B2_FILE,"r");
	
	//Read files, concatenate
	for (i=0 ; i<10; i=i+1)
	       begin
			W1_read = $fscanf(W1_out_file, "%d", w1);
			$display("Read  = %d",w1);

	       end


	end
	
	$fclose(W1_out_file);
	$fclose(W2_out_file);
	$fclose(B1_out_file);
	$fclose(B2_out_file);
	$finish;
end
endmodule
