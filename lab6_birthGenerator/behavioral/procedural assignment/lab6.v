`timescale 1ns/1ps
module lab6(in, out);//模組 lab6(對應的輸入埠與輸出埠)
	
	//宣告區段
	input [2:0]in; //宣告輸入埠 in ,其形態為 3bit wire		
	output reg [3:0]out; //宣告輸出埠 out ,其形態為 4bit reg

	//邏輯區段
	always @ (in) // 當變數 in 改變時，always 敘述會再次執行
	case(in) //依照 in 值執行不同的敘述
		0 : out = 1; //當 in 為 0 , out 為1
		1 : out = 9;
		2 : out = 9;
		3 : out = 7;
		4 : out = 0;
		5 : out = 7;
		6 : out = 2;
		7 : out = 8;
		default : $display("Error in input"); //out 的預設敘述為 顯示錯誤訊息
	endcase

endmodule

/*
case ()
< case1 > : < statement >
< case2 > : < statement >
.....
default : < statement >

endcase
參考網站: http://www.asic-world.com/verilog/vbehave2.html#The_Case_Statement
*/
