`timescale 1ns / 1ps

module Tanhx(Neurons,clk,reset,Finished,ActivatedNeurons

);

parameter DataWidth = 32;
parameter No_of_Neurons = 24;
  
  
input [DataWidth*No_of_Neurons-1:0] Neurons;
input clk;
input reset;
output reg Finished;
output wire [DataWidth*No_of_Neurons-1:0]ActivatedNeurons;

genvar i;
generate
    for (i = 0; i < No_of_Neurons; i=i+1) begin
        Tanhx_Activation_func #(DataWidth)
        TanhActivator(clk,reset,Neurons[i*DataWidth+:DataWidth], ActivatedNeurons[i*DataWidth+:DataWidth]);
    end
endgenerate

always@(posedge clk)
begin
    if(reset == 1'b1)
        Finished = 1'b0;
    if(reset == 1'b0)
        Finished <= 1'b1;
end

endmodule
