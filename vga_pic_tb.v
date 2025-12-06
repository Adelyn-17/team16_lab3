`timescale 1ns/1ps

module vga_pic_tb;

    // ----------------------- 信号声明 -----------------------
    reg vga_clk;
    reg sys_rst_n;
    reg [9:0] pix_x;
    reg [9:0] pix_y;
    wire [15:0] pix_data;
    
    // ----------------------- 实例化待测模块 (DUT) -----------------------
    vga_pic dut (
        .vga_clk(vga_clk),
        .sys_rst_n(sys_rst_n),
        .pix_x(pix_x),
        .pix_y(pix_y),
        .pix_data(pix_data)
    );

    // ----------------------- 关键参数 (与 vga_pic.v 保持一致) -----------------------
    localparam LETTER_H = 10'd80;
    localparam LETTER_W = 10'd48;
    localparam GAP      = 10'd12;
    localparam X_START  = 10'd320 - (4*LETTER_W + 3*GAP)/2;
    localparam Y_START  = 10'd240 - (LETTER_H/2);
    localparam WHITE    = 16'hFFFF;

    // ----------------------- 测试点基准坐标 (已从 initial 块移到此处) -----------------------
    localparam U_X_BASE = X_START + LETTER_W + GAP;
    localparam S_X_BASE = X_START + 2*(LETTER_W + GAP);
    localparam T_X_BASE = X_START + 3*(LETTER_W + GAP);

    // ----------------------- 时钟生成 (vga_clk: 25MHz, 周期 40ns) -----------------------
    localparam VGA_CLK_PERIOD = 40; 
    initial begin
        vga_clk = 0;
        forever #(VGA_CLK_PERIOD/2) vga_clk = ~vga_clk;
    end

    // ----------------------- 激励生成 (扫描关键点) -----------------------
    initial begin
        sys_rst_n = 1'b0;
        pix_x = 10'd0;
        pix_y = 10'd0;
        $display("------------------- VGA PIC Test Start -------------------");
        #(VGA_CLK_PERIOD * 2) sys_rst_n = 1'b1; // 释放复位

        // M 字母测试点 (左侧竖线中点)
        @(posedge vga_clk); 
        pix_x = X_START + 10'd5; 
        pix_y = Y_START + LETTER_H/2; 
        #VGA_CLK_PERIOD;
        if (pix_data == WHITE) $display("M Test 1 Pass: x=%d, y=%d (Expected White)", pix_x, pix_y);
        else $display("M Test 1 FAIL: x=%d, y=%d (Expected White, Got %h)", pix_x, pix_y, pix_data);

        // U 字母测试点 (底部圆角区域)
        @(posedge vga_clk); 
        pix_x = U_X_BASE + LETTER_W - 10'd1; // 使用模块级 localparam
        pix_y = Y_START + LETTER_H - 10'd1;
        #VGA_CLK_PERIOD;
        if (pix_data == WHITE) $display("U Test 1 Pass: x=%d, y=%d (Expected White)", pix_x, pix_y);
        else $display("U Test 1 FAIL: x=%d, y=%d (Expected White, Got %h)", pix_x, pix_y, pix_data);
        
        // S 字母测试点 (中间横线)
        @(posedge vga_clk); 
        pix_x = S_X_BASE + LETTER_W/2; // 使用模块级 localparam
        pix_y = Y_START + LETTER_H/2;
        #VGA_CLK_PERIOD;
        if (pix_data == WHITE) $display("S Test 1 Pass: x=%d, y=%d (Expected White)", pix_x, pix_y);
        else $display("S Test 1 FAIL: x=%d, y=%d (Expected White, Got %h)", pix_x, pix_y, pix_data);

        // T 字母测试点 (垂直杆)
        @(posedge vga_clk); 
        pix_x = T_X_BASE + LETTER_W/2; // 使用模块级 localparam
        pix_y = Y_START + LETTER_H/2;
        #VGA_CLK_PERIOD;
        if (pix_data == WHITE) $display("T Test 1 Pass: x=%d, y=%d (Expected White)", pix_x, pix_y);
        else $display("T Test 1 FAIL: x=%d, y=%d (Expected White, Got %h)", pix_x, pix_y, pix_data);

        // 非字符区域测试点 (屏幕中央黑区)
        @(posedge vga_clk); 
        pix_x = 10'd320; 
        pix_y = 10'd240;
        #VGA_CLK_PERIOD;
        if (pix_data != WHITE) $display("Background Test Pass: x=%d, y=%d (Expected Black)", pix_x, pix_y);
        else $display("Background Test FAIL: x=%d, y=%d (Expected Black, Got %h)", pix_x, pix_y, pix_data);
        
        // 3. 结束仿真
        $display("------------------- VGA PIC Test Finished -------------------");
        $stop; 
    end

endmodule
