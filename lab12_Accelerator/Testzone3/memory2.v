`timescale 1ns / 1ps

module mem2(addra, clka, dina, douta, ena, wea,getvalue);
	
	input clka, ena, wea ,getvalue;
	input [5:0] addra;
	input [31:0] dina;
	output [31:0] douta;

	reg [31:0] mem[0:63];
	reg [31:0] addr_reg;
	
	assign douta = mem[addra];
	
	always @(posedge clka)
	begin
		if(!getvalue)begin
			if(wea)		
            	mem[addra] <= dina;
			if(ena)	
            	addr_reg <= addra;
        end
	end

endmodule