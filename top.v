`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/12 21:21:06
// Design Name: 
// Module Name: top
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


module top # (
    parameter DATA_WIDTH = 32
) (
    input clk, rst
);
    wire [DATA_WIDTH-1:0] instr, pc;
    wire memread, memwrite;
    wire [DATA_WIDTH-1:0] readdata;
    wire [DATA_WIDTH-1:0] alu_result, read_data2;
    
    //----------------------------inst_ram--------------------------
    inst_ram inst_ram (
        .clka(clk),    // input wire clka
        .wea(4'b0000),      // input wire [3 : 0] wea
        .addra(pc),  // input wire [31 : 0] addra
        .dina(0),    // input wire [31 : 0] dina
        .douta(instr)  // output wire [31 : 0] douta
    );
    
    //---------------------------data_ram----------------------------
    data_ram data_ram (
        .clka(clk),    // input wire clka
        .ena(memread),      // input wire ena
        .wea({4{memwrite}}),      // input wire [3 : 0] wea
        .addra(alu_result),  // input wire [31 : 0] addra
        .dina(read_data2),    // input wire [31 : 0] dina
        .douta(readdata)  // output wire [31 : 0] douta
    );
    
    //---------------------------core--------------------------------
    riscv riscv (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .readdata(readdata),
        .pc(pc),
        .alu_result(alu_result),
        .read_data2(read_data2),
        .memread_M(memread),
        .memwrite(memwrite)
    );
endmodule
