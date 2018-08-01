`timescale 1ns/1ps
module lab(CLK, RST, in_a, in_b, Product, Product_Valid);
input CLK, RST;
input signed [31:0]	in_a;	// Multiplicand
input signed [31:0]	in_b;// Multiplier
output reg signed [63:0] Product;
output reg Product_Valid;

reg signed [31:0] Mplicand;
reg signed [32:0] Mplier;
reg [4:0] Counter;
reg	sign;

//Counter
always @(posedge CLK or posedge RST)
begin
	if(RST)
		Counter <=5'b0;
	else
		Counter <= Counter +5'b1;
end

//Multiplier
always @(posedge CLK or posedge RST)
begin
	//初始化數值
	if(RST) begin
		Product  <= 64'b0;
		Mplicand <= 32'b0;
		Mplier   <= 33'b0;	
	end 
	
	//輸入乘數與被乘數
	else if(Counter == 5'd0) begin
		Mplicand <= in_a;
		Mplier <= {in_b,1'b0};
	end 
	
	else if(in_b ==1 ) begin
		Product=in_a;
	end
	
	//乘法與數值移位
	/* write down your design below */
	else if(Counter <=5'd11) 
	begin
		if((Mplier[2]==1'b0 & Mplier[1]==1'b0 & Mplier[0]==1'b1) | (Mplier[2]==1'b0 & Mplier[1]==1'b1 & Mplier[0]==1'b0)) //001 010 +A
			Product <= Mplicand + Product;
		else if(Mplier[2]==1'b0 & Mplier[1] == 1'b1 & Mplier[0] == 1'b1 ) //+2A
			Product <= Product + (Mplicand * 2 );
		else if(Mplier[2]==1'b1 & Mplier[1] == 1'b0 & Mplier[0] == 1'b0) //-2A
			Product <= Product - (Mplicand * 2 );
		else if((Mplier[2]==1'b1 & Mplier[1]==1'b0 & Mplier[0]==1'b1) | (Mplier[2]==1'b1 & Mplier[1]==1'b1 & Mplier[0]==1'b0)) //101 110 -A
			Product <= Product - Mplicand;
		//$display("%d,%d",Product,Mplicand);
		Mplier <= Mplier >> 2'b10;
		Mplicand <= Mplicand << 2'b10;
	end 

	/* write down your design upon */
end

//判斷輸出
always @(posedge CLK or posedge RST)
begin
	if(RST)
		Product_Valid <=1'b0;
	else if(Counter==5'd11)
		Product_Valid <=1'b1;
	else
		Product_Valid <=1'b0;
end

endmodule
