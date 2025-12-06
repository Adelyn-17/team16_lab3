`timescale 1ns/1ps

module pll_tb;

    // ----------------------- 信号声明 -----------------------
    reg sys_clk;
    reg sys_rst_n;
    wire vga_clk;

    // ----------------------- 实例化待测模块 (DUT) -----------------------
    pll dut (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .vga_clk(vga_clk)
    );

    // ----------------------- 时钟生成 (sys_clk: 50MHz, 周期 20ns) -----------------------
    localparam SYS_CLK_PERIOD = 20; // 50MHz
    initial begin
        sys_clk = 0;
        forever #(SYS_CLK_PERIOD/2) sys_clk = ~sys_clk;
    end

    // ----------------------- 激励生成 -----------------------
    initial begin
        // 1. 初始化和复位
        sys_rst_n = 1'b0;
        $display("------------------- Test Start -------------------");
        #(SYS_CLK_PERIOD * 2) sys_rst_n = 1'b1; // 释放复位
        $display("Reset released.");

        // 2. 运行一段时间观察时钟
        #(SYS_CLK_PERIOD * 100);
        
        // 3. 结束仿真
        $display("------------------- Test Finished -------------------");
        $stop; 
    end

  

endmodule
