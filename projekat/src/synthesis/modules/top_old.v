module top #(parameter DIVISOR = 50_000_000,
             parameter FILE_NAME = "mem_init.mif",
             parameter ADDR_WIDTH = 6,
             parameter DATA_WIDTH = 16)
            (input clk,
             input rst_n,
             input [2:0] btn,                      
             input [9:0] sw,                       
             input [1:0] kbd,                      //?
             output [13:0] mnt,                    //?
             output [9:0] led,
             output [27:0] hex);                   //hex ili ssd
    
    
    // wire clk_1hz;
    // wire BUTTON0_red;
    
    // red red_inst (CLOCK_50, sw[9], ~btn[0], BUTTON0_red);
    
    // wire SW8_deb;
    // wire SW8_red;
    // wire SW7_deb;
    // wire SW7_red;
    // wire SW6_deb;
    // wire SW6_red;
    // wire SW5_deb;
    // wire SW5_red;
    // wire SW4_deb;
    // wire SW4_red;
    // wire SW3_deb;
    // wire SW3_red;
    // wire SW2_deb;
    // wire SW2_red;
    // wire SW1_deb;
    // wire SW1_red;
    // wire SW0_deb;
    // wire SW0_red;
    
    // debouncer deb_inst8 (CLOCK_50, sw[9], sw[8], SW8_deb);
    // red red_inst8 (CLOCK_50, sw[9], SW8_deb, SW8_red);
    
    // debouncer deb_inst7 (clk_1hz, sw[9], sw[7], SW7_deb);
    // red red_inst7 (clk_1hz, sw[9], SW7_deb, SW7_red);
    
    // debouncer deb_inst6 (clk_1hz, sw[9], sw[6], SW6_deb);
    // red red_inst6 (clk_1hz, sw[9], SW6_deb, SW6_red);
    
    // debouncer deb_inst5 (clk_1hz, sw[9], sw[5], SW5_deb);
    // red red_inst5 (clk_1hz, sw[9], SW5_deb, SW5_red);
    
    // debouncer deb_inst4 (clk_1hz, sw[9], sw[4], SW4_deb);
    // red red_inst4 (clk_1hz, sw[9], SW4_deb, SW4_red);
    
    // debouncer deb_inst3 (clk_1hz, sw[9], sw[3], SW3_deb);
    // red red_inst3 (clk_1hz, sw[9], SW3_deb, SW3_red);
    
    // debouncer deb_inst2 (clk_1hz, sw[9], sw[2], SW2_deb);
    // red red_inst2 (clk_1hz, sw[9], SW2_deb, SW2_red);
    
    // debouncer deb_inst1 (clk_1hz, sw[9], sw[1], SW1_deb);
    // red red_inst1 (clk_1hz, sw[9], SW1_deb, SW1_red);
    
    // debouncer deb_inst0 (clk_1hz, sw[9], sw[0], SW0_deb);
    // red red_inst0 (clk_1hz, sw[9], SW0_deb, SW0_red);
    
    clk_div #(.DIVISOR(DIVISOR)) clk_div_inst (
    .clk(clk), .rst_n(sw[9]), .out(clk_1hz)
    );
    
    wire                    we_singal;
    wire [ADDR_WIDTH-1:0]   addr, pc, sp;
    wire [DATA_WIDTH-1:0]   data, mem_out, cpu_out;
    
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
    
    cpu #(
    .ADDR_WIDTH (ADDR_WIDTH),
    .DATA_WIDTH (DATA_WIDTH)
    ) cpu_inst (
    .clk   (clk_1hz),
    .rst_n (sw[9]),
    .mem   (mem_out),
    .in    ({12'b0, sw[3:0]}),
    //.in_ready (BUTTON0_red),
    .we    (we_singal),
    .addr  (addr),
    .data  (data),
    .out   (cpu_out),
    .pc    (pc),
    .sp    (sp)
    );
    
    assign led[4:0] = cpu_out[4:0];
    assign led[9:5] = 5'b0;
    
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
    
