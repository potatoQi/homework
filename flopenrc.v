`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/15 13:00:35
// Design Name: 
// Module Name: flopenrc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module flopenrc #(
    parameter DATA_WIDTH = 32
) (
    input clk, rst, clc, en,
    input [DATA_WIDTH-1:0] din,
    output reg [DATA_WIDTH-1:0] dout
);
	always @ (posedge clk) begin
		if(rst) begin
			dout <= 0;
		end else if(clc) begin
			dout <= 0;
		end else if(en) begin
			dout <= din;
		end
	end
endmodule
