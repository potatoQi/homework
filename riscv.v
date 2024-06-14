`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/12 21:20:03
// Design Name: 
// Module Name: riscv
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


module riscv # (
    parameter DATA_WIDTH = 32
) (
    input clk, rst,
    input [DATA_WIDTH-1:0] instr,
    input [DATA_WIDTH-1:0] readdata,
    output [DATA_WIDTH-1:0] pc,
    output [DATA_WIDTH-1:0] alu_result,
    output [DATA_WIDTH-1:0] read_data2,
    output memread_M, memwrite
);
    wire branch, regsrc, alusrc, regwrite_W, regwrite_M;
    wire [3:0] alucontrol;
    wire [1:0] immsel;
    wire [DATA_WIDTH-1:0] instr_D;
    wire [1:0] fowardA, fowardB;
    wire [DATA_WIDTH-1:0] instr_E, instr_M, instr_W;
    wire is_bubble;
    wire memread_E, memread_D;
    
    flopenrc r1 (
        .clk(clk),
        .rst(rst),
        .clc(0),
        .en(~is_bubble),    //ÔÝÍ£IF/ID¼Ä´æÆ÷
        .din(instr),
        .dout(instr_D)
    );
    //------------------datapath------------------
    datapath datapath (
        .clk(clk),
        .rst(rst),
        .is_bubble(is_bubble),
        .instr_D(instr_D),
        .readdata(readdata),
        .branch(branch),
        .memread(memread_M),
        .memwrite(memwrite),
        .regsrc(regsrc),
        .alusrc(alusrc),
        .alucontrol(alucontrol),
        .regwrite(regwrite_W),
        .immsel(immsel),
        .pc(pc),
        .alu_result_M(alu_result),
        .read_data2_M(read_data2),
        .fowardA(fowardA),
        .fowardB(fowardB),
        .instr_E(instr_E),
        .instr_M(instr_M),
        .instr_W(instr_W)
    );
    
    //-----------------controller--------------
    controller controller (
        .is_bubble(is_bubble),
        .clk(clk),
        .rst(rst),
        .instr_D(instr_D),
        .branch_D(branch),
        .memread_M(memread_M),
        .memread_E(memread_E),
        .memread_D(memread_D),
        .memwrite_M(memwrite),
        .regsrc_W(regsrc),
        .alusrc_E(alusrc),
        .alucontrol_E(alucontrol),
        .regwrite_W(regwrite_W),
        .regwrite_M(regwrite_M),
        .immsel_D(immsel)
    );
    
    //-----------------foward_detecting--------------
    foward_detecting foward_detecting (
        .ID_EX_Rs1({{27{0}}, instr_E[19:15]}),
        .ID_EX_Rs2({{27{0}}, instr_E[24:20]}),
        .EX_MEM_Rd({{27{0}}, instr_M[11:7]}),
        .MEM_WB_Rd({{27{0}}, instr_W[11:7]}),
        .EX_MEM_Regwrite(regwrite_M),
        .MEM_WB_Regwrite(regwrite_W),
        .fowardA(fowardA),
        .fowardB(fowardB)
    );
    
    //------------------bubble_detecting---------------
    bubble_detecting bubble_detecting (
        .clk(clk),
        .rst(rst),
        .ID_EX_MemRead(memread_E),
        .ID_EX_Rd({{27{0}}, instr_E[11:7]}),
        .IF_ID_Rs1({{27{0}}, instr_D[19:15]}),
        .IF_ID_Rs2({{27{0}}, instr_D[24:20]}),
        .is_bubble(is_bubble)
    );
endmodule
