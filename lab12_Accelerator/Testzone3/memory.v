`timescale 1ns / 1ps

module mem(addra, clka, dina, douta,doutb, ena, wea,getvalue);
	
	input clka, ena, wea ,getvalue;
	input [5:0] addra;
	input [31:0] dina;
	output [31:0] douta;
	output [31:0] doutb;

	reg [31:0] mem[0:63];
	reg [31:0] addr_reg;
	
	assign douta = mem[addra];
	assign doutb = mem[addr_reg];

	always @(posedge clka)
	begin
		if(~getvalue)
		begin
			if(wea)	begin
            	mem[addra] <= dina;
            	//$display("%h",dina);
            end
			if(ena)	
            	addr_reg <= addra;
        end
        else
        	//if(wea)		
            //	mem[addra] <= dina;
            addr_reg <= addra;
	end

endmodule