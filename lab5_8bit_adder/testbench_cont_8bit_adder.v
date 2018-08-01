`timescale 1ns/1ps
module testbench_cont_8bit_adder;
reg [7:0] a,b;
reg [8:0] c;
reg cin;
wire [7:0] sum;
wire cout;
cont_8bit_adder DUT(sum,cout,a,b,cin);

initial begin
	$dumpfile("cont_8bit_adder.vcd");
	$dumpvars;
end

initial
begin
	a=8'b00000000;
	b=8'b00000000;
	c=9'b000000000;
	cin=1'b0;
end
always #1
begin
	$monitor("%4dns a=%d b=%d sum=%d IsWrong=%d  ans=%d",$stime,a,b,sum,cout,c);
	a=a+1;
end
always #256 b=b+1;
always #256 a=0;
always #1 c=a+b;
initial #65536 $finish;
endmodule