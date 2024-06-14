`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/12 21:18:11
// Design Name: 
// Module Name: immGen
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


module immGen #(
    parameter DATA_WIDTH = 32
)(
	input [DATA_WIDTH-1:0] din,
	input [1:0] immsel,
	output [DATA_WIDTH-1:0] dout
);
	assign dout = (immsel == 2'b00) ? (0) :                                                           // *
	              (immsel == 2'b01) ? ({{20{din[31]}}, din[31:20]}) :                                 // I
	              (immsel == 2'b10) ? ({{20{din[31]}}, din[31:25], din[11:7]}) :                      // S
	              (immsel == 2'b11) ? ({{20{din[31]}}, din[31], din[7], din[30:25], din[11:8]}) : 0;  // B
endmodule
