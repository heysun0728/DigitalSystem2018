//top module
module CLA_4bit( a, b, cin, sum, cout); //module 模組名稱(對應的連接埠);

	//宣告區段
	input [3:0] a, b; //宣告4bit輸入埠 a 與 b (型態預設為wire)
	input cin;
	output [3:0] sum; //宣告4bit輸出埠 s (型態預設為wire)
	output cout;
	
	wire [3:0] g, p; //宣告4bit wire g 與 p 
	wire [4:0] c; 
	
	//邏輯區段
	pg_generator cla4_pg(a, b, p, g); 
	carry_generator c_generator( p, g, cin, {cout, c[3:1]}); 
	// {cout, c[3:1]} 代表 該模組輸出 c 的最左邊位數為 cout ，其餘為c[3:1]
	sum_generator sum1(a, b, cin, c[3:1], sum); 
	
endmodule 

//submodule for generating p & g
module pg_generator(a, b, p, g ); 

     input [3:0] a, b;
	 output [3:0] p, g;
	 
	assign p = a | b ; //p = a + b
	assign g = a & b ; //p = a * b
	 
endmodule

//submodule for generating carry
module carry_generator( p , g , cin , c );

	input [3:0] p, g;
	input cin;
	output [4:1] c;
	
	assign c[1] = g[0] | (p[0] & cin); //c[1] = g[0] + (p[0] * cin)
	assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin); 
	assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
	assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & cin);
				
endmodule

//submodule for generating sum
module sum_generator(a, b, cin, c, sum);

    input [3:0] a, b;
	input cin;
	input [3:1] c;
	output [3:0] sum;

	assign sum = a ^ b ^ {c, cin} ; //s = a XOR B XOR c

endmodule