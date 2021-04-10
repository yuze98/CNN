`timescale 1ns / 1ps
module mult_try2(
	input [31:0] A,
	input [31:0] B,
	input reset,
	output [31:0] result
	//output enableAccum
    );

	reg [7:0] exp1,exp2;
	reg [22:0] man1,man2;
	reg [27:0] man_r;
	reg [31:0] answer;
	

	
	always @ (*) begin
	    if (reset) begin
		answer = 32'b0;
		
	    end
	    else begin
		exp1 = A[30:23];
		exp2 = B[30:23];
		man1 = A[22:0];
		man2 = B[22:0];
		man_r = {1'b1, man1[22:10]} * {1'b1, man2[22:10]};
		//exponent
		answer[30:23] = (man_r[27])? (({1'b0,exp1} + {1'b0,exp2}) - 9'd126) :  (({1'b0,exp1} + {1'b0,exp2}) - 9'd127); 
		//mantissa
		answer[22:0] = (man_r[27])? man_r[26:4] : man_r[25:3] ;
		//sign
		answer[31] = A[31] ^ B[31];
	end
	end
	
	assign result = (reset) ? 31'b0 : answer;
endmodule

