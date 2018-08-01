-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
-- Date        : Thu Jun 14 19:45:56 2018
-- Host        : MSI running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               d:/CCU/DigitalSys/DDlab12/Lab12DemoV1.0_3/Lab12Demo.srcs/sources_1/ip/clkwiz0/clkwiz0_stub.vhdl
-- Design      : clkwiz0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clkwiz0 is
  Port ( 
    clkout : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end clkwiz0;

architecture stub of clkwiz0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clkout,reset,locked,clk_in1";
begin
end;
