`timescale 1ns/1ps
module lab(CLK, RST, in_a, in_b, Product, Product_Valid);
input CLK, RST;
input [31:0] in_a;	// Multiplicand
input [31:0] in_b;  // Multiplier
output reg [63:0] Product;
output reg Product_Valid;

reg [31:0] Mplicand;
reg [7:0]	Counter ;
reg	sign;

//Counter
always @(posedge CLK or posedge RST)
begin
	if(RST)
		Counter <=7'b0;
	else
		Counter <= Counter +7'b1;
end

//Multiplier
always @(posedge CLK or posedge RST)
begin
	//初始化數值
	if(RST) begin
		Product  <= 64'b0;
		Mplicand <= 32'b0;
	end 
	
	//輸入乘數與被乘數
	else if(Counter == 7'd0) begin
		Mplicand <= in_a;
		Product <= {32'b0,in_b};
	end 
	
	//乘法與數值移位
	/* write down your design below */
	else if(Counter <=7'd64 && Counter%2==1) 
	begin
		if(Product[0] == 1'b1)	begin
			Product[63:32] <= Mplicand + Product[63:32];
		end
	end 

	else if(Counter <=7'd64 && Counter%2==0)
	begin
		Product <= Product >> 1'b1;
		//$display("%b",Product);
	end
	/* write down your design upon */
end

//判斷輸出
always @(posedge CLK or posedge RST)
begin
	if(RST)
		Product_Valid <=1'b0;
	else if(Counter==7'd64)
		Product_Valid <=1'b1;
	else
		Product_Valid <=1'b0;
end

endmodule
