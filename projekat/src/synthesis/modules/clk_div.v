module clk_div #(parameter DIVISOR = 50_000_000)
                (input clk,
                 input rst_n,
                 output out);
    
    reg out_next, out_reg;
    integer counter_next, counter_reg;
    assign out = out_reg;
    always @(posedge clk, negedge rst_n)
        if (!rst_n) begin
            out_reg     <= 1'b0;
            counter_reg <= 0;
        end
        else begin
            out_reg     <= out_next;
            counter_reg <= counter_next;
        end
    
    always @(*) begin
        out_next     = out_reg;
        counter_next = counter_reg;
        if (DIVISOR / 2 -1 <= counter_reg) begin
            out_next     = ~out_reg;
            counter_next = 0;
        end
        else
            counter_next = counter_reg + 1;
    end
endmodule
