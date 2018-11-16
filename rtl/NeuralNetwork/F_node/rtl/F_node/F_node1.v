//
//
//
//
`timescale 1ns/1ps

module F_node (clk, write_in, write_enable, save);

        input clk, write_enable;
        input [15:0] write_in;
        output reg [15:0] save;


        always @(posedge clk)
        begin
            if (write_enable)
                begin
                        out <= write_in;
                end
        end
endmodule

