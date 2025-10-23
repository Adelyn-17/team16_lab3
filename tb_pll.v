`timescale 1ns/1ps
module tb_pll();
//declear artificial inputs
reg artificial_sys_clk;
reg artificial_rst_n;

wire recorder_vga_clk;

initial begin
artificial_sys_clk <= 1'b1;
artificial_rst_n <= 1'b0;
#200;
artificial_rst_n <= 1'b1;
end
always begin
#10 artificial_sys_clk <= ~artificial_sys_clk;
end

//instance
pll pll_inst
(
.sys_clk(artificial_sys_clk),
.sys_rst_n(artificial_rst_n),
.vga_clk(recorder_vga_clk)
);
endmodule
