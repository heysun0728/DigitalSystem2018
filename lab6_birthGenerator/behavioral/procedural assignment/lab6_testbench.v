`timescale 1ns/1ps
module lab6_testbench;
reg [2:0] in;
wire [3:0] out;
integer i;
lab6 DUT(in,out);

initial begin
	$dumpfile("lab6.vcd");
	$dumpvars;
end

initial begin
    for(i=0;i<8;i=i+1) begin
       $monitor(out);
	   in=i;
	   #8;
    end
end
endmodule
