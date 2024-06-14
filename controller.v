`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/12 21:16:58
// Design Name: 
// Module Name: controller
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


module main_dec (
    input [6:0] op,
    output branch,
    output memread, memwrite,
    output regsrc,
    output alusrc,
    output [1:0] aluop,
    output regwrite,
    output [1:0] immsel
);
    reg [9:0] controls;
    assign {branch, memread, regsrc, memwrite, aluop, alusrc, regwrite, immsel} = controls;
    // immsel = *, 00
    // immsel = I, 01
    // immsel = S, 10
    // immsel = B, 11
    always @ (*) begin
        case (op)
            7'h33: controls <= 10'b0000100100;
            7'h13: controls <= 10'b0000101101;
            7'h03: controls <= 10'b0110001101;
            7'h23: controls <= 10'b0001001010;
            7'h63: controls <= 10'b1000010011;
            default: controls <= 10'b0000000000;
        endcase
    end
endmodule

module alu_dec (
    input [3:0] funct,
    input [1:0] aluop,
    output reg [3:0] alucontrol
);
    always @ (*) begin
        case (aluop)
			2'b00: alucontrol <= 4'b0001;
			2'b01: alucontrol <= 4'b0010;
			default : case (funct)
				4'b0000: alucontrol <= 4'b0001;
				4'b1000: alucontrol <= 4'b0010;
				4'b0111: alucontrol <= 4'b0011;
				4'b0110: alucontrol <= 4'b0100;
				4'b0100: alucontrol <= 4'b0101;
				4'b0001: alucontrol <= 4'b0110;
				4'b0101: alucontrol <= 4'b0111;
				4'b1101: alucontrol <= 4'b1000;
				4'b0010: alucontrol <= 4'b1001;
				default:  alucontrol <= 4'b0000;
			endcase
		endcase
	end
endmodule

module controller #(
    parameter DATA_WIDTH = 32
)(
    input clk, rst,
    input [DATA_WIDTH-1:0] instr_D,
    input is_bubble,
    output branch_D,
    output memread_M,
    output memread_E,
    output memread_D,
    output memwrite_M,
    output regsrc_W,
    output alusrc_E,
    output [3:0] alucontrol_E,
    output regwrite_W,
    output regwrite_M,
    output [1:0] immsel_D
);
    wire alusrc_D;
    wire [3:0] alucontrol_D;
    wire memwrite_D, memwrite_E;
    wire regsrc_D, regsrc_E, regsrc_M;
    wire regwrite_D, regwrite_E;
    
    floprc #(1) r13 (clk, rst, is_bubble, alusrc_D, alusrc_E);
    floprc #(4) r14 (clk, rst, is_bubble, alucontrol_D, alucontrol_E);
    floprc #(1) r15 (clk, rst, is_bubble, memread_D, memread_E);
    floprc #(1) r16 (clk, rst, 0, memread_E, memread_M);
    floprc #(1) r17 (clk, rst, is_bubble, memwrite_D, memwrite_E);
    floprc #(1) r18 (clk, rst, 0, memwrite_E, memwrite_M);
    floprc #(1) r19 (clk, rst, is_bubble, regsrc_D, regsrc_E);
    floprc #(1) r20 (clk, rst, 0, regsrc_E, regsrc_M);
    floprc #(1) r21 (clk, rst, 0, regsrc_M, regsrc_W);
    floprc #(1) r22 (clk, rst, is_bubble, regwrite_D, regwrite_E);
    floprc #(1) r23 (clk, rst, 0, regwrite_E, regwrite_M);
    floprc #(1) r24 (clk, rst, 0, regwrite_M, regwrite_W);

    wire [1:0] aluop;
    main_dec main_dec (
        .op(instr_D[6:0]),
        .branch(branch_D),
        .memread(memread_D),
        .memwrite(memwrite_D),
        .regsrc(regsrc_D),
        .alusrc(alusrc_D),
        .aluop(aluop),
        .regwrite(regwrite_D),
        .immsel(immsel_D)
    );
    alu_dec alu_dec (
        .funct({instr_D[30:30], instr_D[14:12]}),
        .aluop(aluop),
        .alucontrol(alucontrol_D)
    );
endmodule
