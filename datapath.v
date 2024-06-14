`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/12 21:17:31
// Design Name: 
// Module Name: datapath
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


module datapath #(
    parameter DATA_WIDTH = 32
)(
    input clk, rst,
    input is_bubble,
    input [DATA_WIDTH-1:0] instr_D,         //由inst_ram传入
    input [DATA_WIDTH-1:0] readdata,        //由data_ram传入
    input branch,
    input memread, memwrite,
    input regsrc,
    input alusrc,
    input [3:0] alucontrol,
    input regwrite,
    input [1:0] immsel,
    input [1:0] fowardA, fowardB,
    output [DATA_WIDTH-1:0] pc,
    output [DATA_WIDTH-1:0] alu_result_M,
    output [DATA_WIDTH-1:0] read_data2_M,
    output [DATA_WIDTH-1:0] instr_E, instr_M, instr_W
);
    wire [DATA_WIDTH-1:0] pc_nxt_1, pc_nxt_2, pc_nxt;
    wire [DATA_WIDTH-1:0] read_data1, write_data;
    wire [DATA_WIDTH-1:0] imm_gen, imm_gen_sl1;
    wire pcsrc, zero, less;
    wire [DATA_WIDTH-1:0] alu_din2;
    wire [DATA_WIDTH-1:0] alu_result;
    wire [DATA_WIDTH-1:0] read_data2;
    
    wire [DATA_WIDTH-1:0] pc_D;
    wire [DATA_WIDTH-1:0] read_data1_E, read_data2_E;
    wire [DATA_WIDTH-1:0] imm_gen_E;
    wire [DATA_WIDTH-1:0] readdata_W;
    wire [DATA_WIDTH-1:0] alu_result_W;
    wire [DATA_WIDTH-1:0] alu_din1_true, alu_din2_true;

    //------------------------pc---------------------
    // pc + 4
    adder adder1 (
        .din1(pc),
        .din2(32'd4),
        .dout(pc_nxt_1)
    );
    //imm_gen_sl1 + pc
    adder adder2 (
        .din1(pc_D),
        .din2(imm_gen_sl1),
        .dout(pc_nxt_2)
    );
    //mux2 of pc_nxt_1/2
    assign pcsrc = (zero & branch);
    mux2 mux2_pc (
        .din1(pc_nxt_2),
        .din2(pc_nxt_1),
        .op(pcsrc),
        .dout(pc_nxt)
    );
    // 得到下一个pc
    pc get_nxt_pc (
        .clk(clk),
        .rst(rst),
        .en(~is_bubble),    //使pc寄存器不读下一条指令
        .din(pc_nxt),
        .dout(pc)
    );
    flopenrc r2 (
        .clk(clk),
        .rst(rst),
        .clc(0),
        .en(~is_bubble),    //暂停IF/ID寄存器
        .din(pc),
        .dout(pc_D)
    );
    
    //-----------------------registers----------------
    floprc r10 (
        .clk(clk),
        .rst(rst),
        .clc(0),
        .din(readdata),
        .dout(readdata_W)
    );
    floprc r11 (
        .clk(clk),
        .rst(rst),
        .clc(0),
        .din(alu_result_M),
        .dout(alu_result_W)
    );
    floprc r12 (
        .clk(clk),
        .rst(rst),
        .clc(0),
        .din(instr_M),
        .dout(instr_W)
    );
    mux2 mux2_reg (
        .din1(readdata_W),
        .din2(alu_result_W),
        .op(regsrc),
        .dout(write_data)
    );
    registers registers (
        .clk(clk),
        .regWrite(regwrite),
        .wire_addr({{27{0}}, instr_W[11:7]}),
        .din(write_data),
        .read_addr1({{27{0}}, instr_D[19:15]}),
        .read_addr2({{27{0}}, instr_D[24:20]}),
        .dout1(read_data1),
        .dout2(read_data2)
    );
    floprc r3 (
        .clk(clk),
        .rst(rst),
        .clc(is_bubble),        //清除ID/EX寄存器
        .din(read_data1),
        .dout(read_data1_E)
    );
    floprc r4 (
        .clk(clk),
        .rst(rst),
        .clc(is_bubble),        //清除ID/EX寄存器
        .din(read_data2),
        .dout(read_data2_E)
    );
    floprc r8 (
        .clk(clk),
        .rst(rst),
        .clc(0),
        .din(read_data2_E),
        .dout(read_data2_M)
    );
    floprc r6 (
        .clk(clk),
        .rst(rst),
        .clc(is_bubble),        //清除ID/EX寄存器
        .din(instr_D),
        .dout(instr_E)
    );
    floprc r9 (
        .clk(clk),
        .rst(rst),
        .clc(0),
        .din(instr_E),
        .dout(instr_M)
    );
    
    //----------------------immGen & sl1-------------------
    immGen immGen (
        .din(instr_D),
        .immsel(immsel),
        .dout(imm_gen)
    );
    floprc r5 (
        .clk(clk),
        .rst(rst),
        .clc(is_bubble),        //清除ID/EX寄存器
        .din(imm_gen),
        .dout(imm_gen_E)
    );
    sl1 sl1 (
        .din(imm_gen),
        .dout(imm_gen_sl1)
    );
    
    //----------------------alu----------------------------
    mux2 mux2_alu (
        .din1(imm_gen_E),
        .din2(read_data2_E),
        .op(alusrc),
        .dout(alu_din2)
    );
    mux3 mux3_1 (
        .din1(read_data1_E),
        .din2(alu_result_M),
        .din3(write_data),
        .op(fowardA),
        .dout(alu_din1_true)
    );
    mux3 mux3_2 (
        .din1(alu_din2),
        .din2(alu_result_M),
        .din3(write_data),
        .op(fowardB),
        .dout(alu_din2_true)
    );
    alu alu (
        //.din1(read_data1_E),
        //.din2(alu_din2),
        .din1(alu_din1_true),
        .din2(alu_din2_true),
        .op(alucontrol),
        .dout(alu_result),
        .less(less),
        .zero(zero)
    );
    floprc r7 (
        .clk(clk),
        .rst(rst),
        .clc(0),
        .din(alu_result),
        .dout(alu_result_M)
    );
endmodule
