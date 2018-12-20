
module Layer1_Controller ( reset, clk, inputsReady, queueEmpty, 
        outputsRecieved, weightWriteEnable, biasWriteEnable, 
        WriteAddressSelect, writeIn, queueOut, outputsReady, dequeue, 
        layer1Output );
  input [9:0] WriteAddressSelect;
  input [15:0] writeIn;
  input [9:0] queueOut;
  output [23:0] layer1Output;
  input reset, clk, inputsReady, queueEmpty, outputsRecieved,
         weightWriteEnable, biasWriteEnable;
  output outputsReady, dequeue;
  wire   wBuffer_A_Write, pstoreReset, reluTrigger, idle, processFinished, N18,
         n5, n6, n7, n14, n15, n16, n17, n180, n19, n20, n21, n22, n23, n24,
         n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69;
  wire   [9:0] nodeAddress;
  wire   [15:0] weightStorageBus;
  wire   [15:0] wBuffer_A_Out;
  wire   [23:0] pstoreOutput;
  wire   [23:0] reluOutput;

  Layer1WeightStorage weightStorage ( .writeEnable(weightWriteEnable), 
        .NodeSelect(nodeAddress), .writeIn(writeIn), .readOut(weightStorageBus) );
  NodeWeightBank weightBuffer_A ( .writeEnable(wBuffer_A_Write), .writeIn(
        weightStorageBus), .readOut(wBuffer_A_Out) );
  pStore plusStore ( .clk(clk), .clr(pstoreReset), .weightsIn(wBuffer_A_Out), 
        .biasesIn(writeIn), .biasWriteEnable(biasWriteEnable), .sumOut(
        pstoreOutput) );
  RELU relu ( .sumIn(pstoreOutput), .trigger(reluTrigger), .layer1Out(
        reluOutput) );
  DFFRX4TS wBuffer_A_Write_reg ( .D(n6), .CK(clk), .RN(n69), .Q(
        wBuffer_A_Write) );
  DFFSX4TS processFinished_reg ( .D(n60), .CK(clk), .SN(n69), .Q(n62), .QN(
        processFinished) );
  AO22XLTS U49 ( .A0(N18), .A1(WriteAddressSelect[9]), .B0(n43), .B1(
        queueOut[9]), .Y(nodeAddress[9]) );
  AO22XLTS U50 ( .A0(N18), .A1(WriteAddressSelect[8]), .B0(n43), .B1(
        queueOut[8]), .Y(nodeAddress[8]) );
  AO22XLTS U51 ( .A0(N18), .A1(WriteAddressSelect[7]), .B0(n43), .B1(
        queueOut[7]), .Y(nodeAddress[7]) );
  AO22XLTS U52 ( .A0(N18), .A1(WriteAddressSelect[6]), .B0(n43), .B1(
        queueOut[6]), .Y(nodeAddress[6]) );
  AO22XLTS U53 ( .A0(N18), .A1(WriteAddressSelect[5]), .B0(n43), .B1(
        queueOut[5]), .Y(nodeAddress[5]) );
  AO22XLTS U54 ( .A0(N18), .A1(WriteAddressSelect[4]), .B0(n43), .B1(
        queueOut[4]), .Y(nodeAddress[4]) );
  AO22XLTS U55 ( .A0(N18), .A1(WriteAddressSelect[3]), .B0(n43), .B1(
        queueOut[3]), .Y(nodeAddress[3]) );
  AO22XLTS U56 ( .A0(N18), .A1(WriteAddressSelect[2]), .B0(n43), .B1(
        queueOut[2]), .Y(nodeAddress[2]) );
  AO22XLTS U57 ( .A0(N18), .A1(WriteAddressSelect[1]), .B0(n43), .B1(
        queueOut[1]), .Y(nodeAddress[1]) );
  AO22XLTS U58 ( .A0(N18), .A1(WriteAddressSelect[0]), .B0(n43), .B1(
        queueOut[0]), .Y(nodeAddress[0]) );
  DFFHQX8TS layer1Output_reg_23_ ( .D(n37), .CK(clk), .Q(layer1Output[23]) );
  DFFHQX8TS layer1Output_reg_0_ ( .D(n14), .CK(clk), .Q(layer1Output[0]) );
  DFFHQX8TS layer1Output_reg_1_ ( .D(n15), .CK(clk), .Q(layer1Output[1]) );
  DFFHQX8TS layer1Output_reg_2_ ( .D(n16), .CK(clk), .Q(layer1Output[2]) );
  DFFHQX8TS layer1Output_reg_3_ ( .D(n17), .CK(clk), .Q(layer1Output[3]) );
  DFFHQX8TS layer1Output_reg_4_ ( .D(n180), .CK(clk), .Q(layer1Output[4]) );
  DFFHQX8TS layer1Output_reg_5_ ( .D(n19), .CK(clk), .Q(layer1Output[5]) );
  DFFHQX8TS layer1Output_reg_6_ ( .D(n20), .CK(clk), .Q(layer1Output[6]) );
  DFFHQX8TS layer1Output_reg_7_ ( .D(n21), .CK(clk), .Q(layer1Output[7]) );
  DFFHQX8TS layer1Output_reg_8_ ( .D(n22), .CK(clk), .Q(layer1Output[8]) );
  DFFHQX8TS layer1Output_reg_9_ ( .D(n23), .CK(clk), .Q(layer1Output[9]) );
  DFFHQX8TS layer1Output_reg_10_ ( .D(n24), .CK(clk), .Q(layer1Output[10]) );
  DFFHQX8TS layer1Output_reg_11_ ( .D(n25), .CK(clk), .Q(layer1Output[11]) );
  DFFHQX8TS layer1Output_reg_12_ ( .D(n26), .CK(clk), .Q(layer1Output[12]) );
  DFFHQX8TS layer1Output_reg_13_ ( .D(n27), .CK(clk), .Q(layer1Output[13]) );
  DFFHQX8TS layer1Output_reg_14_ ( .D(n28), .CK(clk), .Q(layer1Output[14]) );
  DFFHQX8TS layer1Output_reg_15_ ( .D(n29), .CK(clk), .Q(layer1Output[15]) );
  DFFHQX8TS layer1Output_reg_16_ ( .D(n30), .CK(clk), .Q(layer1Output[16]) );
  DFFHQX8TS layer1Output_reg_21_ ( .D(n35), .CK(clk), .Q(layer1Output[21]) );
  DFFHQX8TS layer1Output_reg_20_ ( .D(n34), .CK(clk), .Q(layer1Output[20]) );
  DFFHQX8TS layer1Output_reg_19_ ( .D(n33), .CK(clk), .Q(layer1Output[19]) );
  DFFHQX8TS layer1Output_reg_18_ ( .D(n32), .CK(clk), .Q(layer1Output[18]) );
  DFFHQX8TS layer1Output_reg_17_ ( .D(n31), .CK(clk), .Q(layer1Output[17]) );
  DFFHQX8TS layer1Output_reg_22_ ( .D(n36), .CK(clk), .Q(layer1Output[22]) );
  DFFSXLTS pstoreReset_reg ( .D(n7), .CK(clk), .SN(n69), .Q(pstoreReset) );
  DFFSHQX8TS outputsReady_reg ( .D(n46), .CK(clk), .SN(n69), .Q(n59) );
  NOR4BBX1TS U48 ( .AN(n58), .BN(clk), .C(outputsReady), .D(n63), .Y(dequeue)
         );
  DFFSHQX1TS idle_reg ( .D(n38), .CK(clk), .SN(n69), .Q(idle) );
  DFFRXLTS reluTrigger_reg ( .D(n5), .CK(clk), .RN(n69), .Q(reluTrigger) );
  CLKINVX1TS U59 ( .A(n54), .Y(n44) );
  INVX2TS U60 ( .A(idle), .Y(n48) );
  INVX2TS U61 ( .A(n59), .Y(outputsReady) );
  OA21XLTS U62 ( .A0(n45), .A1(n59), .B0(n44), .Y(n46) );
  OAI21X1TS U63 ( .A0(n56), .A1(n48), .B0(n55), .Y(n38) );
  INVX12TS U64 ( .A(n52), .Y(n64) );
  NAND2BX1TS U65 ( .AN(outputsReady), .B(n56), .Y(n51) );
  AND2X8TS U66 ( .A(n54), .B(n69), .Y(n52) );
  NOR3X1TS U67 ( .A(n48), .B(n47), .C(n63), .Y(n56) );
  INVX1TS U68 ( .A(pstoreReset), .Y(n68) );
  INVX2TS U69 ( .A(wBuffer_A_Write), .Y(n66) );
  NOR2X4TS U70 ( .A(idle), .B(n62), .Y(n54) );
  INVX1TS U71 ( .A(n47), .Y(n58) );
  CLKBUFX2TS U72 ( .A(queueEmpty), .Y(n63) );
  NAND3X1TS U73 ( .A(n48), .B(n62), .C(n63), .Y(n53) );
  INVX2TS U74 ( .A(layer1Output[22]), .Y(n57) );
  OA21XLTS U75 ( .A0(n56), .A1(n62), .B0(n50), .Y(n60) );
  INVX2TS U76 ( .A(reluTrigger), .Y(n65) );
  NOR2BX1TS U77 ( .AN(outputsRecieved), .B(n48), .Y(n45) );
  INVX2TS U78 ( .A(reset), .Y(n69) );
  INVX2TS U79 ( .A(inputsReady), .Y(n47) );
  INVX1TS U80 ( .A(n53), .Y(n49) );
  AOI21X1TS U81 ( .A0(processFinished), .A1(outputsReady), .B0(n49), .Y(n50)
         );
  NAND2X1TS U82 ( .A(n51), .B(n66), .Y(n6) );
  OAI21XLTS U83 ( .A0(n54), .A1(n65), .B0(n53), .Y(n5) );
  INVX2TS U84 ( .A(n43), .Y(N18) );
  AOI21X1TS U85 ( .A0(idle), .A1(outputsReady), .B0(n54), .Y(n55) );
  OAI21X1TS U86 ( .A0(n56), .A1(n68), .B0(n67), .Y(n7) );
  MXI2X1TS U87 ( .A(n61), .B(n57), .S0(n64), .Y(n36) );
  NOR2X1TS U88 ( .A(biasWriteEnable), .B(weightWriteEnable), .Y(n43) );
  INVX2TS U89 ( .A(reluOutput[22]), .Y(n61) );
  CLKMX2X2TS U90 ( .A(reluOutput[10]), .B(layer1Output[10]), .S0(n64), .Y(n24)
         );
  CLKMX2X2TS U91 ( .A(reluOutput[11]), .B(layer1Output[11]), .S0(n64), .Y(n25)
         );
  CLKMX2X2TS U92 ( .A(reluOutput[14]), .B(layer1Output[14]), .S0(n64), .Y(n28)
         );
  CLKMX2X2TS U93 ( .A(reluOutput[15]), .B(layer1Output[15]), .S0(n64), .Y(n29)
         );
  CLKMX2X2TS U94 ( .A(reluOutput[16]), .B(layer1Output[16]), .S0(n64), .Y(n30)
         );
  CLKMX2X2TS U95 ( .A(reluOutput[17]), .B(layer1Output[17]), .S0(n64), .Y(n31)
         );
  CLKMX2X2TS U96 ( .A(reluOutput[18]), .B(layer1Output[18]), .S0(n64), .Y(n32)
         );
  CLKMX2X2TS U97 ( .A(reluOutput[19]), .B(layer1Output[19]), .S0(n64), .Y(n33)
         );
  CLKMX2X2TS U98 ( .A(reluOutput[20]), .B(layer1Output[20]), .S0(n64), .Y(n34)
         );
  CLKMX2X2TS U99 ( .A(reluOutput[21]), .B(layer1Output[21]), .S0(n64), .Y(n35)
         );
  CLKMX2X2TS U100 ( .A(reluOutput[12]), .B(layer1Output[12]), .S0(n64), .Y(n26) );
  CLKMX2X2TS U101 ( .A(reluOutput[13]), .B(layer1Output[13]), .S0(n64), .Y(n27) );
  CLKMX2X2TS U102 ( .A(reluOutput[7]), .B(layer1Output[7]), .S0(n64), .Y(n21)
         );
  CLKMX2X2TS U103 ( .A(reluOutput[6]), .B(layer1Output[6]), .S0(n64), .Y(n20)
         );
  CLKMX2X2TS U104 ( .A(reluOutput[5]), .B(layer1Output[5]), .S0(n64), .Y(n19)
         );
  CLKMX2X2TS U105 ( .A(reluOutput[4]), .B(layer1Output[4]), .S0(n64), .Y(n180)
         );
  CLKMX2X2TS U106 ( .A(reluOutput[3]), .B(layer1Output[3]), .S0(n64), .Y(n17)
         );
  CLKMX2X2TS U107 ( .A(reluOutput[2]), .B(layer1Output[2]), .S0(n64), .Y(n16)
         );
  CLKMX2X2TS U108 ( .A(reluOutput[1]), .B(layer1Output[1]), .S0(n64), .Y(n15)
         );
  CLKMX2X2TS U109 ( .A(reluOutput[0]), .B(layer1Output[0]), .S0(n64), .Y(n14)
         );
  CLKMX2X2TS U110 ( .A(reluOutput[9]), .B(layer1Output[9]), .S0(n64), .Y(n23)
         );
  CLKMX2X2TS U111 ( .A(reluOutput[8]), .B(layer1Output[8]), .S0(n64), .Y(n22)
         );
  CLKMX2X2TS U112 ( .A(reluOutput[23]), .B(layer1Output[23]), .S0(n64), .Y(n37) );
  AOI21X1TS U113 ( .A0(outputsReady), .A1(pstoreReset), .B0(n54), .Y(n67) );
endmodule

