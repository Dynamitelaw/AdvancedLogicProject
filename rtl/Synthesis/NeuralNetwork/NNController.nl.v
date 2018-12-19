
module NN_Controler ( reset, masterClk, inputsInbound, predictionRecieved, 
        inputPixel, weightWriteEnable, biasWriteEnable, LayerWriteSelect, 
        WriteAddressSelect, writeIn, predictionReady, readyForInputs, 
        predictionOut );
  input [9:0] WriteAddressSelect;
  input [63:0] writeIn;
  output [3:0] predictionOut;
  input reset, masterClk, inputsInbound, predictionRecieved, inputPixel,
         weightWriteEnable, biasWriteEnable, LayerWriteSelect;
  output predictionReady, readyForInputs;
  wire   dequeue, L1_InputsReady, queueEmpty, L2_InputsRecieved,
         L1_WeightWriteEnable, L1_BiasWriteEnable, L2_InputsReady,
         L2_WeightWriteEnable, L2_BiasWriteEnable, n3, n4;
  wire   [9:0] indexOut;
  wire   [23:0] L2_Input;

  InputLayerController InputLayer ( .reset(reset), .clk(masterClk), 
        .inputsInbound(inputsInbound), .pixelValue(inputPixel), .dequeue(
        dequeue), .readyForInputs(readyForInputs), .outputsReady(
        L1_InputsReady), .indexOut(indexOut), .queueEmpty(queueEmpty) );
  Layer1_Controller Layer1 ( .reset(reset), .clk(masterClk), .inputsReady(
        L1_InputsReady), .queueEmpty(queueEmpty), .outputsRecieved(
        L2_InputsRecieved), .weightWriteEnable(L1_WeightWriteEnable), 
        .biasWriteEnable(L1_BiasWriteEnable), .WriteAddressSelect(
        WriteAddressSelect), .writeIn(writeIn[15:0]), .queueOut(indexOut), 
        .outputsReady(L2_InputsReady), .dequeue(dequeue), .layer1Output(
        L2_Input) );
  Layer2_Controller Layer2 ( .reset(reset), .clk(masterClk), .inputsReady(
        L2_InputsReady), .outputsRecieved(predictionRecieved), 
        .weightWriteEnable(L2_WeightWriteEnable), .biasWriteEnable(
        L2_BiasWriteEnable), .WriteAddressSelect(WriteAddressSelect[2:0]), 
        .writeIn(writeIn[39:0]), .layer2Input(L2_Input), .inputsRecieved(
        L2_InputsRecieved), .outputsReady(predictionReady), .predictionOutput(
        predictionOut) );
  AO22XLTS U5 ( .A0(1'b0), .A1(n3), .B0(weightWriteEnable), .B1(n4), .Y(
        L2_WeightWriteEnable) );
  AO22XLTS U4 ( .A0(1'b0), .A1(n3), .B0(biasWriteEnable), .B1(n4), .Y(
        L2_BiasWriteEnable) );
  AO22XLTS U7 ( .A0(weightWriteEnable), .A1(n3), .B0(1'b0), .B1(n4), .Y(
        L1_WeightWriteEnable) );
  AO22XLTS U6 ( .A0(biasWriteEnable), .A1(n3), .B0(1'b0), .B1(n4), .Y(
        L1_BiasWriteEnable) );
  INVX2TS U8 ( .A(LayerWriteSelect), .Y(n3) );
  INVX2TS U9 ( .A(n3), .Y(n4) );
endmodule

