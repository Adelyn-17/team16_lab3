`timescale 1ns/1ps

module vga_colorbar_tb;

    // ----------------------- 1. 信号声明 (DUT 端口) -----------------------
    // DUT Input Signals
    reg sys_clk;
    reg sys_rst_n;

    // DUT Output Signals
    wire hsync;
    wire vsync;
    wire [15:0] rgb;

    // ----------------------- 2. 关键参数定义 -----------------------
    // 定义系统时钟周期 (50MHz -> 周期 20ns)
    localparam SYS_CLK_PERIOD = 20;
    
    // 仿真运行时间 (运行约 2 个 VGA 场周期，足够观察所有信号)
    // VGA 640x480@60Hz 场周期约为 16.6ms
    localparam SIM_RUN_TIME = 40000000; // 40ms, 确保观察到 vsync 变化
    
    // ----------------------- 3. 实例化待测模块 (DUT) -----------------------
    vga_colorbar dut (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .hsync(hsync),
        .vsync(vsync),
        .rgb(rgb)
    );

    // ----------------------- 4. 时钟生成 (50MHz) -----------------------
    initial begin
        sys_clk = 0;
        // 持续生成 50MHz 时钟
        forever #(SYS_CLK_PERIOD / 2) sys_clk = ~sys_clk;
    end

    // ----------------------- 5. 激励生成 (复位和仿真控制) -----------------------
    initial begin
        // 1. 初始化输入
        sys_rst_n = 1'b0; // 初始复位
        
        $display("------------------- vga_colorbar Test Start -------------------");

        // 2. 保持复位一段时间 (等待时钟稳定)
        #100;

        // 3. 释放复位
        sys_rst_n = 1'b1; 
        $display("@ %0t ns: System Reset Released.", $time);

        // 4. 运行仿真足够长的时间
        // 40ms 足够看到至少两次完整的 VSYNC 脉冲，确认时序正常
        #(SIM_RUN_TIME); 

        // 5. 结束仿真
        $display("@ %0t ns: Simulation Time Finished.", $time);
        $display("------------------- vga_colorbar Test Finished -------------------");
        $stop; 
    end


endmodule
