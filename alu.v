`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/12 21:16:32
// Design Name: 
// Module Name: alu
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


module alu # (
    parameter DATA_WIDTH = 32
)(
    input [DATA_WIDTH-1:0] din1,
    input [DATA_WIDTH-1:0] din2,
    input [3:0] op,
    output [DATA_WIDTH-1:0] dout,
    output less, zero
);
    assign dout = (op == 4'b0001) ? (din1 + din2) :
                  (op == 4'b0010) ? (din1 - din2) :
                  (op == 4'b0011) ? (din1 & din2) :
                  (op == 4'b0100) ? (din1 | din2) :
                  (op == 4'b0101) ? (din1 ^ din2) :
                  (op == 4'b0110) ? (din1 << din2) :
                  (op == 4'b0111) ? (din1 >> din2) :
                  (op == 4'b1000) ? ($signed(din1) >>> $signed(din2)) : //bug
                  (op == 4'b1001) ? ($signed(din1) < $signed(din2)) : 0;
    assign less = ($signed(din1) < $signed(din2));
    assign zero = ($signed(din1) == $signed(din2));
endmodule
