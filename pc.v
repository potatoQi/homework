`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/12 21:19:08
// Design Name: 
// Module Name: pc
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


module pc # (
    parameter DATA_WIDTH = 32
)(
    input clk, rst, en,
    input [DATA_WIDTH-1:0] din,
    output reg [DATA_WIDTH-1:0] dout
);
    always @ (posedge clk) begin
        if (rst) begin
            dout <= 0;
        end else if (en) begin
            dout <= din;
        end else begin
            dout <= dout;
        end
    end
endmodule
