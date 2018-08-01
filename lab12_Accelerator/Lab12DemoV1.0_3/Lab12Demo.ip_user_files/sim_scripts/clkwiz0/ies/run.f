-makelib ies_lib/xil_defaultlib -sv \
  "D:/Xilinx/Vivado/2018.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/Xilinx/Vivado/2018.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../Lab12Demo.srcs/sources_1/ip/clkwiz0/clkwiz0_clk_wiz.v" \
  "../../../../Lab12Demo.srcs/sources_1/ip/clkwiz0/clkwiz0.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

