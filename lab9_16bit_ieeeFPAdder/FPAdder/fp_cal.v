`timescale 1ns / 1ps

module fadd_cal (op_sub,large_frac24,small_frac27, cal_frac); // calculation
	input [23:0] large_frac24;
	input op_sub;
	input [26:0] small_frac27;
	output [27:0] cal_frac;
	//補上grs,以及避免溢位狀況,共28bit
	wire [27:0] aligned_large_frac = {1'b0,large_frac24,3'b000};
	wire [27:0] aligned_small_frac = {1'b0,small_frac27};
	//相減或相加
	assign cal_frac = op_sub?
	aligned_large_frac - aligned_small_frac :
	aligned_large_frac + aligned_small_frac;
endmodule