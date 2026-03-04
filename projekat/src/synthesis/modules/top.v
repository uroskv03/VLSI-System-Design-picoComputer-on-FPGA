module top #(parameter DIVISOR = 50_000_000,
             parameter FILE_NAME = "mem_init.mif",
             parameter ADDR_WIDTH = 6,
             parameter DATA_WIDTH = 16)
            (input clk,
             input rst_n,
             input [2:0] btn,
             input [9:0] sw,
             input [1:0] kbd,
             output [13:0] mnt,
             output [9:0] led,
             output [27:0] hex);                   //ssd
    
    
    
    clk_div #(.DIVISOR(DIVISOR)) clk_div_inst (
    .clk(clk), .rst_n(sw[9]), .out(clk_1hz)
    );
    
    wire                    we_singal;
    wire [ADDR_WIDTH-1:0]   addr, pc, sp;
    wire [DATA_WIDTH-1:0]   data, mem_out, cpu_out;
    
    wire [15:0] ps2_code;
    wire scan_control;
    wire [3:0] scan_num;
    wire cpu_status;
    
    wire [23:0] vga_code;
    
    memory #(
    .FILE_NAME  (FILE_NAME),
    .ADDR_WIDTH (ADDR_WIDTH),
    .DATA_WIDTH (DATA_WIDTH)
    ) mem (
    .clk   (clk_1hz),
    .we    (we_singal),
    .addr  (addr),
    .data  (data),
    .out   (mem_out)
    );
    
    ps2 ps2_inst (
    .clk      (clk),
    .rst_n    (sw[9]),
    .ps2_clk  (kbd[0]),  // takt tastature
    .ps2_data (kbd[1]),  // podatak
    .code     (ps2_code)
    );
    
    scan_codes scan_inst (
    .clk     (clk),
    .rst_n   (sw[9]),
    .code    (ps2_code),
    .status  (cpu_status),
    .control (scan_control),
    .num     (scan_num)
    );
    
    
    cpu #(
    .ADDR_WIDTH (ADDR_WIDTH),
    .DATA_WIDTH (DATA_WIDTH)
    ) cpu_inst (
    .clk   (clk_1hz),
    .rst_n (sw[9]),
    .mem   (mem_out),
    .in    ({12'b0, scan_num}),
    .control (scan_control),
    .status  (cpu_status),
    .we    (we_singal),
    .addr  (addr),
    .data  (data),
    .out   (cpu_out),
    .pc    (pc),
    .sp    (sp)
    );
    
    color_codes color_inst (
    .num  (cpu_out[5:0]),
    .code (vga_code)
    );
    
    // vga vga_inst (
    // .clk   (clk),
    // .rst_n (sw[9]),
    // .code  (vga_code),
    // .hsync (mnt[13]),
    // .vsync (mnt[12]),
    // .red   (mnt[11:8]),
    // .green (mnt[7:4]),
    // .blue  (mnt[3:0])
    // );
    
    
    vga vga_inst (
    .clk   (clk),
    .rst_n (sw[9]),
    .code  (vga_code),
    .hsync (mnt[13]),
    .vsync (mnt[12]),
    .red   (mnt[11:8]),
    .green (mnt[7:4]),
    .blue  (mnt[3:0])
    );
    
    
    
    assign led[5]   = cpu_status;
    assign led[4:0] = cpu_out[4:0];
    assign led[9:6] = 5'b0;
    
    wire [3:0] pc_ones, pc_tens;
    wire [3:0] sp_ones, sp_tens;
    
    bcd bcd_pc (
    .in   (pc),
    .ones (pc_ones),
    .tens (pc_tens)
    );
    
    bcd bcd_sp (
    .in   (sp),
    .ones (sp_ones),
    .tens (sp_tens)
    );
    
    ssd ssd0 (.in(pc_ones), .out(hex[6:0]));
    ssd ssd1 (.in(pc_tens), .out(hex[13:7]));
    ssd ssd2 (.in(sp_ones), .out(hex[20:14]));
    ssd ssd3 (.in(sp_tens), .out(hex[27:21]));
    
endmodule
    
