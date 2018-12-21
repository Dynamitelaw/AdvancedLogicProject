###################################################################

# Created by write_sdc on Thu Dec 20 11:57:48 2018

###################################################################
set sdc_version 1.7

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_max_fanout 4 [current_design]
set_max_area 0
set_driving_cell -lib_cell INVX1TS [get_ports writeEnable]
set_driving_cell -lib_cell INVX1TS [get_ports {NodeSelect[2]}]
set_driving_cell -lib_cell INVX1TS [get_ports {NodeSelect[1]}]
set_driving_cell -lib_cell INVX1TS [get_ports {NodeSelect[0]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[59]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[58]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[57]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[56]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[55]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[54]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[53]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[52]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[51]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[50]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[49]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[48]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[47]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[46]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[45]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[44]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[43]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[42]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[41]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[40]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[39]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[38]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[37]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[36]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[35]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[34]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[33]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[32]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[31]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[30]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[29]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[28]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[27]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[26]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[25]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[24]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[23]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[22]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[21]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[20]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[19]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[18]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[17]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[16]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[15]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[14]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[13]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[12]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[11]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[10]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[9]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[8]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[7]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[6]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[5]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[4]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[3]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[2]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[1]}]
set_driving_cell -lib_cell INVX1TS [get_ports {writeIn[0]}]
set_load -pin_load 0.005 [get_ports {readOut[59]}]
set_load -pin_load 0.005 [get_ports {readOut[58]}]
set_load -pin_load 0.005 [get_ports {readOut[57]}]
set_load -pin_load 0.005 [get_ports {readOut[56]}]
set_load -pin_load 0.005 [get_ports {readOut[55]}]
set_load -pin_load 0.005 [get_ports {readOut[54]}]
set_load -pin_load 0.005 [get_ports {readOut[53]}]
set_load -pin_load 0.005 [get_ports {readOut[52]}]
set_load -pin_load 0.005 [get_ports {readOut[51]}]
set_load -pin_load 0.005 [get_ports {readOut[50]}]
set_load -pin_load 0.005 [get_ports {readOut[49]}]
set_load -pin_load 0.005 [get_ports {readOut[48]}]
set_load -pin_load 0.005 [get_ports {readOut[47]}]
set_load -pin_load 0.005 [get_ports {readOut[46]}]
set_load -pin_load 0.005 [get_ports {readOut[45]}]
set_load -pin_load 0.005 [get_ports {readOut[44]}]
set_load -pin_load 0.005 [get_ports {readOut[43]}]
set_load -pin_load 0.005 [get_ports {readOut[42]}]
set_load -pin_load 0.005 [get_ports {readOut[41]}]
set_load -pin_load 0.005 [get_ports {readOut[40]}]
set_load -pin_load 0.005 [get_ports {readOut[39]}]
set_load -pin_load 0.005 [get_ports {readOut[38]}]
set_load -pin_load 0.005 [get_ports {readOut[37]}]
set_load -pin_load 0.005 [get_ports {readOut[36]}]
set_load -pin_load 0.005 [get_ports {readOut[35]}]
set_load -pin_load 0.005 [get_ports {readOut[34]}]
set_load -pin_load 0.005 [get_ports {readOut[33]}]
set_load -pin_load 0.005 [get_ports {readOut[32]}]
set_load -pin_load 0.005 [get_ports {readOut[31]}]
set_load -pin_load 0.005 [get_ports {readOut[30]}]
set_load -pin_load 0.005 [get_ports {readOut[29]}]
set_load -pin_load 0.005 [get_ports {readOut[28]}]
set_load -pin_load 0.005 [get_ports {readOut[27]}]
set_load -pin_load 0.005 [get_ports {readOut[26]}]
set_load -pin_load 0.005 [get_ports {readOut[25]}]
set_load -pin_load 0.005 [get_ports {readOut[24]}]
set_load -pin_load 0.005 [get_ports {readOut[23]}]
set_load -pin_load 0.005 [get_ports {readOut[22]}]
set_load -pin_load 0.005 [get_ports {readOut[21]}]
set_load -pin_load 0.005 [get_ports {readOut[20]}]
set_load -pin_load 0.005 [get_ports {readOut[19]}]
set_load -pin_load 0.005 [get_ports {readOut[18]}]
set_load -pin_load 0.005 [get_ports {readOut[17]}]
set_load -pin_load 0.005 [get_ports {readOut[16]}]
set_load -pin_load 0.005 [get_ports {readOut[15]}]
set_load -pin_load 0.005 [get_ports {readOut[14]}]
set_load -pin_load 0.005 [get_ports {readOut[13]}]
set_load -pin_load 0.005 [get_ports {readOut[12]}]
set_load -pin_load 0.005 [get_ports {readOut[11]}]
set_load -pin_load 0.005 [get_ports {readOut[10]}]
set_load -pin_load 0.005 [get_ports {readOut[9]}]
set_load -pin_load 0.005 [get_ports {readOut[8]}]
set_load -pin_load 0.005 [get_ports {readOut[7]}]
set_load -pin_load 0.005 [get_ports {readOut[6]}]
set_load -pin_load 0.005 [get_ports {readOut[5]}]
set_load -pin_load 0.005 [get_ports {readOut[4]}]
set_load -pin_load 0.005 [get_ports {readOut[3]}]
set_load -pin_load 0.005 [get_ports {readOut[2]}]
set_load -pin_load 0.005 [get_ports {readOut[1]}]
set_load -pin_load 0.005 [get_ports {readOut[0]}]
set_max_capacitance 0.005 [get_ports writeEnable]
set_max_capacitance 0.005 [get_ports {NodeSelect[2]}]
set_max_capacitance 0.005 [get_ports {NodeSelect[1]}]
set_max_capacitance 0.005 [get_ports {NodeSelect[0]}]
set_max_capacitance 0.005 [get_ports {writeIn[59]}]
set_max_capacitance 0.005 [get_ports {writeIn[58]}]
set_max_capacitance 0.005 [get_ports {writeIn[57]}]
set_max_capacitance 0.005 [get_ports {writeIn[56]}]
set_max_capacitance 0.005 [get_ports {writeIn[55]}]
set_max_capacitance 0.005 [get_ports {writeIn[54]}]
set_max_capacitance 0.005 [get_ports {writeIn[53]}]
set_max_capacitance 0.005 [get_ports {writeIn[52]}]
set_max_capacitance 0.005 [get_ports {writeIn[51]}]
set_max_capacitance 0.005 [get_ports {writeIn[50]}]
set_max_capacitance 0.005 [get_ports {writeIn[49]}]
set_max_capacitance 0.005 [get_ports {writeIn[48]}]
set_max_capacitance 0.005 [get_ports {writeIn[47]}]
set_max_capacitance 0.005 [get_ports {writeIn[46]}]
set_max_capacitance 0.005 [get_ports {writeIn[45]}]
set_max_capacitance 0.005 [get_ports {writeIn[44]}]
set_max_capacitance 0.005 [get_ports {writeIn[43]}]
set_max_capacitance 0.005 [get_ports {writeIn[42]}]
set_max_capacitance 0.005 [get_ports {writeIn[41]}]
set_max_capacitance 0.005 [get_ports {writeIn[40]}]
set_max_capacitance 0.005 [get_ports {writeIn[39]}]
set_max_capacitance 0.005 [get_ports {writeIn[38]}]
set_max_capacitance 0.005 [get_ports {writeIn[37]}]
set_max_capacitance 0.005 [get_ports {writeIn[36]}]
set_max_capacitance 0.005 [get_ports {writeIn[35]}]
set_max_capacitance 0.005 [get_ports {writeIn[34]}]
set_max_capacitance 0.005 [get_ports {writeIn[33]}]
set_max_capacitance 0.005 [get_ports {writeIn[32]}]
set_max_capacitance 0.005 [get_ports {writeIn[31]}]
set_max_capacitance 0.005 [get_ports {writeIn[30]}]
set_max_capacitance 0.005 [get_ports {writeIn[29]}]
set_max_capacitance 0.005 [get_ports {writeIn[28]}]
set_max_capacitance 0.005 [get_ports {writeIn[27]}]
set_max_capacitance 0.005 [get_ports {writeIn[26]}]
set_max_capacitance 0.005 [get_ports {writeIn[25]}]
set_max_capacitance 0.005 [get_ports {writeIn[24]}]
set_max_capacitance 0.005 [get_ports {writeIn[23]}]
set_max_capacitance 0.005 [get_ports {writeIn[22]}]
set_max_capacitance 0.005 [get_ports {writeIn[21]}]
set_max_capacitance 0.005 [get_ports {writeIn[20]}]
set_max_capacitance 0.005 [get_ports {writeIn[19]}]
set_max_capacitance 0.005 [get_ports {writeIn[18]}]
set_max_capacitance 0.005 [get_ports {writeIn[17]}]
set_max_capacitance 0.005 [get_ports {writeIn[16]}]
set_max_capacitance 0.005 [get_ports {writeIn[15]}]
set_max_capacitance 0.005 [get_ports {writeIn[14]}]
set_max_capacitance 0.005 [get_ports {writeIn[13]}]
set_max_capacitance 0.005 [get_ports {writeIn[12]}]
set_max_capacitance 0.005 [get_ports {writeIn[11]}]
set_max_capacitance 0.005 [get_ports {writeIn[10]}]
set_max_capacitance 0.005 [get_ports {writeIn[9]}]
set_max_capacitance 0.005 [get_ports {writeIn[8]}]
set_max_capacitance 0.005 [get_ports {writeIn[7]}]
set_max_capacitance 0.005 [get_ports {writeIn[6]}]
set_max_capacitance 0.005 [get_ports {writeIn[5]}]
set_max_capacitance 0.005 [get_ports {writeIn[4]}]
set_max_capacitance 0.005 [get_ports {writeIn[3]}]
set_max_capacitance 0.005 [get_ports {writeIn[2]}]
set_max_capacitance 0.005 [get_ports {writeIn[1]}]
set_max_capacitance 0.005 [get_ports {writeIn[0]}]
set_max_fanout 4 [get_ports writeEnable]
set_max_fanout 4 [get_ports {NodeSelect[2]}]
set_max_fanout 4 [get_ports {NodeSelect[1]}]
set_max_fanout 4 [get_ports {NodeSelect[0]}]
set_max_fanout 4 [get_ports {writeIn[59]}]
set_max_fanout 4 [get_ports {writeIn[58]}]
set_max_fanout 4 [get_ports {writeIn[57]}]
set_max_fanout 4 [get_ports {writeIn[56]}]
set_max_fanout 4 [get_ports {writeIn[55]}]
set_max_fanout 4 [get_ports {writeIn[54]}]
set_max_fanout 4 [get_ports {writeIn[53]}]
set_max_fanout 4 [get_ports {writeIn[52]}]
set_max_fanout 4 [get_ports {writeIn[51]}]
set_max_fanout 4 [get_ports {writeIn[50]}]
set_max_fanout 4 [get_ports {writeIn[49]}]
set_max_fanout 4 [get_ports {writeIn[48]}]
set_max_fanout 4 [get_ports {writeIn[47]}]
set_max_fanout 4 [get_ports {writeIn[46]}]
set_max_fanout 4 [get_ports {writeIn[45]}]
set_max_fanout 4 [get_ports {writeIn[44]}]
set_max_fanout 4 [get_ports {writeIn[43]}]
set_max_fanout 4 [get_ports {writeIn[42]}]
set_max_fanout 4 [get_ports {writeIn[41]}]
set_max_fanout 4 [get_ports {writeIn[40]}]
set_max_fanout 4 [get_ports {writeIn[39]}]
set_max_fanout 4 [get_ports {writeIn[38]}]
set_max_fanout 4 [get_ports {writeIn[37]}]
set_max_fanout 4 [get_ports {writeIn[36]}]
set_max_fanout 4 [get_ports {writeIn[35]}]
set_max_fanout 4 [get_ports {writeIn[34]}]
set_max_fanout 4 [get_ports {writeIn[33]}]
set_max_fanout 4 [get_ports {writeIn[32]}]
set_max_fanout 4 [get_ports {writeIn[31]}]
set_max_fanout 4 [get_ports {writeIn[30]}]
set_max_fanout 4 [get_ports {writeIn[29]}]
set_max_fanout 4 [get_ports {writeIn[28]}]
set_max_fanout 4 [get_ports {writeIn[27]}]
set_max_fanout 4 [get_ports {writeIn[26]}]
set_max_fanout 4 [get_ports {writeIn[25]}]
set_max_fanout 4 [get_ports {writeIn[24]}]
set_max_fanout 4 [get_ports {writeIn[23]}]
set_max_fanout 4 [get_ports {writeIn[22]}]
set_max_fanout 4 [get_ports {writeIn[21]}]
set_max_fanout 4 [get_ports {writeIn[20]}]
set_max_fanout 4 [get_ports {writeIn[19]}]
set_max_fanout 4 [get_ports {writeIn[18]}]
set_max_fanout 4 [get_ports {writeIn[17]}]
set_max_fanout 4 [get_ports {writeIn[16]}]
set_max_fanout 4 [get_ports {writeIn[15]}]
set_max_fanout 4 [get_ports {writeIn[14]}]
set_max_fanout 4 [get_ports {writeIn[13]}]
set_max_fanout 4 [get_ports {writeIn[12]}]
set_max_fanout 4 [get_ports {writeIn[11]}]
set_max_fanout 4 [get_ports {writeIn[10]}]
set_max_fanout 4 [get_ports {writeIn[9]}]
set_max_fanout 4 [get_ports {writeIn[8]}]
set_max_fanout 4 [get_ports {writeIn[7]}]
set_max_fanout 4 [get_ports {writeIn[6]}]
set_max_fanout 4 [get_ports {writeIn[5]}]
set_max_fanout 4 [get_ports {writeIn[4]}]
set_max_fanout 4 [get_ports {writeIn[3]}]
set_max_fanout 4 [get_ports {writeIn[2]}]
set_max_fanout 4 [get_ports {writeIn[1]}]
set_max_fanout 4 [get_ports {writeIn[0]}]