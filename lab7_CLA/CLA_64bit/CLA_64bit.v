module cla_64bit( a, b, cin, sum);

	input [63:0] a, b;
	input cin;
	output [63:0] sum;
	
	//write your design below
	wire [3:0] PP, GG;
	wire [15:0] P, G;
	wire [63:0] p, g;
	wire [64:0] c;
		
	//generate p & g
	pg_generator pg(a[63:0], b[63:0],p[63:0], g[63:0]);
	
	//generate group g & p 
	PG_carry_generator PG1( p[3:0], g[3:0], ,G[0], P[0],);
	PG_carry_generator PG2( p[7:4], g[7:4], ,G[1], P[1],);
	PG_carry_generator PG3( p[11:8], g[11:8], ,G[2], P[2],);
	PG_carry_generator PG4( p[15:12], g[15:12], ,G[3], P[3],);
	PG_carry_generator PG5( p[19:16], g[19:16], ,G[4], P[4],);
	PG_carry_generator PG6( p[23:20], g[23:20], ,G[5], P[5],);
	PG_carry_generator PG7( p[27:24], g[27:24], ,G[6], P[6],);
	PG_carry_generator PG8( p[31:28], g[31:28], ,G[7], P[7],);
	PG_carry_generator PG9( p[35:32], g[35:32], ,G[8], P[8],);
	PG_carry_generator PG10( p[39:36], g[39:36], ,G[9], P[9],);
	PG_carry_generator PG11( p[43:40], g[43:40], ,G[10], P[10],);
	PG_carry_generator PG12( p[47:44], g[47:44], ,G[11], P[11],);
	PG_carry_generator PG13( p[51:48], g[51:48], ,G[12], P[12],);
	PG_carry_generator PG14( p[55:52], g[55:52], ,G[13], P[13],);
	PG_carry_generator PG15( p[59:56], g[59:56], ,G[14], P[14],);
	PG_carry_generator PG16( p[63:60], g[63:60], ,G[15], P[15],);

	//generate group GG & PP
	PG_carry_generator PG2_1( P[3:0], G[3:0], ,GG[0], PP[0],);
	PG_carry_generator PG2_2( P[7:4], G[7:4], ,GG[1], PP[1],);
	PG_carry_generator PG2_3( P[11:8], G[11:8], ,GG[2], PP[2],);
	PG_carry_generator PG2_4( P[15:12], G[15:12], ,GG[3], PP[3],);

	//generate c16, c32, c48, c64 & cout
	PG_carry_generator carry_c16x(PP[3:0], GG[3:0], cin,,, {c[48],c[32],c[16]});

	//generate c4, c8, c12,...
	PG_carry_generator carry_c4x1(P[3:0], G[3:0], cin,,, {c[12],c[8],c[4]});
	PG_carry_generator carry_c4x2(P[7:4], G[7:4], c[16],,,{c[28],c[24],c[20]});
	PG_carry_generator carry_c4x3(P[11:8], G[11:8], c[32],,, {c[44],c[40],c[36]});
	PG_carry_generator carry_c4x4(P[15:12], G[15:12], c[48],,, {c[60],c[56],c[52]});

	//assign cout = c4x[4];
	//generate all c
	PG_carry_generator carry1(p[3:0], g[3:0], cin,,, {c[3:1]});
	PG_carry_generator carry2(p[7:4], g[7:4], c[4],,, c[7:5]);
	PG_carry_generator carry3(p[11:8], g[11:8], c[8],,, c[11:9]);
	PG_carry_generator carry4(p[15:12], g[15:12], c[12],,, c[15:13]);
	PG_carry_generator carry5(p[19:16], g[19:16], c[16],,, c[19:17]);
	PG_carry_generator carry6(p[23:20], g[23:20], c[20],,, c[23:21]);
	PG_carry_generator carry7(p[27:24], g[27:24], c[24],,, c[27:25]);
	PG_carry_generator carry8(p[31:28], g[31:28], c[28],,, c[31:29]);
	PG_carry_generator carry9(p[35:32], g[35:32], c[32],,, c[35:33]);
	PG_carry_generator carry10(p[39:36], g[39:36], c[36],,, c[39:37]);
	PG_carry_generator carry11(p[43:40], g[43:40], c[40],,, c[43:41]);
	PG_carry_generator carry12(p[47:44], g[47:44], c[44],,, c[47:45]);
	PG_carry_generator carry13(p[51:48], g[51:48], c[48],,, c[51:49]);
	PG_carry_generator carry14(p[55:52], g[55:52], c[52],,, c[55:53]);
	PG_carry_generator carry15(p[59:56], g[59:56], c[56],,, c[59:57]);
	PG_carry_generator carry16(p[63:60], g[63:60], c[60],,, c[63:61]);

	//generate sum
	sum_generator sum1( a[63:0], b[63:0], cin, c[63:1], sum[63:0]);
	
endmodule

module PG_carry_generator( p, g,cin, gG, gP,c);

	input [3:0] p, g;
	input cin;
	output gG, gP;
	output [3:1] c;

	assign gG = (g[0] & p[1] & p[2] & p[3])|(g[1]&p[2]&p[3])|(g[2]&p[3])|g[3];
	assign gP = p[0] & p[1] & p[2] & p[3];
	
	assign c[1] = g[0]|(p[0] & cin);
	assign c[2] = g[1]|(p[1] & g[0])|(p[1] & p[0] & cin);
	assign c[3] = g[2]|(p[2] & g[1])|(p[2] & p[1] & g[0])|(p[2] & p[1] & p[0] & cin);
	//assign c[4] = g[3]|(p[3] & g[2])|(p[3] & p[2] & g[1])|(p[3] & p[2] & p[1] & g[0])|(p[3] & p[2] & p[1] & p[0] & cin);
		
endmodule

module sum_generator( a,b,cin,c, sum);

    input [63:0] a, b;
	input cin;
	input [63:1]c;
	output [63:0] sum;

		
	assign sum = a^ b^{c,cin};
		
endmodule

module pg_generator( a, b, p, g);

    input [63:0] a, b;
    output [63:0] p, g;

    // Carry Propagate
    assign p = a | b;
    assign g = a & b ;
    

endmodule



