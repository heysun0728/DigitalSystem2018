`timescale 1ns / 1ps
module accelerator (
    clk,
    rst_n,
    wen,
    start,
    addr,
    din,
    dout,
    bsy
 );

input clk;
input rst_n;
input wen;
input start;
input [32-1:0] addr;
input [32-1:0] din;

output [32-1:0] dout;
output bsy;
//output [31:0] mulout;

wire [31:0] adderin,adderin2;
wire [31:0] adderout;
wire [31:0] aout;
reg bsy2;
reg [7:0] cnt;
reg [5:0] cnt2;
reg wcnt;
reg bsy;
reg [31:0] mul[0:63];
wire [31:0] mul_output;
wire [31:0] dout2;

wire [5:0] addr_in;
wire [31:0] din_in;
wire wen_in;
/*
wire [1:0] opcode;
assign opcode = 2'b11;
*/
always @(posedge clk_out or negedge rst_n)
begin
	if(~rst_n) begin
		bsy <= 1'b0;
		bsy2 <= 1'b0;
	end
	else if(start == 1'b1 && bsy == 1'b0) begin
		bsy <= 1'b1;
		bsy2 <= 1'b1;
	end
	else if(cnt == 8'd14 && bsy ==1'b1)begin
		bsy2 <= 1'b0;
	end
	else if (cnt == 8'd21 && bsy ==1'b1)begin
		bsy <= 1'b0;
		bsy2 <= 1'b1;
	end
	else
		bsy <= bsy;
end
always @(posedge clk_out or negedge rst_n)
begin
	if(~rst_n) begin
		cnt <= 8'b0;
		wcnt <= 8'b0;
		cnt2 <= 8'b0;
	end
	else if(bsy == 1'b1 && (cnt <=8'd21)) begin
		cnt <= cnt + 8'b1;
		if(cnt!=0) begin
			if(cnt%2==0) cnt2 <= 6'd15 - cnt2 + 6'b1;
			else cnt2 <= 6'd15-cnt2;
		end
		if(cnt>=3 && cnt%2!=0) wcnt=1;
		else wcnt=0;
	end
	else begin
		cnt <= 8'b0;
		wcnt <= 8'b0;
	end
end


//cnt[0] = 
//		0: memory read (wen=0)
//		1: memory write (wen=1)
assign wen_in = (bsy)?wcnt:wen;
assign addr_in = (bsy)?cnt2[5:0]:addr[7:2];//從2開始是因為要除4
//assign addr_in = (bsy)?cnt[6:1]:addr[7:2];
assign din_in = (bsy)?aout:din;
assign aout = (wcnt)?adderout:aout;
assign adderin= (cnt<8)?((cnt%4==0 && wcnt)?mul_output:adderin):((cnt%2==0 && wcnt)?(aout):adderin);
assign adderin2= (cnt%4!=0&&wcnt)?mul_output:adderin2;
//assign mulout = (wcnt)?mul_output:32'd0;
//assign dout = (bsy)?adderout:dout;
//assign mul_output = dout*dout;
//assign ans=(bsy)?aout:ans;

fpu mpy(.clk(clk_out),.opcode(2'b11), .A(dout), .B(dout2), .dout(mul_output));

//此處會製造dout
mem memory(
    .addra(addr_in),
    .clka(clk_out),
    .dina(din_in),
    .douta(dout2),
    .doutb(dout),
    .ena(1'b1),
    .wea(wen_in),
    .getvalue(bsy2)
);
pipelined_fpadder test(
	adderin,
	adderin2,
	1'b0,
	2'd0,
	adderout,
	clk_out,
	1'b1,
	1'b1
);
wire clk_out;
clkwiz0 clkgene(.clk_in1(clk),.clkout(clk_out));
endmodule

