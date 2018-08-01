set_property SRC_FILE_INFO {cfile:d:/CCU/DigitalSys/DDlab12/Lab12DemoV1.0_3/Lab12Demo.srcs/sources_1/ip/clkwiz0/clkwiz0.xdc rfile:../../../Lab12Demo.srcs/sources_1/ip/clkwiz0/clkwiz0.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.1
