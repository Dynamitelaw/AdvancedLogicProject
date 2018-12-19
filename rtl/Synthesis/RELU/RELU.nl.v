
module RELU ( sumIn, trigger, layer1Out );
  input [255:0] sumIn;
  output [127:0] layer1Out;
  input trigger;
  wire   n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113, n114, n115, n116, n117, n118, n119, n120, n121,
         n122, n123, n124, n125, n126, n127, n128, n129, n130;

  INVX2TS U99 ( .A(1'b1), .Y(layer1Out[3]) );
  INVX2TS U101 ( .A(1'b1), .Y(layer1Out[7]) );
  INVX2TS U103 ( .A(1'b1), .Y(layer1Out[11]) );
  INVX2TS U105 ( .A(1'b1), .Y(layer1Out[15]) );
  INVX2TS U107 ( .A(1'b1), .Y(layer1Out[19]) );
  INVX2TS U109 ( .A(1'b1), .Y(layer1Out[23]) );
  INVX2TS U111 ( .A(1'b1), .Y(layer1Out[27]) );
  INVX2TS U113 ( .A(1'b1), .Y(layer1Out[31]) );
  INVX2TS U115 ( .A(1'b1), .Y(layer1Out[35]) );
  INVX2TS U117 ( .A(1'b1), .Y(layer1Out[39]) );
  INVX2TS U119 ( .A(1'b1), .Y(layer1Out[43]) );
  INVX2TS U121 ( .A(1'b1), .Y(layer1Out[47]) );
  INVX2TS U123 ( .A(1'b1), .Y(layer1Out[51]) );
  INVX2TS U125 ( .A(1'b1), .Y(layer1Out[55]) );
  INVX2TS U127 ( .A(1'b1), .Y(layer1Out[59]) );
  INVX2TS U129 ( .A(1'b1), .Y(layer1Out[63]) );
  INVX2TS U131 ( .A(1'b1), .Y(layer1Out[67]) );
  INVX2TS U133 ( .A(1'b1), .Y(layer1Out[71]) );
  INVX2TS U135 ( .A(1'b1), .Y(layer1Out[75]) );
  INVX2TS U137 ( .A(1'b1), .Y(layer1Out[79]) );
  INVX2TS U139 ( .A(1'b1), .Y(layer1Out[83]) );
  INVX2TS U141 ( .A(1'b1), .Y(layer1Out[87]) );
  INVX2TS U143 ( .A(1'b1), .Y(layer1Out[91]) );
  INVX2TS U145 ( .A(1'b1), .Y(layer1Out[95]) );
  INVX2TS U147 ( .A(1'b1), .Y(layer1Out[99]) );
  INVX2TS U149 ( .A(1'b1), .Y(layer1Out[103]) );
  INVX2TS U151 ( .A(1'b1), .Y(layer1Out[107]) );
  INVX2TS U153 ( .A(1'b1), .Y(layer1Out[111]) );
  INVX2TS U155 ( .A(1'b1), .Y(layer1Out[115]) );
  INVX2TS U157 ( .A(1'b1), .Y(layer1Out[119]) );
  INVX2TS U159 ( .A(1'b1), .Y(layer1Out[123]) );
  INVX2TS U161 ( .A(1'b1), .Y(layer1Out[127]) );
  INVX2TS U195 ( .A(trigger), .Y(n117) );
  CLKBUFX2TS U196 ( .A(n117), .Y(n115) );
  CLKBUFX2TS U197 ( .A(n115), .Y(n101) );
  CLKBUFX2TS U198 ( .A(n101), .Y(n99) );
  NOR3BXLTS U199 ( .AN(sumIn[252]), .B(sumIn[255]), .C(n99), .Y(layer1Out[124]) );
  NOR3BXLTS U200 ( .AN(sumIn[253]), .B(sumIn[255]), .C(n99), .Y(layer1Out[125]) );
  NOR3BXLTS U201 ( .AN(sumIn[254]), .B(sumIn[255]), .C(n99), .Y(layer1Out[126]) );
  NOR3BXLTS U202 ( .AN(sumIn[244]), .B(sumIn[247]), .C(n99), .Y(layer1Out[120]) );
  CLKBUFX2TS U203 ( .A(n101), .Y(n100) );
  NOR3BXLTS U204 ( .AN(sumIn[245]), .B(sumIn[247]), .C(n100), .Y(
        layer1Out[121]) );
  NOR3BXLTS U205 ( .AN(sumIn[246]), .B(sumIn[247]), .C(n100), .Y(
        layer1Out[122]) );
  NOR3BXLTS U206 ( .AN(sumIn[236]), .B(sumIn[239]), .C(n100), .Y(
        layer1Out[116]) );
  NOR3BXLTS U207 ( .AN(sumIn[237]), .B(sumIn[239]), .C(n100), .Y(
        layer1Out[117]) );
  CLKBUFX2TS U208 ( .A(n101), .Y(n102) );
  NOR3BXLTS U209 ( .AN(sumIn[238]), .B(sumIn[239]), .C(n102), .Y(
        layer1Out[118]) );
  NOR3BXLTS U210 ( .AN(sumIn[228]), .B(sumIn[231]), .C(n102), .Y(
        layer1Out[112]) );
  NOR3BXLTS U211 ( .AN(sumIn[229]), .B(sumIn[231]), .C(n102), .Y(
        layer1Out[113]) );
  NOR3BXLTS U212 ( .AN(sumIn[230]), .B(sumIn[231]), .C(n102), .Y(
        layer1Out[114]) );
  CLKBUFX2TS U213 ( .A(n117), .Y(n103) );
  NOR3BXLTS U214 ( .AN(sumIn[220]), .B(sumIn[223]), .C(n103), .Y(
        layer1Out[108]) );
  NOR3BXLTS U215 ( .AN(sumIn[221]), .B(sumIn[223]), .C(n103), .Y(
        layer1Out[109]) );
  NOR3BXLTS U216 ( .AN(sumIn[222]), .B(sumIn[223]), .C(n103), .Y(
        layer1Out[110]) );
  NOR3BXLTS U217 ( .AN(sumIn[212]), .B(sumIn[215]), .C(n103), .Y(
        layer1Out[104]) );
  CLKBUFX2TS U218 ( .A(n115), .Y(n104) );
  NOR3BXLTS U219 ( .AN(sumIn[213]), .B(sumIn[215]), .C(n104), .Y(
        layer1Out[105]) );
  NOR3BXLTS U220 ( .AN(sumIn[214]), .B(sumIn[215]), .C(n104), .Y(
        layer1Out[106]) );
  NOR3BXLTS U221 ( .AN(sumIn[204]), .B(sumIn[207]), .C(n104), .Y(
        layer1Out[100]) );
  NOR3BXLTS U222 ( .AN(sumIn[205]), .B(sumIn[207]), .C(n104), .Y(
        layer1Out[101]) );
  CLKBUFX2TS U223 ( .A(n115), .Y(n112) );
  CLKBUFX2TS U224 ( .A(n112), .Y(n108) );
  CLKBUFX2TS U225 ( .A(n108), .Y(n105) );
  NOR3BXLTS U226 ( .AN(sumIn[206]), .B(sumIn[207]), .C(n105), .Y(
        layer1Out[102]) );
  NOR3BXLTS U227 ( .AN(sumIn[196]), .B(sumIn[199]), .C(n105), .Y(layer1Out[96]) );
  NOR3BXLTS U228 ( .AN(sumIn[197]), .B(sumIn[199]), .C(n105), .Y(layer1Out[97]) );
  NOR3BXLTS U229 ( .AN(sumIn[198]), .B(sumIn[199]), .C(n105), .Y(layer1Out[98]) );
  CLKBUFX2TS U230 ( .A(n108), .Y(n106) );
  NOR3BXLTS U231 ( .AN(sumIn[188]), .B(sumIn[191]), .C(n106), .Y(layer1Out[92]) );
  NOR3BXLTS U232 ( .AN(sumIn[189]), .B(sumIn[191]), .C(n106), .Y(layer1Out[93]) );
  NOR3BXLTS U233 ( .AN(sumIn[190]), .B(sumIn[191]), .C(n106), .Y(layer1Out[94]) );
  NOR3BXLTS U234 ( .AN(sumIn[180]), .B(sumIn[183]), .C(n106), .Y(layer1Out[88]) );
  CLKBUFX2TS U235 ( .A(n108), .Y(n107) );
  NOR3BXLTS U236 ( .AN(sumIn[181]), .B(sumIn[183]), .C(n107), .Y(layer1Out[89]) );
  NOR3BXLTS U237 ( .AN(sumIn[182]), .B(sumIn[183]), .C(n107), .Y(layer1Out[90]) );
  NOR3BXLTS U238 ( .AN(sumIn[172]), .B(sumIn[175]), .C(n107), .Y(layer1Out[84]) );
  NOR3BXLTS U239 ( .AN(sumIn[173]), .B(sumIn[175]), .C(n107), .Y(layer1Out[85]) );
  CLKBUFX2TS U240 ( .A(n108), .Y(n109) );
  NOR3BXLTS U241 ( .AN(sumIn[174]), .B(sumIn[175]), .C(n109), .Y(layer1Out[86]) );
  NOR3BXLTS U242 ( .AN(sumIn[164]), .B(sumIn[167]), .C(n109), .Y(layer1Out[80]) );
  NOR3BXLTS U243 ( .AN(sumIn[165]), .B(sumIn[167]), .C(n109), .Y(layer1Out[81]) );
  NOR3BXLTS U244 ( .AN(sumIn[166]), .B(sumIn[167]), .C(n109), .Y(layer1Out[82]) );
  CLKBUFX2TS U245 ( .A(n112), .Y(n110) );
  NOR3BXLTS U246 ( .AN(sumIn[156]), .B(sumIn[159]), .C(n110), .Y(layer1Out[76]) );
  NOR3BXLTS U247 ( .AN(sumIn[157]), .B(sumIn[159]), .C(n110), .Y(layer1Out[77]) );
  NOR3BXLTS U248 ( .AN(sumIn[158]), .B(sumIn[159]), .C(n110), .Y(layer1Out[78]) );
  NOR3BXLTS U249 ( .AN(sumIn[148]), .B(sumIn[151]), .C(n110), .Y(layer1Out[72]) );
  CLKBUFX2TS U250 ( .A(n112), .Y(n111) );
  NOR3BXLTS U251 ( .AN(sumIn[149]), .B(sumIn[151]), .C(n111), .Y(layer1Out[73]) );
  NOR3BXLTS U252 ( .AN(sumIn[150]), .B(sumIn[151]), .C(n111), .Y(layer1Out[74]) );
  NOR3BXLTS U253 ( .AN(sumIn[140]), .B(sumIn[143]), .C(n111), .Y(layer1Out[68]) );
  NOR3BXLTS U254 ( .AN(sumIn[141]), .B(sumIn[143]), .C(n111), .Y(layer1Out[69]) );
  CLKBUFX2TS U255 ( .A(n112), .Y(n113) );
  NOR3BXLTS U256 ( .AN(sumIn[142]), .B(sumIn[143]), .C(n113), .Y(layer1Out[70]) );
  NOR3BXLTS U257 ( .AN(sumIn[132]), .B(sumIn[135]), .C(n113), .Y(layer1Out[64]) );
  NOR3BXLTS U258 ( .AN(sumIn[133]), .B(sumIn[135]), .C(n113), .Y(layer1Out[65]) );
  NOR3BXLTS U259 ( .AN(sumIn[134]), .B(sumIn[135]), .C(n113), .Y(layer1Out[66]) );
  CLKBUFX2TS U260 ( .A(n117), .Y(n114) );
  NOR3BXLTS U261 ( .AN(sumIn[124]), .B(sumIn[127]), .C(n114), .Y(layer1Out[60]) );
  NOR3BXLTS U262 ( .AN(sumIn[125]), .B(sumIn[127]), .C(n114), .Y(layer1Out[61]) );
  NOR3BXLTS U263 ( .AN(sumIn[126]), .B(sumIn[127]), .C(n114), .Y(layer1Out[62]) );
  NOR3BXLTS U264 ( .AN(sumIn[116]), .B(sumIn[119]), .C(n114), .Y(layer1Out[56]) );
  CLKBUFX2TS U265 ( .A(n115), .Y(n128) );
  CLKBUFX2TS U266 ( .A(n128), .Y(n125) );
  CLKBUFX2TS U267 ( .A(n125), .Y(n121) );
  CLKBUFX2TS U268 ( .A(n121), .Y(n116) );
  NOR3BXLTS U269 ( .AN(sumIn[117]), .B(sumIn[119]), .C(n116), .Y(layer1Out[57]) );
  NOR3BXLTS U270 ( .AN(sumIn[118]), .B(sumIn[119]), .C(n116), .Y(layer1Out[58]) );
  NOR3BXLTS U271 ( .AN(sumIn[108]), .B(sumIn[111]), .C(n116), .Y(layer1Out[52]) );
  NOR3BXLTS U272 ( .AN(sumIn[109]), .B(sumIn[111]), .C(n116), .Y(layer1Out[53]) );
  CLKBUFX2TS U273 ( .A(n117), .Y(n118) );
  NOR3BXLTS U274 ( .AN(sumIn[110]), .B(sumIn[111]), .C(n118), .Y(layer1Out[54]) );
  NOR3BXLTS U275 ( .AN(sumIn[100]), .B(sumIn[103]), .C(n118), .Y(layer1Out[48]) );
  NOR3BXLTS U276 ( .AN(sumIn[101]), .B(sumIn[103]), .C(n118), .Y(layer1Out[49]) );
  NOR3BXLTS U277 ( .AN(sumIn[102]), .B(sumIn[103]), .C(n118), .Y(layer1Out[50]) );
  CLKBUFX2TS U278 ( .A(n121), .Y(n119) );
  NOR3BXLTS U279 ( .AN(sumIn[92]), .B(sumIn[95]), .C(n119), .Y(layer1Out[44])
         );
  NOR3BXLTS U280 ( .AN(sumIn[93]), .B(sumIn[95]), .C(n119), .Y(layer1Out[45])
         );
  NOR3BXLTS U281 ( .AN(sumIn[94]), .B(sumIn[95]), .C(n119), .Y(layer1Out[46])
         );
  NOR3BXLTS U282 ( .AN(sumIn[84]), .B(sumIn[87]), .C(n119), .Y(layer1Out[40])
         );
  CLKBUFX2TS U283 ( .A(n121), .Y(n120) );
  NOR3BXLTS U284 ( .AN(sumIn[85]), .B(sumIn[87]), .C(n120), .Y(layer1Out[41])
         );
  NOR3BXLTS U285 ( .AN(sumIn[86]), .B(sumIn[87]), .C(n120), .Y(layer1Out[42])
         );
  NOR3BXLTS U286 ( .AN(sumIn[76]), .B(sumIn[79]), .C(n120), .Y(layer1Out[36])
         );
  NOR3BXLTS U287 ( .AN(sumIn[77]), .B(sumIn[79]), .C(n120), .Y(layer1Out[37])
         );
  CLKBUFX2TS U288 ( .A(n121), .Y(n122) );
  NOR3BXLTS U289 ( .AN(sumIn[78]), .B(sumIn[79]), .C(n122), .Y(layer1Out[38])
         );
  NOR3BXLTS U290 ( .AN(sumIn[68]), .B(sumIn[71]), .C(n122), .Y(layer1Out[32])
         );
  NOR3BXLTS U291 ( .AN(sumIn[69]), .B(sumIn[71]), .C(n122), .Y(layer1Out[33])
         );
  NOR3BXLTS U292 ( .AN(sumIn[70]), .B(sumIn[71]), .C(n122), .Y(layer1Out[34])
         );
  CLKBUFX2TS U293 ( .A(n125), .Y(n123) );
  NOR3BXLTS U294 ( .AN(sumIn[60]), .B(sumIn[63]), .C(n123), .Y(layer1Out[28])
         );
  NOR3BXLTS U295 ( .AN(sumIn[61]), .B(sumIn[63]), .C(n123), .Y(layer1Out[29])
         );
  NOR3BXLTS U296 ( .AN(sumIn[62]), .B(sumIn[63]), .C(n123), .Y(layer1Out[30])
         );
  NOR3BXLTS U297 ( .AN(sumIn[52]), .B(sumIn[55]), .C(n123), .Y(layer1Out[24])
         );
  CLKBUFX2TS U298 ( .A(n125), .Y(n124) );
  NOR3BXLTS U299 ( .AN(sumIn[53]), .B(sumIn[55]), .C(n124), .Y(layer1Out[25])
         );
  NOR3BXLTS U300 ( .AN(sumIn[54]), .B(sumIn[55]), .C(n124), .Y(layer1Out[26])
         );
  NOR3BXLTS U301 ( .AN(sumIn[44]), .B(sumIn[47]), .C(n124), .Y(layer1Out[20])
         );
  NOR3BXLTS U302 ( .AN(sumIn[45]), .B(sumIn[47]), .C(n124), .Y(layer1Out[21])
         );
  CLKBUFX2TS U303 ( .A(n125), .Y(n126) );
  NOR3BXLTS U304 ( .AN(sumIn[46]), .B(sumIn[47]), .C(n126), .Y(layer1Out[22])
         );
  NOR3BXLTS U305 ( .AN(sumIn[36]), .B(sumIn[39]), .C(n126), .Y(layer1Out[16])
         );
  NOR3BXLTS U306 ( .AN(sumIn[37]), .B(sumIn[39]), .C(n126), .Y(layer1Out[17])
         );
  NOR3BXLTS U307 ( .AN(sumIn[38]), .B(sumIn[39]), .C(n126), .Y(layer1Out[18])
         );
  CLKBUFX2TS U308 ( .A(n128), .Y(n129) );
  CLKBUFX2TS U309 ( .A(n129), .Y(n127) );
  NOR3BXLTS U310 ( .AN(sumIn[28]), .B(sumIn[31]), .C(n127), .Y(layer1Out[12])
         );
  NOR3BXLTS U311 ( .AN(sumIn[29]), .B(sumIn[31]), .C(n127), .Y(layer1Out[13])
         );
  NOR3BXLTS U312 ( .AN(sumIn[30]), .B(sumIn[31]), .C(n127), .Y(layer1Out[14])
         );
  NOR3BXLTS U313 ( .AN(sumIn[20]), .B(sumIn[23]), .C(n127), .Y(layer1Out[8])
         );
  NOR3BXLTS U314 ( .AN(sumIn[21]), .B(sumIn[23]), .C(n129), .Y(layer1Out[9])
         );
  NOR3BXLTS U315 ( .AN(sumIn[22]), .B(sumIn[23]), .C(n128), .Y(layer1Out[10])
         );
  NOR3BXLTS U316 ( .AN(sumIn[12]), .B(sumIn[15]), .C(n129), .Y(layer1Out[4])
         );
  NOR3BXLTS U317 ( .AN(sumIn[13]), .B(sumIn[15]), .C(n128), .Y(layer1Out[5])
         );
  CLKBUFX2TS U318 ( .A(n129), .Y(n130) );
  NOR3BXLTS U319 ( .AN(sumIn[14]), .B(sumIn[15]), .C(n130), .Y(layer1Out[6])
         );
  NOR3BXLTS U320 ( .AN(sumIn[4]), .B(sumIn[7]), .C(n130), .Y(layer1Out[0]) );
  NOR3BXLTS U321 ( .AN(sumIn[5]), .B(sumIn[7]), .C(n130), .Y(layer1Out[1]) );
  NOR3BXLTS U322 ( .AN(sumIn[6]), .B(sumIn[7]), .C(n130), .Y(layer1Out[2]) );
endmodule

