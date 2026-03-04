/*module top; reg [2:0] oc; reg [3:0] a, b; wire [3:0] f; integer i; alu alu1 (.oc(oc), .a(a), .b(b), .f(f));
 
 reg clk, rst_n, cl, ld, inc, dec, sr, ir, sl, il;
 reg [3:0] in;
 wire [3:0] out;
 register register(.clk(clk), .rst_n(rst_n), .cl(cl) , .ld(ld), .inc(inc), .dec(dec), .sr(sr), .ir(ir), .sl(sl), .il(il), .in(in), .out(out));
 
 initial begin
 clk   = 1'b0;
 rst_n = 1'b0;
 $monitor("Vreme: %5d, oc: %3b, a: %d, b: %d, f: %d", $time, oc, a, b, f);
 for (i = 0 ; i<1024 ;i = i+1) begin
 {oc, a, b} = i;
 #5;
 end
 $stop;
 for (i = 1024 ; i<2048 ;i = i+1) begin
 {oc, a, b} = i;
 #5;
 end
 $stop;
 rst_n = 1'b1; clk = 1'b0;
 #1; //da bi se videlo koja op je izvrsena u ispisu
 repeat(1000) begin
 #10 {cl, ld, inc, dec, sr, ir, sl, il, in} = $urandom_range(4095);
 end
 
 $finish;
 end
 
 always @(out) begin
 $strobe("Vreme: %5d, cl: %b, ld: %b, inc: %b, dec: %b, sr: %b, ir: %b, sl: %b, il: %b, in: %4b, out: %4b", $time, cl, ld, inc, dec, sr, ir, sl, il, in , out);
 end
 
 always
 #5 clk = ~clk;
 
 endmodule
 */
