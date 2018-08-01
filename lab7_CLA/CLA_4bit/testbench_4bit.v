`timescale 1ns/1ps
`include "CLA_4bit.v"

module Test_CLA_4bit;
    reg [3:0] A;
    reg [3:0] B;
	reg CLK;
	reg reset;
	reg  [4:0] correct_ans;
    reg Cin;
	reg [5:0] counter;
	reg [5:0] ct;
	reg error;
	reg [4:0] successful_count;
    wire [3:0] S;
    wire Cout;
 
    CLA_4bit DDLab6(.sum(S), .cout(Cout), .a(A), .b(B), .cin(Cin));

	
	/*初始化*/
	initial begin
	
	A =0;
	B =0;
	ct = 0;
	Cin = 0;
	successful_count = 0;
	$dumpfile("lab6_4bit.fsdb");  //產生波形檔
	$dumpvars;
	CLK = 1'b0;
	#10 reset = 1;
	#20 reset = 0;
	
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;	
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	
	#500    $finish;
	
	end
	

	always #10 CLK = ~CLK;
	
	always @(posedge CLK or posedge reset)
	begin
		if(reset)
		begin
			counter <= 0;
			A <= {$random} % 15;
			B <= {$random} % 15;
			Cin <= {$random} % 2;
			correct_ans <= 0;
			error <= 0;
			ct <= ct + 1'b1;
		end
		else
		begin
			correct_ans <= A + B + Cin;
			counter <= counter + 1;
			if(counter == 4)
				if({Cout,S} == correct_ans)
				begin
					successful_count = successful_count+1;
					$display ("Test %d ", ct);
					$display ("//////////////////");
					$display ("// Successful %d//",successful_count);
					$display ("//////////////////");
					$display ("%d + %d + %d= ?", A, B , Cin);
					$display ("Cout = %d S = %d", Cout, S);
					$display ();
				end
				else
				begin
					$display ();
					$display ("Test %d ", ct);
					$display ("//////////");
					$display ("// Fail //");
					$display ("//////////");
					$display ("%d + %d + %d= ?", A, B , Cin);
					$display ("your Cout = %d S=%d", Cout, S);
					$display ("correct:");
					$display ("     Cout = %d S=%d", correct_ans[16], correct_ans[15:0]);
	
					$display ();
				end
		end


	end
	
	
endmodule