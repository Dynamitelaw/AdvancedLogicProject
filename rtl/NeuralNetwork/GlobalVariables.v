/*
This file contains all global macro definitions
*/

`define TRUE 1
`define FALSE 0

`define QUEUE_MAX_SIZE 5  //Available storage elements in the input queue

`define INPUT_LAYER_NODES 4 //784
`define LAYER_1_BIT_WIDTH 4
`define LAYER_1_OUT_BIT_WIDTH 4 //10

`define RELU_NODES 3
`define LAYER_2_IN_BIT_WIDTH 4
`define LAYER_2_WEIGHTS_BIT_WIDTH 4
`define LAYER_2_OUT_BIT_WIDTH 6
`define RELU_INDEX_WIDTH 4

`define SOFTMAX_IN_BIT_WIDTH 4
