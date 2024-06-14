`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/12 21:19:34
// Design Name: 
// Module Name: registers
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


module registers #(
    parameter DATA_WIDTH = 32
)(
    input clk,
    input regWrite,
    input [DATA_WIDTH-1:0] wire_addr,
    input [DATA_WIDTH-1:0] din,
    input [DATA_WIDTH-1:0] read_addr1,
    input [DATA_WIDTH-1:0] read_addr2,
    output [DATA_WIDTH-1:0] dout1,
    output [DATA_WIDTH-1:0] dout2
);

reg [DATA_WIDTH-1:0] registers[0:(1<<5)-1];

// 如果读取的是0号寄存器的内容，那么直接return 0回去
assign dout1 = (read_addr1 == 0) ? 0 : registers[read_addr1];
assign dout2 = (read_addr2 == 0) ? 0 : registers[read_addr2];

always @ (negedge clk) begin
    // 只有在regWrite并且wire_addr不为0号寄存器的时候才把数据写进去
    if (regWrite && (wire_addr != 0)) begin
        registers[wire_addr] <= din;
    end
end

endmodule
