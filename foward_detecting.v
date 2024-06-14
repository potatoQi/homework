`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/15 01:48:39
// Design Name: 
// Module Name: foward_detecting
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


module foward_detecting # (
    parameter DATA_WIDTH = 32
) (
    input [DATA_WIDTH-1:0] ID_EX_Rs1,
    input [DATA_WIDTH-1:0] ID_EX_Rs2,
    input [DATA_WIDTH-1:0] EX_MEM_Rd,
    input [DATA_WIDTH-1:0] MEM_WB_Rd,
    input EX_MEM_Regwrite,
    input MEM_WB_Regwrite,
    output [1:0] fowardA,
    output [1:0] fowardB
);
    assign fowardA[0] = (EX_MEM_Regwrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs1));
    assign fowardA[1] = (MEM_WB_Regwrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs1));
    
    assign fowardB[0] = (EX_MEM_Regwrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs2));
    assign fowardB[1] = (MEM_WB_Regwrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs2)); 
endmodule
