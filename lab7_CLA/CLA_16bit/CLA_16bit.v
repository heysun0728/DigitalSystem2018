module cla_16bit( a, b, cin, sum);

	input [15:0] a, b;
	input cin;
	output [15:0] sum;
	
	wire PP,GG;
	wire [4:0] P, G;
	wire [15:0] p, g;
	wire [16:0] c;

	//generate p & g
	pg_generator pg( a[15:0], b[15:0], p[15:0], g[15:0]);
	
	//generate group g & p 
	PG_carry_generator PG1( p[2:0], g[2:0], ,G[0], P[0],);
	PG_carry_generator PG2( p[5:3], g[5:3], ,G[1], P[1],);
	PG_carry_generator PG3( p[8:6], g[8:6], ,G[2], P[2],);
	PG_carry_generator PG4( p[11:9], g[11:9], ,G[3], P[3],);
	PG_carry_generator PG5( p[14:12], g[14:12], ,G[4], P[4],);

	//generate group GG & PP
	PG_carry_generator PG2_1( P[2:0], G[2:0], ,GG, PP,);

	//generate c9 & cout
	PG_carry_generator_1bit carry_c9x(PP,GG,cin,c[9]);

	//generate c3, c6, c12 ,c15
	PG_carry_generator carry_c3x1(P[2:0], G[2:0], cin,,, {c[6],c[3]});
	PG_carry_generator_2bit carry_c3x2(P[4:3], G[4:3], c[9],{c[15],c[12]});

	//generate all c
	PG_carry_generator carry1(p[2:0], g[2:0], cin,,, {c[2:1]});
	PG_carry_generator carry2(p[5:3], g[5:3], c[3],,, {c[5:4]});
	PG_carry_generator carry3(p[8:6], g[8:6], c[6],,, {c[8:7]});
	PG_carry_generator carry4(p[11:9], g[11:9], c[9],,, {c[11:10]});
	PG_carry_generator carry5(p[14:12], g[14:12], c[12],,, {c[14:13]});
	//generate sum
	sum_generator sum1( a[15:0], b[15:0], cin, c[15:1], sum[15:0]);

endmodule

module PG_carry_generator_2bit(p,g,cin,c);
	input [1:0] p, g;
	input cin;
	output [2:1] c;

	assign c[1] = g[0]|(p[0] & cin);
	assign c[2] = g[1]|(p[1] & g[0])|(p[1] & p[0] & cin);
endmodule

module PG_carry_generator_1bit(p, g,cin,c);
	input p,g;
	input cin;
	output c;

	assign c = g|(p & cin);
endmodule

module PG_carry_generator( p, g,cin, gG, gP,c);

	input [2:0] p, g;
	input cin;
	output gG, gP;
	output [2:1] c;

	assign gG = (g[0] & p[1] & p[2])|(g[1]&p[2])|g[2];
	assign gP = p[0] & p[1] & p[2];
	
	assign c[1] = g[0]|(p[0] & cin);
	assign c[2] = g[1]|(p[1] & g[0])|(p[1] & p[0] & cin);

endmodule

module sum_generator( a,b,cin,c, sum);

    input [15:0] a, b;
	input cin;
	input [15:1]c;
	output [15:0] sum;
	assign sum = a^ b^{c,cin};
		
endmodule

module pg_generator( a, b, p, g);

        input [15:0] a, b;
        output [15:0] p, g;

        // Carry Propagate
        assign p = a | b;
        assign g = a & b ;
endmodule