`timescale 1ns/1ps
module testbench_lab6;
reg [2:0] in;
reg [3:0] out;
lab6 DUT(in,out);

initial begin
	$dumpfile("lab6.vcd");
	$dumpvars;
end

initial begin
	in=3'b0;
end

always #1
begin
	$monitor("%d",out);
	in=in+1;
end

initial #8 $finish;
endmodule
