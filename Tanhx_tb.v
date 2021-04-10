`timescale 1ns / 1ps

module Tanhx_tb();

parameter DATA_WIDTH = 32;
localparam No_of_Neurons = 8;

reg clk;
reg reset;
reg [DATA_WIDTH*No_of_Neurons-1:0] x;
wire [DATA_WIDTH*No_of_Neurons-1:0] activatedNeurons;
wire Finished;

localparam PERIOD = 10;


Tanhx #(DATA_WIDTH, No_of_Neurons) TanhxInstance (x, clk, reset, Finished,activatedNeurons);

initial begin
 clk = 1;
 forever #(PERIOD/2) clk = ~clk;
end
    
initial begin


    $monitor ("timeStep:%g  reset = %b x=%b activatedNeuron=%b "
   	,$time,reset,x[31:0],activatedNeurons);	
   	// -0.5, 0.5, 2, -2, 0.76, -0.76, 0.234, -0.234 (From Most significant to least)
   	x= 32'b10111111000000000000000000000000_00111111000000000000000000000000_01000000000000000000000000000000_11000000000000000000000000000000_00111111010000101000111101011100_10111111010000101000111101011100_00111110011011111001110110110010_10111110011011111001110110110010;
	
    reset = 1'b1;
   	#(PERIOD) reset = 1'b0;
	
    
    #(3*PERIOD)
    $stop;

end



endmodule
