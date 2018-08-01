`timescale 1ns/1ps
module cont_8bit_adder(sum,cout,a,b,cin);
	input cin;
	input [7:0] a,b;
	output [7:0] sum;
	output cout;
	assign{cout,sum}=a+b+cin;
endmodule