onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib clkwiz0_opt

do {wave.do}

view wave
view structure
view signals

do {clkwiz0.udo}

run -all

quit -force
