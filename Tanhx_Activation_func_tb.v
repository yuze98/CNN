`timescale 1ns / 1ps

module Tanhx_Activation_func_tb();

parameter DATA_WIDTH = 32;

reg clk;
reg reset;
reg [DATA_WIDTH-1:0] x;
wire [DATA_WIDTH-1:0] activatedNeuron;

localparam PERIOD = 10;

Tanhx_Activation_func #(DATA_WIDTH) Tanhx (clk, reset, x,activatedNeuron);

initial begin
 clk = 1;
 forever #(PERIOD/2) clk = ~clk;
end
    
initial begin


    $monitor ("timeStep:%g  reset = %b x=%b activatedNeuron=%b "
   	,$time,reset,x[31:0],activatedNeuron[31:0]);	
   	
    reset = 1'b1;
   	#(PERIOD/2) reset = 1'b0;
	
   	x= 32'b10111111000000000000000000000000;// -0.5
    #(PERIOD) 
	
	x= 32'b00111111000000000000000000000000;//0.5
   #(PERIOD)
	
	x= 32'b01000000000000000000000000000000;//2
    #(PERIOD)
	
	x= 32'b11000000000000000000000000000000;//-2
    #(PERIOD)
	
	x= 32'b00111111010000101000111101011100;//0.76
    #(PERIOD)
	
	x= 32'b10111111010000101000111101011100;//-0.76
    #(PERIOD)
	
	x= 32'b00111110011011111001110110110010; //0.234
    #(PERIOD)
	
	x= 32'b10111110011011111001110110110010;//-0.234
    #(PERIOD)
    
    #(500*PERIOD)
    $stop;

end



endmodule
