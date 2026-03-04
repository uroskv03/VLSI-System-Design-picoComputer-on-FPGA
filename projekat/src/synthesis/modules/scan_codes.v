module scan_codes (input clk,
                   input rst_n,
                   input [15:0] code,
                   input status,
                   output reg control,
                   output reg [3:0] num);
    
    // Moramo pamtiti prethodni code da bismo znali kada je stigao NOVI paket
    reg [15:0] last_code_seen;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            num            <= 4'd0;
            control        <= 1'b0;
            last_code_seen <= 16'd0;
        end
        else if (status == 1'b1) begin
            if (code ^ last_code_seen && code[15:8] == 8'hF0) begin    //^ je razlicito, moraju da budu razliciti da ne upisuje beskonacno istu vr, a takodje mora da procita 2 reci pa je 2. uslov
                last_code_seen <= code;
                case (code[7:0])
                    8'h45: begin
                        num     <= 4'd0;
                        control <= 1'b1;
                    end
                    8'h16: begin
                        num     <= 4'd1;
                        control <= 1'b1;
                    end
                    8'h1E: begin
                        num     <= 4'd2;
                        control <= 1'b1;
                    end
                    8'h26: begin
                        num     <= 4'd3;
                        control <= 1'b1;
                    end
                    8'h25: begin
                        num     <= 4'd4;
                        control <= 1'b1;
                    end
                    8'h2E: begin
                        num     <= 4'd5;
                        control <= 1'b1;
                    end
                    8'h36: begin
                        num     <= 4'd6;
                        control <= 1'b1;
                    end
                    8'h3D: begin
                        num     <= 4'd7;
                        control <= 1'b1;
                    end
                    8'h3E: begin
                        num     <= 4'd8;
                        control <= 1'b1;
                    end
                    8'h46: begin
                        num     <= 4'd9;
                        control <= 1'b1;
                    end
                    default: ; // Ostali tasteri se ignorišu
                endcase
            end
        end
        else begin
            control <= 1'b0;
            if (code[15:8] ^ 8'hF0) begin
                last_code_seen <= 16'd0;   //rs tastera osim ako smo procitali prvu pa cekamo 2. rec
            end
        end
    end
endmodule
