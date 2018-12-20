
module ReluNodeQueue ( reset, ReluNodeValues, dequeue, writeEnable, indexOut, 
        NodeValueOut, queueEmpty );
  input [127:0] ReluNodeValues;
  output [2:0] indexOut;
  output [3:0] NodeValueOut;
  input reset, dequeue, writeEnable;
  output queueEmpty;
  wire   ReluQueueRegister_7__3_, ReluQueueRegister_7__2_,
         ReluQueueRegister_7__1_, ReluQueueRegister_7__0_,
         ReluQueueRegister_6__3_, ReluQueueRegister_6__2_,
         ReluQueueRegister_6__1_, ReluQueueRegister_6__0_,
         ReluQueueRegister_5__3_, ReluQueueRegister_5__2_,
         ReluQueueRegister_5__1_, ReluQueueRegister_5__0_,
         ReluQueueRegister_4__3_, ReluQueueRegister_4__2_,
         ReluQueueRegister_4__1_, ReluQueueRegister_4__0_,
         ReluQueueRegister_3__3_, ReluQueueRegister_3__2_,
         ReluQueueRegister_3__1_, ReluQueueRegister_3__0_,
         ReluQueueRegister_2__3_, ReluQueueRegister_2__2_,
         ReluQueueRegister_2__1_, ReluQueueRegister_2__0_,
         ReluQueueRegister_1__3_, ReluQueueRegister_1__2_,
         ReluQueueRegister_1__1_, ReluQueueRegister_1__0_,
         ReluQueueRegister_0__3_, ReluQueueRegister_0__2_,
         ReluQueueRegister_0__1_, ReluQueueRegister_0__0_, N4, N5, N6, N7, N12,
         N13, n29, n36, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55,
         n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69,
         n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83,
         n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97,
         n98, n99, n100;
  wire   [2:0] frontPointer;

  DFFNSRX1TS frontPointer_reg_2_ ( .D(N13), .CKN(n89), .SN(1'b1), .RN(n36), 
        .Q(frontPointer[2]), .QN(n91) );
  TLATXLTS ReluQueueRegister_reg_3__3_ ( .G(n98), .D(ReluNodeValues[115]), .Q(
        ReluQueueRegister_3__3_) );
  TLATXLTS ReluQueueRegister_reg_3__2_ ( .G(n98), .D(ReluNodeValues[114]), .Q(
        ReluQueueRegister_3__2_) );
  TLATXLTS ReluQueueRegister_reg_3__1_ ( .G(n98), .D(ReluNodeValues[113]), .Q(
        ReluQueueRegister_3__1_) );
  TLATXLTS ReluQueueRegister_reg_3__0_ ( .G(n98), .D(ReluNodeValues[112]), .Q(
        ReluQueueRegister_3__0_) );
  TLATXLTS ReluQueueRegister_reg_2__3_ ( .G(n99), .D(ReluNodeValues[119]), .Q(
        ReluQueueRegister_2__3_) );
  TLATXLTS ReluQueueRegister_reg_2__2_ ( .G(n99), .D(ReluNodeValues[118]), .Q(
        ReluQueueRegister_2__2_) );
  TLATXLTS ReluQueueRegister_reg_2__1_ ( .G(n99), .D(ReluNodeValues[117]), .Q(
        ReluQueueRegister_2__1_) );
  TLATXLTS ReluQueueRegister_reg_2__0_ ( .G(n99), .D(ReluNodeValues[116]), .Q(
        ReluQueueRegister_2__0_) );
  TLATXLTS ReluQueueRegister_reg_7__3_ ( .G(n94), .D(ReluNodeValues[99]), .Q(
        ReluQueueRegister_7__3_) );
  TLATXLTS ReluQueueRegister_reg_7__2_ ( .G(n94), .D(ReluNodeValues[98]), .Q(
        ReluQueueRegister_7__2_) );
  TLATXLTS ReluQueueRegister_reg_7__1_ ( .G(n94), .D(ReluNodeValues[97]), .Q(
        ReluQueueRegister_7__1_) );
  TLATXLTS ReluQueueRegister_reg_7__0_ ( .G(n94), .D(ReluNodeValues[96]), .Q(
        ReluQueueRegister_7__0_) );
  TLATXLTS ReluQueueRegister_reg_6__3_ ( .G(n95), .D(ReluNodeValues[103]), .Q(
        ReluQueueRegister_6__3_) );
  TLATXLTS ReluQueueRegister_reg_6__2_ ( .G(n95), .D(ReluNodeValues[102]), .Q(
        ReluQueueRegister_6__2_) );
  TLATXLTS ReluQueueRegister_reg_6__1_ ( .G(n95), .D(ReluNodeValues[101]), .Q(
        ReluQueueRegister_6__1_) );
  TLATXLTS ReluQueueRegister_reg_6__0_ ( .G(n95), .D(ReluNodeValues[100]), .Q(
        ReluQueueRegister_6__0_) );
  TLATXLTS ReluQueueRegister_reg_4__3_ ( .G(n97), .D(ReluNodeValues[111]), .Q(
        ReluQueueRegister_4__3_) );
  TLATXLTS ReluQueueRegister_reg_4__2_ ( .G(n97), .D(ReluNodeValues[110]), .Q(
        ReluQueueRegister_4__2_) );
  TLATXLTS ReluQueueRegister_reg_4__1_ ( .G(n97), .D(ReluNodeValues[109]), .Q(
        ReluQueueRegister_4__1_) );
  TLATXLTS ReluQueueRegister_reg_4__0_ ( .G(n97), .D(ReluNodeValues[108]), .Q(
        ReluQueueRegister_4__0_) );
  TLATXLTS ReluQueueRegister_reg_5__3_ ( .G(n96), .D(ReluNodeValues[107]), .Q(
        ReluQueueRegister_5__3_) );
  TLATXLTS ReluQueueRegister_reg_5__2_ ( .G(n96), .D(ReluNodeValues[106]), .Q(
        ReluQueueRegister_5__2_) );
  TLATXLTS ReluQueueRegister_reg_5__1_ ( .G(n96), .D(ReluNodeValues[105]), .Q(
        ReluQueueRegister_5__1_) );
  TLATXLTS ReluQueueRegister_reg_5__0_ ( .G(n96), .D(ReluNodeValues[104]), .Q(
        ReluQueueRegister_5__0_) );
  TLATXLTS ReluQueueRegister_reg_1__3_ ( .G(n100), .D(ReluNodeValues[123]), 
        .Q(ReluQueueRegister_1__3_) );
  TLATXLTS ReluQueueRegister_reg_1__2_ ( .G(n100), .D(ReluNodeValues[122]), 
        .Q(ReluQueueRegister_1__2_) );
  TLATXLTS ReluQueueRegister_reg_1__1_ ( .G(n100), .D(ReluNodeValues[121]), 
        .Q(ReluQueueRegister_1__1_) );
  TLATXLTS ReluQueueRegister_reg_1__0_ ( .G(n100), .D(ReluNodeValues[120]), 
        .Q(ReluQueueRegister_1__0_) );
  TLATXLTS ReluQueueRegister_reg_0__3_ ( .G(writeEnable), .D(
        ReluNodeValues[127]), .Q(ReluQueueRegister_0__3_) );
  TLATXLTS ReluQueueRegister_reg_0__2_ ( .G(n93), .D(ReluNodeValues[126]), .Q(
        ReluQueueRegister_0__2_) );
  TLATXLTS ReluQueueRegister_reg_0__1_ ( .G(n93), .D(ReluNodeValues[125]), .Q(
        ReluQueueRegister_0__1_) );
  TLATXLTS ReluQueueRegister_reg_0__0_ ( .G(n93), .D(ReluNodeValues[124]), .Q(
        ReluQueueRegister_0__0_) );
  DFFNSRX1TS frontPointer_reg_1_ ( .D(N12), .CKN(n88), .SN(1'b1), .RN(n36), 
        .Q(frontPointer[1]), .QN(n45) );
  DFFNSRX1TS frontPointer_reg_0_ ( .D(n92), .CKN(n89), .SN(1'b1), .RN(n36), 
        .Q(frontPointer[0]), .QN(n92) );
  DFFRXLTS NodeValueOut_reg_3_ ( .D(N4), .CK(n87), .RN(n29), .Q(
        NodeValueOut[3]) );
  DFFRXLTS NodeValueOut_reg_2_ ( .D(N5), .CK(n87), .RN(n29), .Q(
        NodeValueOut[2]) );
  DFFRXLTS NodeValueOut_reg_1_ ( .D(N6), .CK(n87), .RN(n29), .Q(
        NodeValueOut[1]) );
  DFFRXLTS NodeValueOut_reg_0_ ( .D(N7), .CK(n89), .RN(n90), .Q(
        NodeValueOut[0]) );
  DFFRXLTS indexOut_reg_2_ ( .D(n86), .CK(n88), .RN(n90), .Q(indexOut[2]) );
  DFFRXLTS indexOut_reg_1_ ( .D(n85), .CK(n89), .RN(n90), .Q(indexOut[1]) );
  DFFRXLTS indexOut_reg_0_ ( .D(frontPointer[0]), .CK(n88), .RN(n90), .Q(
        indexOut[0]) );
  INVX2TS U40 ( .A(1'b1), .Y(queueEmpty) );
  OR2X1TS U42 ( .A(frontPointer[1]), .B(frontPointer[0]), .Y(n46) );
  INVX2TS U43 ( .A(n45), .Y(n85) );
  INVX2TS U44 ( .A(frontPointer[2]), .Y(n52) );
  INVX2TS U45 ( .A(n52), .Y(n86) );
  INVX2TS U46 ( .A(dequeue), .Y(n47) );
  INVX2TS U47 ( .A(n47), .Y(n87) );
  INVX2TS U48 ( .A(n47), .Y(n88) );
  INVX2TS U49 ( .A(n47), .Y(n89) );
  INVX1TS U50 ( .A(reset), .Y(n29) );
  CLKBUFX2TS U51 ( .A(n29), .Y(n90) );
  CLKBUFX2TS U52 ( .A(writeEnable), .Y(n48) );
  CLKBUFX2TS U53 ( .A(n48), .Y(n98) );
  CLKBUFX2TS U54 ( .A(n48), .Y(n49) );
  CLKBUFX2TS U55 ( .A(n49), .Y(n94) );
  CLKBUFX2TS U56 ( .A(n49), .Y(n95) );
  CLKBUFX2TS U57 ( .A(n48), .Y(n99) );
  CLKBUFX2TS U58 ( .A(n48), .Y(n97) );
  CLKBUFX2TS U59 ( .A(n49), .Y(n96) );
  CLKBUFX2TS U60 ( .A(n49), .Y(n100) );
  CLKBUFX2TS U61 ( .A(writeEnable), .Y(n93) );
  NOR2XLTS U62 ( .A(reset), .B(n93), .Y(n36) );
  OR2X1TS U63 ( .A(n85), .B(n92), .Y(n53) );
  INVX2TS U64 ( .A(n53), .Y(n67) );
  NAND2X1TS U65 ( .A(n92), .B(n85), .Y(n50) );
  INVX2TS U66 ( .A(n50), .Y(n51) );
  INVX2TS U67 ( .A(n50), .Y(n74) );
  OR2X1TS U68 ( .A(n67), .B(n74), .Y(N12) );
  NAND2X1TS U69 ( .A(n85), .B(frontPointer[0]), .Y(n54) );
  INVX2TS U70 ( .A(n54), .Y(n68) );
  AOI22X1TS U71 ( .A0(frontPointer[2]), .A1(n68), .B0(n54), .B1(n91), .Y(N13)
         );
  INVX2TS U72 ( .A(n53), .Y(n75) );
  INVX2TS U73 ( .A(n50), .Y(n60) );
  AOI22X1TS U74 ( .A0(n75), .A1(ReluQueueRegister_5__3_), .B0(n60), .B1(
        ReluQueueRegister_6__3_), .Y(n59) );
  INVX2TS U75 ( .A(n46), .Y(n61) );
  INVX2TS U76 ( .A(n54), .Y(n76) );
  AOI22X1TS U77 ( .A0(n61), .A1(ReluQueueRegister_4__3_), .B0(n76), .B1(
        ReluQueueRegister_7__3_), .Y(n58) );
  INVX2TS U78 ( .A(n53), .Y(n77) );
  AOI22X1TS U79 ( .A0(n77), .A1(ReluQueueRegister_1__3_), .B0(n60), .B1(
        ReluQueueRegister_2__3_), .Y(n56) );
  INVX2TS U80 ( .A(n54), .Y(n78) );
  AOI22X1TS U81 ( .A0(n61), .A1(ReluQueueRegister_0__3_), .B0(n78), .B1(
        ReluQueueRegister_3__3_), .Y(n55) );
  CLKAND2X2TS U82 ( .A(n56), .B(n55), .Y(n57) );
  AOI32X1TS U83 ( .A0(n59), .A1(n86), .A2(n58), .B0(n57), .B1(n52), .Y(N4) );
  AOI22X1TS U84 ( .A0(n67), .A1(ReluQueueRegister_5__2_), .B0(n60), .B1(
        ReluQueueRegister_6__2_), .Y(n66) );
  AOI22X1TS U85 ( .A0(n61), .A1(ReluQueueRegister_4__2_), .B0(n68), .B1(
        ReluQueueRegister_7__2_), .Y(n65) );
  AOI22X1TS U86 ( .A0(n75), .A1(ReluQueueRegister_1__2_), .B0(n51), .B1(
        ReluQueueRegister_2__2_), .Y(n63) );
  AOI22X1TS U87 ( .A0(n61), .A1(ReluQueueRegister_0__2_), .B0(n76), .B1(
        ReluQueueRegister_3__2_), .Y(n62) );
  CLKAND2X2TS U88 ( .A(n63), .B(n62), .Y(n64) );
  AOI32X1TS U89 ( .A0(n66), .A1(frontPointer[2]), .A2(n65), .B0(n64), .B1(n91), 
        .Y(N5) );
  AOI22X1TS U90 ( .A0(n77), .A1(ReluQueueRegister_5__1_), .B0(n74), .B1(
        ReluQueueRegister_6__1_), .Y(n73) );
  INVX2TS U91 ( .A(n46), .Y(n79) );
  AOI22X1TS U92 ( .A0(n79), .A1(ReluQueueRegister_4__1_), .B0(n78), .B1(
        ReluQueueRegister_7__1_), .Y(n72) );
  AOI22X1TS U93 ( .A0(n67), .A1(ReluQueueRegister_1__1_), .B0(n51), .B1(
        ReluQueueRegister_2__1_), .Y(n70) );
  AOI22X1TS U94 ( .A0(n79), .A1(ReluQueueRegister_0__1_), .B0(n68), .B1(
        ReluQueueRegister_3__1_), .Y(n69) );
  CLKAND2X2TS U95 ( .A(n70), .B(n69), .Y(n71) );
  AOI32X1TS U96 ( .A0(n73), .A1(n86), .A2(n72), .B0(n71), .B1(n91), .Y(N6) );
  AOI22X1TS U97 ( .A0(n75), .A1(ReluQueueRegister_5__0_), .B0(n74), .B1(
        ReluQueueRegister_6__0_), .Y(n84) );
  AOI22X1TS U98 ( .A0(n79), .A1(ReluQueueRegister_4__0_), .B0(n76), .B1(
        ReluQueueRegister_7__0_), .Y(n83) );
  AOI22X1TS U99 ( .A0(n77), .A1(ReluQueueRegister_1__0_), .B0(n74), .B1(
        ReluQueueRegister_2__0_), .Y(n81) );
  AOI22X1TS U100 ( .A0(n79), .A1(ReluQueueRegister_0__0_), .B0(n78), .B1(
        ReluQueueRegister_3__0_), .Y(n80) );
  CLKAND2X2TS U101 ( .A(n81), .B(n80), .Y(n82) );
  AOI32X1TS U102 ( .A0(n84), .A1(n86), .A2(n83), .B0(n82), .B1(n91), .Y(N7) );
endmodule

