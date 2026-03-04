module color_codes (input [5:0] num,
                    output [23:0] code);

wire [3:0] tens_digit;
wire [3:0] ones_digit;


bcd bcd_inst (
.in(num),
.ones(ones_digit),
.tens(tens_digit)
);


wire [11:0] color_tens;
wire [11:0] color_ones;

assign color_tens = get_color(tens_digit);
assign color_ones = get_color(ones_digit);


assign code = {color_tens, color_ones};


function [11:0] get_color;
    input [3:0] digit;
    begin
        case (digit)
            4'd0: get_color    = 12'h000; // Crna
            4'd1: get_color    = 12'hF00; // Crvena
            4'd2: get_color    = 12'hF80; // Narandžasta
            4'd3: get_color    = 12'hFF0; // Žuta
            4'd4: get_color    = 12'h0F0; // Zelena
            4'd5: get_color    = 12'h0FF; // Cijan
            4'd6: get_color    = 12'h08F; // Svetloplava
            4'd7: get_color    = 12'h00F; // Plava
            4'd8: get_color    = 12'hF0F; // Magenta
            4'd9: get_color    = 12'hFFF; // Bela
            default: get_color = 12'h000;
        endcase
    end
endfunction

endmodule
