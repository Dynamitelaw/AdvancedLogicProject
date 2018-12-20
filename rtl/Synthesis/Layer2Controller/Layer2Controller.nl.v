
module Layer2_Controller ( reset, clk, inputsReady, outputsRecieved, 
        weightWriteEnable, biasWriteEnable, WriteAddressSelect, writeIn, 
        layer2Input, inputsRecieved, outputsReady, predictionOutput );
  input [2:0] WriteAddressSelect;
  input [39:0] writeIn;
  input [23:0] layer2Input;
  output [3:0] predictionOutput;
  input reset, clk, inputsReady, outputsRecieved, weightWriteEnable,
         biasWriteEnable;
  output inputsRecieved, outputsReady;
  wire   queueReset, dequeue, queueWriteEnable, queueEmpty, mstoreReset, idle,
         processFinished, N22, N31, n5, n7, n18, n19, n20, n220, n23, n25, n27,
         n28, n29, n30, n310, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41,
         n42, n43, n44, n45, n46, n47, n48, n49, n50;
  wire   [2:0] nodeAddress;
  wire   [39:0] weightStorageBus;
  wire   [2:0] queueIndexOut;
  wire   [5:0] queueValueOut;
  wire   [99:0] mstoreOutput;
  wire   [3:0] softmaxOutput;

  Layer2WeightStorage weightStorage ( .writeEnable(weightWriteEnable), 
        .NodeSelect(nodeAddress), .writeIn(writeIn), .readOut(weightStorageBus) );
  ReluNodeQueue queue ( .reset(queueReset), .ReluNodeValues(layer2Input), 
        .dequeue(dequeue), .writeEnable(queueWriteEnable), .indexOut(
        queueIndexOut), .NodeValueOut(queueValueOut), .queueEmpty(queueEmpty)
         );
  multStore multStore ( .clk(clk), .clr(mstoreReset), .layer2In(queueValueOut), 
        .weightsIn(weightStorageBus), .biasesIn(writeIn), .biasWriteEnable(
        biasWriteEnable), .sumOut(mstoreOutput) );
  softMax softMax ( .sumIn(mstoreOutput), .result(softmaxOutput) );
  DFFSX4TS queueReset_reg ( .D(n5), .CK(clk), .SN(n50), .Q(queueReset) );
  NOR3BXLTS U29 ( .AN(clk), .B(queueEmpty), .C(mstoreReset), .Y(N31) );
  CLKAND2X2TS U30 ( .A(N31), .B(n49), .Y(dequeue) );
  AO22XLTS U31 ( .A0(N22), .A1(WriteAddressSelect[2]), .B0(n25), .B1(
        queueIndexOut[2]), .Y(nodeAddress[2]) );
  AO22XLTS U32 ( .A0(N22), .A1(WriteAddressSelect[1]), .B0(n25), .B1(
        queueIndexOut[1]), .Y(nodeAddress[1]) );
  AO22XLTS U33 ( .A0(N22), .A1(WriteAddressSelect[0]), .B0(n25), .B1(
        queueIndexOut[0]), .Y(nodeAddress[0]) );
  DFFHQX8TS predictionOutput_reg_1_ ( .D(n18), .CK(clk), .Q(
        predictionOutput[1]) );
  DFFHQX8TS predictionOutput_reg_2_ ( .D(n19), .CK(clk), .Q(
        predictionOutput[2]) );
  DFFHQX8TS predictionOutput_reg_3_ ( .D(n20), .CK(clk), .Q(
        predictionOutput[3]) );
  DFFHQX8TS predictionOutput_reg_0_ ( .D(n39), .CK(clk), .Q(n38) );
  DFFRHQX4TS processFinished_reg ( .D(n220), .CK(clk), .RN(n50), .Q(
        processFinished) );
  DFFSHQX8TS inputsRecieved_reg ( .D(n28), .CK(clk), .SN(n50), .Q(n37) );
  DFFSHQX2TS outputsReady_reg ( .D(n27), .CK(clk), .SN(n50), .Q(n44) );
  DFFRX1TS queueWriteEnable_reg ( .D(n48), .CK(clk), .RN(n50), .Q(
        queueWriteEnable) );
  DFFSHQX4TS idle_reg ( .D(n23), .CK(clk), .SN(n50), .Q(idle) );
  DFFSX1TS mstoreReset_reg ( .D(n7), .CK(clk), .SN(n50), .Q(mstoreReset) );
  OAI2BB2X4TS U34 ( .B0(n32), .B1(outputsReady), .A0N(queueWriteEnable), .A1N(
        idle), .Y(n48) );
  OAI2BB1X2TS U35 ( .A0N(idle), .A1N(mstoreReset), .B0(n47), .Y(n7) );
  NAND2BX1TS U36 ( .AN(n33), .B(n49), .Y(n47) );
  INVX2TS U37 ( .A(idle), .Y(n49) );
  NAND2X1TS U38 ( .A(idle), .B(n310), .Y(n32) );
  INVX1TS U39 ( .A(n42), .Y(n18) );
  INVX1TS U40 ( .A(n41), .Y(n20) );
  INVX1TS U41 ( .A(n40), .Y(n19) );
  NOR2BX1TS U42 ( .AN(outputsRecieved), .B(n49), .Y(n34) );
  INVX2TS U43 ( .A(queueReset), .Y(n46) );
  INVX2TS U44 ( .A(n30), .Y(n310) );
  NAND3X2TS U45 ( .A(n49), .B(processFinished), .C(n50), .Y(n45) );
  CLKINVX2TS U46 ( .A(n32), .Y(n36) );
  INVX2TS U47 ( .A(n37), .Y(inputsRecieved) );
  INVX2TS U48 ( .A(n38), .Y(predictionOutput[0]) );
  OAI21X1TS U49 ( .A0(idle), .A1(n310), .B0(inputsRecieved), .Y(n29) );
  AOI22X1TS U50 ( .A0(n49), .A1(queueEmpty), .B0(outputsReady), .B1(
        processFinished), .Y(n43) );
  OA21XLTS U51 ( .A0(n34), .A1(n44), .B0(n47), .Y(n27) );
  INVX2TS U52 ( .A(processFinished), .Y(n33) );
  OA21XLTS U53 ( .A0(idle), .A1(inputsRecieved), .B0(n29), .Y(n28) );
  INVX2TS U54 ( .A(n44), .Y(outputsReady) );
  INVX2TS U55 ( .A(inputsReady), .Y(n30) );
  INVX2TS U56 ( .A(reset), .Y(n50) );
  OAI21X1TS U57 ( .A0(n36), .A1(n33), .B0(n43), .Y(n220) );
  OAI21X1TS U58 ( .A0(outputsReady), .A1(n30), .B0(idle), .Y(n35) );
  NAND2XLTS U59 ( .A(n47), .B(n35), .Y(n23) );
  AOI21X1TS U60 ( .A0(n44), .A1(n36), .B0(n46), .Y(n5) );
  INVX2TS U61 ( .A(n25), .Y(N22) );
  MXI2X1TS U62 ( .A(softmaxOutput[0]), .B(predictionOutput[0]), .S0(n45), .Y(
        n39) );
  MXI2X1TS U63 ( .A(softmaxOutput[2]), .B(predictionOutput[2]), .S0(n45), .Y(
        n40) );
  MXI2X1TS U64 ( .A(softmaxOutput[3]), .B(predictionOutput[3]), .S0(n45), .Y(
        n41) );
  MXI2X1TS U65 ( .A(softmaxOutput[1]), .B(predictionOutput[1]), .S0(n45), .Y(
        n42) );
  NOR2XLTS U66 ( .A(biasWriteEnable), .B(weightWriteEnable), .Y(n25) );
endmodule

