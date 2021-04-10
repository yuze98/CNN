
module Tanhx_Activation_func(clk,reset,x, activatedNeuron);


parameter DATA_WIDTH = 32; 


input clk,reset;
input [DATA_WIDTH-1:0] x;
output reg[DATA_WIDTH-1:0] activatedNeuron;


reg[DATA_WIDTH-1:0] activatedNeuron_tmp;
//using taylor expansion
//Tanhx = x-(1/3 *x^3)+(2/15 *x^5)-(17/315 *x^7)..
//approximated Equation:
//Tanhx = x[1-(x^2)/3[1-(x^2)/5(1-17/42(x^2))]]
//Tanhx = x[1-First_fp[(1-Second_fp)(1-Third_fp)]
//First_fp=(x^2)*(1/3)
//Second_fp=((x^2)*(1/5))
//Third_fp=(x^2)*(17/42)

//(1/3)(infp=0.33333333) in bin fp = 32'b00111110101010101010101000111011
//(1/5)(infp=0.2) in bin fp = 32'b00111110010011001100110011001101
//(17/42)(infp=0.4047619047619048) in bin fp = 32'00111110110011110011110011110100

wire[DATA_WIDTH-1:0] First_fp,First_minus,First_last,last;
wire[DATA_WIDTH-1:0] Second_fp,Second_minus,Second_last;
wire[DATA_WIDTH-1:0] Third_fp,Third_minus,Third_last;
wire[DATA_WIDTH-1:0] x_seq;//x^2 fp multiplied

fp_mul M_seq (.A(x),.B(x),.result(x_seq));//x squared
fp_mul First_mult (.A(x_seq),.B(32'b00111110101010101010101000111011),.result(First_fp));
fp_mul Second_mult (.A(x_seq),.B(32'b00111110010011001100110011001101),.result(Second_fp));
fp_mul Third_mult (.A(x_seq),.B(32'b00111110110011110011110011110100),.result(Third_fp));



assign Second_fp[31] = !Second_fp[31];
assign Third_fp[31]  =  !Third_fp[31];


fp_add_subtract fp_sub1 (.A(32'b00111111100000000000000000000000),.B(Third_fp),.R(Third_minus)); //1-Third_fp
fp_add_subtract fp_sub2 (.A(32'b00111111100000000000000000000000),.B(Second_fp),.R(Second_minus)); //1-Second_fp


fp_mul First_mult1 (.A(Third_minus),.B(Second_minus),.result(Third_last));// Third*Second
fp_mul Third_mult2 (.A(Third_last),.B(First_fp),.result(Second_last)); // Third_last*first_fp

assign Second_last[31]  = !Second_last[31];// changing sign of second last

fp_add_subtract fp_sub3 (.A(32'b00111111100000000000000000000000),.B(Second_last),.R(First_last)); //(1-Second_last)

fp_mul Third_mult1 (.A(x),.B(First_last),.result(last));// getting the last result (x*First_last)


always @ (posedge clk)
begin
	
		//if ((x[31:23] < 9'b1011_1111_1)	&& (x[31:23] < 9'b0011_1111_1)) begin //if it's bigger than -1 and smaller than 1 (Tanh condition)
		if(x[31] == 1'b1) begin
			if(x[30:23] < 8'b011_1111_1)begin
				activatedNeuron_tmp = last;
				end
			else begin
		activatedNeuron_tmp = 32'b0;
		
		end
		end
		else begin
			if(x[30:23] < 8'b011_1111_1)begin
				activatedNeuron_tmp = last;
			end
			else begin
			activatedNeuron_tmp = 32'b0;
		
		end
	end
		// else begin
			// activatedNeuron_tmp = 32'b0;
		
		// end
		if(reset == 1'b1)
		begin
			
			activatedNeuron_tmp = 32'b0;
		end
		activatedNeuron = activatedNeuron_tmp;

end

endmodule



