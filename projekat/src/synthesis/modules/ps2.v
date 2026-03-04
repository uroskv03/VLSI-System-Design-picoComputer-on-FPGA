module ps2 (input clk,
            input rst_n,
            input ps2_clk,
            input ps2_data,
            output reg [15:0] code);
    
    reg [2:0] ps2_clk_sync;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) ps2_clk_sync <= 3'b111;
        else ps2_clk_sync        <= {ps2_clk_sync[1:0], ps2_clk};
    end
    
    wire falling_edge = (ps2_clk_sync[2:1] == 2'b10);
    
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt   <= 4'd0;
            code      <= 16'd0;
            shift_reg <= 8'd0;
            end else if (falling_edge) begin
            
            if (bit_cnt == 4'd0) begin
                //start bit
                bit_cnt <= 4'd1;
            end
            else if (bit_cnt > 4'd0 && bit_cnt < 4'd9) begin
                //podatak
                shift_reg <= {ps2_data, shift_reg[7:1]};
                bit_cnt   <= bit_cnt + 4'd1;
            end
                else if (bit_cnt == 4'd9) begin
                //bit parnosti
                bit_cnt <= 4'd10;
                end
                else if (bit_cnt == 4'd10) begin
                //end bit
                code    <= {code[7:0], shift_reg};
                bit_cnt <= 4'd0;
                end
            else begin
                bit_cnt <= 4'd0;
            end
            
        end
    end
    
endmodule
