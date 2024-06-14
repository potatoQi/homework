`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/15 11:28:24
// Design Name: 
// Module Name: bubble_detecting
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


module bubble_detecting # (
    parameter DATA_WIDTH = 32
) (
    input clk, rst,
    input ID_EX_MemRead,
    input [DATA_WIDTH-1:0] ID_EX_Rd,
    input [DATA_WIDTH-1:0] IF_ID_Rs1,
    input [DATA_WIDTH-1:0] IF_ID_Rs2,
    output is_bubble
);
    assign is_bubble = (~rst & (ID_EX_MemRead == 1) && ((ID_EX_Rd == IF_ID_Rs1) || (ID_EX_Rd == IF_ID_Rs2))) ? 1 : 0;
endmodule
