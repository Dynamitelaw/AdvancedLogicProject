/*
This file contains all global macro definitions
*/

`define TRUE 1
`define FALSE 0

`define QUEUE_MAX_SIZE 7  //Available storage elements in the input queue

`define INPUT_LAYER_NODES 6 //784

//`define LAYER_1_CLK_DIVIDER 1
`define LAYER_1_BIT_WIDTH 5
`define LAYER_1_OUT_BIT_WIDTH 8
`define RELU_NODES 32

//`define LAYER_2_CLK_DIVIDER 1
`define LAYER_2_IN_BIT_WIDTH 4
`define LAYER_2_WEIGHTS_BIT_WIDTH 6
`define LAYER_2_OUT_BIT_WIDTH 10
`define RELU_INDEX_WIDTH 3

`define SOFTMAX_IN_BIT_WIDTH 10

`define WRITE_IN_BIT_WIDTH 64  //must be greater than or equal to both L1 and L2 write ports
