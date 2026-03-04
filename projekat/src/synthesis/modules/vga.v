module vga (
    input  wire        clk,  
    input  wire        rst_n,
    input  wire [23:0] code,
    output wire        hsync,
    output wire        vsync,
    output wire [3:0]  red,
    output wire [3:0]  green,
    output wire [3:0]  blue
);

    reg clk_25mhz;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_25mhz <= 1'b0;
        else
            clk_25mhz <= ~clk_25mhz;
    end



    localparam H_DISPLAY = 640;
    localparam H_FRONT   = 16;
    localparam H_SYNC    = 96;
    localparam H_BACK    = 48;
    localparam H_TOTAL   = 800;

    localparam V_DISPLAY = 480;
    localparam V_FRONT   = 10;
    localparam V_SYNC    = 2;
    localparam V_BACK    = 33;
    localparam V_TOTAL   = 525;



    reg [9:0] h_cnt;
    reg [9:0] v_cnt;

    always @(posedge clk_25mhz or negedge rst_n) begin
        if (!rst_n) begin
            h_cnt <= 10'd0;
            v_cnt <= 10'd0;
        end else begin
            if (h_cnt == H_TOTAL - 1) begin
                h_cnt <= 10'd0;

                if (v_cnt == V_TOTAL - 1)
                    v_cnt <= 10'd0;
                else
                    v_cnt <= v_cnt + 10'd1;

            end else begin
                h_cnt <= h_cnt + 10'd1;
            end
        end
    end

    assign hsync = ~(
        (h_cnt >= H_DISPLAY + H_FRONT) &&
        (h_cnt <  H_DISPLAY + H_FRONT + H_SYNC)
    );

    assign vsync = ~(
        (v_cnt >= V_DISPLAY + V_FRONT) &&
        (v_cnt <  V_DISPLAY + V_FRONT + V_SYNC)
    );


    wire active_video;
    assign active_video = (h_cnt < H_DISPLAY) &&
                          (v_cnt < V_DISPLAY);

    reg [11:0] current_color;

    always @(*) begin
        if (active_video) begin
            if (h_cnt < 320)
                current_color = code[23:12];  // leva polovina
            else
                current_color = code[11:0];   // desna polovina
        end else begin
            current_color = 12'd0;
        end
    end

    assign red   = current_color[11:8];
    assign green = current_color[7:4];
    assign blue  = current_color[3:0];

endmodule