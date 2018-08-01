// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Thu Jun 14 19:45:56 2018
// Host        : MSI running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/CCU/DigitalSys/DDlab12/Lab12DemoV1.0_3/Lab12Demo.srcs/sources_1/ip/clkwiz0/clkwiz0_stub.v
// Design      : clkwiz0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clkwiz0(clkout, reset, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clkout,reset,locked,clk_in1" */;
  output clkout;
  input reset;
  output locked;
  input clk_in1;
endmodule
