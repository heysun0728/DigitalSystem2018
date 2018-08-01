`timescale 1ns/1ps
`include "accelerator.v"
module tb;

reg clk, rst_n;
reg wen, start_run;
wire bsy;
reg [31:0] addr, din;
wire [31:0] dout,dout2,ans;

reg [31:0] in [0:63];
reg [31:0] correct_out;
reg [31:0] moutarr [0:63];
reg error;
integer i,j;

initial clk =1;
always #5 clk = ~clk;

initial begin
	$dumpfile("square_wave.fsdb");
	$dumpvars;
//	$fsdbDumpMDA;
end

accelerator accelerator(
  .clk(clk),
  .rst_n(rst_n),
  .wen(wen),
  .start(start_run),
  .addr(addr),
  .din(din),
  .dout(dout),
  .bsy(bsy)
);



initial begin //Dump
	// initial values
	//for (i=0;i<16;i=i+1) begin
//		in[i] = 32'h3f000000 + i;
		correct_out = 32'h43c80000;
	//end
    in[0] = 32'h3f000000;
    in[1] = 32'h40000000;
    in[2] = 32'h40400000;
	in[3] = 32'h40800000;
    in[4] = 32'h40a00000;
    in[5] = 32'h40c00000;
	in[6] = 32'h40e00000;
	in[7] = 32'h41000000;
    in[8] = 32'h41100000;
    in[9] = 32'h41200000;
	in[10] = 32'h41300000;
    in[11] = 32'h41400000;
    in[12] = 32'h41500000;
	in[13] = 32'h41600000;
    in[14] = 32'h41700000;
    in[15] = 32'h41800000;

	error = 0;
	
	// run
	$display("input values");
	addr = 1'b0;
	start_run = 1'b0;
	rst_n = 1'b0;
	wen = 1'b0;
	#12;
	rst_n = 1'b1;
	
	for (i=0;i<16;i=i+1) begin
		@(posedge clk);
		din = in[i];
		addr = i*4;
		wen = 1'b1;
	end
	
	$display("start run");
	@(posedge clk);
	wen = 1'b0;
	start_run = 1'b1;
	@(posedge clk);
	start_run = 1'b0;
	
	@(posedge clk);
	while (bsy!=1'b0) begin
		@(posedge clk);
	end

	for (i=0;i<16;i=i+1) begin
	    addr = i<<2; 
		@(posedge clk);
		@(posedge clk);
		//@(posedge clk);
		//@(posedge clk);
        $display("output = %h",dout);
    end

	/*$display("get output");
	$display("%h",ans);
	if(ans!=correct_out) begin
			$display("ERROR at address:%d dout:%h correct:%h",addr,ans,correct_out[i-1]);
			error =1;
	end
	else begin
		$display("========================");
		$display("=        PASS          =");
		$display("========================");
	end*/


	/*$display("get mul");
	@(posedge clk);
	for (i=0;i<=9;i=i+1) begin
		if(i>1) begin
			$display("mul output = %h",mout);
			moutarr[i-1]=mout;
		end
		if(i<9) begin
			for(j=0;j<2;j=j+1)begin
				if(j==0) addr=i;
				else addr=15-i;
				@(posedge clk);
			end
		end
	end

	$display("make sum");
	for (i=2;i<=8;i=i+1) begin
	    //addr = i<<2;
	    
	    if(i==2) adderin=moutarr[1];
	    else adderin=adderout;

	    adderin2=moutarr[i];
		for(j=0;j<10;j++) begin
			@(posedge clk);
		end
		$display("%h",adderout);

	end

	@(posedge clk);
	@(posedge clk);
	addr = 0;
	din = adderout;
	@(posedge clk);
	@(posedge clk);


	$display("ans");
	$display("%h",adderout);
	if(adderout!=correct_out) begin
			$display("ERROR at address:%d dout:%h correct:%h",addr,dout,correct_out[i-1]);
			error =1;
	end
	else begin
		$display("========================");
		$display("=        PASS          =");
		$display("========================");
	end
	*/
	$finish;
end
endmodule
